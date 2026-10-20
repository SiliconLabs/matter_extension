/*******************************************************************************
 * @file
 * @brief main loop for the host side of the mmic
 *******************************************************************************
 * # License
 * <b>Copyright 2026 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <atomic>
#include <chrono>
#include <condition_variable>
#include <mutex>

#if MMIC_USE_CPC
#include <sl_cpc.h>
#else
#include <termios.h>
#endif

#include "mmic.h"
#include "chip_tool_storage.h"
#include "matter_cert_issuer.h"

#if MMIC_USE_CPC
/* CPC endpoint the device-side mmic task exposes. */
#define MMIC_CPC_ENDPOINT_ID     ((uint8_t)18)
/* TX window size for the endpoint; 1 matches the cpcd examples. */
#define MMIC_CPC_TX_WINDOW_SIZE  ((uint8_t)1)
#endif

#define MMIC_MAX_TOKENS    16
/* Large enough to hold the commission command payload (commissionArgs_t header
 * plus three Matter-TLV certificates, ~800 bytes total). */
#define MMIC_MAX_ARG_BYTES 2048

/* Chip-tool storage loaded at startup from the working directory.
 * When loaded == false, the `commission` command is disabled. */
static ChipToolStorage g_chipToolStorage;

static bool commissionAvailable=true;

/* Split `line` in place on whitespace. Fills `tokens[]` with pointers into
 * the line buffer and returns the number of tokens (0..maxTokens). */
static int tokenizeLine(char * line, char ** tokens, int maxTokens)
{
    int n = 0;
    char * saveptr = NULL;
    for (char * tok = strtok_r(line, " \t", &saveptr);
         tok != NULL && n < maxTokens;
         tok = strtok_r(NULL, " \t", &saveptr))
    {
        tokens[n++] = tok;
    }
    return n;
}

/* Parse a token as an unsigned integer, accepting decimal, 0x-hex and 0-octal.
 * Returns 0 on success, non-zero on parse error (empty token, trailing junk,
 * or value above `maxVal`). */
static int parseU64(const char * tok, uint64_t maxVal, uint64_t * out)
{
    if (tok == NULL || *tok == '\0') {
        return -1;
    }
    char * end = NULL;
    errno = 0;
    unsigned long long v = strtoull(tok, &end, 0);
    if (errno != 0 || end == tok || *end != '\0' || (uint64_t)v > maxVal) {
        return -1;
    }
    *out = (uint64_t)v;
    return 0;
}

/* Serialize the textual arguments for `id` (argv[1..argc-1]) into `out`,
 * matching the on-wire packed layout expected by the device. Returns the
 * number of bytes written, or -1 on error. Returns 0 for commands that
 * take no arguments. */
