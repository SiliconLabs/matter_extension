/***************************************************************************
 * @file BLEShellCommands.cpp
 * @brief Instrumenting to call BLE shell commands for the Silicon Labs platform.
 *******************************************************************************
 * # License
 * <b>Copyright 2025 Silicon Laboratories Inc. www.silabs.com</b>
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

#include "BLEShellCommands.h"
#include <lib/shell/Command.h>
#include <lib/shell/Engine.h>
#include <lib/shell/commands/Help.h>
#include <lib/support/CodeUtils.h>

#include <platform/ConfigurationManager.h>
#include <platform/internal/BLEManager.h>

using namespace chip;
using Shell::Engine;
using Shell::shell_command_t;
using Shell::streamer_get;
using Shell::streamer_printf;

namespace {

Engine sShellBLESubCommands;

/********************************************************
 * Silabs Tracing shell functions
 *********************************************************/

CHIP_ERROR BLEHelpHandler(int argc, char ** argv)
{
    sShellBLESubCommands.ForEachCommand(Shell::PrintCommandHelp, nullptr);
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLECommandHandler(int argc, char ** argv)
{
    if (argc == 0)
    {
        return BLEHelpHandler(argc, argv);
    }

    return sShellBLESubCommands.ExecCommand(argc, argv);
}

CHIP_ERROR StartBLESideChannelAdvertising(int argc, char ** argv)
{
    // TODO : Configure first
    CHIP_ERROR err = DeviceLayer::Internal::BLEMgrImpl().SideChannelConfigureAdvertisingDefaultData();
    VerifyOrReturnError(
        err == CHIP_NO_ERROR, err,
        streamer_printf(streamer_get(), "Failed to configure the BLE side channel advertising: %s\n", ErrorStr(err)););
    err = DeviceLayer::Internal::BLEMgrImpl().SideChannelStartAdvertising();
    VerifyOrReturnError(err == CHIP_NO_ERROR, err,
                        streamer_printf(streamer_get(), "Failed to start BLE side channel advertising: %s\n", ErrorStr(err)););
    streamer_printf(streamer_get(), "Started BLE side channel advertising\n");
    return CHIP_NO_ERROR;
}

CHIP_ERROR StopBLESideChannelAvertising(int argc, char ** argv)
{
    return DeviceLayer::Internal::BLEMgrImpl().SideChannelStopAdvertising();
}

} // namespace

namespace BLEShellCommands {

void RegisterCommands()
{
    static const Shell::Command sBLESubCommands[] = {
        { &BLEHelpHandler, "help", "Output the BLE Commands help menu" },
        { &StartBLESideChannelAdvertising, "AdvStart", "Start BLE Side Channel advertising with default parameters" },
        { &StopBLESideChannelAvertising, "AdvStop", "Stop BLE Side Channel advertising" },
    };
    static const Shell::Command sBleCmds = { &BLECommandHandler, "ble-side", "Dispatch Silicon Labs BLE Side Channel commands" };

    sShellBLESubCommands.RegisterCommands(sBLESubCommands, MATTER_ARRAY_SIZE(sBLESubCommands));
    Engine::Root().RegisterCommands(&sBleCmds, 1);
}

} // namespace BLEShellCommands
