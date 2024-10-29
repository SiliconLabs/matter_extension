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

#include "AppEvent.h"
#include "BaseApplication.h"
#include "FreeRTOS.h"
#include "timers.h"
#include <app/clusters/occupancy-sensor-server/occupancy-hal.h>
#include <app/data-model/Nullable.h>
#include <lib/core/CHIPError.h>
#include <protocols/interaction_model/StatusCode.h>

#if DISPLAY_ENABLED
#include "glib.h"
#endif

/**
 * @brief namespace responsible of the business logic around managing the different sensors.
 *        Application implements 3 sensors : Occupancy sensor, Temperature sensor and Humidity sensor
 */
namespace SensorManager {

/**
 * @brief Init function for the SensorManager.
 *        - Configures Sensor Timer
 *        - Inits the underlying sensors
 *        - Inits the LCD if enabled
 *
 * @return CHIP_ERROR CHIP_NO_ERROR if init succeeded
 *                    Errorcode if an error happens during the init process.
 */
CHIP_ERROR Init();

/**
 * @brief Process function when the application button is pressed.
 *        Trigger an Occupancy sensor attribute update. If the occupancy value is Occupied, the attribute is set to occupied.
 *        If the attribute value is Unoccupied, the attribute is set to occupied.
 *
 *        This function does not needs to be executed from the Matter task since it schedules the update to be done by the
 *        Matter task.
 *
 * @param aEvent
 */
void ButtonActionTriggered(AppEvent * aEvent);

/**
 * @brief Returns the DataModel TemperatureMeasurement::MeasureValue attribute.
 *        Function locks and unlocks the Matter task.
 *        The caller MUST NOT hold the lock on the Matter task, otherwise a deadlock is created.
 *
 * @return Status code code if we failed to read the data model attribute
 */
chip::Protocols::InteractionModel::Status GetMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value);

/**
 * @brief Returns the DataModel TemperatureMeasurement::MaxMeasureValue attribute.
 *        Function locks and unlocks the Matter task.
 *        The caller MUST NOT hold the lock on the Matter task, otherwise a deadlock is created.
 *
 * @return Status code code if we failed to read the data model attribute
 */
chip::Protocols::InteractionModel::Status GetMaxMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value);

/**
 * @brief Returns the DataModel TemperatureMeasurement::MinMeasureValue attribute.
 *        Function locks and unlocks the Matter task.
 *        The caller MUST NOT hold the lock on the Matter task, otherwise a deadlock is created.
 *
 * @return Status code code if we failed to read the data model attribute
 */
chip::Protocols::InteractionModel::Status GetMinMeasuredTemperature(chip::app::DataModel::Nullable<int16_t> & value);

/**
 * @brief Returns the DataModel RelativityHumidityMeasurement::MeasureValue attribute.
 *        Function locks and unlocks the Matter task.
 *        The caller MUST NOT hold the lock on the Matter task, otherwise a deadlock is created.
 *
 * @return Status code code if we failed to read the data model attribute
 */
chip::Protocols::InteractionModel::Status GetMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value);

/**
 * @brief Returns the DataModel RelativityHumidityMeasurement::MaxMeasureValue attribute.
 *        Function locks and unlocks the Matter task.
 *        The caller MUST NOT hold the lock on the Matter task, otherwise a deadlock is created.
 *
 * @return Status code code if we failed to read the data model attribute
 */
chip::Protocols::InteractionModel::Status GetMaxMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value);

/**
 * @brief Returns the DataModel RelativityHumidityMeasurement::MinMeasureValue attribute.
 *        Function locks and unlocks the Matter task.
 *        The caller MUST NOT hold the lock on the Matter task, otherwise a deadlock is created.
 *
 * @return Status code code if we failed to read the data model attribute
 */
chip::Protocols::InteractionModel::Status GetMinMeasuredHumidity(chip::app::DataModel::Nullable<uint16_t> & value);

/**
 * @brief Functions reads the Occupancy attributes and returns based on if Occupancy is detected.
 *        Function locks and unlocks the Matter task.
 *        The caller MUST NOT hold the lock on the Matter task, otherwise a deadlock is created.
 *
 * @return true Occupancy is detected - Ocupancysensing::Occupancy is set to occupied
 * @return false Occupancy not is detected - Ocupancysensing::Occupancy is not set to occupied
 */
bool IsOccupancyDetected();

}; // namespace SensorManager