static int serializeArgs(mmic_command_id_e id,
                         int argc, char ** argv,
                         uint8_t * out, size_t outCap)
{
    switch (id)
    {
        case ping:
        case version:
        case matter_state:
        case subscription_info:
        case openCommissioning:
        case decommission:
        case wakeUpList:
            if (argc != 1) {
                fprintf(stderr, "%s takes no arguments\n", commandsString[id]);
                return -1;
            }
            return 0;

        case establish_subscription:
        {
            /* Wire layout: subscriptionArgs_t (packed, little-endian).
             * Usage: establish_subscription <fabricIndex> <nodeId> <endpointId> <clusterId> <attributeId> */
            if (argc != 6) {
                fprintf(stderr,
                        "Usage: %s <fabricIndex> <nodeId> <endpointId> <clusterId> <attributeId>\n",
                        commandsString[id]);
                return -1;
            }
            if (outCap < sizeof(subscriptionArgs_t)) {
                fprintf(stderr,
                        "Buffer too small for %s arguments\n", commandsString[id]);
                return -1;
            }

            uint64_t v;
            subscriptionArgs_t args;

            if (parseU64(argv[1], UINT8_MAX,  &v) != 0) { fprintf(stderr, "bad fabricIndex\n"); return -1; }
            args.fabricIndex = (uint8_t)v;
            if (parseU64(argv[2], UINT64_MAX, &v) != 0) { fprintf(stderr, "bad nodeId\n");      return -1; }
            args.nodeId = v;
            if (parseU64(argv[3], UINT16_MAX, &v) != 0) { fprintf(stderr, "bad endpointId\n");  return -1; }
            args.endpointId = (uint16_t)v;
            if (parseU64(argv[4], UINT32_MAX, &v) != 0) { fprintf(stderr, "bad clusterId\n");   return -1; }
            args.clusterId = (uint32_t)v;
            if (parseU64(argv[5], UINT32_MAX, &v) != 0) { fprintf(stderr, "bad attributeId\n"); return -1; }
            args.attributeId = (uint32_t)v;

            memcpy(out, &args, sizeof(args));
            return (int)sizeof(args);
        }

        case addWakeUp:
        {
            /* Usage: addWakeUp <clusterId> <attributeId> <mode> <operand>
             * mode: 0 = Boolean, 1 = Bitmask, 2 = Equal */
            if (argc != 5) {
                fprintf(stderr,
                        "Usage: %s <clusterId> <attributeId> <mode> <operand>\n",
                        commandsString[id]);
                return -1;
            }
            if (outCap < sizeof(wakeUpEntry_t)) {
                fprintf(stderr, "Buffer too small for %s arguments\n", commandsString[id]);
                return -1;
            }

            uint64_t v;
            wakeUpEntry_t entry;

            if (parseU64(argv[1], UINT32_MAX, &v) != 0) { fprintf(stderr, "bad clusterId\n");   return -1; }
            entry.clusterId = (uint32_t) v;
            if (parseU64(argv[2], UINT32_MAX, &v) != 0) { fprintf(stderr, "bad attributeId\n"); return -1; }
            entry.attributeId = (uint32_t) v;
            if (parseU64(argv[3], 2,          &v) != 0) { fprintf(stderr, "bad mode (0..2)\n"); return -1; }
            entry.mode = (uint8_t) v;
            if (parseU64(argv[4], UINT64_MAX, &v) != 0) { fprintf(stderr, "bad operand\n");     return -1; }
            entry.operand = v;

            memcpy(out, &entry, sizeof(entry));
            return (int) sizeof(entry);
        }

        case removeWakeUp:
        {
            /* Usage: removeWakeUp <clusterId> <attributeId> */
            if (argc != 3) {
                fprintf(stderr,
                        "Usage: %s <clusterId> <attributeId>\n",
                        commandsString[id]);
                return -1;
            }
            if (outCap < sizeof(wakeUpRemoveArgs_t)) {
                fprintf(stderr, "Buffer too small for %s arguments\n", commandsString[id]);
                return -1;
            }

            uint64_t v;
            wakeUpRemoveArgs_t args;

            if (parseU64(argv[1], UINT32_MAX, &v) != 0) { fprintf(stderr, "bad clusterId\n");   return -1; }
            args.clusterId = (uint32_t) v;
            if (parseU64(argv[2], UINT32_MAX, &v) != 0) { fprintf(stderr, "bad attributeId\n"); return -1; }
            args.attributeId = (uint32_t) v;

            memcpy(out, &args, sizeof(args));
            return (int) sizeof(args);
        }

        case commission:
        {
            if(!commissionAvailable)
            {
                fprintf(stderr,
                "Warning: chip-tool storage not available.\n");
                return -1;
            }
            /* Usage: commission <nodeId>
             * Requires chip-tool storage to have been loaded successfully at startup.
             * Builds a fresh NOC for the target nodeId, packs the commissionArgs_t
             * header plus RCAC || ICAC || NOC (all Matter-TLV) into `out`. */
            if (argc != 2) {
                fprintf(stderr, "Usage: %s <nodeId>\n", commandsString[id]);
                return -1;
            }
            if (!g_chipToolStorage.loaded) {
                fprintf(stderr, "%s is disabled: %s\n",
                        commandsString[id], g_chipToolStorage.missingReason.c_str());
                return -1;
            }

            uint64_t nodeId = 0;
            if (parseU64(argv[1], UINT64_MAX, &nodeId) != 0) {
                fprintf(stderr, "bad nodeId\n");
                return -1;
            }

            IssuedNoc issued = issueNoc(g_chipToolStorage, nodeId);
            if (!issued.ok) {
                fprintf(stderr, "commission: NOC issuance failed: %s\n", issued.error.c_str());
                return -1;
            }

            const size_t hdrSize = sizeof(commissionArgs_t);
            const size_t certsSize =
                g_chipToolStorage.rcacTlv.size() +
                g_chipToolStorage.icacTlv.size() +
                issued.nocTlv.size();
            const size_t total = hdrSize + certsSize;
            if (total > outCap) {
                fprintf(stderr, "commission: payload (%zu bytes) does not fit in argBuf (%zu)\n",
                        total, outCap);
                return -1;
            }
            if (g_chipToolStorage.rcacTlv.size() > UINT16_MAX ||
                g_chipToolStorage.icacTlv.size() > UINT16_MAX ||
                issued.nocTlv.size()             > UINT16_MAX) {
                fprintf(stderr, "commission: cert length exceeds uint16\n");
                return -1;
            }

            commissionArgs_t hdr;
            memset(&hdr, 0, sizeof(hdr));
            hdr.nodeId   = nodeId;
            hdr.fabricId = g_chipToolStorage.fabricId;
            hdr.vendorId = g_chipToolStorage.vendorId;
            // Send the RAW chip-tool epoch key ("temporary ipk 01", per
            // TestGroupData.h::DefaultIpkValue). chip-tool persists only the
            // *derived* operational key in f/1/k/0, so we can't reuse
            // g_chipToolStorage.ipk here — SetSingleIpkEpochKey on the device
            // would derive it a second time and never match the peer.
            static const uint8_t kRawIpk[MMIC_COMMISSION_IPK_LEN] = {
                't', 'e', 'm', 'p', 'o', 'r', 'a', 'r', 'y', ' ', 'i', 'p', 'k', ' ', '0', '1'
            };
            memcpy(hdr.ipk,       kRawIpk,                        MMIC_COMMISSION_IPK_LEN);
            memcpy(hdr.opkeyPub,  issued.opKeyPub.data(),         MMIC_COMMISSION_OPKEY_PUB_LEN);
            memcpy(hdr.opkeyPriv, issued.opKeyPriv.data(),        MMIC_COMMISSION_OPKEY_PRIV_LEN);
            hdr.rcacLen = (uint16_t)g_chipToolStorage.rcacTlv.size();
            hdr.icacLen = (uint16_t)g_chipToolStorage.icacTlv.size();
            hdr.nocLen  = (uint16_t)issued.nocTlv.size();

            uint8_t * cursor = out;
            memcpy(cursor, &hdr, hdrSize);           cursor += hdrSize;
            memcpy(cursor, g_chipToolStorage.rcacTlv.data(), hdr.rcacLen); cursor += hdr.rcacLen;
            memcpy(cursor, g_chipToolStorage.icacTlv.data(), hdr.icacLen); cursor += hdr.icacLen;
            memcpy(cursor, issued.nocTlv.data(),             hdr.nocLen);  cursor += hdr.nocLen;

            return (int)total;
        }

        default:
            return -1;
    }
}

