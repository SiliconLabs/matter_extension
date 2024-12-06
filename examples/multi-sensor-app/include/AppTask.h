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

/**********************************************************
 * Includes
 *********************************************************/

#include "AppEvent.h"
#include "BaseApplication.h"
#include "FreeRTOS.h"
#include "timers.h"
#include <app/clusters/occupancy-sensor-server/occupancy-sensor-server.h>
#include <ble/BLEEndPoint.h>
#include <lib/core/CHIPError.h>
#include <memory>
#include <platform/CHIPDeviceLayer.h>
#include <stdbool.h>
#include <stdint.h>

/**********************************************************
 * Defines
 *********************************************************/

// Application-defined error codes in the CHIP_ERROR space.
#define APP_ERROR_EVENT_QUEUE_FAILED CHIP_APPLICATION_ERROR(0x01)
#define APP_ERROR_CREATE_TASK_FAILED CHIP_APPLICATION_ERROR(0x02)
#define APP_ERROR_UNHANDLED_EVENT CHIP_APPLICATION_ERROR(0x03)
#define APP_ERROR_CREATE_TIMER_FAILED CHIP_APPLICATION_ERROR(0x04)
#define APP_ERROR_START_TIMER_FAILED CHIP_APPLICATION_ERROR(0x05)
#define APP_ERROR_STOP_TIMER_FAILED CHIP_APPLICATION_ERROR(0x06)

/**********************************************************
 * AppTask Declaration
 *********************************************************/

class AppTask : public BaseApplication
{

public:
    AppTask() = default;

    static AppTask & GetAppTask() { return sAppTask; }

    /**
     * @brief AppTask task main loop function
     *
     * @param pvParameter FreeRTOS task parameter
     */
    static void AppTaskMain(void * pvParameter);

    CHIP_ERROR StartAppTask();

    /**
     * @brief Event handler when a button is pressed
     * Function posts an event for button processing
     *
     * @param buttonHandle APP_LIGHT_SWITCH or APP_FUNCTION_BUTTON
     * @param btnAction button action - SL_SIMPLE_BUTTON_PRESSED,
     *                  SL_SIMPLE_BUTTON_RELEASED or SL_SIMPLE_BUTTON_DISABLED
     */
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction);

    /**
     * @brief Triggers button event processing for the application button.
     *        Use the EventHandler structure to be used as a callback the Application events.
     *
     */
    static void ProccessButtonEvent(AppEvent * event);

    /**
     * @brief Triggers necessary updates when the Sensor values have been changed.
     *        Use the EventHandler structure to be used as a callback the Application events.
     */
    static void SensorAttributeUpdateEvent(AppEvent * event);

    /**
     * @brief Triggers necessary updates when the Occupancy values have been changed.
     *        Use the EventHandler structure to be used as a callback the Application events.
     */
    static void OccupancyAttributeUpdateEvent(AppEvent * event);

#ifdef DISPLAY_ENABLED
    /**
     * @brief LCD callback function to cycle LCD display.
     *        Function switch to the next LCD UI and update the show values.
     */
    void UpdateDisplay() override;
#endif // DISPLAY_ENABLED

private:
    static AppTask sAppTask;

    enum class kSensorUIEnum : uint8_t
    {
        kOccupancySensor = 0,
        kSensor          = 1,
        kStatusScreen    = 2,
#ifdef QR_CODE_ENABLED
        kQrCode = 3,
        kCount  = 4,
#else
        kCount = 3,
#endif
    };

    /**
     * @brief AppTask initialisation function
     *
     * @return CHIP_ERROR
     */
    CHIP_ERROR Init();

#ifdef DISPLAY_ENABLED
    /**
     * @brief Function cycle between the different LCD UIs.
     *        The LCD order is : Occupancy -> Temp/Hum values -> Status Screen -> QR code (if enabled) -> Occupancy.
     */
    void CycleSensorUI();

    /**
     * @brief Trigger an LCD update to get the latest attribute values
     *        Only the currently shown LCD image is updated.
     */
    void UpdateSensorDisplay(void);
#endif // DISPLAY_ENABLED

    /**
     * @brief PB0 Button event processing function
     *        Press and hold will trigger a factory reset timer start
     *        Press and release will restart BLEAdvertising if not commisionned
     *
     * @param aEvent button event being processed
     */
    static void ButtonHandler(AppEvent * aEvent);

    kSensorUIEnum mCurrentSensorUI;
    std::unique_ptr<chip::app::Clusters::OccupancySensing::Instance> mOccupancyInstance;
};
