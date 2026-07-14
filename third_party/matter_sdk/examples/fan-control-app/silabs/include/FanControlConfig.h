/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
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

#ifndef SL_MATTER_FAN_CONTROL_CONFIG_H
#define SL_MATTER_FAN_CONTROL_CONFIG_H

// <<< Use Configuration Wizard in Context Menu >>>

// FanControlConfig.h
// Preprocessor knobs for the silabs fan-control example. Edit these #define
// statements to customize the cluster endpoint and the speed-range bands used
// to map SpeedSetting onto FanMode (Low/Medium/High).
//
// The Low/Medium/High bounds segment the speed range [1..SpeedMax] into the
// FanMode bands. Defaults assume SpeedMax = 10 (1..3 Low, 4..7 Medium,
// 8..10 High). Products with a different SpeedMax must adjust these to
// stay inside the speed range.

// <o FAN_CONTROL_ENDPOINT> Endpoint that hosts the FanControl cluster
// <i> Default: 1
#define FAN_CONTROL_ENDPOINT 1

// <o FAN_MODE_LOW_LOWER_BOUND> Lower bound (inclusive) of the Low fan-mode speed band
// <i> Default: 1
#define FAN_MODE_LOW_LOWER_BOUND 1

// <o FAN_MODE_LOW_UPPER_BOUND> Upper bound (inclusive) of the Low fan-mode speed band
// <i> Default: 3
#define FAN_MODE_LOW_UPPER_BOUND 3

// <o FAN_MODE_MEDIUM_LOWER_BOUND> Lower bound (inclusive) of the Medium fan-mode speed band
// <i> Default: 4
#define FAN_MODE_MEDIUM_LOWER_BOUND 4

// <o FAN_MODE_MEDIUM_UPPER_BOUND> Upper bound (inclusive) of the Medium fan-mode speed band
// <i> Default: 7
#define FAN_MODE_MEDIUM_UPPER_BOUND 7

// <o FAN_MODE_HIGH_LOWER_BOUND> Lower bound (inclusive) of the High fan-mode speed band
// <i> Default: 8
#define FAN_MODE_HIGH_LOWER_BOUND 8

// <o FAN_MODE_HIGH_UPPER_BOUND> Upper bound (inclusive) of the High fan-mode speed band
// <i> Default: 10
#define FAN_MODE_HIGH_UPPER_BOUND 10

// <<< end of configuration section >>>

#endif // SL_MATTER_FAN_CONTROL_CONFIG_H
