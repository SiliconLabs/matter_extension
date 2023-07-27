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

#include <AppConfig.h>
#include <WindowApp.h>

#include "init_ccpPlatform.h"
using namespace ::chip::DeviceLayer;

#define UNUSED_PARAMETER(a) (a = a)

WindowApp & app = WindowApp::Instance();

// ================================================================================
// Main Code
// ================================================================================
int main(void)
{
    init_ccpPlatform();
    SILABS_LOG("init_ccpPlatform completed ");

    // Create Main task and starting a scheduler
    Create_application_task();

    // Should never get here.
    chip::Platform::MemoryShutdown();
    SILABS_LOG("vTaskStartScheduler() failed");
    appError(CHIP_ERROR_INTERNAL);

    app.Finish();
    return 0;
}
