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

#include "FanControlManager.h"
#if defined (DISPLAY_ENABLED) && DISPLAY_ENABLED
#include "FanControlUI.h"
#endif

#include "AppConfig.h"
#include "AppTask.h"

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/AttributeAccessInterfaceRegistry.h>
#include <lib/support/TypeTraits.h>

using namespace chip;
using namespace chip::app;
using namespace ::chip::app::Clusters::FanControl;
using Protocols::InteractionModel::Status;

FanControlManager FanControlManager::sFan(FanControlMgr().GetEndPoint());

#ifdef SL_CATALOG_SIMPLE_LED_LED1_PRESENT
#define FAN_LED 1
#else
#define FAN_LED 0
#endif

namespace {
LEDWidget sFanLED;

uint8_t SpeedToPercent(uint8_t speed, uint8_t speedMax)
{
    if (speedMax == 0)
    {
        return 0;
    }
    return static_cast<uint8_t>((static_cast<uint16_t>(speed) * 100) / speedMax);
}
} // namespace

CHIP_ERROR FanControlManager::Init()
{
    SetDefaultDelegate(GetEndPoint(), this);
    sFanLED.Init(FAN_LED);
    AppTask::GetAppTask().LinkAppLed(&sFanLED);

    chip::DeviceLayer::PlatformMgr().LockChipStack();
    Attributes::SpeedMax::Get(GetEndPoint(), &mSpeedMax);
    DataModel::Nullable<Percent> percentSettingNullable = GetPercentSetting();
    DataModel::Nullable<uint8_t> speedSettingNullable   = GetSpeedSetting();
    chip::DeviceLayer::PlatformMgr().UnlockChipStack();

    uint8_t percentSettingCB = percentSettingNullable.IsNull() ? 0 : percentSettingNullable.Value();
    PercentSettingWriteCallback(percentSettingCB);

    uint8_t speedSettingCB = speedSettingNullable.IsNull() ? 0 : speedSettingNullable.Value();
    SpeedSettingWriteCallback(speedSettingCB);

    return CHIP_NO_ERROR;
}

EndpointId FanControlManager::GetEndPoint()
{
    return mEndPoint;
}

