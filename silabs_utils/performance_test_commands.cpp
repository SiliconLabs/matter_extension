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
#if defined(ENABLE_CHIP_SHELL)

#include <app/server/Server.h>
#include <app/OperationalSessionSetup.h>
#include <lib/shell/Engine.h>
#include <lib/shell/commands/Help.h>
#include <platform/CHIPDeviceLayer.h>
#include <lib/support/CodeUtils.h>
#include <controller/WriteInteraction.h>

#include <app/clusters/general-diagnostics-server/general-diagnostics-server.h>

#include "debug_channel.h"

#include <performance_test_commands.h>

using namespace chip;
using namespace chip::app;

using Shell::Engine;
using Shell::shell_command_t;
using Shell::streamer_get;
using Shell::streamer_printf;

using namespace chip;
using namespace chip::app;

#include "controller/InvokeInteraction.h"

#ifndef MAX
#define MAX(a,b) ((a) > (b) ? (a) : (b))
#endif

Engine sShellPerfTestSubCommands;

// Define static memebers
MatterPerfTest *MatterPerfTest::globalInstance = nullptr;



/*********************************************************************************************/
/*************** Implementation of the callbacks for the Performance Testing cluster *********/
/*********************************************************************************************/

bool emberAfPerformanceTestingClusterEmptyCommandCallback(chip::app::CommandHandler* commandObj, chip::app::ConcreteCommandPath const& commandPath, chip::app::Clusters::PerformanceTesting::Commands::EmptyCommand::DecodableType const& commandData)
{

    if (commandData.payload.HasValue())
    {
        auto payload = commandData.payload;

        if((payload.Value().size()) >= 4) {
            uint32_t sequence = ((payload.Value()[0])<<0)|((payload.Value()[1])<<8)|((payload.Value()[2])<<16)|((payload.Value()[3])<<24);
            ChipLogDetail(NotSpecified, "  Performance Test Payload: buf %p size %u sequence number: %lu",
                      (payload.Value().data()),
                      static_cast<unsigned int>(payload.Value().size()),
                      sequence);

            // Print message on debug backchannel. sl_debug_binary_format() prints in the big-endian format
            sequence = ((payload.Value()[0])<<24)|((payload.Value()[1])<<16)|((payload.Value()[2])<<8)|((payload.Value()[3])<<0);

            sl_debug_binary_format(EM_DEBUG_LATENCY, "BBD",
                           1,   // frame control: Latency Stop
                           4,   // length of sequence number
                           sequence);

        } else {
            ChipLogError(NotSpecified, "ERROR! size is less than 4");
        }
    }

    commandObj->AddStatus(commandPath, chip::Protocols::InteractionModel::Status::Success);

    return true;
}

void MatterPerformanceTestingPluginServerInitCallback()
{
}

/********************************************************************************************/
/************************* MatterPerfTest class implementation ******************************/
/********************************************************************************************/

// Send another ping or complete the test
void MatterPerfTest::PingExecuteNextAction()
{
    if(pingInProgress != true) {
        // Should not happen
        ChipLogError(NotSpecified, "ERROR: Received a ping responce with no ping in progress");
        return;
    }

    if(requestsSent < pingCountTotal) {
        DeviceLayer::SystemLayer().ScheduleLambda([this] { SendNextPing(); });
    } else {
        ChipLogProgress(NotSpecified, "Last ping completed");
        streamer_printf(streamer_get(), "Ping: %d packets transmitted, %d packets received.\r\n",
                    requestsSent, responsesReceived);
        if(responsesReceived != 0) {
            uint32_t packetLossRate = 1000 * (requestsSent - responsesReceived) / requestsSent;
            uint32_t avgRoundTripTime = 1000 * totalResponseTime / responsesReceived;
            streamer_printf(streamer_get(), "Packet loss = %u.%u%%, Round-trip min/avg/max = %u/%u.%u/%u ms.\r\n",
                            packetLossRate / 10, packetLossRate % 10,
                            minResponseTime, avgRoundTripTime / 1000, avgRoundTripTime % 1000, maxResponseTime);
        }

        pingInProgress    = false;
        responsesReceived = 0;
        requestsSent      = 0;
        length            = 0;
        minResponseTime   = -1;
        maxResponseTime   = 0;
        totalResponseTime = 0;
    }
}

