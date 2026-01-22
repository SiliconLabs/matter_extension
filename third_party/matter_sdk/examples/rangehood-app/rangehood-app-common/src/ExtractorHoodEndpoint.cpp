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

#include "ExtractorHoodEndpoint.h"

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app/clusters/fan-control-server/fan-control-server.h>
#include <lib/core/CHIPError.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/CHIPDeviceLayer.h>

#include <algorithm>

using namespace chip;
using namespace chip::app;
using namespace chip::DeviceLayer;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::FanControl;
using Status = chip::Protocols::InteractionModel::Status;

CHIP_ERROR ExtractorHoodEndpoint::Init()
{
    // Initialize percent current from percent setting
    // This ensures the fan speed reflects the current setting on startup
    DeviceLayer::PlatformMgr().LockChipStack();
    DataModel::Nullable<chip::Percent> percentSettingNullable = GetPercentSetting();
    Percent initialPercentSetting = percentSettingNullable.IsNull() ? 0 : percentSettingNullable.Value();
    CHIP_ERROR err                = HandlePercentSettingChange(initialPercentSetting);
    DeviceLayer::PlatformMgr().UnlockChipStack();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(NotSpecified, "ExtractorHoodEndpoint::Init: Failed to initialize PercentCurrent");
        return err;
    }

    return CHIP_NO_ERROR;
}

/**
 * @brief Get the PercentSetting attribute.
 * The caller MUST hold the CHIP stack lock before calling this function,
 * unless calling from a CHIP task context where the lock is already held.
 */
DataModel::Nullable<Percent> ExtractorHoodEndpoint::GetPercentSetting() const
{
    DataModel::Nullable<Percent> percentSetting;
    Status Status = Clusters::FanControl::Attributes::PercentSetting::Get(mEndpointId, percentSetting);
    VerifyOrReturnValue(Status == chip::Protocols::InteractionModel::Status::Success, DataModel::Nullable<Percent>(),
                        ChipLogError(NotSpecified,
                                     "ExtractorHoodEndpoint::GetPercentSetting: failed to get PercentSetting attribute: %d",
                                     to_underlying(Status)));
    return percentSetting;
}

/* The caller MUST hold the CHIP stack lock before calling this function,
 * unless calling from a CHIP task context where the lock is already held.
 */

CHIP_ERROR ExtractorHoodEndpoint::GetFanMode(FanControl::FanModeEnum & fanMode) const
{
    Status status = FanControl::Attributes::FanMode::Get(mEndpointId, &fanMode);
    VerifyOrReturnError(status == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(NotSpecified, "ExtractorHoodEndpoint::GetFanMode: failed to get FanMode attribute: %d",
                                     to_underlying(status)));
    return CHIP_NO_ERROR;
}

/**
 * The caller MUST hold the CHIP stack lock before calling this function,
 * unless calling from a CHIP task context where the lock is already held.
 */

CHIP_ERROR ExtractorHoodEndpoint::SetPercentCurrent(Percent newPercentSetting)
{
    Percent currentPercentCurrent = 0;
    Status getStatus              = FanControl::Attributes::PercentCurrent::Get(mEndpointId, &currentPercentCurrent);
    VerifyOrReturnError(getStatus == chip::Protocols::InteractionModel::Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(NotSpecified,
                                     "ExtractorHoodEndpoint::SetPercentCurrent: failed to get currentPercentCurrent: %d",
                                     to_underlying(getStatus)));
    // No update needed if value is unchanged
    VerifyOrReturnError(newPercentSetting != currentPercentCurrent, CHIP_NO_ERROR);
    Status setStatus = FanControl::Attributes::PercentCurrent::Set(mEndpointId, newPercentSetting);
    VerifyOrReturnError(setStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(NotSpecified,
                                     "ExtractorHoodEndpoint::SetPercentCurrent: failed to update PercentCurrent attribute: %d",
                                     to_underlying(setStatus)));
    return CHIP_NO_ERROR;
}

/**
 * @brief Handle a change to the PercentSetting attribute, updating PercentCurrent as needed.
 * The caller MUST hold the CHIP stack lock before calling this function,
 * unless calling from a CHIP task context where the lock is already held.
 */

