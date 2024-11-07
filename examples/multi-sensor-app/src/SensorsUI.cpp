/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
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

#include "SensorsUI.h"
#include "demo-ui-bitmaps.h"
#include "demo-ui.h"
#include "dmd.h"
#include "glib.h"
#include "lcd.h"
#include "sl_memlcd.h"
#include <app/data-model/Nullable.h>
#include <stdio.h>
#include <string.h>

#if SL_WIFI && !SLI_SI91X_MCU_INTERFACE
#include "spi_multiplex.h"
#endif // SL_WIFI && !SLI_SI91X_MCU_INTERFACE

using namespace chip::Protocols::InteractionModel;

namespace {

constexpr uint8_t kMaxStringLength = 30;

/**
 * @brief Helper function to format a single line on the LCD
 *        String format is  <label>: <-><8 MSB of value>. <8 LSB of value><unit>
 *
 * @param line line number on which to draw the string
 */
void DrawValue(GLIB_Context_t * glibContext, const char * label, int16_t value, const char * unit, int line)
{
    char str[kMaxStringLength] = { 0 };
    char isNegative            = ' ';

    if (value < 0)
    {
        isNegative = '-';
        value *= -1;
    }

    snprintf(str, sizeof(str), "%s: %c%d.%d%s", label, isNegative, (uint8_t) (value / 100), (uint8_t) (value % 100), unit);
    GLIB_drawStringOnLine(glibContext, str, line, GLIB_ALIGN_LEFT, 0, 0, true);
}
} // namespace

namespace SensorsUI {

void SensorUI(GLIB_Context_t * glibContext)
{
    uint8_t line  = 1;
    Status status = Status::Success;

#if SLI_SI91X_MCU_INTERFACE && CHIP_CONFIG_ENABLE_ICD_SERVER
    // In sleep, memlcd will not be retained so re-initialize MEMLCD interface after sleep wakeup
    sl_memlcd_post_wakeup_init();
#endif // SLI_SI91X_MCU_INTERFACE && SL_ICD_ENABLED && CHIP_CONFIG_ENABLE_ICD_SERVER

    GLIB_clear(glibContext);

#if defined(SL_MATTER_USE_SI70XX_SENSOR) && (SL_MATTER_USE_SI70XX_SENSOR)
    GLIB_drawStringOnLine(glibContext, "Using Sensor", line++, GLIB_ALIGN_LEFT, 0, 0, true);
#else
    GLIB_drawStringOnLine(glibContext, "Using Simulation", line++, GLIB_ALIGN_LEFT, 0, 0, true);
#endif // !(defined(SL_MATTER_USE_SI70XX_SENSOR) && (SL_MATTER_USE_SI70XX_SENSOR))

    GLIB_drawStringOnLine(glibContext, "", line++, GLIB_ALIGN_LEFT, 0, 0, true);

    {
        chip::app::DataModel::Nullable<int16_t> value;
        int16_t temp = 0;

        GLIB_drawStringOnLine(glibContext, "Temp. Sensor", line++, GLIB_ALIGN_LEFT, 0, 0, true);

        // Get and Write Temperature MeasuredValue
        status = SensorManager::GetMeasuredTemperature(value);
        VerifyOrReturn(status == Status::Success && !value.IsNull());
        temp = value.Value();
        value.SetNull();
        DrawValue(glibContext, "Current", temp, "C", line++);

        // Get and Write Temperature MaxMeasuredValue
        status = SensorManager::GetMaxMeasuredTemperature(value);
        VerifyOrReturn(status == Status::Success && !value.IsNull());
        temp = value.Value();
        value.SetNull();
        DrawValue(glibContext, "Max", temp, "C", line++);

        // Get and Write Temperature MinMeasuredValue
        status = SensorManager::GetMinMeasuredTemperature(value);
        VerifyOrReturn(status == Status::Success && !value.IsNull());
        temp = value.Value();
        value.SetNull();
        DrawValue(glibContext, "Min", temp, "C", line++);
    }

    GLIB_drawStringOnLine(glibContext, "", line++, GLIB_ALIGN_LEFT, 0, 0, true);

    {
        chip::app::DataModel::Nullable<uint16_t> value;
        int16_t humidity;
        GLIB_drawStringOnLine(glibContext, "Humidity Sensor", line++, GLIB_ALIGN_LEFT, 0, 0, true);

        // Get and Write Humidity MeasuredValue
        status = SensorManager::GetMeasuredHumidity(value);
        VerifyOrReturn(status == Status::Success && !value.IsNull());
        humidity = value.Value();
        value.SetNull();
        DrawValue(glibContext, "Current", humidity, "%", line++);

        // Get and Write Humidity MaxMeasuredValue
        status = SensorManager::GetMaxMeasuredHumidity(value);
        VerifyOrReturn(status == Status::Success && !value.IsNull());
        humidity = value.Value();
        value.SetNull();
        DrawValue(glibContext, "Max", humidity, "%", line++);

        // Get and Write Humidity MinMeasuredValue
        status = SensorManager::GetMinMeasuredHumidity(value);
        VerifyOrReturn(status == Status::Success && !value.IsNull());
        humidity = value.Value();
        value.SetNull();
        DrawValue(glibContext, "Min", humidity, "%", line++);
    }

#if SL_LCDCTRL_MUX
    status = sl_wfx_host_pre_lcd_spi_transfer();
    if (status != SL_STATUS_OK)
        return status;
#endif // SL_LCDCTRL_MUX

    DMD_updateDisplay();

#if SL_LCDCTRL_MUX
    status = sl_wfx_host_post_lcd_spi_transfer();
    if (status != SL_STATUS_OK)
        return status;
#endif // SL_LCDCTRL_MUX

#if SLI_SI91X_MCU_INTERFACE && CHIP_CONFIG_ENABLE_ICD_SERVER
    // MEMLCD is not a UULP component and not available in sleep so powering down before sleep and need to be re-initialized after
    // sleep-wakeup
    sl_memlcd_power_on(NULL, false);
#endif // SLI_SI91X_MCU_INTERFACE && CHIP_CONFIG_ENABLE_ICD_SERVER
}
} // namespace SensorsUI