// Callback to be invoked when a session with the target node is successfully established
void MatterPerfTest::PingPerfTestOnConnnection(Messaging::ExchangeManager & exchangeMgr, const SessionHandle & sessionHandle)
{
    CHIP_ERROR err = CHIP_NO_ERROR;

    // Lambda that will be executed if the command response has been received
    auto onSuccess = [this](const ConcreteCommandPath & commandPath, const StatusIB & status, const auto & dataResponse) {
        uint64_t now = chip::System::SystemClock().GetMonotonicMilliseconds64().count();
        uint32_t currentResponseTime = (uint32_t)(now - pingStartTime);

        minResponseTime = ((currentResponseTime < minResponseTime) ?  currentResponseTime : minResponseTime);
        maxResponseTime = ((currentResponseTime > maxResponseTime) ?  currentResponseTime : maxResponseTime);
        totalResponseTime += currentResponseTime;

        responsesReceived++;
        ChipLogProgress(NotSpecified, "Ping response received. Total received so far: %d", responsesReceived);

        PingExecuteNextAction();
    };

    // Lambda that will be executed if the command was sent but no response was received
    auto onFailure = [this](CHIP_ERROR error) {
        ChipLogError(NotSpecified, "Ping: got no response, CHIP ERROR: %" CHIP_ERROR_FORMAT, error.Format());

        PingExecuteNextAction();
    };

    ChipLogProgress(NotSpecified, "Connection established, transmitting a ping command");

    // Print message on debug backchannel, sl_debug_binary_format() prints in the big-endian format so flip the bytes
    uint32_t sequence =  ((PerformanceTestPingMagicNumber & 0xff000000UL)>>24) | ((PerformanceTestPingMagicNumber & 0x00ff0000UL)>>8) |
                         ((PerformanceTestPingMagicNumber & 0x0000ff00UL)<<8)  | ((PerformanceTestPingMagicNumber & 0x000000ffUL)<<24);
    sl_debug_binary_format(EM_DEBUG_LATENCY, "BBD",
                           0,   // frame control: Latency Start
                           4,   // length of the next field
                           sequence);

    // First four bytes are the sequence number
    uint8_t buf[300];
    buf[0] = (sequence & 0xff000000UL)>>24;
    buf[1] = (sequence & 0x00ff0000UL)>>16;
    buf[2] = (sequence & 0x0000ff00UL)>>8;
    buf[3] = (sequence & 0x000000ffUL);

    for(int i = 4; i < length; i++) {
        buf[i] = 0x07; // arbitrary
    }

    Clusters::PerformanceTesting::Commands::EmptyCommand::Type EmptyCommand;
    EmptyCommand.payload =  chip::MakeOptional(chip::Span<const uint8_t>(buf, MAX(4, length)));


    requestsSent++;
    pingStartTime = chip::System::SystemClock().GetMonotonicMilliseconds64().count();

    err = Controller::InvokeCommandRequest(&exchangeMgr, sessionHandle, chip::EndpointId(0), EmptyCommand, onSuccess, onFailure,
                                           NullOptional,
                                           MakeOptional(chip::System::Clock::Timeout(timeoutMs)));

    // Command could not be sent
    if(err != CHIP_NO_ERROR) {
        ChipLogError(NotSpecified, "Command invocation for ping test failed, Error: %" CHIP_ERROR_FORMAT, err.Format());
        PingExecuteNextAction();
    }
}