CHIP_ERROR ExtractorHoodEndpoint::HandlePercentSettingChange(Percent newPercentSetting)
{
    ChipLogDetail(NotSpecified, "ExtractorHoodEndpoint::HandlePercentSettingChange: %d", newPercentSetting);
    Percent currentPercentCurrent = 0;
    Status getStatus              = FanControl::Attributes::PercentCurrent::Get(mEndpointId, &currentPercentCurrent);
    VerifyOrReturnError(getStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(NotSpecified,
                                     "ExtractorHoodEndpoint::HandlePercentSettingChange: failed to get PercentCurrent: %d",
                                     to_underlying(getStatus)));
    VerifyOrReturnError(newPercentSetting != currentPercentCurrent, CHIP_NO_ERROR);
    FanControl::FanModeEnum currentFanMode;
    Status fanModeStatus = FanControl::Attributes::FanMode::Get(mEndpointId, &currentFanMode);
    VerifyOrReturnError(fanModeStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(NotSpecified, "ExtractorHoodEndpoint::HandlePercentSettingChange: failed to get FanMode: %d",
                                     to_underlying(fanModeStatus)));
    // Update PercentCurrent only fanmode other than auto or smart
    VerifyOrReturnError(currentFanMode != FanControl::FanModeEnum::kAuto && currentFanMode != FanControl::FanModeEnum::kSmart,
                        CHIP_NO_ERROR);
    Status setStatus = FanControl::Attributes::PercentCurrent::Set(mEndpointId, newPercentSetting);
    VerifyOrReturnError(
        setStatus == Status::Success, CHIP_ERROR_INTERNAL,
        ChipLogError(NotSpecified,
                     "ExtractorHoodEndpoint::HandlePercentSettingChange: failed to update PercentCurrent attribute: %d",
                     to_underlying(setStatus)));
    return CHIP_NO_ERROR;
}

CHIP_ERROR ExtractorHoodEndpoint::HandleFanModeChange(chip::app::Clusters::FanControl::FanModeEnum newFanMode)
{
    ChipLogDetail(NotSpecified, "ExtractorHoodEndpoint::HandleFanModeChange: %d", (uint8_t) newFanMode);
    switch (newFanMode)
    {
    case FanControl::FanModeEnum::kOff:
        return SetPercentCurrent(mFanModeOffPercent);
    case FanControl::FanModeEnum::kLow:
        return SetPercentCurrent(mFanModeLowPercent);
    case FanControl::FanModeEnum::kMedium:
        return SetPercentCurrent(mFanModeMediumPercent);
    case FanControl::FanModeEnum::kOn:
    case FanControl::FanModeEnum::kHigh:
        return SetPercentCurrent(mFanModeHighPercent);
    case FanControl::FanModeEnum::kSmart:
    case FanControl::FanModeEnum::kAuto:
        ChipLogProgress(NotSpecified, "ExtractorHoodEndpoint::HandleFanModeChange: Auto");
        return CHIP_NO_ERROR;
    case FanControl::FanModeEnum::kUnknownEnumValue:
        ChipLogProgress(NotSpecified, "ExtractorHoodEndpoint::HandleFanModeChange: Unknown");
        return CHIP_NO_ERROR; // Don't treat unknown as error
    default:
        return CHIP_NO_ERROR;
    }
}

/**
 * @brief Update the FanMode attribute.
 * The caller MUST hold the CHIP stack lock before calling this function,
 * unless calling from a CHIP task context where the lock is already held.
 */

CHIP_ERROR ExtractorHoodEndpoint::UpdateFanModeAttribute(FanControl::FanModeEnum newFanMode)
{
    Status setStatus = FanControl::Attributes::FanMode::Set(mEndpointId, newFanMode);
    VerifyOrReturnError(setStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(NotSpecified,
                                     "ExtractorHoodEndpoint::UpdateFanModeAttribute: failed to update FanMode attribute: %d",
                                     to_underlying(setStatus)));
    return CHIP_NO_ERROR;
}

/**
 * @brief Toggle fan mode between Off and High.
 * This is used for button press toggles.
 */

CHIP_ERROR ExtractorHoodEndpoint::ToggleFanMode()
{
    FanControl::FanModeEnum currentFanMode = FanControl::FanModeEnum::kUnknownEnumValue;
    CHIP_ERROR err                         = GetFanMode(currentFanMode);
    if (err != CHIP_NO_ERROR || currentFanMode == FanControl::FanModeEnum::kUnknownEnumValue)
    {
        ChipLogError(NotSpecified, "ExtractorHoodEndpoint::ToggleFanMode: failed to get current fan mode");
        return CHIP_ERROR_INTERNAL;
    }
    FanControl::FanModeEnum target =
        (currentFanMode == FanControl::FanModeEnum::kOff) ? FanControl::FanModeEnum::kHigh : FanControl::FanModeEnum::kOff;
    CHIP_ERROR Err = UpdateFanModeAttribute(target);
    VerifyOrReturnError(Err == CHIP_NO_ERROR, Err);
    // Ensure PercentCurrent is updated to match the new mode
    return HandleFanModeChange(target);
}
