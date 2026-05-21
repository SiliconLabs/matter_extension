/*
 *
 *    Copyright (c) 2026 Project CHIP Authors
 *    Copyright (c) 2022 Google LLC.
 *    All rights reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/**
 * @file MqttTransportSi91xNwp.cpp
 * @brief Matter AWS MQTT transport: sl_net DNS + credential store, TLS on Si91x NWP (sl_si91x_socket).
 *        Feeds the common mqtt.c stack via mqtt_transport_intf_t.
 *        IPv4 only: DNS uses @ref SL_NET_DNS_TYPE_IPV4, TCP is @c AF_INET. There is no IPv6 path;
 *        The broker hostname is always resolved via @ref sl_net_dns_resolve_hostname.
 *
 */

#include "sl_constants.h"
#include "sl_ip_types.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "sl_net.h"
#include "sl_net_constants.h"
#include "sl_net_dns.h"
#ifdef __cplusplus
}
#endif

#include "sl_si91x_constants.h"
#include "sl_si91x_socket.h"
#include "sl_si91x_socket_constants.h"
#include "sl_si91x_socket_utility.h"
#include "sl_status.h"

#include <lib/support/logging/CHIPLogging.h>

#include "MQTT_transport.h"

#include "FreeRTOS.h"
#include "event_groups.h"
#include "semphr.h"
#include "timers.h"

#include "errno.h"
#include "lwip/err.h"
#include "string.h"
#include <stdbool.h>
#include <stdint.h>

#ifndef MATTER_AWS_NWP_CERT_INDEX
#define MATTER_AWS_NWP_CERT_INDEX 0
#endif

/* Ring + recv staging size (power of 2). Same layout as MQTT_transport_dual_stack.c (MQTT_DUAL_STACK_RX_BUF_SIZE). */
#ifndef MQTT_MATTER_SI91X_RX_BUF_SIZE
#define MQTT_MATTER_SI91X_RX_BUF_SIZE 4096u
#endif

#ifndef MQTT_MATTER_SI91X_RX_RING_SIZE
#define MQTT_MATTER_SI91X_RX_RING_SIZE MQTT_MATTER_SI91X_RX_BUF_SIZE
#endif

#ifndef MQTT_MATTER_SI91X_TX_BUDGET
#define MQTT_MATTER_SI91X_TX_BUDGET (2 * 1152)
#endif

/* Stack in words: must fit rx_task tmp[RX_BUF_SIZE] + frame; matches MQTT_transport_dual_stack MQTT_RX_TASK_STACK. */
#ifndef MQTT_MATTER_SI91X_RX_TASK_STACK
#define MQTT_MATTER_SI91X_RX_TASK_STACK 1536u
#endif

#ifndef MQTT_MATTER_SI91X_RX_TASK_PRIORITY
#define MQTT_MATTER_SI91X_RX_TASK_PRIORITY (configMAX_PRIORITIES - 2)
#endif

#ifndef MQTT_MATTER_SI91X_DNS_TIMEOUT_SEC
#define MQTT_MATTER_SI91X_DNS_TIMEOUT_SEC 5u
#endif

#ifndef MQTT_MATTER_SI91X_DNS_RETRY_COUNT
#define MQTT_MATTER_SI91X_DNS_RETRY_COUNT 2u
#endif

#ifndef SL_SI91X_SOL_SOCKET
#define SL_SI91X_SOL_SOCKET 1
#endif

struct MQTT_Transport_t
{
    uint8_t conn_state;
    matter_aws_connect_cb matter_aws_conn_cb;
    EventGroupHandle_t events;
    char * hostname;
    int sock;
    bool tls_enabled;
    uint8_t cert_index;

    uint8_t * rx_buf;
    volatile uint16_t rx_put;
    uint16_t rx_get;
    SemaphoreHandle_t rx_mutex;

    TaskHandle_t rx_task_handle;
    volatile uint8_t rx_task_run;

    TimerHandle_t cyclic_timer;
    void (*timer_handler)(void *);
    void * timer_arg;
};

