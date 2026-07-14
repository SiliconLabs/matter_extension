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

#ifndef SL_MATTER_SENSOR_APP_CONFIG_H
#define SL_MATTER_SENSOR_APP_CONFIG_H

// <<< Use Configuration Wizard in Context Menu >>>

// SensorConfig.h
// Preprocessor knobs for the silabs multi-sensor example. Edit these #define
// statements to map each sensor cluster to the endpoint it occupies in your
// data model.

// <o OCCUPANCY_SENSOR_ENDPOINT> OccupancySensing cluster endpoint
// <i> Default: 1
#define OCCUPANCY_SENSOR_ENDPOINT 1

// <o TEMPERATURE_SENSOR_ENDPOINT> TemperatureMeasurement cluster endpoint
// <i> Default: 2
#define TEMPERATURE_SENSOR_ENDPOINT 2

// <o HUMIDITY_SENSOR_ENDPOINT> RelativeHumidityMeasurement cluster endpoint
// <i> Default: 3
#define HUMIDITY_SENSOR_ENDPOINT 3

// <<< end of configuration section >>>

#endif // SL_MATTER_SENSOR_APP_CONFIG_H
