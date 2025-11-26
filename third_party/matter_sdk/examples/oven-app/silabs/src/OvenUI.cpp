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

#include "AppTask.h"
#include "OvenManager.h"
#include "OvenUI.h"
#include "demo-ui-bitmaps.h"
#include "dmd.h"
#include "glib.h"
#include "lcd.h"

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app/clusters/mode-base-server/mode-base-cluster-objects.h>

// State display positions
#define COOKTOP_STATE_DISPLAY_LINE 4
#define OVEN_MODE_DISPLAY_LINE 6

#define LCD_MAX_LINE_LEN 16

using namespace chip::app::Clusters;
using namespace chip::app::Clusters::TemperatureControlledCabinet;
using namespace chip::app::Clusters::OvenMode;

namespace {
// Bitmap
const uint8_t silabsLogo[]       = { SILABS_LOGO_SMALL };
const uint8_t matterLogoBitmap[] = { MATTER_LOGO_BITMAP };

const uint8_t wifiLogo[]   = { WIFI_BITMAP };
const uint8_t threadLogo[] = { THREAD_BITMAP };
const uint8_t bleLogo[]    = { BLUETOOTH_ICON_SMALL };
} // namespace

void OvenUI::DrawUI(GLIB_Context_t * glibContext)
{
    if (glibContext == nullptr)
    {
        ChipLogError(AppServer, "Context is null");
        return;
    }

    GLIB_clear(glibContext);
    DrawHeader(glibContext);
    DrawCookTopState(glibContext);
    DrawOvenMode(glibContext);

#if SL_LCDCTRL_MUX
    sl_wfx_host_pre_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
    DMD_updateDisplay();
#if SL_LCDCTRL_MUX
    sl_wfx_host_post_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
}

void OvenUI::DrawHeader(GLIB_Context_t * glibContext)
{
    // Draw Silabs Corner icon
    GLIB_drawBitmap(glibContext, SILABS_ICON_POSITION_X, STATUS_ICON_LINE, SILABS_LOGO_WIDTH, SILABS_LOGO_HEIGHT, silabsLogo);
    // Draw BLE Icon
    GLIB_drawBitmap(glibContext, BLE_ICON_POSITION_X, STATUS_ICON_LINE, BLUETOOTH_ICON_SIZE, BLUETOOTH_ICON_SIZE, bleLogo);
    // Draw WiFi/OpenThread Icon
#ifdef SL_WIFI
    GLIB_drawBitmap(glibContext, NETWORK_ICON_POSITION_X, STATUS_ICON_LINE, WIFI_BITMAP_WIDTH, WIFI_BITMAP_HEIGHT, wifiLogo);
#else
    GLIB_drawBitmap(glibContext, NETWORK_ICON_POSITION_X, STATUS_ICON_LINE, THREAD_BITMAP_WIDTH, THREAD_BITMAP_HEIGHT, threadLogo);
#endif // SL_WIFI
    // Draw Matter Icon
    GLIB_drawBitmap(glibContext, MATTER_ICON_POSITION_X, STATUS_ICON_LINE, MATTER_LOGO_WIDTH, MATTER_LOGO_HEIGHT, matterLogoBitmap);
}

void OvenUI::DrawCookTopState(GLIB_Context_t * glibContext)
{
    // Get CookTop state from OvenManager
    bool cookTopState = OvenManager::GetInstance().GetCookTopState();

    if (cookTopState)
    {
        GLIB_drawStringOnLine(glibContext, "COOKTOP: ON", COOKTOP_STATE_DISPLAY_LINE, GLIB_ALIGN_LEFT, 0, 0, true);
    }
    else
    {
        GLIB_drawStringOnLine(glibContext, "COOKTOP: OFF", COOKTOP_STATE_DISPLAY_LINE, GLIB_ALIGN_LEFT, 0, 0, true);
    }
}

void OvenUI::DrawOvenMode(GLIB_Context_t * glibContext)
{
    // Get current oven mode from the Temperature Controlled Cabinet endpoint
    uint8_t currentMode = OvenManager::GetInstance().GetCurrentOvenMode();

    // LCD Display line max length is 16 characters, so allocate 17 bytes for the message (MODE: + mode text + null terminator)
    char message[LCD_MAX_LINE_LEN + 1];
    const char * modeText = nullptr;

    switch (currentMode)
    {
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeBake):
        modeText = "BAKE";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeConvection):
        modeText = "CONVECTION";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeGrill):
        modeText = "GRILL";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeRoast):
        modeText = "ROAST";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeClean):
        modeText = "CLEAN";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeConvectionBake):
        modeText = "CONV BAKE";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeConvectionRoast):
        modeText = "CONV ROAST";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeWarming):
        modeText = "WARMING";
        break;
    case chip::to_underlying(OvenModeDelegate::OvenModes::kModeProofing):
        modeText = "PROOFING";
        break;
    default:
        modeText = "UNKNOWN";
        break;
    }

    VerifyOrReturn(modeText != nullptr);
    snprintf(message, LCD_MAX_LINE_LEN + 1, "MODE: %s", modeText);

    GLIB_drawStringOnLine(glibContext, message, OVEN_MODE_DISPLAY_LINE, GLIB_ALIGN_LEFT, 0, 0, true);
}