enum
{
    TRANSPORT_NOT_CONNECTED,
    TRANSPORT_CONNECTED,
};

extern void mqtt_cyclic_timer(void * arg);

static void setup_transport_callbacks(MQTT_Transport_t * client, mqtt_transport_intf_t * trans);

static uint16_t rx_ring_len(MQTT_Transport_t * client)
{
    return (uint16_t) (client->rx_put - client->rx_get);
}

static void mqtt_freertos_timer_cb(TimerHandle_t xTimer)
{
    MQTT_Transport_t * t = (MQTT_Transport_t *) pvTimerGetTimerID(xTimer);
    if (t != NULL && t->timer_handler != NULL && t->timer_arg != NULL)
    {
        t->timer_handler(t->timer_arg);
    }
}

static void transport_timerStart(u32_t msecs, timer_callback handler, void * arg)
{
    mqtt_client_t * mqtt_client = (mqtt_client_t *) arg;
    MQTT_Transport_t * t        = NULL;

    if (mqtt_client == NULL || mqtt_client->conn == NULL)
    {
        return;
    }
    t = (MQTT_Transport_t *) mqtt_client->conn->connCtxt;
    if (t == NULL)
    {
        return;
    }

    t->timer_handler = handler;
    t->timer_arg     = arg;

    if (t->cyclic_timer == NULL)
    {
        t->cyclic_timer = xTimerCreate("mqtt_si91x", pdMS_TO_TICKS(msecs), pdTRUE, (void *) t, mqtt_freertos_timer_cb);
        if (t->cyclic_timer == NULL)
        {
            return;
        }
    }
    else
    {
        xTimerChangePeriod(t->cyclic_timer, pdMS_TO_TICKS(msecs), 0);
    }
    xTimerStart(t->cyclic_timer, portMAX_DELAY);
}

static void transport_timerStop(timer_callback handler, void * arg)
{
    mqtt_client_t * mqtt_client = (mqtt_client_t *) arg;
    MQTT_Transport_t * t        = NULL;

    if (mqtt_client == NULL || mqtt_client->conn == NULL)
    {
        return;
    }
    t = (MQTT_Transport_t *) mqtt_client->conn->connCtxt;
    if (t == NULL)
    {
        return;
    }
    if (handler == t->timer_handler && arg == t->timer_arg)
    {
        if (t->cyclic_timer != NULL)
        {
            xTimerStop(t->cyclic_timer, portMAX_DELAY);
        }
        t->timer_handler = NULL;
        t->timer_arg     = NULL;
    }
}

static uint16_t transport_get_sendlen_cb(void * conn)
{
    (void) conn;
    return MQTT_MATTER_SI91X_TX_BUDGET;
}

static int8_t transport_write_cb(void * conn, void * buff, uint16_t len, uint8_t flags, uint8_t isFinal)
{
    MQTT_Transport_t * client = (MQTT_Transport_t *) conn;
    if (!client || client->sock < 0)
    {
        return ERR_FAIL;
    }

    int sent = sl_si91x_send(client->sock, (const uint8_t *) buff, len, 0);
    if (sent < 0)
    {
        return ERR_FAIL;
    }
    if (isFinal && client->events != NULL)
    {
        xEventGroupSetBits(client->events, SIGNAL_TRANSINTF_TX_ACK);
    }
    (void) flags;
    return ERR_OK;
}

static uint16_t transport_get_recvlen_cb(void * conn)
{
    MQTT_Transport_t * client = (MQTT_Transport_t *) conn;
    if (!client)
    {
        return 0;
    }
    xSemaphoreTake(client->rx_mutex, portMAX_DELAY);
    uint16_t n = rx_ring_len(client);
    xSemaphoreGive(client->rx_mutex);
    return n;
}

