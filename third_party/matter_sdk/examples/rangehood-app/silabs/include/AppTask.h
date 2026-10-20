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

    static AppTask & GetAppTask();

    static void AppTaskMain(void * pvParameter);

    CHIP_ERROR StartAppTask();

    /** @brief Platform button callback; posts fan-control or base application events. */
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction);

    /** @brief Applies range-hood actions (light/fan) to LED and display after attribute changes. */
    static void ActionTriggerHandler(AppEvent * aEvent);

    static void FanControlButtonHandler(AppEvent * aEvent);

    /**
     * @brief Matter stack callback after a server attribute change, forwards @c FanControl and @c OnOff
     *        updates to endpoint handlers to refresh range-hood UI and LEDs.
     *
     * @param attributePath Endpoint, cluster, and attribute that changed
     * @param type          TLV encoding type of @p value
     * @param size          Size in bytes of @p value
     * @param value         Pointer to the new attribute value
     */
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value);

    static ExtractorHoodEndpoint & GetExtractorHoodEndpoint();
    static LightEndpoint & GetLightEndpoint();

protected:
    CHIP_ERROR AppInit() override;

    /**
     * @brief Initializes extractor-hood/light endpoints and syncs the light LED to the OnOff cluster state.
     *
     * @return CHIP_NO_ERROR on success, or CHIP_ERROR_INTERNAL if ExtractorHoodEndpoint init fails.
     */
    CHIP_ERROR InitRangeHood();
};
