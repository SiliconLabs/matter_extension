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

#include "OvenManager.h"
#include "CookEndpoints.h"
#include "OvenBindingHandler.h"
#include "OvenEndpoint.h"

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/cluster-objects.h>
#include <app/clusters/mode-base-server/mode-base-cluster-objects.h>
#include <platform/CHIPDeviceLayer.h>

#include "AppConfig.h"
#include "AppTask.h"
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#define MAX_TEMPERATURE 30000
#define MIN_TEMPERATURE 0
#define TEMPERATURE_STEP 500

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using chip::Protocols::InteractionModel::Status;

OvenManager OvenManager::sOvenMgr;

void OvenManager::Init()
{
    // Endpoint initializations

    CHIP_ERROR initErr = mTemperatureControlledCabinetEndpoint.Init();
    if (initErr != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "TemperatureControlledCabinetEndpoint initialization failed");
        chipDie();
    }

    // Set initial state for TemperatureControlledCabinetEndpoint
    VerifyOrReturn(SetTemperatureControlledCabinetInitialState(kTemperatureControlledCabinetEndpoint) == CHIP_NO_ERROR,
                   ChipLogError(AppServer, "Setting TemperatureControlledCabinet initial state failed"));
    // Register the shared TemperatureLevelsDelegate for all the cooksurface endpoints
    TemperatureControl::SetInstance(&mTemperatureControlDelegate);

    // Set initial state for CookSurface endpoints
    VerifyOrReturn(SetCookSurfaceInitialState(mCookSurfaceEndpoint1.GetEndpointId()) == CHIP_NO_ERROR,
                   ChipLogError(AppServer, "Setting CookSurfaceEndpoint1 initial state failed"));
    VerifyOrReturn(SetCookSurfaceInitialState(mCookSurfaceEndpoint2.GetEndpointId()) == CHIP_NO_ERROR,
                   ChipLogError(AppServer, "Setting CookSurfaceEndpoint2 initial state failed"));

    // Initialize binding manager
    VerifyOrReturn(InitOvenBindingHandler() == CHIP_NO_ERROR, ChipLogError(AppServer, "Initializing OvenBindingHandler failed"));

    // Register supported temperature levels (Low, Medium, High) for CookSurface endpoints 1 and 2
    static const CharSpan kCookSurfaceLevels[] = { CharSpan::fromCharString("Low"), CharSpan::fromCharString("Medium"),
                                                   CharSpan::fromCharString("High") };
    VerifyOrReturn(mTemperatureControlDelegate.RegisterSupportedLevels(
                       kCookSurfaceEndpoint1, kCookSurfaceLevels,
                       static_cast<uint8_t>(AppSupportedTemperatureLevelsDelegate::kNumTemperatureLevels)) == CHIP_NO_ERROR,
                   ChipLogError(AppServer, "Registering supported levels for CookSurfaceEndpoint1 failed"));

    VerifyOrReturn(mTemperatureControlDelegate.RegisterSupportedLevels(
                       kCookSurfaceEndpoint2, kCookSurfaceLevels,
                       static_cast<uint8_t>(AppSupportedTemperatureLevelsDelegate::kNumTemperatureLevels)) == CHIP_NO_ERROR,
                   ChipLogError(AppServer, "Registering supported levels for CookSurfaceEndpoint2 failed"));

    VerifyOrReturn(OnOffServer::Instance().getOnOffValue(kCookTopEndpoint, &mIsCookTopOn) == Status::Success,
                   ChipLogError(AppServer, "Getting CookTop OnOff state failed"));

    VerifyOrReturn(OnOffServer::Instance().getOnOffValue(kCookSurfaceEndpoint1, &mIsCookSurface1On) == Status::Success,
                   ChipLogError(AppServer, "Getting CookSurfaceEndpoint1 OnOff state failed"));

    VerifyOrReturn(OnOffServer::Instance().getOnOffValue(kCookSurfaceEndpoint2, &mIsCookSurface2On) == Status::Success,
                   ChipLogError(AppServer, "Getting CookSurfaceEndpoint2 OnOff state failed"));

    // Get current oven mode
    VerifyOrReturn(OvenMode::Attributes::CurrentMode::Get(kTemperatureControlledCabinetEndpoint, &mCurrentOvenMode) ==
                       Status::Success,
                   ChipLogError(AppServer, "Getting CurrentOvenMode failed"));
}

CHIP_ERROR OvenManager::SetCookSurfaceInitialState(EndpointId cookSurfaceEndpoint)
{
    // Set the initial temperature-measurement values for CookSurfaceEndpoint
    Status status = TemperatureMeasurement::Attributes::MeasuredValue::Set(cookSurfaceEndpoint, MIN_TEMPERATURE);
    VerifyOrReturnError(status == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "Setting MeasuredValue failed : %u", to_underlying(status)));

    // Initialize min/max measured values (range: 0 to 30000 -> 0.00C to 300.00C if unit is 0.01C) for cook surface endpoint
    status = TemperatureMeasurement::Attributes::MinMeasuredValue::Set(cookSurfaceEndpoint, MIN_TEMPERATURE);
    VerifyOrReturnError(status == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "Setting MinMeasuredValue failed : %u", to_underlying(status)));
    status = TemperatureMeasurement::Attributes::MaxMeasuredValue::Set(cookSurfaceEndpoint, MAX_TEMPERATURE);
    VerifyOrReturnError(status == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "Setting MaxMeasuredValue failed : %u", to_underlying(status)));
    return CHIP_NO_ERROR;
}

