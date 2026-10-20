/*******************************************************************************
 * @file
 * @brief MMIC task using the matter_cpc transport.
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
#include "mmic.h"
#include "string.h"
#include "stdlib.h"

uint16_t crc16(const uint8_t * buffer, uint16_t size)
{
    uint16_t crc = 0xFFFF;
    while (size--)
    {
        crc ^= (uint16_t)(*buffer++) << 8;
        for (uint8_t i = 0; i < 8; i++)
        {
            crc = (crc & 0x8000) ? (uint16_t)((crc << 1) ^ 0x1021) : (uint16_t)(crc << 1);
        }
    }
    return crc;
}

uint8_t mmic_serialize_packet(uint8_t header, mmic_command_id_e id,
                              const void * payload, size_t payloadLen,
                              uint8_t ** encodedPacket, size_t * packetSize)
{
    if (id >= INVALID_COMMAND_ID || encodedPacket == NULL || packetSize == NULL)
    {
        return MMIC_ERROR_INVALID_ARG;
    }

    const size_t frameSize = (size_t) MMIC_PACKET_OVERHEAD + payloadLen;
    if (frameSize > UINT16_MAX)
    {
        return MMIC_ERROR_INVALID_ARG;
    }

    uint8_t * workbuffer = (uint8_t *) malloc(frameSize);
    if (workbuffer == NULL)
    {
        return MMIC_ERROR_NO_MEMORY;
    }

    workbuffer[0] = header;
    uint8_t err   = mmic_write_length(workbuffer, (uint16_t) frameSize);
    if (err != MMIC_ERROR_OK)
    {
        free(workbuffer);
        return err;
    }
    workbuffer[MMIC_OFFSET_OP] = (uint8_t) id;

    if (payloadLen > 0 && payload != NULL)
    {
        memcpy(workbuffer + MMIC_OFFSET_PAYLOAD, payload, payloadLen);
    }

    const uint16_t crc = crc16(workbuffer, (uint16_t) (frameSize - 2));
    memcpy(workbuffer + frameSize - 2, &crc, 2);

    *encodedPacket = workbuffer; // Warning: must be freed by the caller
    *packetSize    = frameSize;
    return MMIC_ERROR_OK;
}

uint8_t mmic_deserialize_packet(const uint8_t * buffer, size_t len, uint8_t expectedHeader,
                                mmic_command_id_e * outOpCode,
                                const uint8_t ** outPayload, uint16_t * outPayloadLen)
{
    if (buffer == NULL || len == 0)
    {
        return MMIC_ERROR_INVALID_ARG;
    }

    const uint16_t frameLen = mmic_read_length(buffer);
    if (buffer[0] != expectedHeader
        || buffer[MMIC_OFFSET_OP] >= INVALID_COMMAND_ID
        || frameLen < MMIC_PACKET_OVERHEAD
        || frameLen > len)
    {
        return MMIC_ERROR_INVALID_PACKET;
    }

    uint16_t crc = 0;
    memcpy(&crc, buffer + (frameLen - 2), 2);
    if (crc != crc16(buffer, (uint16_t) (frameLen - 2)))
    {
        return MMIC_ERROR_INVALID_PACKET;
    }

    if (outOpCode != NULL)
    {
        *outOpCode = (mmic_command_id_e) buffer[MMIC_OFFSET_OP];
    }
    if (outPayload != NULL)
    {
        *outPayload = buffer + MMIC_OFFSET_PAYLOAD;
    }
    if (outPayloadLen != NULL)
    {
        *outPayloadLen = (uint16_t) (frameLen - MMIC_PACKET_OVERHEAD);
    }
    return MMIC_ERROR_OK;
}

#if HOST_SIDE
#include <stdio.h>

static const commandsData_t commands[] =
{
    #define X(a,b,c, d) {.argsCnt=c, .argsSize= (c * sizeof(d))},
    COMMAND_LIST
    #undef X
};

const char commandsString[][255] = {
    #define X(a,b,c, d) #a,
    COMMAND_LIST
    #undef X
};


uint8_t encodeCommand(mmic_command_id_e id, void * parameter, uint16_t size, uint8_t ** encodedPacket, size_t * packetSize)
{
    if (id >= INVALID_COMMAND_ID)
    {
        return MMIC_ERROR_INVALID_ARG;
    }

    // For fixed-args commands defined via COMMAND_LIST, argsCnt/argsSize drive the wire size.
    // For variable-length commands (establish_subscription, commission) the caller passes size.
    const bool isVariableLen = (id == establish_subscription) || (id == commission);

    if (!isVariableLen && (commands[id].argsCnt == 0 && parameter != NULL))
    {
        return MMIC_ERROR_INVALID_ARG;
    }
    if (!isVariableLen && (commands[id].argsCnt != 0 && parameter == NULL))
    {
        return MMIC_ERROR_INVALID_ARG;
    }
    if (isVariableLen && (parameter == NULL || size == 0))
    {
        return MMIC_ERROR_INVALID_ARG;
    }

    // Determine payload size for this frame.
    uint16_t payloadSize = 0;
    if (commands[id].argsCnt == 0)
    {
        payloadSize = 0;
    }
    else if (isVariableLen)
    {
        payloadSize = size;
    }
    else
    {
        payloadSize = (uint16_t) (commands[id].argsSize);
    }

    return mmic_serialize_packet(MMIC_HEADER_CMD, id,
                                 (payloadSize > 0) ? parameter : NULL, payloadSize,
                                 encodedPacket, packetSize);
}

uint8_t decodeAndPrintResponse(uint8_t * buffer, size_t len)
{
    mmic_command_id_e opcode = INVALID_COMMAND_ID;
    const uint8_t * payload  = NULL;
    uint16_t payloadLen      = 0;
    uint8_t err = mmic_deserialize_packet(buffer, len, MMIC_HEADER_ANS, &opcode, &payload, &payloadLen);
    if (err != MMIC_ERROR_OK)
    {
        return err;
    }

    switch (opcode)
    {
        case ping:
            printf("\r\n%s\r\n", (const char *) payload);
            break;
        case version:
            printf("\r\n%s\r\n", (const char *) payload);
            break;
        case matter_state:
            matterState_t state;
            memcpy(&state, payload, sizeof(matterState_t));
            printf("\r\nNumber of Fabrics: %d\r\nCommisionning Window Open:  %s\r\n",state.nbOfFabric, (state.commissioningWindowOpen)? "true" : "false" );
            printf("mDNS Operational Advertising: %s\r\n", state.mdnsOperationalAdvertising ? "true" : "false");
            if (state.nbOfFabric > 0)
            {
                printf("Fabric[%u]: nodeId=0x%016llx fabricId=0x%016llx\r\n",
                       (unsigned) state.fabricIndex,
                       (unsigned long long) state.nodeId,
                       (unsigned long long) state.fabricId);
                printf("  compressedFabricId: ");
                for (size_t i = 0; i < sizeof(state.compressedFabricId); ++i)
                {
                    printf("%02x", state.compressedFabricId[i]);
                }
                printf("\r\n  rootPublicKey: ");
                for (size_t i = 0; i < sizeof(state.rootPublicKey); ++i)
                {
                    printf("%02x", state.rootPublicKey[i]);
                }
                printf("\r\n");
            }
            if (state.commissioningWindowOpen)
            {
                printf("mDNS Commissionable Advertising (_matterc._udp):\r\n"
                       "  Instance Name: %s\r\n"
                       "  UDP Port: %u\r\n"
                       "  Discriminator: 0x%03x (%u)\r\n",
                       state.mdnsCommissionableInstanceName,
                       state.mdnsCommissionableUdpPort,
                       state.setupDiscriminator, state.setupDiscriminator);
            }
            printf("Thread interface up: %s\r\nThread attached: %s\r\n",
                   state.threadInterfaceUp ? "true" : "false",
                   state.threadAttached ? "true" : "false");
            printf("Thread mesh-local EID: "
                   "%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x\r\n",
                   state.threadMeshLocalEid[0],  state.threadMeshLocalEid[1],
                   state.threadMeshLocalEid[2],  state.threadMeshLocalEid[3],
                   state.threadMeshLocalEid[4],  state.threadMeshLocalEid[5],
                   state.threadMeshLocalEid[6],  state.threadMeshLocalEid[7],
                   state.threadMeshLocalEid[8],  state.threadMeshLocalEid[9],
                   state.threadMeshLocalEid[10], state.threadMeshLocalEid[11],
                   state.threadMeshLocalEid[12], state.threadMeshLocalEid[13],
                   state.threadMeshLocalEid[14], state.threadMeshLocalEid[15]);
            printf("Thread Network Name: %s\r\nThread PAN ID: 0x%04x\r\nThread Channel: %u\r\n",
                   state.threadNetworkName, state.threadPanId, state.threadChannel);
            printf("Thread Extended PAN ID: %02x%02x%02x%02x%02x%02x%02x%02x\r\n",
                   state.threadExtendedPanId[0], state.threadExtendedPanId[1],
                   state.threadExtendedPanId[2], state.threadExtendedPanId[3],
                   state.threadExtendedPanId[4], state.threadExtendedPanId[5],
                   state.threadExtendedPanId[6], state.threadExtendedPanId[7]);
            break;
        case openCommissioning:
        case commission:
        case decommission:
        case addWakeUp:
        case removeWakeUp:
            printf("\r\n%s : %d\r\n", payload[0] == 0 ? "Success" : "Failure", payload[0]);
            break;
        case establish_subscription:
        {
            if (payloadLen < sizeof(subscriptionEstablishResp_t)) {
                printf("\r\nestablish_subscription: truncated response\r\n");
                break;
            }
            subscriptionEstablishResp_t r;
            memcpy(&r, payload, sizeof(r));
            if (r.status == 0) {
                printf("\r\nestablish_subscription: Success (handle=%u)\r\n", (unsigned) r.handle);
            } else {
                printf("\r\nestablish_subscription: Failure (status=%u)\r\n", (unsigned) r.status);
            }
            break;
        }
        case subscription_info:
        {
            if (payloadLen < 1) { printf("\r\nsubscription_info: empty payload\r\n"); break; }
            uint8_t count = payload[0];
            const size_t expected = 1 + (size_t) count * sizeof(subscriptionEntry_t);
            if (payloadLen < expected) { printf("\r\nsubscription_info: truncated\r\n"); break; }
            printf("\r\nActive subscriptions (%u):\r\n", (unsigned) count);
            const uint8_t * p = payload + 1;
            for (uint8_t i = 0; i < count; ++i)
            {
                subscriptionEntry_t e;
                memcpy(&e, p + i * sizeof(subscriptionEntry_t), sizeof(e));
                printf("  [%u] fabric=%u node=0x%016llx endpoint=%u cluster=0x%08x attribute=0x%08x\r\n",
                       (unsigned) e.handle, (unsigned) e.fabricIndex,
                       (unsigned long long) e.nodeId, (unsigned) e.endpointId,
                       (unsigned) e.clusterId, (unsigned) e.attributeId);
            }
            break;
        }
        case wakeUpList:
        {
            if (payloadLen < 1) { printf("\r\nwakeUpList: empty payload\r\n"); break; }
            uint8_t count = payload[0];
            const size_t expected = 1 + (size_t) count * sizeof(wakeUpEntry_t);
            if (payloadLen < expected) { printf("\r\nwakeUpList: truncated\r\n"); break; }
            static const char * const kModeName[] = { "Boolean", "Bitmask", "Equal" };
            printf("\r\nActive wake-up triggers (%u):\r\n", (unsigned) count);
            const uint8_t * p = payload + 1;
            for (uint8_t i = 0; i < count; ++i)
            {
                wakeUpEntry_t e;
                memcpy(&e, p + i * sizeof(wakeUpEntry_t), sizeof(e));
                const char * modeStr = (e.mode < (sizeof(kModeName) / sizeof(kModeName[0]))) ? kModeName[e.mode] : "?";
                printf("  cluster=0x%08x attribute=0x%08x mode=%s(%u) operand=0x%016llx\r\n",
                       (unsigned) e.clusterId, (unsigned) e.attributeId,
                       modeStr, (unsigned) e.mode, (unsigned long long) e.operand);
            }
            break;
        }
        default:
            return MMIC_ERROR_NOT_IMPLEMENTED;
    };
    fflush(stdout);
    return MMIC_ERROR_OK;
}

void printHelp(void)
{
    #define X(a,b,c, d) fprintf(stderr, #a " :\t" b "\r\n");
    COMMAND_LIST
    #undef X
}
#else
#include "../subscription/SubscriptionManager.h"
#include "WakeUpMgr.h"
#include <app/server/CommissioningWindowManager.h>
#include <app/server/Dnssd.h>
#include <app/server/Server.h>
#include <credentials/FabricTable.h>
#include <credentials/GroupDataProvider.h>
#include <crypto/CHIPCryptoPAL.h>
#include <lib/core/CHIPError.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/Span.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/CommissionableDataProvider.h>
#include <platform/ConnectivityManager.h>

#if CHIP_DEVICE_CONFIG_ENABLE_THREAD
#include <platform/ThreadStackManager.h>
#include <openthread/dataset.h>
#include <openthread/instance.h>
#include <openthread/ip6.h>
#include <openthread/thread.h>

extern "C" otInstance * otGetInstance(void);
#endif


uint8_t encodeResponse(mmic_command_id_e id, void * response, size_t responseLen, uint8_t ** encodedPacket, size_t * packetSize)
{
    return mmic_serialize_packet(MMIC_HEADER_ANS, id, response, responseLen, encodedPacket, packetSize);
}

// Local helper: perform local fabric injection using cert/key material supplied
// by the host over MMIC. Defined below parseAndRunCommand.
static uint8_t performCommission(const commissionArgs_t * args,
                                 const uint8_t * rcac, uint16_t rcacLen,
                                 const uint8_t * icac, uint16_t icacLen,
                                 const uint8_t * noc,  uint16_t nocLen);

// SubscriptionManager delegate: logs lifecycle + attribute reports to the
// device console. Attaches lazily on the first establish_subscription call.
namespace {

mmic_subscription_cb_t gSubscriptionCallback = nullptr;

class MmicSubscriptionDelegate : public chip::Silabs::SubscriptionManager::Delegate
{
public:
    void OnAttributeData(chip::Silabs::SubscriptionManager::Handle handle,
                         const chip::Silabs::SubscriptionManager::Info & info,
                         const chip::app::ConcreteDataAttributePath & path,
                         chip::TLV::TLVReader * data,
                         const chip::app::StatusIB & status) override
    {
        (void) data;
        ChipLogProgress(NotSpecified,
                        "mmic sub[%u] report: node=0x" ChipLogFormatX64
                        " endpoint=%u cluster=" ChipLogFormatMEI " attr=" ChipLogFormatMEI
                        " status=0x%02x",
                        handle, ChipLogValueX64(info.nodeId), path.mEndpointId,
                        ChipLogValueMEI(path.mClusterId), ChipLogValueMEI(path.mAttributeId),
                        static_cast<unsigned>(status.mStatus));
        if (gSubscriptionCallback != nullptr)
        {
            uint64_t value = 0;
            if (data != nullptr)
            {
                switch (data->GetType())
                {
                case chip::TLV::kTLVType_Boolean: {
                    bool b = false;
                    if (data->Get(b) == CHIP_NO_ERROR) { value = b ? 1u : 0u; }
                    break;
                }
                case chip::TLV::kTLVType_UnsignedInteger: {
                    uint64_t u = 0;
                    if (data->Get(u) == CHIP_NO_ERROR) { value = u; }
                    break;
                }
                case chip::TLV::kTLVType_SignedInteger: {
                    int64_t s = 0;
                    if (data->Get(s) == CHIP_NO_ERROR) { value = static_cast<uint64_t>(s); }
                    break;
                }
                default:
                    break;
                }
            }
            gSubscriptionCallback(path.mEndpointId, path.mClusterId, path.mAttributeId, value);
        }
    }
    void OnSubscriptionEstablished(chip::Silabs::SubscriptionManager::Handle handle,
                                   const chip::Silabs::SubscriptionManager::Info & info,
                                   chip::SubscriptionId subscriptionId) override
    {
        ChipLogProgress(NotSpecified,
                        "mmic sub[%u] established (subId=" ChipLogFormatX64 ") node=0x" ChipLogFormatX64,
                        handle, ChipLogValueX64(subscriptionId), ChipLogValueX64(info.nodeId));
    }
    void OnError(chip::Silabs::SubscriptionManager::Handle handle,
                 const chip::Silabs::SubscriptionManager::Info & info, CHIP_ERROR error) override
    {
        (void) info;
        ChipLogError(NotSpecified, "mmic sub[%u] error: %" CHIP_ERROR_FORMAT, handle, error.Format());
    }
    void OnSubscriptionTerminated(chip::Silabs::SubscriptionManager::Handle handle,
                                  const chip::Silabs::SubscriptionManager::Info & info) override
    {
        ChipLogProgress(NotSpecified, "mmic sub[%u] terminated (node=0x" ChipLogFormatX64 ")",
                        handle, ChipLogValueX64(info.nodeId));
    }
};

MmicSubscriptionDelegate gSubscriptionDelegate;
bool gSubscriptionDelegateInstalled = false;

void ensureSubscriptionDelegateInstalled()
{
    if (!gSubscriptionDelegateInstalled)
    {
        chip::Silabs::SubscriptionManager::Instance().SetDelegate(&gSubscriptionDelegate);
        gSubscriptionDelegateInstalled = true;
    }
}
} // namespace

void mmic_set_subscription_callback(mmic_subscription_cb_t cb)
{
    gSubscriptionCallback = cb;
}

uint8_t parseAndRunCommand(uint8_t * buffer, uint16_t len, uint8_t ** response, size_t * packetSize)
{
    VerifyOrReturnError(buffer != NULL && len != 0, MMIC_ERROR_INVALID_ARG);
    VerifyOrReturnError(response != NULL && packetSize != NULL, MMIC_ERROR_INVALID_ARG);

    mmic_command_id_e opcode = INVALID_COMMAND_ID;
    const uint8_t * payload  = NULL;
    uint16_t payloadLen      = 0;
    uint8_t derr = mmic_deserialize_packet(buffer, len, MMIC_HEADER_CMD, &opcode, &payload, &payloadLen);
    VerifyOrReturnError(derr == MMIC_ERROR_OK, derr);

    switch (opcode)
    {
        case ping:
            encodeResponse(ping, const_cast<char *>("pong"), sizeof("pong"), response, packetSize);
            break;
        case version:
            encodeResponse(version, const_cast<char *>(MMIC_VERSION_STRING), sizeof(MMIC_VERSION_STRING), response, packetSize);
            break;
        case matter_state: // To verify commissioning
            {
                matterState_t state;
                if (encodeMatterState(&state) == MMIC_ERROR_OK)
                {
                    encodeResponse(matter_state, &state, sizeof(matterState_t), response, packetSize);
                }
            }
            break;
        case establish_subscription:
            {
                VerifyOrReturnError(payloadLen >= sizeof(subscriptionArgs_t), MMIC_ERROR_INVALID_PACKET);

                subscriptionArgs_t args;
                memcpy(&args, payload, sizeof(args));

                chip::Silabs::SubscriptionManager::Info info;
                info.fabricIndex = args.fabricIndex;
                info.nodeId      = args.nodeId;
                info.endpointId  = args.endpointId;
                info.clusterId   = args.clusterId;
                info.attributeId = args.attributeId;

                ensureSubscriptionDelegateInstalled();

                chip::Silabs::SubscriptionManager::Handle handle =
                    chip::Silabs::SubscriptionManager::kInvalidHandle;

                chip::DeviceLayer::PlatformMgr().LockChipStack();
                CHIP_ERROR err = chip::Silabs::SubscriptionManager::Instance().Subscribe(info, &handle);
                chip::DeviceLayer::PlatformMgr().UnlockChipStack();

                subscriptionEstablishResp_t resp;
                resp.status = (err == CHIP_NO_ERROR) ? 0 : 1;
                resp.handle = handle;
                encodeResponse(establish_subscription, &resp, sizeof(resp), response, packetSize);
            }
            break;
        case subscription_info:
            {
                auto & mgr = chip::Silabs::SubscriptionManager::Instance();

                subscriptionEntry_t entries[MMIC_SUBSCRIPTION_MAX_ENTRIES];
                uint8_t count = 0;

                chip::DeviceLayer::PlatformMgr().LockChipStack();
                for (uint8_t h = 0;
                     h < chip::Silabs::SubscriptionManager::kMaxSubscriptions &&
                     count < MMIC_SUBSCRIPTION_MAX_ENTRIES;
                     ++h)
                {
                    const auto * info = mgr.GetInfo(h);
                    if (info == nullptr) continue;
                    entries[count].handle      = h;
                    entries[count].fabricIndex = info->fabricIndex;
                    entries[count].nodeId      = info->nodeId;
                    entries[count].endpointId  = info->endpointId;
                    entries[count].clusterId   = info->clusterId;
                    entries[count].attributeId = info->attributeId;
                    ++count;
                }
                chip::DeviceLayer::PlatformMgr().UnlockChipStack();

                uint8_t payloadBuf[1 + MMIC_SUBSCRIPTION_MAX_ENTRIES * sizeof(subscriptionEntry_t)];
                payloadBuf[0] = count;
                if (count > 0)
                {
                    memcpy(&payloadBuf[1], entries, (size_t) count * sizeof(subscriptionEntry_t));
                }
                encodeResponse(subscription_info, payloadBuf,
                               1 + (size_t) count * sizeof(subscriptionEntry_t),
                               response, packetSize);
            }
            break;
        case commission:
            {
                VerifyOrReturnError(payloadLen >= sizeof(commissionArgs_t), MMIC_ERROR_INVALID_PACKET);

                commissionArgs_t hdr;
                memcpy(&hdr, payload, sizeof(hdr));

                const uint32_t certsTotal = (uint32_t) hdr.rcacLen + (uint32_t) hdr.icacLen + (uint32_t) hdr.nocLen;
                VerifyOrReturnError(payloadLen == sizeof(commissionArgs_t) + certsTotal, MMIC_ERROR_INVALID_PACKET);

                const uint8_t * certs = payload + sizeof(commissionArgs_t);
                const uint8_t * rcac  = certs;
                const uint8_t * icac  = certs + hdr.rcacLen;
                const uint8_t * noc   = icac + hdr.icacLen;

                uint8_t status = performCommission(&hdr, rcac, hdr.rcacLen,
                                                   (hdr.icacLen ? icac : nullptr), hdr.icacLen,
                                                   noc, hdr.nocLen);
                encodeResponse(commission, &status, sizeof(status), response, packetSize);
            }
            break;
        case decommission:
            {
                chip::DeviceLayer::PlatformMgr().LockChipStack();
                chip::Server::GetInstance().GetFabricTable().DeleteAllFabrics();
                uint8_t remaining = chip::Server::GetInstance().GetFabricTable().FabricCount();
                chip::DeviceLayer::PlatformMgr().UnlockChipStack();
                uint8_t status = (remaining == 0) ? 0 : 1;
                encodeResponse(decommission, &status, sizeof(status), response, packetSize);
            }
            break;
        case addWakeUp:
            {
                VerifyOrReturnError(payloadLen >= sizeof(wakeUpEntry_t), MMIC_ERROR_INVALID_PACKET);

                wakeUpEntry_t entry;
                memcpy(&entry, payload, sizeof(entry));

                CHIP_ERROR err = chip::Silabs::WakeUpMgr::Instance().SetWakeUpTrigger(
                    entry.clusterId, entry.attributeId,
                    static_cast<chip::Silabs::WakeUpMatchMode>(entry.mode), entry.operand);
                uint8_t status = (err == CHIP_NO_ERROR) ? MMIC_ERROR_OK : MMIC_ERROR_INVALID_ARG;
                encodeResponse(addWakeUp, &status, sizeof(status), response, packetSize);
            }
            break;
        case removeWakeUp:
            {
                VerifyOrReturnError(payloadLen >= sizeof(wakeUpRemoveArgs_t), MMIC_ERROR_INVALID_PACKET);

                wakeUpRemoveArgs_t args;
                memcpy(&args, payload, sizeof(args));

                CHIP_ERROR err = chip::Silabs::WakeUpMgr::Instance().RemoveWakeUpTrigger(args.clusterId, args.attributeId);
                uint8_t status = (err == CHIP_NO_ERROR) ? MMIC_ERROR_OK : MMIC_ERROR_INVALID_ARG;
                encodeResponse(removeWakeUp, &status, sizeof(status), response, packetSize);
            }
            break;
        case wakeUpList:
            {
                // Enforce shared upper bound between manager and wire format at compile time.
                static_assert(chip::Silabs::WakeUpMgr::kMaxTriggers <= MMIC_WAKEUP_MAX_ENTRIES,
                              "MMIC_WAKEUP_MAX_ENTRIES must cover WakeUpMgr::kMaxTriggers");
                static_assert(sizeof(wakeUpEntry_t) == sizeof(chip::Silabs::WakeUpTrigger),
                              "wire wakeUpEntry_t must match WakeUpTrigger layout");

                auto triggers = chip::Silabs::WakeUpMgr::Instance().GetWakeUpTriggers();
                const uint8_t count = static_cast<uint8_t>(
                    (triggers.size() > MMIC_WAKEUP_MAX_ENTRIES) ? MMIC_WAKEUP_MAX_ENTRIES : triggers.size());

                uint8_t payloadBuf[1 + MMIC_WAKEUP_MAX_ENTRIES * sizeof(wakeUpEntry_t)];
                payloadBuf[0] = count;
                for (uint8_t i = 0; i < count; ++i)
                {
                    wakeUpEntry_t entry;
                    entry.clusterId   = triggers[i].clusterId;
                    entry.attributeId = triggers[i].attributeId;
                    entry.operand     = triggers[i].operand;
                    entry.mode        = triggers[i].mode;
                    memcpy(&payloadBuf[1 + i * sizeof(wakeUpEntry_t)], &entry, sizeof(entry));
                }
                encodeResponse(wakeUpList, payloadBuf,
                               1 + static_cast<size_t>(count) * sizeof(wakeUpEntry_t),
                               response, packetSize);
            }
            break;
        default:
            return MMIC_ERROR_NOT_IMPLEMENTED;
    };


    return MMIC_ERROR_OK;
}



uint8_t encodeMatterState(matterState_t * state)
{
    VerifyOrReturnError(state != nullptr, MMIC_ERROR_INVALID_ARG);

    memset(state, 0, sizeof(*state));

    auto & server = chip::Server::GetInstance();
    state->nbOfFabric              = server.GetFabricTable().FabricCount();
    state->commissioningWindowOpen = server.GetCommissioningWindowManager().IsCommissioningWindowOpen();

    // Proxy: operational DNS-SD advertising is up once at least one fabric exists.
    state->mdnsOperationalAdvertising = (state->nbOfFabric > 0);

    // Populate first-fabric identity for debugging.
    {
        auto & fabricTable = server.GetFabricTable();
        auto it = fabricTable.begin();
        if (it != fabricTable.end())
        {
            state->fabricIndex = it->GetFabricIndex();
            state->fabricId    = it->GetFabricId();
            state->nodeId      = it->GetNodeId();

            uint8_t cfidBuf[sizeof(uint64_t)];
            chip::MutableByteSpan cfidSpan(cfidBuf);
            if (it->GetCompressedFabricIdBytes(cfidSpan) == CHIP_NO_ERROR)
            {
                memcpy(state->compressedFabricId, cfidBuf, sizeof(state->compressedFabricId));
            }

            chip::Crypto::P256PublicKey rootPubKey;
            if (fabricTable.FetchRootPubkey(it->GetFabricIndex(), rootPubKey) == CHIP_NO_ERROR &&
                rootPubKey.Length() == sizeof(state->rootPublicKey))
            {
                memcpy(state->rootPublicKey, rootPubKey.ConstBytes(), sizeof(state->rootPublicKey));
            }
        }
    }

    if (state->commissioningWindowOpen)
    {
        auto & dnssd = chip::app::DnssdServer::Instance();
        state->mdnsCommissionableUdpPort = dnssd.GetSecuredPort();
        (void) dnssd.GetCommissionableInstanceName(state->mdnsCommissionableInstanceName,
                                                   sizeof(state->mdnsCommissionableInstanceName));

        auto * cdp = chip::DeviceLayer::GetCommissionableDataProvider();
        uint16_t discriminator = 0;
        if (cdp != nullptr && cdp->GetSetupDiscriminator(discriminator) == CHIP_NO_ERROR)
        {
            state->setupDiscriminator = discriminator;
        }
    }

#if CHIP_DEVICE_CONFIG_ENABLE_THREAD
    state->threadAttached = chip::DeviceLayer::ConnectivityMgr().IsThreadAttached();

    otInstance * instance = otGetInstance();
    if (instance != nullptr)
    {
        chip::DeviceLayer::ThreadStackMgr().LockThreadStack();

        state->threadInterfaceUp = otIp6IsEnabled(instance);

        const otIp6Address * eid = otThreadGetMeshLocalEid(instance);
        if (eid != nullptr)
        {
            memcpy(state->threadMeshLocalEid, eid->mFields.m8, sizeof(state->threadMeshLocalEid));
        }

        otOperationalDataset dataset;
        if (otDatasetGetActive(instance, &dataset) == OT_ERROR_NONE)
        {
            if (dataset.mComponents.mIsPanIdPresent)
            {
                state->threadPanId = dataset.mPanId;
            }
            if (dataset.mComponents.mIsChannelPresent)
            {
                state->threadChannel = dataset.mChannel;
            }
            if (dataset.mComponents.mIsExtendedPanIdPresent)
            {
                memcpy(state->threadExtendedPanId, dataset.mExtendedPanId.m8, sizeof(state->threadExtendedPanId));
            }
            if (dataset.mComponents.mIsNetworkNamePresent)
            {
                strncpy(state->threadNetworkName, dataset.mNetworkName.m8, sizeof(state->threadNetworkName) - 1);
                state->threadNetworkName[sizeof(state->threadNetworkName) - 1] = '\0';
            }
        }

        chip::DeviceLayer::ThreadStackMgr().UnlockThreadStack();
    }
#endif // CHIP_DEVICE_CONFIG_ENABLE_THREAD

    return MMIC_ERROR_OK;
}
uint8_t establishSubscription()
{
    return MMIC_ERROR_OK;
}
uint8_t getSubscriptionsInfo()
{
    return MMIC_ERROR_OK;
}

// Inject a fabric into the device using pre-built certs, opkey and IPK
// supplied over MMIC by the host. Returns 0 on success, non-zero on any
// failure. Must not be invoked from within a CHIP-stack callback (grabs
// the stack lock).
static uint8_t performCommission(const commissionArgs_t * args,
                                 const uint8_t * rcac, uint16_t rcacLen,
                                 const uint8_t * icac, uint16_t icacLen,
                                 const uint8_t * noc,  uint16_t nocLen)
{
    using namespace chip;
    using namespace chip::Credentials;
    using namespace chip::Crypto;

    VerifyOrReturnError(args != nullptr, 1);
    VerifyOrReturnError(rcac != nullptr && rcacLen != 0, 1);
    VerifyOrReturnError(noc != nullptr && nocLen != 0, 1);

    // Rebuild the operational keypair from the wire material (uncompressed pub
    // point 0x04||X||Y then the private scalar) into a P256SerializedKeypair
    // and Deserialize() into a P256Keypair suitable for FabricTable.
    P256SerializedKeypair serialized;
    VerifyOrReturnError(serialized.Capacity() >= (MMIC_COMMISSION_OPKEY_PUB_LEN + MMIC_COMMISSION_OPKEY_PRIV_LEN), 2);
    memcpy(serialized.Bytes(), args->opkeyPub, MMIC_COMMISSION_OPKEY_PUB_LEN);
    memcpy(serialized.Bytes() + MMIC_COMMISSION_OPKEY_PUB_LEN,
           args->opkeyPriv, MMIC_COMMISSION_OPKEY_PRIV_LEN);
    VerifyOrReturnError(CHIP_NO_ERROR ==
                            serialized.SetLength(MMIC_COMMISSION_OPKEY_PUB_LEN + MMIC_COMMISSION_OPKEY_PRIV_LEN),
                        3);

    P256Keypair opKey;
    VerifyOrReturnError(opKey.Deserialize(serialized) == CHIP_NO_ERROR, 3);

    DeviceLayer::PlatformMgr().LockChipStack();

    FabricTable & fabricTable = Server::GetInstance().GetFabricTable();

    ByteSpan rcacSpan(rcac, rcacLen);
    ByteSpan icacSpan;
    if (icac != nullptr && icacLen > 0)
    {
        icacSpan = ByteSpan(icac, icacLen);
    }
    ByteSpan nocSpan(noc, nocLen);

    FabricIndex newFabricIndex = kUndefinedFabricIndex;
    CHIP_ERROR err = fabricTable.AddNewPendingTrustedRootCert(rcacSpan);
    VerifyOrReturnError(err == CHIP_NO_ERROR, 4, DeviceLayer::PlatformMgr().UnlockChipStack());

    err = fabricTable.AddNewPendingFabricWithProvidedOpKey(nocSpan, icacSpan, args->vendorId,
                                                           &opKey, /*isExistingOpKeyExternallyOwned=*/false,
                                                           &newFabricIndex);
    VerifyOrReturnError(err == CHIP_NO_ERROR, 5,
                        fabricTable.RevertPendingFabricData(); DeviceLayer::PlatformMgr().UnlockChipStack());

    err = fabricTable.CommitPendingFabricData();
    VerifyOrReturnError(err == CHIP_NO_ERROR, 6,
                        fabricTable.RevertPendingFabricData(); DeviceLayer::PlatformMgr().UnlockChipStack());

    // Install the IPK for the newly committed fabric. Compressed fabric ID
    // is needed as the group key context; the FabricTable computes it from
    // the committed root cert.
    const FabricInfo * fabricInfo = fabricTable.FindFabricWithIndex(newFabricIndex);
    VerifyOrReturnError(fabricInfo != nullptr, 7, DeviceLayer::PlatformMgr().UnlockChipStack());

    uint8_t compressedFabricIdBuf[sizeof(uint64_t)];
    MutableByteSpan compressedFabricIdSpan(compressedFabricIdBuf);
    err = fabricInfo->GetCompressedFabricIdBytes(compressedFabricIdSpan);
    VerifyOrReturnError(err == CHIP_NO_ERROR, 8, DeviceLayer::PlatformMgr().UnlockChipStack());

    GroupDataProvider * groupDataProvider = GetGroupDataProvider();
    VerifyOrReturnError(groupDataProvider != nullptr, 9, DeviceLayer::PlatformMgr().UnlockChipStack());

    ByteSpan ipkSpan(args->ipk, MMIC_COMMISSION_IPK_LEN);
    err = SetSingleIpkEpochKey(groupDataProvider, newFabricIndex, ipkSpan, compressedFabricIdSpan);
    VerifyOrReturnError(err == CHIP_NO_ERROR, 10, DeviceLayer::PlatformMgr().UnlockChipStack());

    // Restart operational DNS-SD so the new fabric shows up on the network.
    (void) app::DnssdServer::Instance().AdvertiseOperational();

    DeviceLayer::PlatformMgr().UnlockChipStack();
    return MMIC_ERROR_OK;
}
#endif // HOST_SIDE