// Callback to be invoked if a session with the target node could not be established
void MatterPerfTest::PingPerfTestOnConnnectionFailure(const ScopedNodeId & peerId, CHIP_ERROR error)
{
    ChipLogError(NotSpecified, "Ping test Session establishment failure ");

    // Treat this as a test failure, do not retry. Cancel the test (set pingInProgress to false) and report the results.
    streamer_printf(streamer_get(), "Ping: %d packets transmitted, %d packets received.\r\n",
                    requestsSent, responsesReceived);
    if(responsesReceived != 0) {
        uint32_t packetLossRate = 1000 * (requestsSent - responsesReceived) / requestsSent;
        uint32_t avgRoundTripTime = 1000 * totalResponseTime / responsesReceived;
        streamer_printf(streamer_get(), "Packet loss = %u.%u%%, Round-trip min/avg/max = %u/%u.%u/%u ms.\r\n",
                        packetLossRate / 10, packetLossRate % 10,
                        minResponseTime, avgRoundTripTime / 1000, avgRoundTripTime % 1000, maxResponseTime);
    }

    pingInProgress    = false;
    responsesReceived = 0;
    requestsSent      = 0;
    length            = 0;
    minResponseTime   = -1;
    maxResponseTime   = 0;
    totalResponseTime = 0;
}

// Sends a ping (the EmptyCommand from the Performance Testing custom cluster)
void MatterPerfTest::SendNextPing()
{
    auto & server = chip::Server::GetInstance();
    server.GetCASESessionManager()->FindOrEstablishSession(ScopedNodeId(nodeId, fabricIndex),
                                                       &_PingPerfTestOnConnnection,
                                                       &_PingPerfTestOnConnnectionFailure);
}

// Entry point into the MatterPerfTest ping logic
void MatterPerfTest::PingPerfTest(intptr_t param)
{
    PerfTestCommandData * data = reinterpret_cast<PerfTestCommandData *>(param);

    if(pingInProgress == true) {
         streamer_printf(streamer_get(), "Error: Ping command already in progress \r\n");
         Platform::Delete(data);
         return;
    }

    ChipLogProgress(NotSpecified, "Executing ping performance test, pingCountTotal: %d fabricId: %ld, nodeId: 0x%lx length: %u timeoutMs: %ld",
                    data->count, (uint32_t)data->fabricIndex, (uint32_t)data->nodeId, data->length, data->timeoutMs );

    nodeId = data->nodeId;
    fabricIndex = data->fabricIndex;
    pingCountTotal = data->count;
    length = data->length;

    Platform::Delete(data);

    // pingStartTime = chip::System::SystemClock().GetMonotonicMilliseconds64().count();

    requestsSent = 0;
    responsesReceived = 0;
    pingInProgress = true;

    SendNextPing();
}

// Entry point into the MatterPerfTest multicast test logic
void MatterPerfTest::MxPerfTest(intptr_t  params)
{
    PerfTestCommandData * data = reinterpret_cast<PerfTestCommandData *>(params);

    ChipLogProgress(NotSpecified, "Executing mcast performance test, fabricId: %ld, groupId 0x%lx length %u seqNum %lu",
                    (uint32_t)data->fabricIndex,  (uint32_t)data->groupId, data->length,  data->seqNum);

    // Print message on debug backchannel, sl_debug_binary_format() prints in the big-endian format so flip the bytes
    uint32_t sequence =  ((data->seqNum & 0xff000000UL)>>24) | ((data->seqNum & 0x00ff0000UL)>>8) |
                         ((data->seqNum & 0x0000ff00UL)<<8)  | ((data->seqNum & 0x000000ffUL)<<24);
    sl_debug_binary_format(EM_DEBUG_LATENCY, "BBD",
                           0,   // frame control: Latency Start
                           4,   // length of sequence number
                           sequence);

    Messaging::ExchangeManager & exchangeMgr = Server::GetInstance().GetExchangeManager();

    // First four bytes are the sequence number
    uint8_t buf[300];
    buf[0] = (sequence & 0xff000000UL) >> 24;
    buf[1] = (sequence & 0x00ff0000UL) >> 16;
    buf[2] = (sequence & 0x0000ff00UL) >> 8;
    buf[3] = (sequence & 0x000000ffUL);

    for(int i = 4; i < data->length; i++) {
        buf[i] = 0x07; // arbitrary
    }

    Clusters::PerformanceTesting::Commands::EmptyCommand::Type EmptyCommand;
    EmptyCommand.payload =  chip::MakeOptional(chip::Span<const uint8_t>(buf, MAX(4, data->length)));

    Controller::InvokeGroupCommandRequest(&exchangeMgr, data->fabricIndex, data->groupId, EmptyCommand);

    Platform::Delete(data);
}

