/**
 * @file
 * @brief Matter Performance Testing CLI
 *******************************************************************************
 * # License
 * <b>Copyright 2022 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 *
 * https://www.silabs.com/about-us/legal/master-software-license-agreement
 *
 * This software is distributed to you in Source Code format and is governed by
 * the sections of the MSLA applicable to Source Code.
 */

constexpr uint32_t PerformanceTestPingMagicNumber = 1729;
constexpr uint32_t kPingDefaultTimeoutMs          = 1000;

void RegisterPerfTestCommands();

struct PerfTestCommandData
{
    chip::FabricIndex fabricIndex;
    union
    {
        chip::NodeId nodeId;
        chip::GroupId groupId;
    };
    uint16_t length;
    uint32_t seqNum;
    uint16_t count;
    uint32_t timeoutMs;
};

class MatterPerfTest {
public:
     MatterPerfTest() : _PingPerfTestOnConnnection(sPingPerfTestOnConnnection, this),
                        _PingPerfTestOnConnnectionFailure(sPingPerfTestOnConnnectionFailure, this) {}
    static MatterPerfTest *GetInstance()
    {
        if(globalInstance != nullptr) {
                return globalInstance;
        } else {
            globalInstance = new MatterPerfTest;
            return globalInstance;
        }
    }
    void MxPerfTest(intptr_t  params);
    void PingPerfTest(intptr_t  params);
    void SendNextPing();
    void PingExecuteNextAction();
private:
    static MatterPerfTest *globalInstance;

    bool      pingInProgress = false; // Indicates whether the "perf ping" command is in progress

    uint16_t  responsesReceived = 0;  // Number of successfully acknowledged pings
    uint16_t  requestsSent      = 0;  // Number of pings sent
    uint16_t  pingCountTotal    = 0;  // Total number of pings to be sent by "perf ping"
    uint16_t  length            = 0;  // Length of the ping command payload
    uint32_t  timeoutMs         = kPingDefaultTimeoutMs; // Command timeout
    uint64_t  pingStartTime     = 0;  // Timestamp for the individual ping in progress
    uint32_t  minResponseTime   = -1; // Minimum roundtrip time across all pings sent by "perf ping"
    uint32_t  maxResponseTime   = 0;  // Maximum roundtrip time across all pings sent by "perf ping"
    uint32_t  totalResponseTime = 0;  // Cumulative roundtrip time across all pings sent by "perf ping"

    chip::NodeId nodeId           = chip::kUndefinedNodeId;
    chip::FabricIndex fabricIndex = chip::kUndefinedFabricIndex;

    // Success callback for FindOrEstablishSession()
    void PingPerfTestOnConnnection(chip::Messaging::ExchangeManager & exchangeMgr, const chip::SessionHandle & sessionHandle);
    static void sPingPerfTestOnConnnection(void * context, chip::Messaging::ExchangeManager & exchangeMgr, const chip::SessionHandle & sessionHandle)
    {
      MatterPerfTest   * _this = static_cast<MatterPerfTest *>(context);
      _this->PingPerfTestOnConnnection(exchangeMgr, sessionHandle);
    }
    chip::Callback::Callback<chip::OnDeviceConnected> _PingPerfTestOnConnnection;

    // Failure callback for FindOrEstablishSession()
    void PingPerfTestOnConnnectionFailure(const chip::ScopedNodeId & peerId, CHIP_ERROR error);
    static void sPingPerfTestOnConnnectionFailure(void * context, const chip::ScopedNodeId & peerId, CHIP_ERROR error)
    {
      MatterPerfTest   * _this = static_cast<MatterPerfTest *>(context);
      _this->PingPerfTestOnConnnectionFailure(peerId, error);
    }
    chip::Callback::Callback<chip::OnDeviceConnectionFailure> _PingPerfTestOnConnnectionFailure;
};
