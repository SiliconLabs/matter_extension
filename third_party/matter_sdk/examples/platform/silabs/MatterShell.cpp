/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
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

#include "MatterShell.h"
#include "sl_component_catalog.h"
#include <ChipShellCollection.h>
#include <cmsis_os2.h>
#include <lib/core/CHIPCore.h>
#include <lib/shell/Engine.h>
#include <lib/shell/commands/Help.h>
#include <sl_cmsis_os2_common.h>
#ifdef SL_CATALOG_CLI_PRESENT
#include "sl_cli.h"
#include "sl_cli_config.h"
#include "sli_cli_io.h"
#include <lib/support/StringBuilder.h>
#endif

using namespace ::chip;
using Shell::Engine;
using Shell::shell_command_t;
using Shell::streamer_get;
using Shell::streamer_printf;

namespace {

constexpr uint32_t kShellProcessFlag   = 1;
constexpr uint32_t kShellTaskStackSize = 2048;
uint8_t shellTaskStack[kShellTaskStackSize];
osThread_t shellTaskControlBlock;
constexpr osThreadAttr_t kShellTaskAttr = { .name       = "shell",
                                            .attr_bits  = osThreadDetached,
                                            .cb_mem     = &shellTaskControlBlock,
                                            .cb_size    = osThreadCbSize,
                                            .stack_mem  = shellTaskStack,
                                            .stack_size = kShellTaskStackSize,
                                            .priority   = osPriorityBelowNormal };
osThreadId_t shellTaskHandle;

void MatterShellTask(void * args)
{
    chip::Shell::Engine::Root().RunMainLoop();
}

} // namespace

namespace chip {

void NotifyShellProcess()
{
    // This function may be called from Interrupt Service Routines.
    osThreadFlagsSet(shellTaskHandle, kShellProcessFlag);
}

void WaitForShellActivity()
{
    osThreadFlagsWait(kShellProcessFlag, osFlagsWaitAny, osWaitForever);
}

#ifdef SL_CATALOG_CLI_PRESENT

CHIP_ERROR CmdSilabsDispatch(int argc, char ** argv)
{
    VerifyOrReturnError(argc > 0, CHIP_ERROR_INVALID_ARGUMENT);

    chip::StringBuilder<SL_CLI_INPUT_BUFFER_SIZE> builder;

    for (int i = 0; i < argc; i++)
    {
        builder.Add(argv[i]);
        builder.Add(" ");
    }

    VerifyOrReturnError(builder.Fit(), CHIP_ERROR_BUFFER_TOO_SMALL);

    sl_cli_handle_input(sl_cli_default_handle, const_cast<char *>(builder.c_str()));

    return CHIP_NO_ERROR;
}

static const Shell::shell_command_t cmds_silabs_root = { &CmdSilabsDispatch, "silabs", "Dispatch Silicon Labs CLI command" };

void cmdSilabsInit()
{
    // Register the root otcli command with the top-level shell.
    Engine::Root().RegisterCommands(&cmds_silabs_root, 1);
}

#endif // SL_CATALOG_CLI_PRESENT

#if defined(SL_CATALOG_WATCHDOG_MANAGER_PRESENT) && defined(SL_MATTER_TEST_WATCHDOG)
#include "sl_watchdog_manager.h"

namespace WatchdogShellCommands {

Engine sShellWatchdogSubCommands;

CHIP_ERROR WatchdogCommandHandler(int argc, char ** argv)
{
    if (argc == 0)
    {
        sShellWatchdogSubCommands.ForEachCommand(Shell::PrintCommandHelp, nullptr);
        return CHIP_NO_ERROR;
    }
    return sShellWatchdogSubCommands.ExecCommand(argc, argv);
}

CHIP_ERROR ForceWatchdogStarvation([[maybe_unused]] int argc, [[maybe_unused]] char ** argv)
{
    streamer_printf(streamer_get(), "Watchdog being starved, expect a reboot\r\n");
    while (1)
    {
        __NOP();
    }
    return CHIP_NO_ERROR;
}

void RegisterCommands()
{
    static const Shell::shell_command_t cmds_watchdog = { &WatchdogCommandHandler, "watchdog",
                                                          "Dispatch Silabs Watchdog Manager CLI commands" };

    static const Shell::Command sWatchdogSubCommands[] = {
        { &ForceWatchdogStarvation, "starve", "Force the watchdog to starve" },
    };
    sShellWatchdogSubCommands.RegisterCommands(sWatchdogSubCommands, MATTER_ARRAY_SIZE(sWatchdogSubCommands));
    Engine::Root().RegisterCommands(&cmds_watchdog, 1);
}

} // namespace WatchdogShellCommands
#endif // SL_CATALOG_WATCHDOG_MANAGER_PRESENT && SL_MATTER_TEST_WATCHDOG

void startShellTask()
{
    int status = chip::Shell::Engine::Root().Init();
    VerifyOrDie(status == 0);

    // For now also register commands from shell_common (shell app).
    // TODO move at least OTCLI to default commands in lib/shell/commands
    cmd_misc_init();
#ifdef SL_CATALOG_OPENTHREAD_CLI_PRESENT
    cmd_otcli_init();
#endif

#ifdef SL_CATALOG_CLI_PRESENT
    cmdSilabsInit();
#endif

#if defined(SL_CATALOG_WATCHDOG_MANAGER_PRESENT) && defined(SL_MATTER_TEST_WATCHDOG)
    WatchdogShellCommands::RegisterCommands();
#endif // SL_CATALOG_WATCHDOG_MANAGER_PRESENT && SL_MATTER_TEST_WATCHDOG

    shellTaskHandle = osThreadNew(MatterShellTask, nullptr, &kShellTaskAttr);
    VerifyOrDie(shellTaskHandle);
}

} // namespace chip