static int8_t transport_recv_from_nw(void * conn, void * buf, uint16_t len, uint16_t offset)
{
    MQTT_Transport_t * client = (MQTT_Transport_t *) conn;
    (void) offset;
    if (!client || !buf)
    {
        return 0;
    }
    xSemaphoreTake(client->rx_mutex, portMAX_DELAY);
    uint16_t avail = rx_ring_len(client);
    if (len > avail)
    {
        xSemaphoreGive(client->rx_mutex);
        return 0;
    }
    uint16_t mask = MQTT_MATTER_SI91X_RX_BUF_SIZE - 1u;
    for (uint16_t i = 0; i < len; i++)
    {
        ((uint8_t *) buf)[i] = client->rx_buf[(client->rx_get + i) & mask];
    }
    client->rx_get += len;
    xSemaphoreGive(client->rx_mutex);
    return (int8_t) len;
}

static void transport_close_cb(void * arg)
{
    MQTT_Transport_t * client = (MQTT_Transport_t *) arg;

    client->rx_task_run = 0;
    while (client->rx_task_handle != NULL)
    {
        vTaskDelay(pdMS_TO_TICKS(10));
    }
    if (client->sock >= 0)
    {
        sl_si91x_shutdown(client->sock, 0);
        client->sock = -1;
    }
    client->conn_state = TRANSPORT_NOT_CONNECTED;
    if (client->events != NULL)
    {
        xEventGroupSetBits(client->events, SIGNAL_TRANSINTF_CONN_CLOSE);
    }
    if (client->cyclic_timer != NULL)
    {
        xTimerStop(client->cyclic_timer, portMAX_DELAY);
    }
}

static void mqtt_matter_si91x_rx_task(void * pvParameters)
{
    MQTT_Transport_t * client = (MQTT_Transport_t *) pvParameters;
    uint8_t tmp[MQTT_MATTER_SI91X_RX_BUF_SIZE];
    sl_si91x_time_value timeout;
    timeout.tv_sec  = 0;
    timeout.tv_usec = 100000;

    while (client->rx_task_run && client->sock >= 0)
    {
        sl_si91x_setsockopt(client->sock, SL_SI91X_SOL_SOCKET, SL_SI91X_SO_RCVTIME, &timeout, sizeof(timeout));
        int rc = sl_si91x_recv(client->sock, tmp, sizeof(tmp), 0);
        if (rc > 0)
        {
            ChipLogDetail(DeviceLayer,
                          "[MQTT Si91X INTERFACE ] "
                          "MQTT matter si91x: RX recv %d bytes (socket->ring)",
                          rc);
            xSemaphoreTake(client->rx_mutex, portMAX_DELAY);
            for (int i = 0; i < rc && (uint16_t) (client->rx_put - client->rx_get) < MQTT_MATTER_SI91X_RX_BUF_SIZE; i++)
            {
                client->rx_buf[client->rx_put & (MQTT_MATTER_SI91X_RX_BUF_SIZE - 1u)] = tmp[i];
                client->rx_put++;
            }
            xSemaphoreGive(client->rx_mutex);
            if (client->events)
            {
                xEventGroupSetBits(client->events, SIGNAL_TRANSINTF_RX);
            }
        }
        else if (rc == 0 || (rc == -1 && (errno == ECONNRESET || errno == ENOTCONN)))
        {
            if (client->conn_state == TRANSPORT_CONNECTED && client->events)
            {
                ChipLogDetail(DeviceLayer,
                              "[MQTT Si91X INTERFACE ] "
                              "MQTT matter si91x: CONN_CLOSE (recv rc=%d errno=%d - peer closed or socket error)",
                              rc, errno);
                xEventGroupSetBits(client->events, SIGNAL_TRANSINTF_CONN_CLOSE);
            }
            break;
        }
    }
    client->rx_task_handle = NULL;
    vTaskDelete(NULL);
}

void transport_process_mbedtls_rx(MQTT_Transport_t * client)
{
    (void) client;
}

