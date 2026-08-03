/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
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

#include "AppTask.h"
#include "AppConfig.h"
#include "AppEvent.h"
#include "CustomerAppTask.h"
#include "FanControlConfig.h"
#include "LEDWidget.h"

#ifdef DISPLAY_ENABLED
#include "FanControlUI.h"
#include "lcd.h"
#ifdef QR_CODE_ENABLED
#include "qrcodegen.h"
#endif // QR_CODE_ENABLED
#endif // DISPLAY_ENABLED

#include <app-common/zap-generated/attribute-type.h>
#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app/clusters/fan-control-server/fan-control-delegate.h>
#include <app/clusters/fan-control-server/fan-control-server.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>

#include <assert.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/TypeTraits.h>

#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#include <setup_payload/OnboardingCodesUtil.h>
#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#define APP_FUNCTION_BUTTON 0

#ifdef SL_CATALOG_SIMPLE_LED_LED1_PRESENT
#define FAN_LED 1
#else
#define FAN_LED 0
#endif

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::FanControl;
using namespace ::chip::DeviceLayer;
using Protocols::InteractionModel::Status;

namespace {

CustomerAppTask & AppInstance()
{
    return CustomerAppTask::GetAppTask();
}

// Defaults live in FanControlConfig.h; consumers tune via the Configuration Wizard.
constexpr EndpointId kFanEndpoint = FAN_CONTROL_ENDPOINT;

constexpr int kaLowestOffTrue  = 0;
constexpr int kaLowestOffFalse = 1;

LEDWidget sFanLED;

FanModeEnum sFanMode         = FanModeEnum::kOff;
uint8_t sSpeedMax            = 0;
uint8_t sPercentCurrent      = 0;
uint8_t sSpeedCurrent        = 0;
bool sSupportsMultiSpeed     = false;

void UpdateFanControlLED()
{
    sFanLED.Set(false);
    if (sFanMode != FanModeEnum::kOff && sFanMode != FanModeEnum::kUnknownEnumValue)
    {
        sFanLED.Set(true);
    }
}

#if defined(DISPLAY_ENABLED) && DISPLAY_ENABLED
void UpdateFanControlLCD()
{
    BaseApplication::GetLCD().WriteDemoUI(false);
}
#endif

void PostFanUiUpdateEvent()
{
    AppEvent fan_event{};
    fan_event.Type            = AppEvent::kEventType_FanControl;
    fan_event.FanEvent.Action = to_underlying(sFanMode);
    fan_event.FanEvent.Actor  = static_cast<int32_t>(AppEvent::kEventType_FanControl);
    fan_event.Handler         = &CustomerAppTask::FanUiUpdateEventHandler;
    AppInstance().PostEvent(&fan_event);
}

} // namespace

AppTask::AppTask() : Delegate(kFanEndpoint) {}

CHIP_ERROR AppTask::AppInit()
{
    chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(&CustomerAppTask::ButtonEventHandler);

#ifdef DISPLAY_ENABLED
    GetLCD().SetCustomUI(FanControlUI::DrawUI);
#endif

    CHIP_ERROR err = AppInstance().InitFanControl();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "InitFanControl() failed: %" CHIP_ERROR_FORMAT, err.Format());
        appError(err);
    }

    // Update the LCD with the Stored value. Show QR Code if not provisioned.
#ifdef DISPLAY_ENABLED
    GetLCD().WriteDemoUI(false);
#ifdef QR_CODE_ENABLED
    if (!BaseApplication::GetProvisionStatus())
    {
        GetLCD().ShowQRCode(true);
    }
#endif // QR_CODE_ENABLED
#endif

    return CHIP_NO_ERROR;
}