static std::atomic<int> g_stop{0};

// One-shot mode state: set true when the user invokes the binary with a
// command on argv. The reader thread then routes the first complete response
// frame into g_resp_buf and signals main() via g_resp_cv instead of decoding
// straight to stdout.
static std::atomic<bool>       g_one_shot{false};
static std::mutex              g_resp_mtx;
static std::condition_variable g_resp_cv;
static uint8_t                 g_resp_buf[1024];
static size_t                  g_resp_len   = 0;
static bool                    g_resp_ready = false;

/* Response wait timeout (seconds). Sized for commission/subscription
 * establishment, which involve CASE session setup. */
static constexpr int kResponseTimeoutSec = 20;

/* Forward declaration; defined per transport (CPC / UART) below. */
int serial_write(const uint8_t * data, size_t len);

/* Route a received chunk. In interactive mode, decode + print directly. In
 * one-shot mode, accumulate (UART reads may split a frame) until a complete
 * response frame is present, then signal main(). */
static void deliverResponse(const uint8_t * buf, size_t n)
{
    if (!g_one_shot.load()) {
        decodeAndPrintResponse(const_cast<uint8_t *>(buf), n);
        return;
    }

    std::lock_guard<std::mutex> lk(g_resp_mtx);
    if (g_resp_ready) {
        return;
    }
    size_t space = sizeof(g_resp_buf) - g_resp_len;
    size_t copy  = (n < space) ? n : space;
    memcpy(g_resp_buf + g_resp_len, buf, copy);
    g_resp_len += copy;

    if (g_resp_len >= MMIC_PACKET_OVERHEAD && g_resp_buf[0] == MMIC_HEADER_ANS) {
        uint16_t frameLen = mmic_read_length(g_resp_buf);
        if (frameLen >= MMIC_PACKET_OVERHEAD && (size_t)frameLen <= g_resp_len) {
            g_resp_ready = true;
            g_resp_cv.notify_one();
        }
    }
}