MQTT_Transport_t * MQTT_Transport_Init(mqtt_transport_intf_t * trans, mqtt_client_t * mqtt_client,
                                       EventGroupHandle_t matterAwsEvents)
{
    (void) mqtt_client;

    if (trans == NULL || matterAwsEvents == NULL)
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net transport init failed");
        return NULL;
    }

    MQTT_Transport_t * client = (MQTT_Transport_t *) pvPortMalloc(sizeof(MQTT_Transport_t));
    if (client == NULL)
    {
        return NULL;
    }
    memset(client, 0, sizeof(MQTT_Transport_t));
    client->sock     = -1;
    client->events   = matterAwsEvents;
    client->rx_buf   = (uint8_t *) pvPortMalloc(MQTT_MATTER_SI91X_RX_BUF_SIZE);
    client->rx_mutex = xSemaphoreCreateMutex();
    if (client->rx_buf == NULL || client->rx_mutex == NULL)
    {
        if (client->rx_buf != NULL)
        {
            vPortFree(client->rx_buf);
        }
        if (client->rx_mutex != NULL)
        {
            vSemaphoreDelete(client->rx_mutex);
        }
        vPortFree(client);
        return NULL;
    }

    setup_transport_callbacks(client, trans);
    return client;
}

err_t MQTT_Transport_SSLConfigure(MQTT_Transport_t * transP, const u8_t * ca, size_t ca_len, const u8_t * privkey,
                                  size_t privkey_len, const u8_t * privkey_pass, size_t privkey_pass_len, const u8_t * cert,
                                  size_t cert_len)
{
    sl_status_t st;

    (void) privkey_pass;
    (void) privkey_pass_len;

    if (transP == NULL)
    {
        return ERR_ARG;
    }

    transP->tls_enabled = false;
    transP->cert_index  = MATTER_AWS_NWP_CERT_INDEX;

    if (ca != NULL && ca_len > 1 && cert != NULL && cert_len > 1 && privkey != NULL && privkey_len > 1)
    {
        st = sl_net_set_credential((sl_net_credential_id_t) SL_NET_TLS_SERVER_CREDENTIAL_ID(transP->cert_index),
                                   SL_NET_SIGNING_CERTIFICATE, ca, (uint32_t) ca_len);
        if (st != SL_STATUS_OK)
        {
            ChipLogDetail(DeviceLayer,
                          "[MQTT Si91X INTERFACE ] "
                          "Matter si91x net: CA credential failed 0x%lx",
                          (unsigned long) st);
            return ERR_FAIL;
        }

        st = sl_net_set_credential((sl_net_credential_id_t) SL_NET_TLS_CLIENT_CREDENTIAL_ID(transP->cert_index), SL_NET_CERTIFICATE,
                                   cert, (uint32_t) cert_len);
        if (st != SL_STATUS_OK)
        {
            ChipLogDetail(DeviceLayer,
                          "[MQTT Si91X INTERFACE ] "
                          "Matter si91x net: device cert failed 0x%lx",
                          (unsigned long) st);
            return ERR_FAIL;
        }

        st = sl_net_set_credential((sl_net_credential_id_t) SL_NET_TLS_CLIENT_CREDENTIAL_ID(transP->cert_index), SL_NET_PRIVATE_KEY,
                                   privkey, (uint32_t) privkey_len);
        if (st != SL_STATUS_OK)
        {
            ChipLogDetail(DeviceLayer,
                          "[MQTT Si91X INTERFACE ] "
                          "Matter si91x net: private key failed 0x%lx",
                          (unsigned long) st);
            return ERR_FAIL;
        }

        transP->tls_enabled = true;
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: SSL credentials loaded cert_idx=%u (CA + cert + key)",
                      (unsigned) transP->cert_index);
    }
    else
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: SSL configure skipped (incomplete PEM args), tls stays off");
    }

    return ERR_OK;
}