CHIP_ERROR OvenManager::SetTemperatureControlledCabinetInitialState(EndpointId temperatureControlledCabinetEndpoint)
{
    Status tcStatus =
        TemperatureControl::Attributes::TemperatureSetpoint::Set(temperatureControlledCabinetEndpoint, MIN_TEMPERATURE);
    VerifyOrReturnError(tcStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "Setting TemperatureSetpoint failed : %u", to_underlying(tcStatus)));

    tcStatus = TemperatureControl::Attributes::MinTemperature::Set(temperatureControlledCabinetEndpoint, MIN_TEMPERATURE);
    VerifyOrReturnError(tcStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "Setting MinTemperature failed : %u", to_underlying(tcStatus)));

    tcStatus = TemperatureControl::Attributes::MaxTemperature::Set(temperatureControlledCabinetEndpoint, MAX_TEMPERATURE);
    VerifyOrReturnError(tcStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "Setting MaxTemperature failed : %u", to_underlying(tcStatus)));

    tcStatus = TemperatureControl::Attributes::Step::Set(temperatureControlledCabinetEndpoint, TEMPERATURE_STEP);
    VerifyOrReturnError(tcStatus == Status::Success, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "Setting Step failed : %u", to_underlying(tcStatus)));

    return CHIP_NO_ERROR;
}

void OvenManager::OnOffAttributeChangeHandler(EndpointId endpointId, AttributeId attributeId, uint8_t * value, uint16_t size)
{
    VerifyOrReturn(value != nullptr, ChipLogError(AppServer, "OnOffAttributeChangeHandler: value pointer is null"));

    Action_t action = INVALID_ACTION;
    switch (endpointId)
    {
    case kCookTopEndpoint: {
        mIsCookTopOn = (*value != 0);
        // Turn on/off the associated cook surfaces.
        VerifyOrReturn(mCookSurfaceEndpoint1.SetOnOffState(*value) == Status::Success,
                       ChipLogError(AppServer, "Failed to set CookSurfaceEndpoint1 state"));
        VerifyOrReturn(mCookSurfaceEndpoint2.SetOnOffState(*value) == Status::Success,
                       ChipLogError(AppServer, "Failed to set CookSurfaceEndpoint2 state"));

        action = (*value != 0) ? COOK_TOP_ON_ACTION : COOK_TOP_OFF_ACTION;
        // Trigger binding for CookTop OnOff changes
        OnOffBindingContext * context = Platform::New<OnOffBindingContext>();
        if (context != nullptr)
        {
            context->localEndpointId = kCookTopEndpoint;
            context->commandId       = *value ? Clusters::OnOff::Commands::On::Id : Clusters::OnOff::Commands::Off::Id;

            if (CookTopOnOffBindingTrigger(context) != CHIP_NO_ERROR)
            {
                Platform::Delete(context);
                ChipLogError(AppServer, "Failed to schedule CookTopOnOffBindingTrigger, context freed");
            }
        }
        break;
    }
    case kCookSurfaceEndpoint1:
    case kCookSurfaceEndpoint2:
        if (endpointId == kCookSurfaceEndpoint1)
            mIsCookSurface1On = (*value != 0);
        else
            mIsCookSurface2On = (*value != 0);

        // Turn off CookTop if both the CookSurfaces are off.
        if (!mIsCookSurface1On && !mIsCookSurface2On)
        {
            VerifyOrReturn(mCookTopEndpoint.SetOnOffState(false) == Status::Success,
                           ChipLogError(AppServer, "Failed to set CookTopEndpoint state"));

            mIsCookTopOn = false;
        }
        break;
    default:
        break;
    }

    // Only post event if action is valid
    if (action != INVALID_ACTION)
    {
        AppEvent event         = {};
        event.Type             = AppEvent::kEventType_Oven;
        event.OvenEvent.Action = action;
        event.Handler          = AppTask::OvenActionHandler;
        AppTask::GetAppTask().PostEvent(&event);
    }
}

void OvenManager::OvenModeAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value,
                                                 uint16_t size)
{
    VerifyOrReturn(value != nullptr, ChipLogError(AppServer, "OvenModeAttributeChangeHandler: value pointer is null"));

    mCurrentOvenMode       = *value;
    AppEvent event         = {};
    event.Type             = AppEvent::kEventType_Oven;
    event.OvenEvent.Action = OVEN_MODE_UPDATE_ACTION;
    event.Handler          = AppTask::OvenActionHandler;
    AppTask::GetAppTask().PostEvent(&event);
}

bool OvenManager::IsTransitionBlocked(uint8_t fromMode, uint8_t toMode)
{
    for (auto const & bt : kBlockedTransitions)
    {
        if (bt.fromMode == fromMode && bt.toMode == toMode)
        {
            return true;
        }
    }
    return false;
}
