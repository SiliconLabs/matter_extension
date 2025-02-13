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

struct WorkContext
{
    GLIB_Context_t * glibContext;
    uint8_t line;
};

void GetTemperatureHumidityWork(intptr_t contextPtr)
{
    Status status = Status::Success;

    WorkContext * context = reinterpret_cast<WorkContext *>(contextPtr);

    {
        chip::app::DataModel::Nullable<int16_t> value;

        GLIB_drawStringOnLine(context->glibContext, "Temp. Sensor", context->line++, GLIB_ALIGN_LEFT, 0, 0, true);

        // Get and Write Temperature MeasuredValue
        status = SensorManager::GetMeasuredTemperature(value);
        if (status == Status::Success && !value.IsNull())
        {
            DrawValue(context->glibContext, "Current", value.Value(), "C", context->line++);
            value.SetNull();
        }

        // Get and write temperature max measured value
        status = SensorManager::GetMaxMeasuredTemperature(value);
        if (status == Status::Success && !value.IsNull())
        {
            DrawValue(context->glibContext, "Max", value.Value(), "C", context->line++);
            value.SetNull();
        }

        // Get and write temperature min measured value
        status = SensorManager::GetMinMeasuredTemperature(value);
        if (status == Status::Success && !value.IsNull())
        {
            DrawValue(context->glibContext, "Min", value.Value(), "C", context->line++);
            value.SetNull();
        }
    }

    GLIB_drawStringOnLine(context->glibContext, "", context->line++, GLIB_ALIGN_LEFT, 0, 0, true);

    {
        chip::app::DataModel::Nullable<uint16_t> value;
        GLIB_drawStringOnLine(context->glibContext, "Humidity Sensor", context->line++, GLIB_ALIGN_LEFT, 0, 0, true);

        // Get and write humidity measured value
        status = SensorManager::GetMeasuredHumidity(value);
        if (status == Status::Success && !value.IsNull())
        {
            DrawValue(context->glibContext, "Current", value.Value(), "%", context->line++);
            value.SetNull();
        }

        // Get and write humidity max measured value
        status = SensorManager::GetMaxMeasuredHumidity(value);
        if (status == Status::Success && !value.IsNull())
        {
            DrawValue(context->glibContext, "Max", value.Value(), "%", context->line++);
            value.SetNull();
        }

        // Get and write humidity min measured value
        status = SensorManager::GetMinMeasuredHumidity(value);
        if (status == Status::Success && !value.IsNull())
        {
            DrawValue(context->glibContext, "Min", value.Value(), "%", context->line++);
            value.SetNull();
        }
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

void SensorUI(GLIB_Context_t * glibContext)
{
    uint8_t line  = 1;

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

    WorkContext * context = new WorkContext{ glibContext, line };

    // Schedule work to get and write temperature and Humidity values
    chip::DeviceLayer::PlatformMgr().ScheduleWork(
        [](intptr_t contextPtr) {
            GetTemperatureHumidityWork(contextPtr);
            delete reinterpret_cast<WorkContext *>(contextPtr); // Clean up the context
        },
        reinterpret_cast<intptr_t>(context));
}
} // namespace SensorsUI