/* Return index of first argv token matching a known command name, else -1. */
static int findCommandIndex(int argc, char ** argv)
{
    for (int i = 1; i < argc; i++) {
        for (uint8_t j = 0; j < INVALID_COMMAND_ID; j++) {
            if (strcmp(argv[i], commandsString[j]) == 0) {
                return i;
            }
        }
    }
    return -1;
}

/* Encode + send one MMIC command. Returns 0 on success, negative on error. */
static int sendCommandLine(int argc_cmd, char ** argv_cmd)
{
    if (argc_cmd < 1) {
        return -1;
    }
    for (uint8_t i = 0; i < INVALID_COMMAND_ID; i++) {
        mmic_command_id_e id = static_cast<mmic_command_id_e>(i);
        if (strcmp(argv_cmd[0], commandsString[id]) != 0) continue;

        uint8_t argBuf[MMIC_MAX_ARG_BYTES];
        int     argLen = serializeArgs(id, argc_cmd, argv_cmd, argBuf, sizeof(argBuf));
        if (argLen < 0) {
            return -2;
        }

        uint8_t * cmdBuffer = NULL;
        size_t    size      = 0;
        void *    paramPtr  = (argLen > 0) ? argBuf : NULL;
        int       rc        = 0;
        if (encodeCommand(id, paramPtr, (uint16_t)argLen, &cmdBuffer, &size) != 0) {
            fprintf(stderr, "Failed to encode %s\n", commandsString[id]);
            rc = -3;
        } else if (serial_write(cmdBuffer, size) < 0) {
            fprintf(stderr, "Failed to write to serial port\n");
            rc = -4;
        }
        if (cmdBuffer != NULL) {
            free(cmdBuffer);
        }
        return rc;
    }
    fprintf(stderr, "Unknown command: %s\n", argv_cmd[0]);
    return -1;
}

/* Async-signal handler for SIGINT/SIGTERM. Marks the app for shutdown; the
 * main loop's fgets() returns NULL (EINTR, no SA_RESTART) and cleanup then
 * closes the CPC endpoint / serial fd before exiting. */
static void handle_signal(int sig)
{
    (void)sig;
    g_stop.store(1);
}

/* Install SIGINT/SIGTERM handler with SA_RESTART cleared so blocking calls
 * (fgets, cpc_read_endpoint, read) return with EINTR on Ctrl+C. */
static int install_signal_handlers(void)
{
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = handle_signal;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0; /* no SA_RESTART: we want blocking syscalls to be interrupted */

    if (sigaction(SIGINT,  &sa, NULL) != 0) return -1;
    if (sigaction(SIGTERM, &sa, NULL) != 0) return -1;
    return 0;
}

#if MMIC_USE_CPC

static cpc_handle_t   g_cpc_handle;
static cpc_endpoint_t g_cpc_endpoint;

/* Write `len` bytes from `data` to CPC endpoint 90. Returns 0 on success. */
int serial_write(const uint8_t *data, size_t len)
{
    if (data == NULL) {
        return -1;
    }

    ssize_t n = cpc_write_endpoint(g_cpc_endpoint,
                                   (void *)data,
                                   len,
                                   CPC_ENDPOINT_WRITE_FLAG_NONE);
    if (n < 0 || (size_t)n != len) {
        return -1;
    }
    return 0;
}

/* Reader thread: prints anything received on the CPC endpoint to stdout.
 * Endpoint is configured with CPC_OPTION_RX_TIMEOUT so this call unblocks
 * periodically; that lets us observe g_stop and exit before main() closes
 * the endpoint (closing while another thread is blocked in cpc_read_endpoint
 * makes cpc_close_endpoint hang). */
static void *reader_thread(void *arg)
{
    (void)arg;
    uint8_t buf[SL_CPC_READ_MINIMUM_SIZE];

    while (!g_stop.load()) {
        ssize_t n = cpc_read_endpoint(g_cpc_endpoint,
                                      buf,
                                      sizeof(buf),
                                      CPC_ENDPOINT_READ_FLAG_NONE);
        if (n > 0) {
            deliverResponse(buf, (size_t)n);
        } else if (n < 0) {
            /* libcpc returns negated errno on failure and may also set errno;
             * treat both wakeup indications as transient. */
            if (n == -EINTR || n == -EAGAIN || n == -ETIMEDOUT ||
                errno == EINTR || errno == EAGAIN || errno == ETIMEDOUT) {
                continue;
            }
            /* Endpoint closed by us on shutdown -> exit quietly. */
            if (g_stop.load()) {
                break;
            }
            fprintf(stderr, "\n[cpc read error: %s]\n", strerror(errno));
            break;
        }
    }
    return NULL;
}

