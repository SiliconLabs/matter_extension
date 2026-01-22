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

#include "RangeHoodManager.h"

#include "ExtractorHoodEndpoint.h"
#include "LightEndpoint.h"

#include "AppConfig.h"
#include "AppTask.h"

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app/clusters/fan-control-server/fan-control-server.h>
#include <platform/CHIPDeviceLayer.h>

#if DISPLAY_ENABLED
#include "RangeHoodUI.h"
#endif

using namespace chip;
using namespace chip::app;
using namespace ::chip::app::Clusters;
using namespace ::chip::app::Clusters::FanControl;
using namespace chip::Protocols::InteractionModel;
using namespace ::chip::DeviceLayer;

RangeHoodManager RangeHoodManager::sRangeHoodMgr;

CHIP_ERROR RangeHoodManager::Init()
{
    // Endpoint initializations with fan mode percent mappings
    VerifyOrReturnError(mExtractorHoodEndpoint.Init() == CHIP_NO_ERROR, CHIP_ERROR_INTERNAL);

    return CHIP_NO_ERROR;
}

void RangeHoodManager::FanControlAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value,
                                                        uint16_t size)
{
    VerifyOrReturn(endpointId == kExtractorHoodEndpoint,
                   ChipLogError(NotSpecified, "FanControlAttributeChangeHandler: Invalid endpoint %u, expected %u", endpointId,
                                kExtractorHoodEndpoint));

    Action_t action = INVALID_ACTION;

    switch (attributeId)
    {
    case chip::app::Clusters::FanControl::Attributes::PercentSetting::Id: {
        CHIP_ERROR err = mExtractorHoodEndpoint.HandlePercentSettingChange(*value);
        if (err != CHIP_NO_ERROR)
        {
            ChipLogError(NotSpecified, "FanControlAttributeChangeHandler: HandlePercentSettingChange failed: %ld", err.Format());
            return;
        }
        action = FAN_PERCENT_CHANGE_ACTION;
        break;
    }

    case chip::app::Clusters::FanControl::Attributes::FanMode::Id: {
        CHIP_ERROR err = mExtractorHoodEndpoint.HandleFanModeChange(*reinterpret_cast<FanModeEnum *>(value));
        if (err != CHIP_NO_ERROR)
        {
            ChipLogError(NotSpecified, "FanControlAttributeChangeHandler: HandleFanModeChange failed: %ld", err.Format());
            return;
        }
        action = FAN_MODE_CHANGE_ACTION;
        break;
    }

    default: {
        return;
    }
    }

    // Only post event if the operation succeeded
    if (action != INVALID_ACTION)
    {
        AppEvent event;
        event.Type                  = AppEvent::kEventType_RangeHood;
        event.RangeHoodEvent.Action = action;
        event.Handler               = AppTask::ActionTriggerHandler;
        AppTask::GetAppTask().PostEvent(&event);
    }
}

void RangeHoodManager::OnOffAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value,
                                                   uint16_t size)
{
    VerifyOrReturn(
        endpointId == kLightEndpoint,
        ChipLogError(NotSpecified, "OnOffAttributeChangeHandler: Invalid endpoint %u, expected %u", endpointId, kLightEndpoint));

    if (value == nullptr || size < sizeof(uint8_t))
    {
        ChipLogError(NotSpecified, "OnOffAttributeChangeHandler: Invalid value or size");
        return;
    }

    Action_t action = *value ? LIGHT_ON_ACTION : LIGHT_OFF_ACTION;

    AppEvent event;
    event.Type                  = AppEvent::kEventType_RangeHood;
    event.RangeHoodEvent.Action = action;
    event.Handler               = AppTask::ActionTriggerHandler;
    AppTask::GetAppTask().PostEvent(&event);
}