static err_t nwp_tcp_connect(MQTT_Transport_t * client, const sl_ip_address_t * ip, u16_t port)
{
    struct sockaddr_in server = { 0 };
    socklen_t slen            = sizeof(struct sockaddr_in);
    uint8_t cert_idx          = client->cert_index;
    int rc;

    /* Matter AWS: IPv4 only; do not add AF_INET6 / AAAA handling here. */
    if (ip->type != SL_IPV4)
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: peer not IPv4 (type=0x%lx)",
                      (unsigned long) ip->type);
        return ERR_VAL;
    }

    client->sock = sl_si91x_socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (client->sock < 0)
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [tcp] FAIL at sl_si91x_socket errno=%d",
                      errno);
        return ERR_MEM;
    }
    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: [tcp] sl_si91x_socket ok sock=%d",
                  client->sock);

    if (client->tls_enabled)
    {
        {
            uint32_t ssl_v12 = SL_SI91X_ENABLE_TLS | SL_SI91X_TLS_V_1_2;
            if (sl_si91x_setsockopt(client->sock, SL_SI91X_SOL_SOCKET, SL_SI91X_SO_SSL_V_1_2_ENABLE, &ssl_v12, sizeof(ssl_v12)) < 0)
            {
                ChipLogDetail(DeviceLayer,
                              "[MQTT Si91X INTERFACE ] "
                              "Matter si91x net: [tcp] FAIL at SO_SSL_V_1_2 errno=%d",
                              errno);
                goto fail;
            }
        }
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [tcp] SO_SSL_V_1_2 ok");
        if (sl_si91x_setsockopt(client->sock, SL_SI91X_SOL_SOCKET, SL_SI91X_SO_CERT_INDEX, &cert_idx, sizeof(cert_idx)) < 0)
        {
            ChipLogDetail(DeviceLayer,
                          "[MQTT Si91X INTERFACE ] "
                          "Matter si91x net: [tcp] FAIL at SO_CERT_INDEX errno=%d",
                          errno);
            goto fail;
        }
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [tcp] SO_CERT_INDEX ok idx=%u",
                      (unsigned) cert_idx);
    }
    else
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [tcp] TLS sockopts skipped (tls_enabled=0)");
    }

    server.sin_family = AF_INET;
    server.sin_port   = (in_port_t) port;
    memcpy(&server.sin_addr.s_addr, ip->ip.v4.bytes, sizeof(server.sin_addr.s_addr));

    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: [tcp] sl_si91x_connect sock=%d tls=%u cert_idx=%u ip -> %u.%u.%u.%u:%u",
                  client->sock, (unsigned) client->tls_enabled, (unsigned) cert_idx, (unsigned) ip->ip.v4.bytes[0],
                  (unsigned) ip->ip.v4.bytes[1], (unsigned) ip->ip.v4.bytes[2], (unsigned) ip->ip.v4.bytes[3], (unsigned) port);

    rc = sl_si91x_connect(client->sock, (struct sockaddr *) &server, slen);
    if (rc < 0)
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [tcp] FAIL at sl_si91x_connect rc=%d errno=%d sock=%d",
                      rc, errno, client->sock);
        goto fail;
    }
    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: [tcp] sl_si91x_connect returned ok");

    client->conn_state  = TRANSPORT_CONNECTED;
    client->rx_task_run = 1;
    client->rx_put      = 0;
    client->rx_get      = 0;

    if (xTaskCreate(mqtt_matter_si91x_rx_task, "mqtt_m_si91x", MQTT_MATTER_SI91X_RX_TASK_STACK, client,
                    MQTT_MATTER_SI91X_RX_TASK_PRIORITY, &client->rx_task_handle) != pdPASS)
    {
        client->rx_task_run = 0;
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [tcp] FAIL at xTaskCreate(mqtt_matter_si91x_rx)");
        goto fail;
    }

    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: [tcp] complete sock=%d tls=%u rx task started",
                  client->sock, (unsigned) client->tls_enabled);
    return ERR_OK;

fail:
    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: [tcp] nwp_tcp_connect abort cleanup");
    if (client->sock >= 0)
    {
        sl_si91x_shutdown(client->sock, 0);
        client->sock = -1;
    }
    return ERR_ABRT;
}

