/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
 *    Copyright (c) 2019 Google LLC.
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

/*
 * Callbacks for All of the Sensor Applications
 */

#if (SL_MATTER_GN_BUILD == 0)
#include "sl_matter_sensor_config.h"
#endif // SL_MATTER_GN_BUILD

#include <AppConfig.h>
#include <AppTask.h>
#include <SensorManager.h>
#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/clusters/occupancy-sensor-server/occupancy-hal.h>
#include <app/clusters/occupancy-sensor-server/occupancy-sensor-server.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <sl_cmsis_os2_common.h>

#if defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR
#include <Si70xxSensor.h>
#else
#include <crypto/RandUtils.h>
#endif // defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::DeviceLayer::Silabs;
using namespace chip::Protocols::InteractionModel;

namespace {

constexpr EndpointId kOccupancySensorEndpoint   = 1;
constexpr EndpointId kTemperatureSensorEndpoint = 2;
constexpr EndpointId kHumiditySensorEndpoint    = 3;

// The > 0 is necessary to avoid causing a type-limits compilation error when the threshold is equal to 0
// which is specific to the uint8_t data type
#if SL_MATTER_SENSOR_REPORT_THRESHOLD > 0
static_assert((SL_MATTER_SENSOR_REPORT_THRESHOLD <= std::numeric_limits<uint8_t>::max()),
              "The value for SL_MATTER_SENSOR_REPORT_THRESHOLD is greater to the allowed maximum value (255).");
#endif // SL_MATTER_SENSOR_REPORT_THRESHOLD > 0
static_assert((SL_MATTER_SENSOR_REPORT_THRESHOLD >= std::numeric_limits<uint8_t>::min()),
              "The value for SL_MATTER_SENSOR_REPORT_THRESHOLD is inferior to the allowed minimum value (0).");
constexpr uint8_t kAttributeChangeReportThreshold = (SL_MATTER_SENSOR_REPORT_THRESHOLD);

static_assert((std::numeric_limits<uint32_t>::min() <= SL_MATTER_SENSOR_TIMER_PERIOD_S),
              "The value for SL_MATTER_SENSOR_TIMER_PERIOD_S is inferior to the allowed minimum value (0).");
static_assert((SL_MATTER_SENSOR_TIMER_PERIOD_S <= std::numeric_limits<uint32_t>::max()),
              "The value for SL_MATTER_SENSOR_TIMER_PERIOD_S is greater to the allowed maximum value (4294967295).");
constexpr chip::System::Clock::Seconds32 kSensorReadPeriod = chip::System::Clock::Seconds32(SL_MATTER_SENSOR_TIMER_PERIOD_S);

uint16_t mLastReportedHumidityValue   = 0;
int16_t mLastReportedTemperatureValue = 0;
bool isInitialised                    = false;

/**
 * @brief Process function when the Sensor Timer event is triggered.
 *        This update the Data Model sensor values with the latest measurements.
 *        The data model is updated with the latest measurements, but a subscription report is only triggered if the new line is
 *        greater than the `kAttributeChangeReportThreshold` configurations. If the difference does not meet the threshold, the
 *        attributes are not marked as dirty.
 *
 *        This function needs to be executed from the Matter task since it does not attempt to take the Matter task lock.
 */
void SensorActionTriggered(chip::System::Layer * aLayer, void * aAppState)
{
    VerifyOrDieWithMsg(isInitialised, AppServer, "Sensor Action was triggered before the Sensor Manager was initialised!");

    int16_t temperature            = 0;
    uint16_t humidity              = 0;
    MarkAttributeDirty reportState = MarkAttributeDirty::kNo;

#if defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR
    // Read sensor values
    VerifyOrReturn(SL_STATUS_OK == Si70xxSensor::GetSensorData(humidity, temperature));
#else

    DataModel::Nullable<int16_t> maxTempMeasuredValue;
    TemperatureMeasurement::Attributes::MaxMeasuredValue::Get(kTemperatureSensorEndpoint, maxTempMeasuredValue);

    DataModel::Nullable<uint16_t> maxMeasuredHumidityValue;
    RelativeHumidityMeasurement::Attributes::MaxMeasuredValue::Get(kHumiditySensorEndpoint, maxMeasuredHumidityValue);

    DataModel::Nullable<int16_t> currentTempValue;
    TemperatureMeasurement::Attributes::MeasuredValue::Get(kTemperatureSensorEndpoint, currentTempValue);
    if (currentTempValue.IsNull())
    {
        // This configures the initial value for the simulated sensor values
        currentTempValue.SetNonNull(Crypto::GetRandU16() % maxTempMeasuredValue.Value());
    }

    DataModel::Nullable<uint16_t> currentHumidityValue;
    RelativeHumidityMeasurement::Attributes::MeasuredValue::Get(kHumiditySensorEndpoint, currentHumidityValue);
    if (currentHumidityValue.IsNull())
    {
        // This configures the initial value for the simulated sensor values
        currentHumidityValue.SetNonNull(Crypto::GetRandU16() % maxMeasuredHumidityValue.Value());
    }

    if (kAttributeChangeReportThreshold > 3)
    {

        // Triggers a report update every 3 timer triggers
        humidity    = (currentHumidityValue.Value() + kAttributeChangeReportThreshold / 3) % maxMeasuredHumidityValue.Value();
        temperature = (currentTempValue.Value() + kAttributeChangeReportThreshold / 3) % maxTempMeasuredValue.Value();
    }
    else
    {
        humidity    = currentHumidityValue.Value() + 1;
        temperature = currentTempValue.Value() + 1;
    }

#endif // defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR

    // Check if temperature change requires a report - Checks if delta with last reported value is greater
    // than kAttributeChangeReportThreshold. If it is, the attribute is marked as dirty.
    // The goal is to only report when the difference as an impact on the application behavior.
    if (abs(mLastReportedTemperatureValue - temperature) > kAttributeChangeReportThreshold)
    {
        mLastReportedTemperatureValue = temperature;
        reportState                   = MarkAttributeDirty::kIfChanged;
    }
    TemperatureMeasurement::Attributes::MeasuredValue::Set(kTemperatureSensorEndpoint, temperature, reportState);

    // Check if humidity change requires a report - Checks if delta with last reported value is greater
    // than kAttributeChangeReportThreshold. If it is, the attribute is marked as dirty.
    // The goal is to only report when the difference as an impact on the application behavior.
    reportState = MarkAttributeDirty::kNo;
    if (abs(mLastReportedHumidityValue - humidity) > kAttributeChangeReportThreshold)
    {
        mLastReportedHumidityValue = humidity;
        reportState                = MarkAttributeDirty::kIfChanged;
    }
    RelativeHumidityMeasurement::Attributes::MeasuredValue::Set(kHumiditySensorEndpoint, humidity, reportState);

    VerifyOrDieWithMsg(aLayer->StartTimer(kSensorReadPeriod, SensorActionTriggered, nullptr) == CHIP_NO_ERROR, AppServer,
                       "Failed to start recurring timer!");

    ChipLogDetail(AppServer, "Current temperature value: %d", temperature);
    ChipLogDetail(AppServer, "Current humidity value: %d", humidity);
}

} // namespace

