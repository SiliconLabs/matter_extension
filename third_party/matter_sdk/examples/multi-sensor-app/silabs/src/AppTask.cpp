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

#if (SL_MATTER_GN_BUILD == 0)
#include "sl_matter_sensor_config.h"
#endif // SL_MATTER_GN_BUILD

#include "AppTask.h"
#include "AppConfig.h"
#include "AppEvent.h"
#include "CustomerAppTask.h"
#include "LEDWidget.h"
#include "SensorConfig.h"
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/ConcreteAttributePath.h>
#include <app/clusters/occupancy-sensor-server/CodegenIntegration.h>
#include <app/clusters/relative-humidity-measurement-server/CodegenIntegration.h>
#include <app/clusters/temperature-measurement-server/CodegenIntegration.h>
#include <app/data-model-provider/AttributeChangeListener.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>
#include <assert.h>
#include <cmsis_os2.h>
#include <data-model-providers/codegen/CodegenDataModelProvider.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <platform/PlatformError.h>
#include <setup_payload/OnboardingCodesUtil.h>
#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>
#include <sl_cmsis_os2_common.h>

#if defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR
#include <Si70xxSensor.h>
#else
#include <crypto/RandUtils.h>
#endif // defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR

#if defined(DISPLAY_ENABLED) && DISPLAY_ENABLED
#include <SensorsUI.h>
#endif

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::DeviceLayer;
using namespace chip::DeviceLayer::Silabs;
using namespace chip::Protocols::InteractionModel;

namespace {

LEDWidget sOccupancyLed;

enum class ButtonTypes : uint8_t
{
    kFunctionButton    = 0,
    kApplicationButton = 1,
};

#if defined(SL_CATALOG_SIMPLE_LED_LED1_PRESENT)
constexpr uint8_t kOccupancyLedId = 1;
#else
constexpr uint8_t kOccupancyLedId = 0;
#endif

constexpr EndpointId kOccupancySensorEndpoint   = OCCUPANCY_SENSOR_ENDPOINT;
constexpr EndpointId kTemperatureSensorEndpoint = TEMPERATURE_SENSOR_ENDPOINT;
constexpr EndpointId kHumiditySensorEndpoint    = HUMIDITY_SENSOR_ENDPOINT;

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

CustomerAppTask & AppInstance()
{
    return CustomerAppTask::GetAppTask();
}

TemperatureMeasurementCluster * GetTemperatureCluster()
{
    return TemperatureMeasurement::FindClusterOnEndpoint(kTemperatureSensorEndpoint);
}

RelativeHumidityMeasurementCluster * GetHumidityCluster()
{
    return RelativeHumidityMeasurement::FindClusterOnEndpoint(kHumiditySensorEndpoint);
}

} // namespace

CHIP_ERROR AppTask::AppInit()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    GetPlatform().SetButtonsCb(CustomerAppTask::ButtonEventHandler);

    sOccupancyLed.Init(kOccupancyLedId);
    sOccupancyLed.Set(false);

    err = AppInstance().InitSensorManager();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "InitSensorManager failed");
        appError(err);
    }

#ifdef DISPLAY_ENABLED
    mCurrentSensorUI = kSensorUIEnum::kOccupancySensor;

// Show QR Code if not provisioned
#ifdef QR_CODE_ENABLED
    if (!BaseApplication::GetProvisionStatus())
    {
        GetLCD().ShowQRCode(true);
        mCurrentSensorUI = kSensorUIEnum::kQrCode;
    }
#endif // QR_CODE_ENABLED

    UpdateSensorDisplay();

#endif // DISPLAY_ENABLED

    return err;
}

CHIP_ERROR AppTask::StartAppTask()
{
    return BaseApplication::StartAppTask(AppTaskMain);
}

void AppTask::AppTaskMain(void * pvParameter)
{
    AppEvent event;
    osMessageQueueId_t sAppEventQueue = *(static_cast<osMessageQueueId_t *>(pvParameter));

    CHIP_ERROR err = GetAppTask().Init();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "AppTask Init Failed!");
        appError(err);
    }

#if !(defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER)
    GetAppTask().StartStatusLEDTimer();
#endif

    ChipLogProgress(AppServer, "AppTask started.");

    while (true)
    {
        osStatus_t eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, osWaitForever);
        while (eventReceived == osOK)
        {
            GetAppTask().DispatchEvent(&event);
            eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, 0);
        }
    }
}

