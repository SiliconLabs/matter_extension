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

#include "silabs_utils.h"

// ---- newLight Example App Config ----

#define APP_TASK_NAME "NEWLIGHT"

#define BLE_DEV_NAME "SL-" APP_TASK_NAME

// Time it takes in ms for the simulated actuator to move from one
// state to another.
#define ACTUATOR_MOVEMENT_PERIOS_MS 10

#define ON_DEMO_BITMAP                                                                                                             \
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc,  \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0xff, 0xff, 0xcf, 0xff, 0xff, 0xff, 0xff, 0xf3, 0xff, 0xff,    \
        0x8f, 0xff, 0xff, 0xff, 0xff, 0xf1, 0xff, 0xff, 0x0f, 0xff, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0x1f, 0xfe, 0x07, 0xe0,    \
        0x7f, 0xf8, 0xff, 0xff, 0x3f, 0xfc, 0x00, 0x00, 0x3f, 0xfc, 0xff, 0xff, 0x7f, 0x3c, 0xe0, 0x07, 0x3c, 0xfe, 0xff, 0xff,    \
        0xff, 0x1f, 0xfe, 0x7f, 0xf8, 0xff, 0xff, 0xff, 0xff, 0x0f, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xff, 0xc7, 0xff, 0xff,    \
        0xe3, 0xff, 0xff, 0xff, 0xff, 0xe3, 0xff, 0xff, 0xc7, 0xff, 0xff, 0xff, 0xff, 0xf1, 0xff, 0xff, 0x8f, 0xff, 0xff, 0xff,    \
        0xff, 0xf1, 0xff, 0xff, 0x8f, 0xff, 0xff, 0xff, 0xff, 0xf8, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff,    \
        0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfe, 0xff, 0xff, 0x7f, 0xfe, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfc, 0xff, 0x0f, 0x38, 0xfe, 0xff, 0xff, 0x7f, 0x1c, 0xf0, 0x0f, 0x38, 0xfe, 0x03, 0xc0, 0x7f, 0x1c, 0xf0, 0x0f,    \
        0x38, 0xfe, 0x27, 0xe9, 0x7f, 0x1c, 0xf0, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xe7, 0xe7, 0x7f, 0xfc, 0xff, 0xff, 0x7f, 0xfe, 0xef, 0xf7, 0x7f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfc, 0xef, 0xf7, 0x3f, 0xfe, 0xff, 0xff, 0xff, 0xfc, 0xef, 0xf3, 0x3f, 0xff, 0xff, 0xff, 0xff, 0xf8, 0xcf, 0xf3,    \
        0x1f, 0xff, 0xff, 0xff, 0xff, 0xf8, 0xdf, 0xfb, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xf1, 0xdf, 0xfb, 0x8f, 0xff, 0xff, 0xff,    \
        0xff, 0xe3, 0x9f, 0xf9, 0xc7, 0xff, 0xff, 0xff, 0xff, 0xc3, 0x9f, 0xf9, 0xc3, 0xff, 0xff, 0xff, 0xff, 0xc7, 0x9f, 0xfd,    \
        0xe3, 0xff, 0xff, 0xff, 0xff, 0x8f, 0xbf, 0xfd, 0xf1, 0xff, 0xff, 0xff, 0xff, 0x1f, 0x3f, 0xfc, 0xf8, 0xff, 0xff, 0xff,    \
        0xff, 0x3f, 0x3e, 0x7c, 0xfc, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0x3f, 0xfe, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0x3f,    \
        0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf1, 0x8f,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x01, 0x80, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x03, 0xc0, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0x3f, 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff

#define OFF_DEMO_BITMAP                                                                                                            \
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,  \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x07, 0xe0,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xe0, 0x07, 0xfc, 0xff, 0xff, 0xff,    \
        0xff, 0x1f, 0xfe, 0x7f, 0xf8, 0xff, 0xff, 0xff, 0xff, 0x0f, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xff, 0xc7, 0xff, 0xff,    \
        0xe3, 0xff, 0xff, 0xff, 0xff, 0xe3, 0xff, 0xff, 0xc7, 0xff, 0xff, 0xff, 0xff, 0xf1, 0xff, 0xff, 0x8f, 0xff, 0xff, 0xff,    \
        0xff, 0xf1, 0xff, 0xff, 0x8f, 0xff, 0xff, 0xff, 0xff, 0xf8, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff,    \
        0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfe, 0xff, 0xff, 0x7f, 0xfe, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff,    \
        0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0x7f, 0xfc, 0xff, 0xff, 0x7f, 0xfe, 0xff, 0xff, 0x7f, 0xfe, 0xff, 0xff,    \
        0x7f, 0xfc, 0xff, 0xff, 0x3f, 0xfe, 0xff, 0xff, 0xff, 0xfc, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xff, 0xff, 0xf8, 0xff, 0xff,    \
        0x1f, 0xff, 0xff, 0xff, 0xff, 0xf8, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xf1, 0xff, 0xff, 0x8f, 0xff, 0xff, 0xff,    \
        0xff, 0xe3, 0xff, 0xff, 0xc7, 0xff, 0xff, 0xff, 0xff, 0xc3, 0xff, 0xff, 0xc3, 0xff, 0xff, 0xff, 0xff, 0xc7, 0xff, 0xff,    \
        0xe3, 0xff, 0xff, 0xff, 0xff, 0x8f, 0xff, 0xff, 0xf1, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xf8, 0xff, 0xff, 0xff,    \
        0xff, 0x3f, 0xfe, 0x7f, 0xfc, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0x3f, 0xfe, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xfc, 0x3f,    \
        0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf1, 0x8f,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x01, 0x80, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x03, 0xc0, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0x3f, 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,    \
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