CHIP_ERROR AppTask::InitFanControl()
{
    SetDefaultDelegate(kFanEndpoint, &AppInstance());
    sFanLED.Init(FAN_LED);
    LinkAppLed(&sFanLED);

    PlatformMgr().LockChipStack();
    ReadSupportsMultiSpeedFromFeatureMap();
    if (Attributes::SpeedMax::Get(kFanEndpoint, &sSpeedMax) != Status::Success)
    {
        sSpeedMax = static_cast<uint8_t>(FAN_MODE_HIGH_UPPER_BOUND);
    }
    FanModeEnum fanMode = sFanMode;
    Status fanModeStatus = Attributes::FanMode::Get(kFanEndpoint, &fanMode);
    DataModel::Nullable<Percent> percentSettingNullable = GetPercentSetting();
    DataModel::Nullable<uint8_t> speedSettingNullable   = GetSpeedSetting();
    PlatformMgr().UnlockChipStack();

    if (fanModeStatus != Status::Success)
    {
        ChipLogError(NotSpecified, "InitFanControl: failed to get FanMode attribute: %d", to_underlying(fanModeStatus));
    }
    else
    {
        sFanMode = fanMode;
    }

    uint8_t percentSettingCB = percentSettingNullable.IsNull() ? 0 : percentSettingNullable.Value();
    AppInstance().HandlePercentSettingChange(percentSettingCB);

    if (sSupportsMultiSpeed)
    {
        uint8_t speedSettingCB = speedSettingNullable.IsNull() ? 0 : speedSettingNullable.Value();
        AppInstance().HandleSpeedSettingChange(speedSettingCB);
    }
    else
    {
        // Startup runs before BaseApplication marks the app initialized, so
        // boot-time FanMode writes may not loop back through the DM callback.
        AppInstance().HandleFanModeChange(sFanMode);
    }

    PostFanUiUpdateEvent();

    return CHIP_NO_ERROR;
}

bool AppTask::ReadSupportsMultiSpeedFromFeatureMap()
{
    uint32_t featureMap = 0;
    if (Attributes::FeatureMap::Get(kFanEndpoint, &featureMap) != Status::Success)
    {
        sSupportsMultiSpeed = false;
        return false;
    }

    sSupportsMultiSpeed = (featureMap & to_underlying(Feature::kMultiSpeed)) != 0;
    return sSupportsMultiSpeed;
}

uint8_t AppTask::SpeedToPercent(uint8_t speed, uint8_t speedMax)
{
    VerifyOrReturnValue(speedMax != 0, 0);
    return static_cast<uint8_t>((static_cast<uint16_t>(speed) * 100) / speedMax);
}

DataModel::Nullable<uint8_t> AppTask::GetSpeedSetting()
{
    DataModel::Nullable<uint8_t> speedSetting;

    Status status = Attributes::SpeedSetting::Get(kFanEndpoint, speedSetting);
    VerifyOrReturnValue(status == Status::Success, speedSetting);
    return speedSetting;
}

DataModel::Nullable<Percent> AppTask::GetPercentSetting()
{
    DataModel::Nullable<Percent> percentSetting;

    Status status = Attributes::PercentSetting::Get(kFanEndpoint, percentSetting);
    VerifyOrReturnValue(status == Status::Success, percentSetting, ChipLogError(NotSpecified, "GetPercentSetting: failed to get PercentSetting attribute: %d", to_underlying(status)));

    return percentSetting;
}

Status AppTask::SetPercentSetting(Percent aNewPercentSetting)
{
    DataModel::Nullable<Percent> percentSettingNullable = GetPercentSetting();
    VerifyOrReturnValue(!percentSettingNullable.IsNull() && percentSettingNullable.Value() == aNewPercentSetting, Status::Success);

    AttributeUpdateInfo * data = chip::Platform::New<AttributeUpdateInfo>();
    data->percentSetting       = aNewPercentSetting;
    data->endPoint             = kFanEndpoint;
    data->isPercentSetting     = true;
    if (PlatformMgr().ScheduleWork(&CustomerAppTask::UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "SetPercentSetting: failed to update PercentSetting attribute");
        chip::Platform::Delete(data);
        return Status::Failure;
    }

    return Status::Success;
}

Status AppTask::SetSpeedSetting(uint8_t aNewSpeedSetting)
{
    VerifyOrReturnValue(sSupportsMultiSpeed, Status::Success);

    DataModel::Nullable<uint8_t> speedSettingNullable = GetSpeedSetting();
    VerifyOrReturnValue(!speedSettingNullable.IsNull() && speedSettingNullable.Value() == aNewSpeedSetting, Status::Success);

    Status status = Attributes::SpeedSetting::Set(kFanEndpoint, aNewSpeedSetting);
    VerifyOrReturnValue(status == Status::Success, status, ChipLogError(NotSpecified, "SetSpeedSetting: failed to set SpeedSetting attribute: %d", to_underlying(status)));

    return status;
}

void AppTask::SyncFanMode(FanModeEnum aNewFanMode)
{
    FanModeEnum currentFanMode;
    if (Attributes::FanMode::Get(kFanEndpoint, &currentFanMode) == Status::Success && currentFanMode == aNewFanMode)
    {
        sFanMode = aNewFanMode;
        return;
    }

    AttributeUpdateInfo * data = chip::Platform::New<AttributeUpdateInfo>();
    data->endPoint      = kFanEndpoint;
    data->fanMode       = aNewFanMode;
    data->isFanMode     = true;
    if (PlatformMgr().ScheduleWork(&CustomerAppTask::UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "SyncFanMode: failed to update FanMode attribute");
        chip::Platform::Delete(data);
        return;
    }

    sFanMode = aNewFanMode;
}

