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

#ifndef SL_MATTER_RANGEHOOD_CONFIG_H
#define SL_MATTER_RANGEHOOD_CONFIG_H

// <<< Use Configuration Wizard in Context Menu >>>

// RangeHoodConfig.h
// Preprocessor knobs for the silabs rangehood example. Edit these #define
// statements to customize Matter endpoint IDs (must match rangehood-*-app.zap /
// .matter) and FanControl percentSetting values for Low / Medium / High modes.

// <o EXTRACTOR_HOOD_ENDPOINT> Extractor hood (FanControl) cluster endpoint
// <i> Default: 1
#define EXTRACTOR_HOOD_ENDPOINT 1

// <o LIGHT_ENDPOINT> On/Off light cluster endpoint
// <i> Default: 2
#define LIGHT_ENDPOINT 2

// <o FAN_MODE_LOW_PERCENT> FanControl percentSetting for Low mode
// <i> Default: 30
#define FAN_MODE_LOW_PERCENT 30

// <o FAN_MODE_MEDIUM_PERCENT> FanControl percentSetting for Medium mode
// <i> Default: 60
#define FAN_MODE_MEDIUM_PERCENT 60

// <o FAN_MODE_HIGH_PERCENT> FanControl percentSetting for High mode
// <i> Default: 100
#define FAN_MODE_HIGH_PERCENT 100

// <<< end of configuration section >>>

#endif // SL_MATTER_RANGEHOOD_CONFIG_H
