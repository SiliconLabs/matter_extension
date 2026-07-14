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
#include <app/data-model-provider/AttributeChangeListener.h>
#include <app/data-model/Nullable.h>
#include <lib/core/CHIPError.h>
#include <lib/core/DataModelTypes.h>
#include <platform/CHIPDeviceLayer.h>
#include <protocols/interaction_model/StatusCode.h>

struct AppEvent;

// Application-defined error codes in the CHIP_ERROR space.
#define APP_ERROR_EVENT_QUEUE_FAILED CHIP_APPLICATION_ERROR(0x01)
#define APP_ERROR_CREATE_TASK_FAILED CHIP_APPLICATION_ERROR(0x02)
#define APP_ERROR_UNHANDLED_EVENT CHIP_APPLICATION_ERROR(0x03)
#define APP_ERROR_CREATE_TIMER_FAILED CHIP_APPLICATION_ERROR(0x04)
#define APP_ERROR_START_TIMER_FAILED CHIP_APPLICATION_ERROR(0x05)
#define APP_ERROR_STOP_TIMER_FAILED CHIP_APPLICATION_ERROR(0x06)

class AppTask : public BaseApplication, public chip::app::DataModel::AttributeChangeListener
{

public:
    AppTask() = default;

    /** @brief Returns the active app instance (defined in CustomerAppTask.cpp). */
    static AppTask & GetAppTask();

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
    static void ProcessButtonEvent(AppEvent * aEvent);

    /**
     * @brief AttributeChangeListener hook invoked after a cluster attribute changes.
     *        Posts application events for occupancy and sensor measurement updates.
     */
    void OnAttributeChanged(const chip::app::ConcreteAttributePath & path,
                            chip::app::DataModel::AttributeChangeType type) override;

    /**
     * @brief Triggers necessary updates when the Sensor values have been changed.
     *        Use the EventHandler structure to be used as a callback the Application events.
     */
    static void SensorAttributeUpdateEvent(AppEvent * aEvent);

    /**
     * @brief Triggers necessary updates when the Occupancy values have been changed.
     *        Use the EventHandler structure to be used as a callback the Application events.
     */
    static void OccupancyAttributeUpdateEvent(AppEvent * aEvent);

    /**
     * @brief Reads the current temperature and humidity from the sensor (Si70xx) or,
     *        when the sensor is not present returns simulated values.
     */
    CHIP_ERROR GetTemperatureAndHumidity(int16_t & temperature, uint16_t & humidity);

    /** @brief Data model hook invoked when a cluster attribute changes */
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value);

    /**
     * @brief Returns the DataModel TemperatureMeasurement::MeasuredValue attribute.
     *        The caller MUST hold the lock on the Matter task.
     */
    chip::Protocols::InteractionModel::Status GetMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value);

    /**
     * @brief Returns the DataModel TemperatureMeasurement::MaxMeasuredValue attribute.
     *        The caller MUST hold the lock on the Matter task.
     */
    chip::Protocols::InteractionModel::Status GetMaxMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value);

    /**
     * @brief Returns the DataModel TemperatureMeasurement::MinMeasuredValue attribute.
     *        The caller MUST hold the lock on the Matter task.
     */
    chip::Protocols::InteractionModel::Status GetMinMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value);

    /**
     * @brief Returns the DataModel RelativeHumidityMeasurement::MeasuredValue attribute.
     *        The caller MUST hold the lock on the Matter task.
     */
    chip::Protocols::InteractionModel::Status GetMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value);

    /**
     * @brief Returns the DataModel RelativeHumidityMeasurement::MaxMeasuredValue attribute.
     *        The caller MUST hold the lock on the Matter task.
     */
    chip::Protocols::InteractionModel::Status GetMaxMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value);

    /**
     * @brief Returns the DataModel RelativeHumidityMeasurement::MinMeasuredValue attribute.
     *        The caller MUST hold the lock on the Matter task.
     */
    chip::Protocols::InteractionModel::Status GetMinMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value);

    /**
     * @brief Reads the Occupancy attribute and returns whether occupancy is currently detected.
     */
    bool IsOccupancyDetected();

#ifdef DISPLAY_ENABLED
    /**
     * @brief LCD callback function to cycle LCD display.
     *        Function switch to the next LCD UI and update the show values.
     */
    void UpdateDisplay() override;

    /**
     * @brief Trigger an LCD update to get the latest attribute values
     *        Only the currently shown LCD image is updated.
     */
    void UpdateSensorDisplay();
#endif // DISPLAY_ENABLED

protected:
    /**
     * @brief Override of BaseApplication::AppInit(), called by BaseApplication::Init().
     */
    CHIP_ERROR AppInit() override;

    /**
     * @brief Initializes the sensor subsystem: registers the attribute change listener,
     *        initializes the hardware sensor driver (if enabled), and schedules the
     *        first sensor reading.
     */
    CHIP_ERROR InitSensorManager();

    /**
     * @brief chip::System::Layer timer callback that reads sensor values and updates
     *        the TemperatureMeasurement / RelativeHumidityMeasurement clusters.
     *        Must be called from the Matter task context.
     */
    static void TriggerSensorAction(chip::System::Layer * aLayer, void * aAppState);

private:
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

    kSensorUIEnum mCurrentSensorUI;
};