FanModeEnum AppTask::DeriveFanModeFromPercent(Percent percent)
{
    VerifyOrReturnValue(percent != 0, FanModeEnum::kOff);

    const uint8_t lowPercentMax = SpeedToPercent(static_cast<uint8_t>(FAN_MODE_LOW_UPPER_BOUND), sSpeedMax);
    VerifyOrReturnValue(percent > lowPercentMax, FanModeEnum::kLow);

    const uint8_t mediumPercentMax = SpeedToPercent(static_cast<uint8_t>(FAN_MODE_MEDIUM_UPPER_BOUND), sSpeedMax);
    VerifyOrReturnValue(percent > mediumPercentMax, FanModeEnum::kMedium);

    return FanModeEnum::kHigh;
}

void AppTask::HandleFanModeChange(FanModeEnum aNewFanMode)
{
    ChipLogDetail(NotSpecified, "HandleFanModeChange: %d", to_underlying(aNewFanMode));

    if (sSupportsMultiSpeed)
    {
        uint8_t speedSettingCurrent = GetSpeedSetting().ValueOr(101);
        uint8_t highSpeedSetting =
            (sSpeedMax >= FAN_MODE_HIGH_LOWER_BOUND) ? static_cast<uint8_t>(FAN_MODE_HIGH_LOWER_BOUND) : sSpeedMax;

        switch (aNewFanMode)
        {
        case FanModeEnum::kOff: {
            if (speedSettingCurrent != 0)
            {
                SetSpeedSetting(0);
            }
            break;
        }
        case FanModeEnum::kLow: {
            if (speedSettingCurrent < FAN_MODE_LOW_LOWER_BOUND || speedSettingCurrent > FAN_MODE_LOW_UPPER_BOUND)
            {
                SetSpeedSetting(static_cast<uint8_t>(FAN_MODE_LOW_LOWER_BOUND));
            }
            break;
        }
        case FanModeEnum::kMedium: {
            if (speedSettingCurrent < FAN_MODE_MEDIUM_LOWER_BOUND || speedSettingCurrent > FAN_MODE_MEDIUM_UPPER_BOUND)
            {
                SetSpeedSetting(static_cast<uint8_t>(FAN_MODE_MEDIUM_LOWER_BOUND));
            }
            break;
        }
        case FanModeEnum::kOn:
        case FanModeEnum::kHigh: {
            if (speedSettingCurrent < highSpeedSetting || speedSettingCurrent > sSpeedMax)
            {
                SetSpeedSetting(highSpeedSetting);
            }
            break;
        }
        case FanModeEnum::kSmart:
        case FanModeEnum::kAuto: {
            ChipLogProgress(NotSpecified, "HandleFanModeChange: Auto");
            break;
        }
        case FanModeEnum::kUnknownEnumValue: {
            ChipLogProgress(NotSpecified, "HandleFanModeChange: Unknown");
            break;
        }
        default:
            break;
        }
        return;
    }

    uint8_t percentSettingCurrent = GetPercentSetting().ValueOr(101);
    const uint8_t lowPercentMin   = 1;
    const uint8_t lowPercentMax   = SpeedToPercent(static_cast<uint8_t>(FAN_MODE_LOW_UPPER_BOUND), sSpeedMax);
    const uint8_t mediumPercentMin =
        SpeedToPercent(static_cast<uint8_t>(FAN_MODE_MEDIUM_LOWER_BOUND), sSpeedMax);
    const uint8_t mediumPercentMax =
        SpeedToPercent(static_cast<uint8_t>(FAN_MODE_MEDIUM_UPPER_BOUND), sSpeedMax);
    const uint8_t highPercentMin =
        SpeedToPercent(static_cast<uint8_t>((sSpeedMax >= FAN_MODE_HIGH_LOWER_BOUND) ? FAN_MODE_HIGH_LOWER_BOUND : sSpeedMax),
                       sSpeedMax);
    const uint8_t highPercentMax = 100;

    switch (aNewFanMode)
    {
    case FanModeEnum::kOff: {
        if (percentSettingCurrent != 0)
        {
            SetPercentSetting(0);
        }
        break;
    }
    case FanModeEnum::kLow: {
        if (percentSettingCurrent < lowPercentMin || percentSettingCurrent > lowPercentMax)
        {
            SetPercentSetting(SpeedToPercent(static_cast<uint8_t>(FAN_MODE_LOW_LOWER_BOUND), sSpeedMax));
        }
        break;
    }
    case FanModeEnum::kMedium: {
        if (percentSettingCurrent < mediumPercentMin || percentSettingCurrent > mediumPercentMax)
        {
            SetPercentSetting(mediumPercentMin);
        }
        break;
    }
    case FanModeEnum::kOn:
    case FanModeEnum::kHigh: {
        if (percentSettingCurrent < highPercentMin || percentSettingCurrent > highPercentMax)
        {
            SetPercentSetting(highPercentMin);
        }
        break;
    }
    case FanModeEnum::kSmart:
    case FanModeEnum::kAuto: {
        ChipLogProgress(NotSpecified, "HandleFanModeChange: Auto");
        break;
    }
    case FanModeEnum::kUnknownEnumValue: {
        ChipLogProgress(NotSpecified, "HandleFanModeChange: Unknown");
        break;
    }
    default:
        break;
    }
}

