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
#include <cstdlib>
#include <lib/shell/Command.h>
#include <lib/shell/Engine.h>
#include <lib/shell/commands/Help.h>
#include <lib/support/CodeUtils.h>

#include <platform/ConfigurationManager.h>
#include <platform/internal/BLEManager.h>

using namespace chip;
using namespace chip::DeviceLayer::Internal;
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

#if SL_BLE_SIDE_CHANNEL_ENABLED

static constexpr size_t kMaxAdvDataLen = 31;

static bool SafeParseUint(const char * str, unsigned long & out, unsigned long maxVal)
{
    char * end = nullptr;
    out        = strtoul(str, &end, 10);
    return (end != str && *end == '\0' && out <= maxVal);
}

// Decode a hex string (e.g. "020106030312034") into a byte buffer.
// Returns the number of decoded bytes, or -1 on error.
static int DecodeHexString(const char * hex, uint8_t * buf, size_t bufLen)
{
    size_t hexLen = strlen(hex);
    if (hexLen % 2 != 0)
    {
        return -1;
    }

    size_t byteLen = hexLen / 2;
    if (byteLen > bufLen)
    {
        return -1;
    }

    for (size_t i = 0; i < byteLen; i++)
    {
        char byte[3]      = { hex[i * 2], hex[i * 2 + 1], '\0' };
        char * end        = nullptr;
        unsigned long val = strtoul(byte, &end, 16);
        if (end != &byte[2])
        {
            return -1;
        }
        buf[i] = static_cast<uint8_t>(val);
    }
    return static_cast<int>(byteLen);
}

/** @brief ConfigureBLESideChannelAdvertising
 *
 *
 * @param argc int, count of arguments
 * @param argv char **, array of arguments in order, for successful configuration, the arguments are:
 *  - advDataHex: hex string of the advertising data (e.g. "020106030312034" to match default)
 *  - responseDataHex: hex string of the response data (e.g. "0909034" to match default)
 *  - intervalMin: minimum advertising interval in milliseconds
 *  - intervalMax: maximum advertising interval in milliseconds
 *  - advConnectableMode: advertising connectable mode (e.g. 0x02 for connectable and scannable)
 *  - duration: advertising duration in milliseconds
 *  - maxEvents: maximum number of events
 * @return true if the event can be handled, false otherwise.
 */