#else /* !MMIC_USE_CPC : UART transport */

static int g_serial_fd = -1;

/* Configure an open fd for 115200, 8 data bits, no parity, 1 stop bit, no flow control. */
static int configure_port(int fd)
{
    struct termios tio;
    if (tcgetattr(fd, &tio) != 0) {
        return -1;
    }

    cfmakeraw(&tio);

    if (cfsetispeed(&tio, B115200) != 0 || cfsetospeed(&tio, B115200) != 0) {
        return -1;
    }

    /* Control flags: 8N1, no flow control, enable receiver, ignore modem lines. */
    tio.c_cflag &= ~(unsigned)(PARENB | CSTOPB | CSIZE | CRTSCTS);
    tio.c_cflag |=  (unsigned)(CS8 | CLOCAL | CREAD);

    /* Input flags: fully raw. No break handling, no parity marking/stripping,
     * no CR/LF translation, no SW flow control. cfmakeraw() already does most
     * of this; we re-clear explicitly so any platform quirk cannot leave a
     * translation bit set that would corrupt binary data. */
    tio.c_iflag &= ~(unsigned)(IGNBRK | BRKINT | PARMRK | ISTRIP
                             | INLCR  | IGNCR  | ICRNL
                             | IXON   | IXOFF  | IXANY
                             | INPCK  | IGNPAR);

    /* Output flags: no post-processing (no ONLCR/OCRNL/etc.). */
    tio.c_oflag &= ~(unsigned)OPOST;

    /* Local flags: non-canonical, no echo, no signal generation. */
    tio.c_lflag &= ~(unsigned)(ECHO | ECHONL | ICANON | ISIG | IEXTEN);

    /* Non-blocking-ish read: return after up to 100 ms so the reader thread
     * can observe g_stop and exit cleanly. */
    tio.c_cc[VMIN]  = 0;
    tio.c_cc[VTIME] = 1;

    if (tcsetattr(fd, TCSANOW, &tio) != 0) {
        return -1;
    }

    tcflush(fd, TCIOFLUSH);
    return 0;
}