err_t MQTT_Transport_Connect(MQTT_Transport_t * transP, const char * host, size_t hostLen, u16_t port,
                             matter_aws_connect_cb matter_aws_conn_cb)
{
    sl_ip_address_t ip     = { 0 };
    sl_status_t dns_status = SL_STATUS_FAIL;
    char host_dbg[49];
    size_t dbg_len = hostLen < sizeof(host_dbg) - 1 ? hostLen : sizeof(host_dbg) - 1;

    if (transP == NULL || host == NULL)
    {
        return ERR_ARG;
    }
    if (hostLen > MQTT_TRANSPORT_MAX_HOSTNAME_LEN)
    {
        return ERR_ARG;
    }

    if (transP->hostname != NULL)
    {
        vPortFree(transP->hostname);
        transP->hostname = NULL;
    }
    transP->hostname = (char *) pvPortMalloc(hostLen + 1);
    if (transP->hostname == NULL)
    {
        return ERR_MEM;
    }
    memcpy(transP->hostname, host, hostLen);
    transP->hostname[hostLen] = '\0';

    memcpy(host_dbg, host, dbg_len);
    host_dbg[dbg_len] = '\0';
    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: connect start host='%s' len=%u port=%u tls=%u",
                  host_dbg, (unsigned) hostLen, (unsigned) port, (unsigned) transP->tls_enabled);

    const uint32_t dns_timeout_ms = (uint32_t) MQTT_MATTER_SI91X_DNS_TIMEOUT_SEC * 1000u;
    unsigned attempt;
    for (attempt = 0; attempt <= MQTT_MATTER_SI91X_DNS_RETRY_COUNT; attempt++)
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [dns] resolve attempt %u/%u timeout_ms=%lu",
                      attempt + 1u, (unsigned) (MQTT_MATTER_SI91X_DNS_RETRY_COUNT + 1u), (unsigned long) dns_timeout_ms);
        dns_status = sl_net_dns_resolve_hostname(transP->hostname, dns_timeout_ms, SL_NET_DNS_TYPE_IPV4, &ip);
        if (dns_status == SL_STATUS_OK)
        {
            break;
        }
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [dns] attempt %u status=0x%lx",
                      attempt + 1u, (unsigned long) dns_status);
    }

    if (dns_status != SL_STATUS_OK)
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [dns] FAIL final status=0x%lx",
                      (unsigned long) dns_status);
        vPortFree(transP->hostname);
        transP->hostname = NULL;
        return ERR_ABRT;
    }

    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: [dns] ok -> %u.%u.%u.%u",
                  (unsigned) ip.ip.v4.bytes[0], (unsigned) ip.ip.v4.bytes[1], (unsigned) ip.ip.v4.bytes[2],
                  (unsigned) ip.ip.v4.bytes[3]);

    transP->matter_aws_conn_cb = matter_aws_conn_cb;

    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: [flow] entering nwp_tcp_connect");
    err_t cr = nwp_tcp_connect(transP, &ip, port);
    if (cr != ERR_OK)
    {
        ChipLogDetail(DeviceLayer,
                      "[MQTT Si91X INTERFACE ] "
                      "Matter si91x net: [flow] nwp_tcp_connect failed err_t=%d (ERR_ABRT=%d)",
                      (int) cr, (int) ERR_ABRT);
        if (matter_aws_conn_cb != NULL)
        {
            matter_aws_conn_cb(cr);
        }
        return cr;
    }

    ChipLogDetail(DeviceLayer,
                  "[MQTT Si91X INTERFACE ] "
                  "Matter si91x net: stack up, invoking app TCP ok cb");
    if (matter_aws_conn_cb != NULL)
    {
        matter_aws_conn_cb(ERR_OK);
    }
    return ERR_OK;
}

static void setup_transport_callbacks(MQTT_Transport_t * client, mqtt_transport_intf_t * trans)
{
    trans->connCtxt          = client;
    trans->get_send_len      = transport_get_sendlen_cb;
    trans->send_to_network   = transport_write_cb;
    trans->get_recv_len      = transport_get_recvlen_cb;
    trans->recv_from_network = transport_recv_from_nw;
    trans->close_connection  = transport_close_cb;
    trans->timer_start       = transport_timerStart;
    trans->timer_stop        = transport_timerStop;
}