void AppTask::HandlePercentSettingChange(uint8_t aNewPercentSetting)
{
    VerifyOrReturn(aNewPercentSetting != sPercentCurrent);
    VerifyOrReturn(sFanMode != FanModeEnum::kAuto);
    ChipLogDetail(NotSpecified, "HandlePercentSettingChange: %d", aNewPercentSetting);

    AppTask::AttributeUpdateInfo * data = chip::Platform::New<AppTask::AttributeUpdateInfo>();
    data->endPoint             = kFanEndpoint;
    data->percentCurrent       = aNewPercentSetting;
    data->isPercentCurrent     = true;

    if (PlatformMgr().ScheduleWork(&CustomerAppTask::UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "HandlePercentSettingChange: failed to set PercentCurrent attribute");
        chip::Platform::Delete(data);
        return;
    }

    sPercentCurrent = aNewPercentSetting;
}

void AppTask::HandleSpeedSettingChange(uint8_t aNewSpeedSetting)
{
    VerifyOrReturn(sSupportsMultiSpeed);
    VerifyOrReturn(aNewSpeedSetting != sSpeedCurrent);
    VerifyOrReturn(sFanMode != FanModeEnum::kAuto);
    ChipLogDetail(NotSpecified, "HandleSpeedSettingChange: %d", aNewSpeedSetting);

    AppTask::AttributeUpdateInfo * data = chip::Platform::New<AppTask::AttributeUpdateInfo>();
    data->endPoint             = kFanEndpoint;
    data->speedCurrent         = aNewSpeedSetting;
    data->isSpeedCurrent       = true;

    if (PlatformMgr().ScheduleWork(&CustomerAppTask::UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "HandleSpeedSettingChange: failed to set SpeedCurrent attribute");
        chip::Platform::Delete(data);
        return;
    }

    sSpeedCurrent = aNewSpeedSetting;
}

CHIP_ERROR AppTask::StartAppTask()
{
    return BaseApplication::StartAppTask(AppTaskMain);
}

void AppTask::AppTaskMain(void * pvParameter)
{
    AppEvent event;
    osMessageQueueId_t sAppEventQueue = *(static_cast<osMessageQueueId_t *>(pvParameter));

    CHIP_ERROR err = AppInstance().Init();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "AppTask.Init() failed: %" CHIP_ERROR_FORMAT, err.Format());
        appError(err);
    }

#if !(defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER)
    AppInstance().StartStatusLEDTimer();
#endif

    ChipLogProgress(AppServer, "App Task started");

    while (true)
    {
        osStatus_t eventReceived = osMessageQueueGet(sAppEventQueue, &event, nullptr, osWaitForever);
        while (eventReceived == osOK)
        {
            AppInstance().DispatchEvent(&event);
            eventReceived = osMessageQueueGet(sAppEventQueue, &event, nullptr, 0);
        }
    }
}