/*********************************************************************************************/
/************************* Performance Test Shell command implementation *********************/
/*********************************************************************************************/

// Prints out help for the "perf .." commands
CHIP_ERROR PerfTestHelpHandler(int argc, char ** argv)
{
    sShellPerfTestSubCommands.ForEachCommand(Shell::PrintCommandHelp, nullptr);
    return CHIP_NO_ERROR;
}

// "perf ping" comman handler. Checks the argument and schedules MatterPerfTest ping logic
CHIP_ERROR PingPerfTestCommandHandler(int argc, char ** argv)
{
    if (argc != 5)
        {
            return PerfTestHelpHandler(argc, argv);
        }

    if(atoi(argv[0]) <= 0)
        {
            streamer_printf(streamer_get(), "Error: <count> must be greater than zero\r\n");
            return CHIP_ERROR_INVALID_ARGUMENT;
        }

    if(atoi(argv[3]) > 300)
        {
            streamer_printf(streamer_get(), "Error: <length> must be 300 or less \r\n");
            return CHIP_ERROR_INVALID_ARGUMENT;
        }

    PerfTestCommandData * data = Platform::New<PerfTestCommandData>();

    data->count          = atoi(argv[0]);
    data->fabricIndex    = atoi(argv[1]);
    data->nodeId         = atoi(argv[2]);
    data->length         = atol(argv[3]);
    data->timeoutMs      = atol(argv[4]);

    DeviceLayer::SystemLayer().ScheduleLambda([data]{MatterPerfTest::GetInstance()->PingPerfTest(reinterpret_cast<intptr_t>(data));});
    return CHIP_NO_ERROR;
}

// "perf mx" comman handler. Checks the argument and schedules MatterPerfTest multicast logic
CHIP_ERROR MxPerfTestCommandHandler(int argc, char ** argv)
{
    if (argc != 4)
    {
        return PerfTestHelpHandler(argc, argv);
    }

    if(atoi(argv[2]) > 300)
    {
        streamer_printf(streamer_get(), "Error: <length> must be 300 or less \r\n");
        return CHIP_ERROR_INVALID_ARGUMENT;
    }

    PerfTestCommandData * data = Platform::New<PerfTestCommandData>();

    data->fabricIndex = atoi(argv[0]);
    data->groupId     = atoi(argv[1]);
    data->length      = atoi(argv[2]);
    data->seqNum      = atoi(argv[3]);

    DeviceLayer::SystemLayer().ScheduleLambda([data]{MatterPerfTest::GetInstance()->MxPerfTest(reinterpret_cast<intptr_t>(data));});
    return CHIP_NO_ERROR;
}

// Top level "perf .." command handler
CHIP_ERROR PerfTestCommandHandler(int argc, char ** argv)
{
    if (argc == 0)
    {
        return PerfTestHelpHandler(argc, argv);
    }

    return sShellPerfTestSubCommands.ExecCommand(argc, argv);
}

// Register "perf .." shell commands
void RegisterPerfTestCommands()
{
    static const shell_command_t sPerfTestSubCommands[] = {
        { &PerfTestHelpHandler, "help", "Usage: perf <subcommand>" },
        { &PingPerfTestCommandHandler, "ping", "Usage: perf ping <count> <fabricIndex> <destNodeId> <length> <timeout_ms>" },
        { &MxPerfTestCommandHandler, "mx", "Usage: perf mx <fabricIndex> <destGroupId> <length> <sequence number>" }
    };

    static const shell_command_t sPerfTestCommand = { &PerfTestCommandHandler, "perf",
                                                    "Performance Testing commands. Usage: perf <subcommand>" };
    sShellPerfTestSubCommands.RegisterCommands(sPerfTestSubCommands, ArraySize(sPerfTestSubCommands));

    Engine::Root().RegisterCommands(&sPerfTestCommand, 1);
}
#endif // ENABLE_CHIP_SHELL
