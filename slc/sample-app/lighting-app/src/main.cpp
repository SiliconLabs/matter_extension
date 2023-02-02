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

#include "sl_component_catalog.h"
#include "sl_system_init.h"
#include "sl_power_manager.h"
#include "app.h"

#ifdef SL_CATALOG_SIMPLE_BUTTON_PRESENT
#include "sl_simple_button_instances.h"
#endif

#include "sl_system_kernel.h"

void app_init(void)
{
    init_efrPlatform();
    if (EFR32MatterConfig::InitMatter(BLE_DEV_NAME) != CHIP_NO_ERROR)
        appError(CHIP_ERROR_INTERNAL);

    gExampleDeviceInfoProvider.SetStorageDelegate(&Server::GetInstance().GetPersistentStorage());
    chip::DeviceLayer::SetDeviceInfoProvider(&gExampleDeviceInfoProvider);

    chip::DeviceLayer::PlatformMgr().LockChipStack();
    // Initialize device attestation config
#ifdef EFR32_ATTESTATION_CREDENTIALS
    SetDeviceAttestationCredentialsProvider(EFR32::GetEFR32DacProvider());
#else
    SetDeviceAttestationCredentialsProvider(Examples::GetExampleDACProvider());
#endif
    chip::DeviceLayer::PlatformMgr().UnlockChipStack();

    EFR32_LOG("Starting App Task");
    if (AppTask::GetAppTask().StartAppTask() != CHIP_NO_ERROR)
        appError(CHIP_ERROR_INTERNAL);

    EFR32_LOG("Starting FreeRTOS scheduler");
}

int main(void)
{
    // Initialize Silicon Labs device, system, service(s) and protocol stack(s).
    // Note that if the kernel is present, processing task(s) will be created by
    // this call.
    sl_system_init();

    // Initialize the application. For example, create periodic timer(s) or
    // task(s) if the kernel is present.
    app_init();

    // Start the kernel. Task(s) created in app_init() will start running.
    sl_system_kernel_start();

    // Should never get here.
    chip::Platform::MemoryShutdown();
    EFR32_LOG("vTaskStartScheduler() failed");
    appError(CHIP_ERROR_INTERNAL);
}

#ifdef SL_CATALOG_SIMPLE_BUTTON_PRESENT
void sl_button_on_change(const sl_button_t * handle)
{
    AppTask::GetAppTask().ButtonEventHandler(handle, sl_button_get_state(handle));
}
#endif