#ifdef DISPLAY_ENABLED
void AppTask::UpdateDisplay()
{
    mCurrentSensorUI =
        static_cast<kSensorUIEnum>((static_cast<uint8_t>(mCurrentSensorUI) + 1) % static_cast<uint8_t>(kSensorUIEnum::kCount));
    UpdateSensorDisplay();
}

void AppTask::UpdateSensorDisplay()
{
    switch (mCurrentSensorUI)
    {
    case kSensorUIEnum::kOccupancySensor:
        GetLCD().SetCustomUI(nullptr);
        GetLCD().WriteDemoUI(IsOccupancyDetected());
        break;
    case kSensorUIEnum::kSensor:
        GetLCD().SetCustomUI(SensorsUI::SensorUI);
        GetLCD().WriteDemoUI();
        break;
    case kSensorUIEnum::kStatusScreen:
        BaseApplication::UpdateLCDStatusScreen();
        GetLCD().WriteStatus();
        break;
#ifdef QR_CODE_ENABLED
    case kSensorUIEnum::kQrCode:
        GetLCD().ShowQRCode(true);
        break;
#endif
    default:
        // Handle unknown sensor
        // This should never happen
        break;
    }
}
#endif // DISPLAY_ENABLED

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    switch (ButtonTypes(button))
    {
    case ButtonTypes::kFunctionButton:
        button_event.Handler = BaseApplication::ButtonHandler;
        GetAppTask().PostEvent(&button_event);
        break;
    case ButtonTypes::kApplicationButton:
        if (SilabsPlatform::ButtonAction(btnAction) == SilabsPlatform::ButtonAction::ButtonPressed)
        {
            button_event.Handler = CustomerAppTask::ProcessButtonEvent;
            GetAppTask().PostEvent(&button_event);
        }
        break;

    default:
        return;
    }
}

void AppTask::ProcessButtonEvent(AppEvent * aEvent)
{
    VerifyOrReturn(aEvent != nullptr);
    VerifyOrReturn(aEvent->Type == AppEvent::kEventType_Button);

    TEMPORARY_RETURN_IGNORED DeviceLayer::PlatformMgr().ScheduleWork([](intptr_t arg) {
        OccupancySensingCluster * cluster = OccupancySensing::FindClusterOnEndpoint(kOccupancySensorEndpoint);
        VerifyOrReturn(cluster != nullptr);
        bool state = cluster->IsOccupied();
        cluster->SetOccupancy(!state);
    });
}

void AppTask::OnAttributeChanged(const ConcreteAttributePath & path, DataModel::AttributeChangeType)
{
    const bool isOccupancyUpdate = path.mEndpointId == kOccupancySensorEndpoint && path.mClusterId == OccupancySensing::Id &&
        path.mAttributeId == OccupancySensing::Attributes::Occupancy::Id;
    const bool isTemperatureUpdate = path.mEndpointId == kTemperatureSensorEndpoint &&
        path.mClusterId == TemperatureMeasurement::Id && path.mAttributeId == TemperatureMeasurement::Attributes::MeasuredValue::Id;
    const bool isHumidityUpdate = path.mEndpointId == kHumiditySensorEndpoint &&
        path.mClusterId == RelativeHumidityMeasurement::Id &&
        path.mAttributeId == RelativeHumidityMeasurement::Attributes::MeasuredValue::Id;

    if (isOccupancyUpdate)
    {
        OccupancySensingCluster * cluster = OccupancySensing::FindClusterOnEndpoint(path.mEndpointId);
        VerifyOrReturn(cluster != nullptr);

        AppEvent event                         = {};
        event.Type                             = AppEvent::kEventType_OccupancyAttributeUpdate;
        event.Handler                          = CustomerAppTask::OccupancyAttributeUpdateEvent;
        event.OccupancyEvent.occupancyDetected = cluster->IsOccupied();
        AppTask::GetAppTask().PostEvent(&event);
        return;
    }

    if (isTemperatureUpdate || isHumidityUpdate)
    {
        AppEvent event = {};
        event.Type     = AppEvent::kEventType_SensorAttributeUpdate;
        event.Handler  = CustomerAppTask::SensorAttributeUpdateEvent;
        AppTask::GetAppTask().PostEvent(&event);
    }
}

void AppTask::SensorAttributeUpdateEvent(AppEvent * aEvent)
{
    VerifyOrReturn(aEvent != nullptr);
    VerifyOrReturn(aEvent->Type == AppEvent::kEventType_SensorAttributeUpdate);

#ifdef DISPLAY_ENABLED
    GetAppTask().UpdateSensorDisplay();
#endif // DISPLAY_ENABLED
}

