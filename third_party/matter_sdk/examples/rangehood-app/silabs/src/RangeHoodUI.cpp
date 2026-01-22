/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
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

#include <stdio.h>
#include <string.h>

#include "AppConfig.h"
#include "AppTask.h"
#include "RangeHoodManager.h"
#include "RangeHoodUI.h"
#include "demo-ui-bitmaps.h"
#include "dmd.h"
#include "glib.h"
#include "lcd.h"

#include <platform/CHIPDeviceLayer.h>

using namespace chip::app::Clusters;
using namespace chip::app::Clusters::FanControl;
using namespace ::chip::DeviceLayer;

namespace {
// Bitmap
const uint8_t silabsLogo[]       = { SILABS_LOGO_SMALL };
const uint8_t matterLogoBitmap[] = { MATTER_LOGO_BITMAP };

const uint8_t wifiLogo[]   = { WIFI_BITMAP };
const uint8_t threadLogo[] = { THREAD_BITMAP };
const uint8_t bleLogo[]    = { BLUETOOTH_ICON_SMALL };

#ifdef SL_WIFI
constexpr bool UI_WIFI = true;
#else
constexpr bool UI_WIFI = false;
#endif
} // namespace

void RangeHoodUI::DrawUI(GLIB_Context_t * glibContext)
{
    if (glibContext == nullptr)
    {
        ChipLogError(AppServer, "Context is null");
        return;
    }

    GLIB_clear(glibContext);
    DrawHeader(glibContext);
    DrawRangehoodStatus(glibContext);

#if SL_LCDCTRL_MUX
    sl_wfx_host_pre_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
    DMD_updateDisplay();
#if SL_LCDCTRL_MUX
    sl_wfx_host_post_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
}

void RangeHoodUI::DrawHeader(GLIB_Context_t * glibContext)
{
    // Draw Silabs Corner icon
    GLIB_drawBitmap(glibContext, SILABS_ICON_POSITION_X, STATUS_ICON_LINE, SILABS_LOGO_WIDTH, SILABS_LOGO_HEIGHT, silabsLogo);
    // Draw BLE Icon
    GLIB_drawBitmap(glibContext, BLE_ICON_POSITION_X, STATUS_ICON_LINE, BLUETOOTH_ICON_SIZE, BLUETOOTH_ICON_SIZE, bleLogo);
    // Draw WiFi/OpenThread Icon
    GLIB_drawBitmap(glibContext, NETWORK_ICON_POSITION_X, STATUS_ICON_LINE, (UI_WIFI) ? WIFI_BITMAP_WIDTH : THREAD_BITMAP_WIDTH,
                    WIFI_BITMAP_HEIGHT, (UI_WIFI) ? wifiLogo : threadLogo);
    // Draw Matter Icon
    GLIB_drawBitmap(glibContext, MATTER_ICON_POSITION_X, STATUS_ICON_LINE, MATTER_LOGO_WIDTH, MATTER_LOGO_HEIGHT, matterLogoBitmap);

    // Draw application name on a dedicated line below icons.
    GLIB_drawStringOnLine(glibContext, APP_TASK_NAME, 3, GLIB_ALIGN_CENTER, 0, 0, true);
#if SL_LCDCTRL_MUX
    sl_wfx_host_pre_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
    DMD_updateDisplay();
#if SL_LCDCTRL_MUX
    sl_wfx_host_post_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
}

/**
 * @brief Draw the current fan mode and light status on the screen.
 * @param glibContext Pointer to the context for the GLIB library.
 */
void RangeHoodUI::DrawRangehoodStatus(GLIB_Context_t * glibContext)
{
    ChipLogDetail(NotSpecified, "Updating Rangehood Status on LCD");

    FanModeEnum mode = FanModeEnum::kUnknownEnumValue;
    bool lightOn     = false;

    PlatformMgr().LockChipStack();
    CHIP_ERROR fanStatus   = RangeHoodMgr().GetExtractorHoodEndpoint().GetFanMode(mode);
    CHIP_ERROR lightStatus = RangeHoodMgr().GetLightEndpoint().GetOnOffState(lightOn);
    PlatformMgr().UnlockChipStack();

    if (fanStatus != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "Failed to read fan mode: %" CHIP_ERROR_FORMAT, fanStatus.Format());
        mode = FanModeEnum::kUnknownEnumValue;
    }

    if (lightStatus != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "Failed to read light state: %" CHIP_ERROR_FORMAT, lightStatus.Format());
        lightOn = false;
    }

    char fanLine[17];
    const char * modeText = nullptr;
    switch (mode)
    {
    case FanModeEnum::kOff:
        modeText = "OFF";
        break;
    case FanModeEnum::kLow:
        modeText = "LOW";
        break;
    case FanModeEnum::kMedium:
        modeText = "MEDIUM";
        break;
    case FanModeEnum::kHigh:
        modeText = "HIGH";
        break;
    case FanModeEnum::kOn:
        modeText = "ON";
        break;
    case FanModeEnum::kAuto:
        modeText = "AUTO";
        break;
    case FanModeEnum::kSmart:
        modeText = "SMART";
        break;
    default:
        modeText = "UNKNOWN";
        break;
    }
    snprintf(fanLine, sizeof(fanLine), "FAN   : %s", modeText);
    GLIB_drawStringOnLine(glibContext, fanLine, 5, GLIB_ALIGN_LEFT, 0, 0, true);

    // Draw Light status below fan information
    GLIB_drawStringOnLine(glibContext, lightOn ? "LIGHT : ON" : "LIGHT : OFF", 7, GLIB_ALIGN_LEFT, 0, 0, true);

#if SL_LCDCTRL_MUX
    sl_wfx_host_pre_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
    DMD_updateDisplay();
#if SL_LCDCTRL_MUX
    sl_wfx_host_post_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
}
