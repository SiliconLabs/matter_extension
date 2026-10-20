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

#pragma once

#include "BaseApplication.h"
#include <app/ConcreteAttributePath.h>
#include <cstdint>

#include <ble/Ble.h>
#include <cmsis_os2.h>
#include <lib/core/CHIPError.h>

struct AppEvent;

class AppTask : public BaseApplication
{

public:
    AppTask() = default;

    static AppTask & GetAppTask();

    /**
     * @brief AppTask task main loop function
     *
     * @param pvParameter FreeRTOS task parameter
     */
    static void AppTaskMain(void * pvParameter);

    CHIP_ERROR StartAppTask();

    /**
     * @brief Event handler when a button is pressed.
     *
     * @param button    APP_ONOFF_BUTTON or APP_FUNCTION_BUTTON
     * @param btnAction SL_SIMPLE_BUTTON_PRESSED, SL_SIMPLE_BUTTON_RELEASED or SL_SIMPLE_BUTTON_DISABLED
     */
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction);

    /**
     * @brief Matter stack callback after a server attribute change, syncs plug LED and LCD demo UI
     *        when @c OnOff::OnOff changes.
     *
     * @param attributePath Endpoint, cluster, and attribute that changed
     * @param type          TLV encoding type of @p value
     * @param size          Size in bytes of @p value
     * @param value         Pointer to the new attribute value
     */
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value);

    /**
     * @brief Toggles plug on/off, updates LED/display, and schedules cluster sync on the Matter thread.
     *
     * @param aEvent Button AppEvent posted from @c ButtonEventHandler
     */
    static void OnOffActionEventHandler(AppEvent * aEvent);

protected:
    CHIP_ERROR AppInit() override;

    CHIP_ERROR InitPlug();

    /**
     * @brief Handler scheduled on the Matter thread to push the OnOff cluster state via @c OnOffServer::setOnOffValue.
     *
     * @param context On/off state encoded as @c intptr_t (0 = off, non-zero = on)
     */
    static void UpdateOnOffClusterState(intptr_t context);
};