void AppTask::OccupancyAttributeUpdateEvent(AppEvent * aEvent)
{
    VerifyOrReturn(aEvent != nullptr);
    VerifyOrReturn(aEvent->Type == AppEvent::kEventType_OccupancyAttributeUpdate);

    sOccupancyLed.Set(aEvent->OccupancyEvent.occupancyDetected);

#ifdef DISPLAY_ENABLED
    GetAppTask().UpdateSensorDisplay();
#endif // DISPLAY_ENABLED
}

void AppTask::TriggerSensorAction(chip::System::Layer * aLayer, void * aAppState)
{
    VerifyOrDieWithMsg(isInitialised, AppServer, "Sensor Action was triggered before the Sensor Manager was initialised!");

    int16_t temperature = 0;
    uint16_t humidity   = 0;

    VerifyOrReturn(AppInstance().GetTemperatureAndHumidity(temperature, humidity) == CHIP_NO_ERROR);

    if (abs(mLastReportedTemperatureValue - temperature) > kAttributeChangeReportThreshold)
    {
        mLastReportedTemperatureValue = temperature;
    }
    {
        DataModel::Nullable<int16_t> tempVal;
        tempVal.SetNonNull(temperature);
        VerifyOrReturn(TemperatureMeasurement::SetMeasuredValue(kTemperatureSensorEndpoint, tempVal) == CHIP_NO_ERROR);
    }

    if (abs(mLastReportedHumidityValue - humidity) > kAttributeChangeReportThreshold)
    {
        mLastReportedHumidityValue = humidity;
    }
    {
        DataModel::Nullable<uint16_t> humVal;
        humVal.SetNonNull(humidity);
        VerifyOrReturn(RelativeHumidityMeasurement::SetMeasuredValue(kHumiditySensorEndpoint, humVal) == CHIP_NO_ERROR);
    }

    VerifyOrDieWithMsg(aLayer->StartTimer(kSensorReadPeriod, CustomerAppTask::TriggerSensorAction, nullptr) == CHIP_NO_ERROR,
                       AppServer, "Failed to start recurring timer!");

    ChipLogDetail(AppServer, "Current temperature value: %d", temperature);
    ChipLogDetail(AppServer, "Current humidity value: %d", humidity);
}

CHIP_ERROR AppTask::GetTemperatureAndHumidity(int16_t & temperature, uint16_t & humidity)
{
#if defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR
    sl_status_t status = Si70xxSensor::GetSensorData(humidity, temperature);
    if (status != SL_STATUS_OK)
    {
        ChipLogError(AppServer, "Failed to read sensor data: %lx", status);
        return MATTER_PLATFORM_ERROR(status);
    }
#else
    TemperatureMeasurementCluster * tempCluster = GetTemperatureCluster();
    DataModel::Nullable<int16_t> maxTempMeasuredValue =
        (tempCluster != nullptr) ? tempCluster->GetMaxMeasuredValue() : DataModel::Nullable<int16_t>{};

    RelativeHumidityMeasurementCluster * rhCluster = GetHumidityCluster();
    DataModel::Nullable<uint16_t> maxMeasuredHumidityValue =
        (rhCluster != nullptr) ? rhCluster->GetMaxMeasuredValue() : DataModel::Nullable<uint16_t>{};

    DataModel::Nullable<int16_t> currentTempValue;
    if (tempCluster != nullptr)
    {
        currentTempValue = tempCluster->GetMeasuredValue();
    }
    if (currentTempValue.IsNull())
    {
        currentTempValue.SetNonNull(Crypto::GetRandU16() % maxTempMeasuredValue.Value());
    }

    DataModel::Nullable<uint16_t> currentHumidityValue;
    if (rhCluster != nullptr)
    {
        currentHumidityValue = rhCluster->GetMeasuredValue();
    }
    if (currentHumidityValue.IsNull())
    {
        currentHumidityValue.SetNonNull(Crypto::GetRandU16() % maxMeasuredHumidityValue.Value());
    }

    if (kAttributeChangeReportThreshold > 3)
    {
        humidity    = (currentHumidityValue.Value() + kAttributeChangeReportThreshold / 3) % maxMeasuredHumidityValue.Value();
        temperature = (currentTempValue.Value() + kAttributeChangeReportThreshold / 3) % maxTempMeasuredValue.Value();
    }
    else
    {
        humidity    = (currentHumidityValue.Value() + 1) % maxMeasuredHumidityValue.Value();
        temperature = (currentTempValue.Value() + 1) % maxTempMeasuredValue.Value();
    }
#endif // defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR

    return CHIP_NO_ERROR;
}