Status FanControlManager::HandleStep(StepDirectionEnum aDirection, bool aWrap, bool aLowestOff)
{
    ChipLogProgress(NotSpecified, "FanControlManager::HandleStep aDirection %d, aWrap %d, aLowestOff %d", to_underlying(aDirection),
                    aWrap, aLowestOff);

    VerifyOrReturnError(aDirection != StepDirectionEnum::kUnknownEnumValue, Status::InvalidCommand);

    // if aLowestOff is true, Step command can reduce the fan speed to 0, else 1.
    uint8_t speedMin = aLowestOff ? kaLowestOffTrue : kaLowestOffFalse;

    DataModel::Nullable<uint8_t> speedSettingNullable = GetSpeedSetting();

    uint8_t curSpeedSetting = speedSettingNullable.IsNull() ? speedMin : speedSettingNullable.Value();

    // increase or decrease the fan speed by one step
    switch (aDirection)
    {
    case StepDirectionEnum::kIncrease: {
        if (curSpeedSetting >= mSpeedMax)
        {
            curSpeedSetting = aWrap ? speedMin : mSpeedMax;
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
            curSpeedSetting = aWrap ? mSpeedMax : speedMin;
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

    // Convert SpeedSetting to PercentSetting
    uint8_t curPercentSetting = SpeedToPercent(curSpeedSetting, mSpeedMax);

    AttributeUpdateInfo * data = chip::Platform::New<AttributeUpdateInfo>();
    data->percentSetting       = curPercentSetting;
    data->endPoint             = GetEndPoint();
    data->isPercentSetting     = true;

    if (chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "FanControlManager::HandleStep: Failed to update PercentSetting attribute");
        return Status::Failure;
    }

    return Status::Success;
}

void FanControlManager::UpdateClusterState(intptr_t arg)
{
    FanControlManager::AttributeUpdateInfo * data = reinterpret_cast<FanControlManager::AttributeUpdateInfo *>(arg);
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

void FanControlManager::HandleFanControlAttributeChange(AttributeId attributeId, uint8_t type, uint16_t size, uint8_t * value)
{
    switch (attributeId)
    {
    case Attributes::PercentSetting::Id: {
        PercentSettingWriteCallback(*value);
        break;
    }

    case Attributes::SpeedSetting::Id: {
        SpeedSettingWriteCallback(*value);
        break;
    }

    case Attributes::FanMode::Id: {
        mFanMode = *reinterpret_cast<FanModeEnum *>(value);
        FanModeWriteCallback(mFanMode);
        UpdateFanControlLED();
#if defined (DISPLAY_ENABLED) && DISPLAY_ENABLED
        UpdateFanControlLCD();
#endif
        break;
    }

    default: {
        break;
    }
    }
}

void FanControlManager::PercentSettingWriteCallback(uint8_t aNewPercentSetting)
{
    VerifyOrReturn(aNewPercentSetting != percentCurrent);
    VerifyOrReturn(mFanMode != FanModeEnum::kAuto);
    ChipLogDetail(NotSpecified, "FanControlManager::PercentSettingWriteCallback: %d", aNewPercentSetting);
    percentCurrent = aNewPercentSetting;

    AttributeUpdateInfo * data = chip::Platform::New<AttributeUpdateInfo>();
    data->endPoint             = GetEndPoint();
    data->percentCurrent       = percentCurrent;
    data->isPercentCurrent     = true;

    if (chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "FanControlManager::PercentSettingWriteCallback: failed to set PercentCurrent attribute");
    }
}

void FanControlManager::SpeedSettingWriteCallback(uint8_t aNewSpeedSetting)
{
    VerifyOrReturn(aNewSpeedSetting != speedCurrent);
    VerifyOrReturn(mFanMode != FanModeEnum::kAuto);
    ChipLogDetail(NotSpecified, "FanControlManager::SpeedSettingWriteCallback: %d", aNewSpeedSetting);
    speedCurrent = aNewSpeedSetting;

    AttributeUpdateInfo * data = chip::Platform::New<AttributeUpdateInfo>();
    data->endPoint             = GetEndPoint();
    data->speedCurrent         = speedCurrent;
    data->isSpeedCurrent       = true;

    if (chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "FanControlManager::SpeedSettingWriteCallback: failed to set SpeedCurrent attribute");
    }

    // Update the fan mode as per the current speed.
    if (speedCurrent == 0)
    {
        mFanMode = FanModeEnum::kOff;
    }
    else if (speedCurrent <= kFanModeLowUpperBound)
    {
        mFanMode = FanModeEnum::kLow;
    }
    else if (speedCurrent <= kFanModeMediumUpperBound)
    {
        mFanMode = FanModeEnum::kMedium;
    }
    else if (speedCurrent <= kFanModeHighUpperBound)
    {
        mFanMode = FanModeEnum::kHigh;
    }
    UpdateFanMode();
}

void FanControlManager::UpdateFanMode()
{
    AttributeUpdateInfo * data = chip::Platform::New<AttributeUpdateInfo>();
    data->endPoint             = GetEndPoint();
    data->fanMode              = mFanMode;
    data->isFanMode            = true;
    if (chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "FanControlManager::UpdateFanMode: failed to update FanMode attribute");
    }
}

