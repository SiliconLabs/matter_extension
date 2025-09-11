/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
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

// TODO To prevent config with nl headers has to be included before  nl test headers
#include <pw_unit_test/unit_test_service.h>

#include <AppConfig.h>
#include <PigweedLogger.h>
#include <PigweedLoggerMutex.h>
#include <cmsis_os2.h>
#include <credentials/DeviceAttestationCredsProvider.h>
#include <cstring>
#include <headers/ProvisionManager.h>
#include <lib/support/CHIPMem.h>
#include <lib/support/CHIPPlatformMemory.h>
#include <lib/support/UnitTest.h>
#include <mbedtls/platform.h>
#include <nl_test_service/nl_test.rpc.pb.h>
#include <pigweed/RpcService.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/KeyValueStoreManager.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <sl_cmsis_os2_common.h>

#include "sl_component_catalog.h"
// Use sl_system for projects upgraded to 2025.6, identified by the presence of SL_CATALOG_CUSTOM_MAIN_PRESENT
#if defined(SL_CATALOG_CUSTOM_MAIN_PRESENT)
#include "sl_system_init.h"
#include <sl_system_kernel.h>
#else
#include "sl_main_init.h"
#endif

using namespace chip;
using namespace chip::DeviceLayer;

extern "C" int printf(const char * format, ...)
{
    va_list args;
    va_start(args, format);
    chip::Logging::LogV(chip::Logging::kLogModule_NotSpecified, chip::Logging::kLogCategory_Progress, format, args);
    va_end(args);
    return 0;
}

namespace chip::rpc {

class NlTest : public pw_rpc::nanopb::NlTest::Service<NlTest>
{
public:
    void Run(const pw_protobuf_Empty & request, ServerWriter<chip_rpc_Event> & writer)
    {
        printf("--- Running pw_unit_test ---");
        int status = chip::test::RunAllTests();
        printf("Test status: %d", status);
    }
};

} // namespace chip::rpc

namespace {
osThreadId_t sTestTaskHandle;
osThread_t testTaskControlBlock;
constexpr uint32_t kTestTaskStackSize = 16 * 1024;
uint8_t testTaskStack[kTestTaskStackSize];
constexpr osThreadAttr_t kTestTaskAttr = { .name       = "TestDriver",
                                           .attr_bits  = osThreadDetached,
                                           .cb_mem     = &testTaskControlBlock,
                                           .cb_size    = osThreadCbSize,
                                           .stack_mem  = testTaskStack,
                                           .stack_size = kTestTaskStackSize,
                                           .priority   = osPriorityNormal };

chip::rpc::NlTest nl_test_service;
pw::unit_test::UnitTestService unit_test_service;

void RegisterServices(pw::rpc::Server & server)
{
    server.RegisterService(nl_test_service, unit_test_service);
}

void RunRpcService(void *)
{
    Start(RegisterServices, &::chip::rpc::logger_mutex);
}

} // namespace

// This is a User definable function in sl_main context, called by sl_main_init before the kernel is started
void app_init_early(void) {}

// This is a User definable function, in sl_main context, called by start_task_handler once the silabs platform is fully
// initialized.
void app_init(void)
{
    Silabs::GetPlatform().Init();
    PigweedLogger::init();
    mbedtls_platform_set_calloc_free(CHIPPlatformMemoryCalloc, CHIPPlatformMemoryFree);

    Platform::MemoryInit();
    PlatformMgr().InitChipStack();

    // Init Provision Manager and provider instanaces. Required for inits tied to the event loop
    Silabs::Provision::Manager & provision = Silabs::Provision::Manager::GetInstance();
    provision.Init();
    SetDeviceInstanceInfoProvider(&provision.GetStorage());
    SetCommissionableDataProvider(&provision.GetStorage());

    ChipLogProgress(AppServer, "***** CHIP EFR32 device tests *****\r\n");

    // Start RPC service which runs the tests.
    sTestTaskHandle = osThreadNew(RunRpcService, nullptr, &kTestTaskAttr);
}

#if defined(SL_CATALOG_CUSTOM_MAIN_PRESENT)
int main(void)
{
    app_init_early();
    sl_system_init();
    app_init();

    SILABS_LOG("Starting FreeRTOS scheduler");
    sl_system_kernel_start();
    // Should never get here.
    ChipLogProgress(AppServer, "sl_system_kernel_start() failed");
    return -1;
}
#endif
