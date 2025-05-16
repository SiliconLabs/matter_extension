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

// SL-TEMP: GN cannot use sl_main until it supports sisdk 2025.6
// sl_system_init is always used for 917 soc
#if (SL_MATTER_GN_BUILD == 1 || SLI_SI91X_MCU_INTERFACE)
#include "sl_system_init.h"
#else
#include "sl_main_init.h"
#endif
#include <MatterConfig.h>
#include <platform/silabs/tracing/SilabsTracingMacros.h>

using TimeTraceOperation = chip::Tracing::Silabs::TimeTraceOperation;

// This is a User definable function in sl_main context, called by sl_main_init before the kernel is started
void app_init_early(void)
{
    SILABS_TRACE_BEGIN(chip::Tracing::Silabs::TimeTraceOperation::kBootup);
    SILABS_TRACE_BEGIN(chip::Tracing::Silabs::TimeTraceOperation::kSilabsInit);
}

// This is a User definable function, in sl_main context, called by start_task_handler once the silabs platform is fully
// initialized.
void app_init(void)
{
    SILABS_TRACE_END(chip::Tracing::Silabs::TimeTraceOperation::kSilabsInit);
    SILABS_TRACE_BEGIN(chip::Tracing::Silabs::TimeTraceOperation::kMatterInit);
    // Initialize the matter application. For example, create periodic timer(s) or
    // task(s).
    SilabsMatterConfig::AppInit();
}

// SL-TEMP: GN cannot use sl_main until it supports sisdk 2025.6
// sl_system_init is always used for 917 soc
#if (SL_MATTER_GN_BUILD == 1 || SLI_SI91X_MCU_INTERFACE)
int main(void)
{
    app_init_early();
    sl_system_init();
    app_init();
}
#endif