CHIP_ERROR ConfigureBLESideChannelAdvertising(int argc, char ** argv)
{
    if (argc < 7)
    {
        streamer_printf(streamer_get(),
                        "Usage: ble-side AdvConfig <advDataHex> <responseDataHex> <intervalMin> <intervalMax> <advConnectableMode> "
                        "<duration> <maxEvents>\r\n");
        streamer_printf(streamer_get(), "Default: ble-side AdvConfig 020106030312034 0909034 100 200 0x02 0 0\r\n");
        streamer_printf(
            streamer_get(),
            "Note: See ConfigureAdvertisingData() in BLEChannelImpl.cpp for more details on the adv and response data\r\n");
        return CHIP_ERROR_INVALID_ARGUMENT;
    }

    static uint8_t advBuf[kMaxAdvDataLen];
    static uint8_t rspBuf[kMaxAdvDataLen];

    int advLen = DecodeHexString(argv[0], advBuf, sizeof(advBuf));
    VerifyOrReturnError(advLen >= 0, CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Invalid advData hex string: %s\r\n", argv[0]));

    int rspLen = DecodeHexString(argv[1], rspBuf, sizeof(rspBuf));
    VerifyOrReturnError(rspLen >= 0, CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Invalid responseData hex string: %s\r\n", argv[1]));

    AdvConfigStruct config;
    config.advData      = ByteSpan(advBuf, static_cast<size_t>(advLen));
    config.responseData = ByteSpan(rspBuf, static_cast<size_t>(rspLen));

    unsigned long val;
    VerifyOrReturnError(SafeParseUint(argv[2], val, UINT32_MAX), CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Invalid intervalMin: %s\r\n", argv[2]));
    config.intervalMin = static_cast<uint32_t>(val);

    VerifyOrReturnError(SafeParseUint(argv[3], val, UINT32_MAX), CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Invalid intervalMax: %s\r\n", argv[3]));
    config.intervalMax = static_cast<uint32_t>(val);

    VerifyOrReturnError(SafeParseUint(argv[4], val, UINT8_MAX), CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Invalid advConnectableMode: %s\r\n", argv[4]));
    config.advConnectableMode = static_cast<uint8_t>(val);

    VerifyOrReturnError(SafeParseUint(argv[5], val, UINT16_MAX), CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Invalid duration: %s\r\n", argv[5]));
    config.duration = static_cast<uint16_t>(val);

    VerifyOrReturnError(SafeParseUint(argv[6], val, UINT8_MAX), CHIP_ERROR_INVALID_ARGUMENT,
                        streamer_printf(streamer_get(), "Invalid maxEvents: %s\r\n", argv[6]));
    config.maxEvents = static_cast<uint8_t>(val);

    CHIP_ERROR err = BLEMgrImpl().SideChannelConfigureAdvertising(config);
    VerifyOrReturnError(
        err == CHIP_NO_ERROR, err,
        streamer_printf(streamer_get(), "Failed to configure the BLE side channel advertising: %s\r\n", ErrorStr(err)));
    return CHIP_NO_ERROR;
}

#if SL_USE_INTERNAL_BLE_SIDE_CHANNEL
CHIP_ERROR ConfigureBLESideChannelAdvertisingDefaultData(int argc, char ** argv)
{
    CHIP_ERROR err = BLEMgrImpl().SideChannelConfigureAdvertisingDefaultData();
    VerifyOrReturnError(err == CHIP_NO_ERROR, err,
                        streamer_printf(streamer_get(),
                                        "Failed to configure the BLE side channel advertising with default data: %s\r\n",
                                        ErrorStr(err)));
    return CHIP_NO_ERROR;
}
#endif // SL_USE_INTERNAL_BLE_SIDE_CHANNEL

CHIP_ERROR StartBLESideChannelAdvertising(int argc, char ** argv)
{

    BLEChannel * sideChannel = BLEMgrImpl().GetSideChannel();
    VerifyOrReturnError(sideChannel != nullptr, CHIP_ERROR_INCORRECT_STATE,
                        streamer_printf(streamer_get(), "Side channel not injected\r\n"));
    VerifyOrReturnError(sideChannel->IsConfigured(), CHIP_ERROR_INCORRECT_STATE,
                        streamer_printf(streamer_get(), "Side channel not configured\r\n"));
    CHIP_ERROR err = BLEMgrImpl().SideChannelStartAdvertising();
    VerifyOrReturnError(err == CHIP_NO_ERROR, err,
                        streamer_printf(streamer_get(), "Failed to start BLE side channel advertising: %s\r\n", ErrorStr(err)););
    streamer_printf(streamer_get(), "Started BLE side channel advertising\r\n");
    return CHIP_NO_ERROR;
}

CHIP_ERROR StopBLESideChannelAvertising(int argc, char ** argv)
{
    BLEChannel * sideChannel = BLEMgrImpl().GetSideChannel();
    VerifyOrReturnError(sideChannel != nullptr, CHIP_ERROR_INCORRECT_STATE,
                        streamer_printf(streamer_get(), "Side channel not injected\r\n"));
    return sideChannel->StopAdvertising();
}

CHIP_ERROR PrintBLESideChannelAdvertisingInfo(int argc, char ** argv)
{
    BLEChannel * sideChannel = BLEMgrImpl().GetSideChannel();
    VerifyOrReturnError(sideChannel != nullptr, CHIP_ERROR_INCORRECT_STATE,
                        streamer_printf(streamer_get(), "Side channel not injected\r\n"));
    return sideChannel->PrintAdvertisingInfo();
}

#endif // SL_BLE_SIDE_CHANNEL_ENABLED

CHIP_ERROR PrintBLEInfo(int argc, char ** argv)
{
    return DeviceLayer::Internal::BLEMgrImpl().PrintBLEInfo();
}
} // namespace

namespace BLEShellCommands {

void RegisterCommands()
{
    static const Shell::Command sBLESubCommands[] = {
        { &BLEHelpHandler, "help", "Output the BLE Commands help menu" },
        { &PrintBLEInfo, "info", "Print BLE information such as device name, service mode, and static address" },
#if SL_BLE_SIDE_CHANNEL_ENABLED
        { &StartBLESideChannelAdvertising, "AdvStart",
          "Start BLE Side Channel advertising, this will fail if the advertising is not configured" },
        { &StopBLESideChannelAvertising, "AdvStop", "Stop BLE Side Channel advertising" },
        { &ConfigureBLESideChannelAdvertising, "AdvConfig", "Configure BLE Side Channel advertising with custom parameters" },
        { &PrintBLESideChannelAdvertisingInfo, "AdvInfo", "Print BLE Side Channel advertising information" },
#if SL_USE_INTERNAL_BLE_SIDE_CHANNEL
        { &ConfigureBLESideChannelAdvertisingDefaultData, "AdvConfigDefault",
          "Configure BLE Side Channel advertising with default parameters" },
#endif // SL_USE_INTERNAL_BLE_SIDE_CHANNEL
#endif // SL_BLE_SIDE_CHANNEL_ENABLED
    };
    static const Shell::Command sBleCmds = { &BLECommandHandler, "ble-side", "Dispatch Silicon Labs BLE commands" };

    sShellBLESubCommands.RegisterCommands(sBLESubCommands, MATTER_ARRAY_SIZE(sBLESubCommands));
    Engine::Root().RegisterCommands(&sBleCmds, 1);
}

} // namespace BLEShellCommands
