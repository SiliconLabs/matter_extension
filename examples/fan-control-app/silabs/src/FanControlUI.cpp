/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
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

#include "FanControlUI.h"
#include "FanControlManager.h"
#include "demo-ui-bitmaps.h"
#include "dmd.h"
#include "AppTask.h"
#if DISPLAY_ENABLED
#include "glib.h"
#include "lcd.h"
#endif // DISPLAY_ENABLED

using namespace chip::app::Clusters;
using namespace chip::app::Clusters::FanControl;

namespace{
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
}

void FanControlUI::DrawUI(GLIB_Context_t * glibContext)
{
    if (glibContext == nullptr)
    {
        ChipLogError(AppServer,"Context is null");
        return;
    }

    GLIB_clear(glibContext);
    DrawHeader(glibContext);
    DrawCurrentFanMode(glibContext);

#if SL_LCDCTRL_MUX
    sl_wfx_host_pre_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
    DMD_updateDisplay();
#if SL_LCDCTRL_MUX
    sl_wfx_host_post_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
}

void FanControlUI::DrawHeader(GLIB_Context_t * glibContext)
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
#if SL_LCDCTRL_MUX
    sl_wfx_host_pre_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
    DMD_updateDisplay();
#if SL_LCDCTRL_MUX
    sl_wfx_host_post_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
}

/**
 * @brief Draw a 2 digit Air Quality of screen. Because of this Celsius is used by default
 * @param GLIB_Context_t * pointer to the context for the GLIB library
 * @param int8_t current Air Quality
 */
void FanControlUI::DrawCurrentFanMode(GLIB_Context_t * glibContext)
{
    FanModeEnum mode = FanControlMgr().GetFanMode();
    // Print fan mode
    if (mode == FanModeEnum::kOff)
    {
        GLIB_drawStringOnLine(glibContext, "FAN : OFF", 4, GLIB_ALIGN_LEFT, 0, 0, true);
    }
    else if (mode == FanModeEnum::kUnknownEnumValue)
    {
        GLIB_drawStringOnLine(glibContext, "FAN : UNKNOWN", 4, GLIB_ALIGN_LEFT, 0, 0, true);
    }
    else
    {
        GLIB_drawStringOnLine(glibContext, "FAN : ON", 4, GLIB_ALIGN_LEFT, 0, 0, true);
    }

    // Print fan speed
    switch (mode)
    {
    case FanModeEnum::kOff:
        GLIB_drawStringOnLine(glibContext, "SPEED : OFF", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    case FanModeEnum::kLow:
        GLIB_drawStringOnLine(glibContext, "SPEED : LOW", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    case FanModeEnum::kMedium:
        GLIB_drawStringOnLine(glibContext, "SPEED : MEDIUM", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    case FanModeEnum::kHigh:
        GLIB_drawStringOnLine(glibContext, "SPEED : HIGH", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    case FanModeEnum::kAuto:
        GLIB_drawStringOnLine(glibContext, "SPEED : AUTO", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    case FanModeEnum::kSmart:
        GLIB_drawStringOnLine(glibContext, "SPEED : SMART", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    case FanModeEnum::kOn:
        GLIB_drawStringOnLine(glibContext, "SPEED : HIGH", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    case FanModeEnum::kUnknownEnumValue:
        GLIB_drawStringOnLine(glibContext, "SPEED : UNKNOWN", 6, GLIB_ALIGN_LEFT, 0, 0, true);
        break;
    default:
        break;
    }

#if SL_LCDCTRL_MUX
    sl_wfx_host_pre_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
    DMD_updateDisplay();
#if SL_LCDCTRL_MUX
    sl_wfx_host_post_lcd_spi_transfer();
#endif // SL_LCDCTRL_MUX
}

void FanControlUI::DrawFont(GLIB_Context_t * glibContext, uint8_t initial_x, uint8_t initial_y, uint8_t width, uint8_t * data,
                            uint32_t size)
{
    uint8_t x = initial_x, y = initial_y;
    for (uint16_t i = 0; i < size; i++)
    {
        for (uint8_t mask = 0; mask < 8; mask++)
        {
            if (!(data[i] & (0x01 << mask)))
            {
                GLIB_drawPixel(glibContext, x, y);
            }
            // Check line changes
            if (((x - initial_x) % width) == 0 && x != initial_x)
            {
                x = initial_x;
                y++;
                // Font is 8 bit align with paddings bits;
                mask = 8;
            }
            else
            {
                x++;
            }
        }
    }
}