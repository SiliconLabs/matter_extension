/***************************************************************************
 * @file SilabsTracing.cpp
 * @brief Instrumenting for matter operation tracing for the Silicon Labs platform.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
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
#include "TracingShellCommands.h"
#include <lib/shell/Command.h>
#include <lib/shell/Engine.h>
#include <lib/shell/commands/Help.h>
#include <lib/support/Span.h>
#include <platform/silabs/tracing/SilabsTracing.h>

using namespace chip;
using Shell::Engine;
using Shell::shell_command_t;
using Shell::streamer_get;
using Shell::streamer_printf;

namespace {

using TimeTraceOperation = Tracing::Silabs::TimeTraceOperation;
using SilabsTracer       = Tracing::Silabs::SilabsTracer;

TimeTraceOperation StringToTimeTraceOperation(const char * str)
{
    if (strcmp(str, "Spake2p") == 0)
    {
        return TimeTraceOperation::kSpake2p;
    }
    else if (strcmp(str, "Pake1") == 0)
    {
        return TimeTraceOperation::kPake1;
    }
    else if (strcmp(str, "Pake2") == 0)
    {
        return TimeTraceOperation::kPake2;
    }
    else if (strcmp(str, "Pake3") == 0)
    {
        return TimeTraceOperation::kPake3;
    }
    else if (strcmp(str, "OperationalCredentials") == 0)
    {
        return TimeTraceOperation::kOperationalCredentials;
    }
    else if (strcmp(str, "AttestationVerification") == 0)
    {
        return TimeTraceOperation::kAttestationVerification;
    }
    else if (strcmp(str, "CSR") == 0)
    {
        return TimeTraceOperation::kCSR;
    }
    else if (strcmp(str, "NOC") == 0)
    {
        return TimeTraceOperation::kNOC;
    }
    else if (strcmp(str, "TransportLayer") == 0)
    {
        return TimeTraceOperation::kTransportLayer;
    }
    else if (strcmp(str, "TransportSetup") == 0)
    {
        return TimeTraceOperation::kTransportSetup;
    }
    else if (strcmp(str, "FindOperational") == 0)
    {
        return TimeTraceOperation::kFindOperational;
    }
    else if (strcmp(str, "CaseSession") == 0)
    {
        return TimeTraceOperation::kCaseSession;
    }
    else if (strcmp(str, "Sigma1") == 0)
    {
        return TimeTraceOperation::kSigma1;
    }
    else if (strcmp(str, "Sigma2") == 0)
    {
        return TimeTraceOperation::kSigma2;
    }
    else if (strcmp(str, "Sigma3") == 0)
    {
        return TimeTraceOperation::kSigma3;
    }
    else if (strcmp(str, "OTA") == 0)
    {
        return TimeTraceOperation::kOTA;
    }
    else if (strcmp(str, "ImageUpload") == 0)
    {
        return TimeTraceOperation::kImageUpload;
    }
    else if (strcmp(str, "ImageVerification") == 0)
    {
        return TimeTraceOperation::kImageVerification;
    }
    else if (strcmp(str, "AppApplyTime") == 0)
    {
        return TimeTraceOperation::kAppApplyTime;
    }
    else if (strcmp(str, "Bootup") == 0)
    {
        return TimeTraceOperation::kBootup;
    }
    else if (strcmp(str, "SilabsInit") == 0)
    {
        return TimeTraceOperation::kSilabsInit;
    }
    else if (strcmp(str, "MatterInit") == 0)
    {
        return TimeTraceOperation::kMatterInit;
    }
    else if (strcmp(str, "BufferFull") == 0)
    {
        return TimeTraceOperation::kBufferFull;
    }
    else
    {
        return TimeTraceOperation::kNumTraces;
    }
}

Engine sShellTracingSubCommands;

/********************************************************
 * Silabs Tracing shell functions
 *********************************************************/