void FanControlManager::FanModeWriteCallback(FanModeEnum aNewFanMode)
{
    ChipLogDetail(NotSpecified, "FanControlManager::FanModeWriteCallback: %d", (uint8_t) aNewFanMode);
    // If PercentSetting is null, use an out-of-bounds value to force an update.
    uint8_t percentSettingCurrent = GetPercentSetting().ValueOr(101);
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
        const uint8_t lowPercentMin = SpeedToPercent(static_cast<uint8_t>(kFanModeLowLowerBound), mSpeedMax);
        const uint8_t lowPercentMax = SpeedToPercent(static_cast<uint8_t>(kFanModeLowUpperBound), mSpeedMax);
        if (percentSettingCurrent < lowPercentMin || percentSettingCurrent > lowPercentMax)
        {
            SetPercentSetting(lowPercentMin);
        }
        break;
    }
    case FanModeEnum::kMedium: {
        const uint8_t mediumPercentMin = SpeedToPercent(static_cast<uint8_t>(kFanModeMediumLowerBound), mSpeedMax);
        const uint8_t mediumPercentMax = SpeedToPercent(static_cast<uint8_t>(kFanModeMediumUpperBound), mSpeedMax);
        if (percentSettingCurrent < mediumPercentMin || percentSettingCurrent > mediumPercentMax)
        {
            SetPercentSetting(mediumPercentMin);
        }
        break;
    }
    case FanModeEnum::kOn:
    case FanModeEnum::kHigh: {
        const uint8_t highPercentMin = SpeedToPercent(static_cast<uint8_t>(kFanModeHighLowerBound), mSpeedMax);
        const uint8_t highPercentMax = SpeedToPercent(static_cast<uint8_t>(kFanModeHighUpperBound), mSpeedMax);
        if (percentSettingCurrent < highPercentMin || percentSettingCurrent > highPercentMax)
        {
            SetPercentSetting(highPercentMin);
        }
        break;
    }
    case FanModeEnum::kSmart:
    case FanModeEnum::kAuto: {
        ChipLogProgress(NotSpecified, "FanControlManager::FanModeWriteCallback: Auto");
        break;
    }
    case FanModeEnum::kUnknownEnumValue: {
        ChipLogProgress(NotSpecified, "FanControlManager::FanModeWriteCallback: Unknown");
        break;
    }
    default:
        break;
    }
}

void FanControlManager::SetPercentSetting(Percent aNewPercentSetting)
{
    DataModel::Nullable<Percent> percentSettingNullable = GetPercentSetting();
    if (!percentSettingNullable.IsNull() && percentSettingNullable.Value() == aNewPercentSetting)
    {
        return;
    }

    AttributeUpdateInfo * data = chip::Platform::New<AttributeUpdateInfo>();
    data->percentSetting       = aNewPercentSetting;
    data->endPoint             = GetEndPoint();
    data->isPercentSetting     = true;
    if (chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, reinterpret_cast<intptr_t>(data)) != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "FanControlManager::SetPercentSetting: failed to update PercentSetting attribute");
    }
}

DataModel::Nullable<uint8_t> FanControlManager::GetSpeedSetting()
{
    DataModel::Nullable<uint8_t> speedSetting;

    Status status = Attributes::SpeedSetting::Get(GetEndPoint(), speedSetting);
    if (status != Status::Success)
    {
        ChipLogError(NotSpecified, "FanControlManager::GetSpeedSetting: failed to get SpeedSetting attribute: %d",
                     to_underlying(status));
    }

    return speedSetting;
}

DataModel::Nullable<Percent> FanControlManager::GetPercentSetting()
{
    DataModel::Nullable<Percent> percentSetting;

    Status status = Attributes::PercentSetting::Get(GetEndPoint(), percentSetting);
    if (status != Status::Success)
    {
        ChipLogError(NotSpecified, "FanControlManager::GetPercentSetting: failed to get PercentSetting attribute: %d",
                     to_underlying(status));
    }

    return percentSetting;
}

FanModeEnum FanControlManager::GetFanMode()
{
    return mFanMode;
}

void FanControlManager::UpdateFanControlLED()
{
    sFanLED.Set(false);
    FanModeEnum fanState = FanControlMgr().GetFanMode();
    if (fanState != FanModeEnum::kOff && fanState != FanModeEnum::kUnknownEnumValue)
    {
        sFanLED.Set(true);
    }
}

void FanControlManager::UpdateFanControlLCD()
{
    AppTask::GetAppTask().UpdateFanControlUI();
}