namespace SensorManager {

CHIP_ERROR Init()
{
#if defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR
    VerifyOrDieWithMsg(Si70xxSensor::Init() == SL_STATUS_OK, AppServer, "Failed to initialize the sensor!");
#endif // defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR

    VerifyOrDieWithMsg(DeviceLayer::PlatformMgr().ScheduleWork([](intptr_t arg) {
        SensorActionTriggered(&chip::DeviceLayer::SystemLayer(), nullptr);
    }) == CHIP_NO_ERROR,
                       AppServer, "Failed to schedule the first SensorCallback!");

    isInitialised = true;
    return CHIP_NO_ERROR;
}

void ButtonActionTriggered(AppEvent * aEvent)
{
    VerifyOrReturn(aEvent->Type == AppEvent::kEventType_Button);

    DeviceLayer::PlatformMgr().ScheduleWork([](intptr_t arg) {
        chip::BitMask<OccupancySensing::OccupancyBitmap> state;
        OccupancySensing::Attributes::Occupancy::Get(kOccupancySensorEndpoint, &state);

        if (state.Has(OccupancySensing::OccupancyBitmap::kOccupied))
        {
            state.Clear(OccupancySensing::OccupancyBitmap::kOccupied);
        }
        else
        {
            state.Set(OccupancySensing::OccupancyBitmap::kOccupied);
        }

        OccupancySensing::Attributes::Occupancy::Set(kOccupancySensorEndpoint, state);
    });
}

Status GetMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value)
{
    Status status = TemperatureMeasurement::Attributes::MeasuredValue::Get(kTemperatureSensorEndpoint, value);
    return status;
}

Status GetMaxMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value)
{
    Status status = TemperatureMeasurement::Attributes::MaxMeasuredValue::Get(kTemperatureSensorEndpoint, value);
    return status;
}

Status GetMinMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value)
{
    Status status = TemperatureMeasurement::Attributes::MinMeasuredValue::Get(kTemperatureSensorEndpoint, value);
    return status;
}

Status GetMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value)
{
    Status status = RelativeHumidityMeasurement::Attributes::MeasuredValue::Get(kHumiditySensorEndpoint, value);
    return status;
}

Status GetMaxMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value)
{
    Status status = RelativeHumidityMeasurement::Attributes::MaxMeasuredValue::Get(kHumiditySensorEndpoint, value);
    return status;
}

Status GetMinMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value)
{
    Status status = RelativeHumidityMeasurement::Attributes::MinMeasuredValue::Get(kHumiditySensorEndpoint, value);
    return status;
}

bool IsOccupancyDetected()
{
    chip::BitMask<OccupancySensing::OccupancyBitmap> state;
    DeviceLayer::PlatformMgr().LockChipStack();
    OccupancySensing::Attributes::Occupancy::Get(kOccupancySensorEndpoint, &state);
    DeviceLayer::PlatformMgr().UnlockChipStack();

    return state.Has(OccupancySensing::OccupancyBitmap::kOccupied);
}

} // namespace SensorManager
