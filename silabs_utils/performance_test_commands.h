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

#include <SilabsTestEventTriggerDelegate.h>

// This must correspond to the SILABS_TEST_EVENT_TRIGGER_ENABLE_KEY set at compile time
constexpr uint8_t kPerfTestTestEventTriggerEnableKey[chip::TestEventTriggerDelegate::kEnableKeyLength] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55,
                                                                                          0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb,
                                                                                          0xcc, 0xdd, 0xee, 0xff };
constexpr uint32_t EventTriggerPingMagicNumber = 1729;
constexpr uint32_t kPingDefaultTimeoutMs       = 1000;

void RegisterPerfTestCommands();

struct PerfTestCommandData
{
    chip::FabricIndex fabricIndex;
    union
    {
        chip::NodeId nodeId;
        chip::GroupId groupId;
    };
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

    bool    pingInProgress = false;

    uint8_t  responsesReceived = 0;
    uint8_t  requestsSent      = 0;
    uint8_t  pingCountTotal    = 0;
    uint32_t timeoutMs         = kPingDefaultTimeoutMs;

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

    // Failure callback FindOrEstablishSession()
    void PingPerfTestOnConnnectionFailure(const chip::ScopedNodeId & peerId, CHIP_ERROR error);
    static void sPingPerfTestOnConnnectionFailure(void * context, const chip::ScopedNodeId & peerId, CHIP_ERROR error)
    {
      MatterPerfTest   * _this = static_cast<MatterPerfTest *>(context);
      _this->PingPerfTestOnConnnectionFailure(peerId, error);
    }
    chip::Callback::Callback<chip::OnDeviceConnectionFailure> _PingPerfTestOnConnnectionFailure; 
};
