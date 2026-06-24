/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
 *    Copyright (c) 2025 Google LLC.
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

#pragma once

#include "AppEvent.h"
#include "BaseApplication.h"
#include "ExtractorHoodEndpoint.h"
#include "LightEndpoint.h"

#include <app/ConcreteAttributePath.h>
#include <lib/core/CHIPError.h>

class AppTask : public BaseApplication
{
public:
    enum Action_t : uint8_t
    {
        LIGHT_ON_ACTION = 0,
        LIGHT_OFF_ACTION,
        FAN_PERCENT_CHANGE_ACTION,
        FAN_MODE_CHANGE_ACTION,

        INVALID_ACTION
    };

    AppTask() = default;

    /** @brief Returns the active app instance */
    static AppTask & GetAppTask();

    /**
     * @brief AppTask task main loop function
     *
     * @param pvParameter FreeRTOS task parameter
     */
    static void AppTaskMain(void * pvParameter);

    /** @brief Creates and starts the AppTask thread */
    CHIP_ERROR StartAppTask();

    /** @brief Platform button callback; posts fan-control or base application events. */
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction);

    /** @brief Applies range-hood actions (light/fan) to LED and display after attribute changes. */
    static void ActionTriggerHandler(AppEvent * aEvent);

    /** @brief Action-button handler; toggles extractor-hood fan mode. */
    static void FanControlButtonHandler(AppEvent * aEvent);

    /** @brief Data-model attribute-change hook; forwards FanControl and OnOff updates. */
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value);

    /** @brief Returns the extractor-hood endpoint (EP1) helper. */
    static ExtractorHoodEndpoint & GetExtractorHoodEndpoint();
    /** @brief Returns the light endpoint (EP2) helper. */
    static LightEndpoint & GetLightEndpoint();

protected:
    /** @brief Override of `BaseApplication::AppInit()` */
    CHIP_ERROR AppInit() override;

    /** @brief Rangehood specific initialization */
    CHIP_ERROR InitRangeHood();
};