CHIP_ERROR AppTask::InitSensorManager()
{
#if defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR
    VerifyOrDieWithMsg(Si70xxSensor::Init() == SL_STATUS_OK, AppServer, "Failed to initialize the sensor!");
#endif // defined(SL_MATTER_USE_SI70XX_SENSOR) && SL_MATTER_USE_SI70XX_SENSOR

    DeviceLayer::PlatformMgr().LockChipStack();
    CodegenDataModelProvider::Instance().RegisterAttributeChangeListener(AppInstance());
    DeviceLayer::PlatformMgr().UnlockChipStack();

    isInitialised = true;

    VerifyOrDieWithMsg(DeviceLayer::PlatformMgr().ScheduleWork([](intptr_t arg) {
        CustomerAppTask::TriggerSensorAction(&chip::DeviceLayer::SystemLayer(), nullptr);
    }) == CHIP_NO_ERROR,
                       AppServer, "Failed to schedule the first SensorCallback!");

    return CHIP_NO_ERROR;
}

Status AppTask::GetMeasuredTemperature(DataModel::Nullable<int16_t> & value)
{
    TemperatureMeasurementCluster * cluster = GetTemperatureCluster();
    VerifyOrReturnError(cluster != nullptr, Status::UnsupportedEndpoint);
    value = cluster->GetMeasuredValue();
    return Status::Success;
}

Status AppTask::GetMaxMeasuredTemperature(DataModel::Nullable<int16_t> & value)
{
    TemperatureMeasurementCluster * cluster = GetTemperatureCluster();
    VerifyOrReturnError(cluster != nullptr, Status::UnsupportedEndpoint);
    value = cluster->GetMaxMeasuredValue();
    return Status::Success;
}

Status AppTask::GetMinMeasuredTemperature(DataModel::Nullable<int16_t> & value)
{
    TemperatureMeasurementCluster * cluster = GetTemperatureCluster();
    VerifyOrReturnError(cluster != nullptr, Status::UnsupportedEndpoint);
    value = cluster->GetMinMeasuredValue();
    return Status::Success;
}

Status AppTask::GetMeasuredHumidity(DataModel::Nullable<uint16_t> & value)
{
    RelativeHumidityMeasurementCluster * cluster = GetHumidityCluster();
    VerifyOrReturnError(cluster != nullptr, Status::UnsupportedEndpoint);
    value = cluster->GetMeasuredValue();
    return Status::Success;
}

Status AppTask::GetMaxMeasuredHumidity(DataModel::Nullable<uint16_t> & value)
{
    RelativeHumidityMeasurementCluster * cluster = GetHumidityCluster();
    VerifyOrReturnError(cluster != nullptr, Status::UnsupportedEndpoint);
    value = cluster->GetMaxMeasuredValue();
    return Status::Success;
}

Status AppTask::GetMinMeasuredHumidity(DataModel::Nullable<uint16_t> & value)
{
    RelativeHumidityMeasurementCluster * cluster = GetHumidityCluster();
    VerifyOrReturnError(cluster != nullptr, Status::UnsupportedEndpoint);
    value = cluster->GetMinMeasuredValue();
    return Status::Success;
}

bool AppTask::IsOccupancyDetected()
{
    DeviceLayer::PlatformMgr().LockChipStack();
    OccupancySensingCluster * cluster = OccupancySensing::FindClusterOnEndpoint(kOccupancySensorEndpoint);
    bool occupied = (cluster != nullptr) ? cluster->IsOccupied() : false;
    DeviceLayer::PlatformMgr().UnlockChipStack();

    return occupied;
}

void AppTask::DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                            uint8_t * value)
{
    ClusterId clusterId     = attributePath.mClusterId;
    AttributeId attributeId = attributePath.mAttributeId;
    ChipLogProgress(Zcl, "Cluster callback: " ChipLogFormatMEI, ChipLogValueMEI(clusterId));

    switch (clusterId)
    {
    case Clusters::Identify::Id:
        ChipLogProgress(Zcl, "Identify attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u",
                        ChipLogValueMEI(attributeId), type, *value, size);
        break;

    default:
        break;
    }
}