/* Write `len` bytes from `data` to the serial port. Returns 0 on success. */
int serial_write(const uint8_t *data, size_t len)
{
    if (g_serial_fd < 0 || data == NULL) {
        return -1;
    }

    size_t written = 0;
    while (written < len) {
        ssize_t n = write(g_serial_fd, data + written, len - written);
        if (n < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        written += (size_t)n;
    }
    return 0;
}

/* Reader thread: prints anything received on the port to stdout. */
static void *reader_thread(void *arg)
{
    (void)arg;
    uint8_t buf[256]={0};

    while (!g_stop.load()) {
        ssize_t n = read(g_serial_fd, buf, sizeof(buf));
        if (n > 0) {
            deliverResponse(buf, (size_t)n);
        } else if (n < 0 && errno != EINTR && errno != EAGAIN) {
            fprintf(stderr, "\n[serial read error: %s]\n", strerror(errno));
            break;
        }
        /* n == 0: VTIME timeout, just loop */
    }
    return NULL;
}

#endif /* MMIC_USE_CPC */
int main(int argc, char **argv)
{
    if (install_signal_handlers() != 0) {
        fprintf(stderr, "Failed to install signal handlers: %s\n", strerror(errno));
        return 1;
    }

    /* Attempt to load chip-tool storage from the current working directory.
     * If either INI file is missing or malformed, warn the user and continue
     * with the `commission` command disabled. */
    if (!loadChipToolStorage(g_chipToolStorage)) {
        commissionAvailable = false;
    }

    /* Argv layout: [transport args...] [<cmd> <cmd-args...>].
     * If any argv token matches a known command name, we enter one-shot mode:
     * everything before it is transport (existing semantics), everything from
     * it onward is the command. Otherwise, run the interactive shell. */
    int  cmd_index      = findCommandIndex(argc, argv);
    int  transport_argc = (cmd_index > 0) ? cmd_index : argc;
    bool one_shot       = (cmd_index > 0);
    g_one_shot.store(one_shot);

#if MMIC_USE_CPC
    if (transport_argc > 2) {
        fprintf(stderr,
                "Usage: %s [cpcd_instance_name] [<command> [args...]]\n",
                argv[0]);
        return 1;
    }
    const char *instance = (transport_argc == 2) ? argv[1] : NULL;// use default socket location

    if (cpc_init(&g_cpc_handle, instance, false, NULL) != 0) {
        fprintf(stderr, "cpc_init(\"%s\") failed: %s\n",
                instance, strerror(errno));
        return 1;
    }

    if (cpc_open_endpoint(g_cpc_handle,
                          &g_cpc_endpoint,
                          MMIC_CPC_ENDPOINT_ID,
                          MMIC_CPC_TX_WINDOW_SIZE) < 0) {
        fprintf(stderr, "cpc_open_endpoint(%u) failed: %s; attempting close + retry\n",
                (unsigned)MMIC_CPC_ENDPOINT_ID, strerror(errno));

        /* Endpoint may be in a stale state (e.g. left open by a previous
         * instance that did not shut down cleanly). Close it and retry once. */
        (void)cpc_close_endpoint(&g_cpc_endpoint);

        if (cpc_open_endpoint(g_cpc_handle,
                              &g_cpc_endpoint,
                              MMIC_CPC_ENDPOINT_ID,
                              MMIC_CPC_TX_WINDOW_SIZE) < 0) {
            fprintf(stderr, "cpc_open_endpoint(%u) retry failed: %s\n",
                    (unsigned)MMIC_CPC_ENDPOINT_ID, strerror(errno));
            return 1;
        }
    }

    /* Give cpc_read_endpoint a bounded blocking window so the reader thread
     * can observe g_stop on shutdown. Without this, cpc_close_endpoint() will
     * hang whenever the reader is parked in a blocking recv on the daemon
     * socket. */
    {
        bool          block   = true;
        cpc_timeval_t timeout = { .seconds = 0, .microseconds = 200000 };
        (void)cpc_set_endpoint_option(g_cpc_endpoint, CPC_OPTION_BLOCKING,
                                      &block, sizeof(block));
        if (cpc_set_endpoint_option(g_cpc_endpoint, CPC_OPTION_RX_TIMEOUT,
                                    &timeout, sizeof(timeout)) != 0) {
            fprintf(stderr, "warning: cpc_set_endpoint_option(RX_TIMEOUT) failed: %s\n",
                    strerror(errno));
        }
    }

    pthread_t reader;
    if (pthread_create(&reader, NULL, reader_thread, NULL) != 0) {
        fprintf(stderr, "Failed to start reader thread\n");
        cpc_close_endpoint(&g_cpc_endpoint);
        return 1;
    }

    if(!one_shot)
    {
        fprintf(stderr,
                "Connected to cpcd instance \"%s\" on endpoint %u.%s\n",
                instance ? instance : "(default)",
                (unsigned)MMIC_CPC_ENDPOINT_ID,
                " Type 'exit' to quit.");
    }
#else
    if (transport_argc != 2) {
        fprintf(stderr,
                "Usage: %s <serial_device> [<command> [args...]]\n",
                argv[0]);
        return 1;
    }

    const char *device = argv[1];

    g_serial_fd = open(device, O_RDWR | O_NOCTTY);
    if (g_serial_fd < 0) {
        fprintf(stderr, "Failed to open %s: %s\n", device, strerror(errno));
        return 1;
    }

    if (configure_port(g_serial_fd) != 0) {
        fprintf(stderr, "Failed to configure %s: %s\n", device, strerror(errno));
        close(g_serial_fd);
        return 1;
    }

    pthread_t reader;
    if (pthread_create(&reader, NULL, reader_thread, NULL) != 0) {
        fprintf(stderr, "Failed to start reader thread\n");
        close(g_serial_fd);
        return 1;
    }

    fprintf(stderr, "Connected to %s @ 115200 8N1.%s\n",
            device, one_shot ? "" : " Type 'exit' to quit.");
#endif

    int exit_code = 0;

    if (one_shot) {
        int     cmd_argc = argc - cmd_index;
        char ** cmd_argv = &argv[cmd_index];
        int     send_rc  = sendCommandLine(cmd_argc, cmd_argv);
        if (send_rc != 0) {
            exit_code = 1;
        } else {
            std::unique_lock<std::mutex> lk(g_resp_mtx);
            bool got = g_resp_cv.wait_for(lk,
                                          std::chrono::seconds(kResponseTimeoutSec),
                                          [] { return g_resp_ready || g_stop.load(); });
            if (!got || !g_resp_ready) {
                fprintf(stderr, "mmic: timeout waiting for response\n");
                exit_code = 2;
            } else {
                uint8_t rc = decodeAndPrintResponse(g_resp_buf, g_resp_len);
                if (rc != 0) {
                    fprintf(stderr, "mmic: decode failure (rc=%u)\n", (unsigned)rc);
                    exit_code = 4;
                } else if (g_resp_len >= MMIC_PACKET_OVERHEAD) {
                    /* Map op-level failure payloads to a non-zero exit code. */
                    uint8_t         op = g_resp_buf[MMIC_OFFSET_OP];
                    const uint8_t * pl = g_resp_buf + MMIC_OFFSET_PAYLOAD;
                    if ((op == openCommissioning || op == commission || op == decommission) && *pl != 0) {
                        exit_code = 3;
                    } else if (op == establish_subscription) {
                        subscriptionEstablishResp_t r;
                        memcpy(&r, pl, sizeof(r));
                        if (r.status != 0) {
                            exit_code = 3;
                        }
                    }
                }
            }
        }
        g_stop.store(1);
        goto shutdown;
    }

    char line[512];
    while (!g_stop.load()) {
        printf("> ");
        fflush(stdout);

        if (fgets(line, sizeof(line), stdin) == NULL) {
            /* EOF on stdin or interrupted by SIGINT/SIGTERM -> exit */
            printf("\n");
            break;
        }

        /* strip trailing newline */
        size_t l = strlen(line);
        while (l > 0 && (line[l - 1] == '\n' || line[l - 1] == '\r')) {
            line[--l] = '\0';
        }

        if (l == 0) {
            continue;
        }

        /* Tokenize: argv[0] is the command name, argv[1..] are arguments. */
        char * argv_cmd[MMIC_MAX_TOKENS];
        int argc_cmd = tokenizeLine(line, argv_cmd, MMIC_MAX_TOKENS);
        if (argc_cmd == 0) {
            continue;
        }

        if (strcmp(argv_cmd[0], "exit") == 0) {
            break;
        }

        if (strcmp(argv_cmd[0], "help") == 0) {
            printHelp();
            continue;
        }

        char found = 0;
        for (uint8_t i = 0; i < INVALID_COMMAND_ID; i++)
        {
            mmic_command_id_e id = static_cast<mmic_command_id_e>(i);
            if (strcmp(argv_cmd[0], commandsString[id]) != 0) {
                continue;
            }
            found = 1;

            uint8_t  argBuf[MMIC_MAX_ARG_BYTES];
            int      argLen = serializeArgs(id, argc_cmd, argv_cmd, argBuf, sizeof(argBuf));
            if (argLen < 0) {
                /* serializeArgs already printed an error. */
                printf("argLenBad!!\r\n");
                fflush(stdout);
                break;
            }

            uint8_t * cmdBuffer = NULL;
            size_t    size      = 0;
            void *    paramPtr  = (argLen > 0) ? argBuf : NULL;
            if (encodeCommand(id, paramPtr, (uint16_t)argLen, &cmdBuffer, &size) == 0)
            {

                if(serial_write(cmdBuffer, size) < 0)
                {
                    printf("Failed to right to serial port\r\n");
                    fflush(stdout);
                }
            }
            else
            {
                fprintf(stderr, "Failed to encode %s\n", commandsString[id]);
            }
            if (cmdBuffer != NULL)
            {
                free(cmdBuffer);
            }
            break;
        }
        if (found) {
            continue;
        }

        fprintf(stderr, "Unknown command: %s\n", argv_cmd[0]);
    }

    g_stop.store(1);

shutdown:
#if MMIC_USE_CPC
    /* Join first: the reader's cpc_read_endpoint unblocks on its own via the
     * CPC_OPTION_RX_TIMEOUT set at open time. Closing before joining races
     * with a blocked recv() inside the daemon lib and can hang cpc_close_endpoint. */
    pthread_join(reader, NULL);
    cpc_close_endpoint(&g_cpc_endpoint);
#else
    pthread_join(reader, NULL);
    close(g_serial_fd);
    g_serial_fd = -1;
#endif

    return exit_code;
}