CHIP_ERROR TracingHelpHandler(int argc, char ** argv)
{
    sShellTracingSubCommands.ForEachCommand(Shell::PrintCommandHelp, nullptr);
    return CHIP_NO_ERROR;
}

CHIP_ERROR TracingListTimeOperations(int argc, char ** argv)
{
    size_t TotalTraceNumber =
        to_underlying(TimeTraceOperation::kNumTraces) + SilabsTracer::Instance().GetRegisteredAppOperationsCount();
    for (size_t i = 0; i < TotalTraceNumber; ++i)
    {
        streamer_printf(streamer_get(), "Operation: %s\r\n", Tracing::Silabs::TimeTraceOperationToString(i));
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR TracingCommandHandler(int argc, char ** argv)
{
    if (argc == 0)
    {
        return TracingHelpHandler(argc, argv);
    }

    return sShellTracingSubCommands.ExecCommand(argc, argv);
}

CHIP_ERROR WatermarksCommandHandler(int argc, char ** argv)
{
    CHIP_ERROR error = CHIP_NO_ERROR;
    if (argc == 0 || argv == nullptr || argv[0] == nullptr)
    {
        streamer_printf(streamer_get(), "Usage: tracing watermarks <TimeTraceOperation>\r\n");
        return CHIP_ERROR_INVALID_ARGUMENT;
    }

    if (strcmp(argv[0], "all") == 0)
    {
        error = SilabsTracer::Instance().OutputAllWaterMarks();
    }
    else
    {
        TimeTraceOperation operation = StringToTimeTraceOperation(argv[0]);
        error                        = SilabsTracer::Instance().OutputWaterMark(operation);
    }
    return error;
}

CHIP_ERROR FlushCommandHandler(int argc, char ** argv)
{
    CHIP_ERROR error = CHIP_NO_ERROR;
    size_t index;
    if (argc == 0 || argv == nullptr || argv[0] == nullptr)
    {
        streamer_printf(streamer_get(), "Usage: tracing flush <TimeTraceOperation>\r\n");
        return CHIP_ERROR_INVALID_ARGUMENT;
    }

    CharSpan opKey(argv[0], sizeof(argv[0]));
    if (strcmp(argv[0], "all") == 0)
    {
        error = SilabsTracer::Instance().TraceBufferFlushAll();
    }
    else if (CHIP_NO_ERROR == SilabsTracer::Instance().FindAppOperationIndex(opKey, index))
    {
        SilabsTracer::Instance().TraceBufferFlushByOperation(opKey);
    }
    else
    {
        TimeTraceOperation operation = StringToTimeTraceOperation(argv[0]);
        if (operation == TimeTraceOperation::kNumTraces)
        {
            streamer_printf(streamer_get(), "Unknown Operation Key\r\n");
            return CHIP_ERROR_INVALID_ARGUMENT;
        }
        error = SilabsTracer::Instance().TraceBufferFlushByOperation(to_underlying(operation));
    }
    return error;
}

} // namespace

namespace TracingCommands {

void RegisterCommands()
{
    static const Shell::Command sTracingSubCommands[] = {
        { &TracingHelpHandler, "help", "Output the help menu" },
        { &TracingListTimeOperations, "list", "List all available TimeTraceOperations" },
        { &WatermarksCommandHandler, "watermarks", "Display runtime watermarks. Usage: watermarks <TimeTraceOperation>" },
        { &FlushCommandHandler, "flush", "Display buffered traces. Usage: flush <TimeTraceOperation>" },
    };
    static const Shell::Command cmds_silabs_tracing = { &TracingCommandHandler, "tracing",
                                                        "Dispatch Silicon Labs Tracing command" };

    sShellTracingSubCommands.RegisterCommands(sTracingSubCommands, ArraySize(sTracingSubCommands));
    Engine::Root().RegisterCommands(&cmds_silabs_tracing, 1);
}

} // namespace TracingCommands