Status AppTask::HandleStep(StepDirectionEnum aDirection, bool aWrap, bool aLowestOff)
{
    ChipLogProgress(NotSpecified, "AppTask::HandleStep aDirection %d, aWrap %d, aLowestOff %d", to_underlying(aDirection), aWrap,
                    aLowestOff);

    VerifyOrReturnError(aDirection != StepDirectionEnum::kUnknownEnumValue, Status::InvalidCommand);

    uint8_t speedMin = aLowestOff ? kaLowestOffTrue : kaLowestOffFalse;

    if (sSupportsMultiSpeed)
    {
        DataModel::Nullable<uint8_t> speedSettingNullable = GetSpeedSetting();
        uint8_t curSpeedSetting                         = speedSettingNullable.IsNull() ? speedMin : speedSettingNullable.Value();

        switch (aDirection)
        {
        case StepDirectionEnum::kIncrease: {
            if (curSpeedSetting >= sSpeedMax)
            {
                curSpeedSetting = aWrap ? speedMin : sSpeedMax;
            }
            else
            {
                curSpeedSetting++;
            }
            break;
        }
        case StepDirectionEnum::kDecrease: {
            if (curSpeedSetting <= speedMin)
            {
                curSpeedSetting = aWrap ? sSpeedMax : speedMin;
            }
            else
            {
                curSpeedSetting--;
            }
            break;
        }
        default: {
            break;
        }
        }

        return SetSpeedSetting(curSpeedSetting);
    }

    DataModel::Nullable<Percent> percentSettingNullable = GetPercentSetting();
    Percent curPercentSetting = percentSettingNullable.IsNull() ? static_cast<Percent>(speedMin) : percentSettingNullable.Value();

    switch (aDirection)
    {
    case StepDirectionEnum::kIncrease: {
        curPercentSetting++;
        if (curPercentSetting > 100)
        {
            curPercentSetting = aWrap ? static_cast<Percent>(speedMin) : 100;
        }
        break;
    }
    case StepDirectionEnum::kDecrease: {
        curPercentSetting--;
        if (curPercentSetting < speedMin)
        {
            curPercentSetting = aWrap ? 100 : static_cast<Percent>(speedMin);
        }
        break;
    }
    default: {
        break;
    }
    }

    return SetPercentSetting(curPercentSetting);
}

void AppTask::UpdateClusterState(intptr_t arg)
{
    AppTask::AttributeUpdateInfo * data = reinterpret_cast<AppTask::AttributeUpdateInfo *>(arg);
    if (data->isSpeedCurrent)
    {
        Attributes::SpeedCurrent::Set(data->endPoint, data->speedCurrent);
    }
    else if (data->isPercentCurrent)
    {
        Attributes::PercentCurrent::Set(data->endPoint, data->percentCurrent);
    }
    else if (data->isSpeedSetting)
    {
        Attributes::SpeedSetting::Set(data->endPoint, data->speedSetting);
    }
    else if (data->isFanMode)
    {
        Attributes::FanMode::Set(data->endPoint, data->fanMode);
    }
    else if (data->isPercentSetting)
    {
        Attributes::PercentSetting::Set(data->endPoint, data->percentSetting);
    }
    chip::Platform::Delete(data);
}

void AppTask::DMPostAttributeChangeCallback(const ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                            uint8_t * value)
{
    VerifyOrReturn(attributePath.mEndpointId == kFanEndpoint);

    ClusterId clusterId     = attributePath.mClusterId;
    AttributeId attributeId = attributePath.mAttributeId;
    ChipLogProgress(Zcl, "Cluster callback: " ChipLogFormatMEI, ChipLogValueMEI(clusterId));

    if (clusterId == Clusters::Identify::Id)
    {
        ChipLogProgress(Zcl, "Identify attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u",
                        ChipLogValueMEI(attributeId), type, *value, size);
        return;
    }

    if (clusterId != FanControl::Id)
    {
        return;
    }

    switch (attributeId)
    {
    case Attributes::PercentSetting::Id: {
        AppInstance().HandlePercentSettingChange(*value);
        break;
    }
    case Attributes::SpeedSetting::Id: {
        if (sSupportsMultiSpeed)
        {
            AppInstance().HandleSpeedSettingChange(*value);
        }
        break;
    }
    case Attributes::FanMode::Id: {
        sFanMode = *reinterpret_cast<FanModeEnum *>(value);
        // MultiSpeed: cluster keeps FanMode / PercentSetting / SpeedSetting consistent.
        if (!sSupportsMultiSpeed)
        {
            AppInstance().HandleFanModeChange(sFanMode);
        }
        PostFanUiUpdateEvent();
        break;
    }
    default: {
        break;
    }
    }
}

FanModeEnum AppTask::GetFanMode()
{
    return sFanMode;
}

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    if (button == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        AppInstance().PostEvent(&button_event);
    }
}

void AppTask::FanUiUpdateEventHandler(AppEvent * aEvent)
{
    if (aEvent == nullptr || aEvent->Type != AppEvent::kEventType_FanControl)
    {
        return;
    }

    UpdateFanControlLED();
#if defined(DISPLAY_ENABLED) && DISPLAY_ENABLED
    UpdateFanControlLCD();
#endif
}
