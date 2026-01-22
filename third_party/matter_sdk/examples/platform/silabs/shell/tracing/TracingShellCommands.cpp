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
    return SilabsTracer::Instance().OutputAllCurrentOperations();
}

CHIP_ERROR TracingCommandHandler(int argc, char ** argv)
{
    if (argc == 0)
    {
        return TracingHelpHandler(argc, argv);
    }

    return sShellTracingSubCommands.ExecCommand(argc, argv);
}

CHIP_ERROR MetricsCommandHandler(int argc, char ** argv)
{
    VerifyOrReturnError((argc != 0) && (argv != nullptr) && (argv[0] != nullptr), CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Usage: tracing metrics <TimeTraceOperation>\r\n"));

    CHIP_ERROR error = CHIP_NO_ERROR;
    if (strcmp(argv[0], "all") == 0)
    {
        error = SilabsTracer::Instance().OutputAllMetrics();
    }
    else
    {
        error = SilabsTracer::Instance().OutputMetric(CharSpan::fromCharString(argv[0]));
    }
    return error;
}

CHIP_ERROR FlushCommandHandler(int argc, char ** argv)
{
    VerifyOrReturnError((argc != 0) && (argv != nullptr) && (argv[0] != nullptr), CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Usage: tracing flush <TimeTraceOperation>\r\n"));

    CHIP_ERROR error = CHIP_NO_ERROR;
    CharSpan opKey(argv[0], sizeof(argv[0]));
    if (strcmp(argv[0], "all") == 0)
    {
        error = SilabsTracer::Instance().TraceBufferFlushAll();
    }
    else
    {
        error = SilabsTracer::Instance().TraceBufferFlushByOperation(CharSpan::fromCharString(argv[0]));
    }
    return error;
}

CHIP_ERROR TasksCommandHandler(int argc, char ** argv)
{
    return SilabsTracer::Instance().OutputTaskStatistics();
}

CHIP_ERROR EnergyCommandHandler(int argc, char ** argv)
{
    return SilabsTracer::Instance().OutputPowerManagerStatistics();
}

} // namespace

namespace TracingCommands {

void RegisterCommands()
{
    static const Shell::Command sTracingSubCommands[] = {
        { &TracingHelpHandler, "help", "Output the help menu" },
        { &TracingListTimeOperations, "list", "List all available TimeTraceOperations" },
        { &MetricsCommandHandler, "metrics", "Display runtime metrics. Usage: metrics <TimeTraceOperation>" },
        { &FlushCommandHandler, "flush", "Display buffered traces. Usage: flush <TimeTraceOperation>" },
        { &TasksCommandHandler, "tasks", "Display FreeRTOS task statistics." },
        { &EnergyCommandHandler, "energy", "Display energy mode statistics." },
    };
    static const Shell::Command cmds_silabs_tracing = { &TracingCommandHandler, "tracing",
                                                        "Dispatch Silicon Labs Tracing command" };

    sShellTracingSubCommands.RegisterCommands(sTracingSubCommands, MATTER_ARRAY_SIZE(sTracingSubCommands));
    Engine::Root().RegisterCommands(&cmds_silabs_tracing, 1);
}

} // namespace TracingCommands
