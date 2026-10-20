/*
 *
 *    Copyright (c) 2026 Project CHIP Authors
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

#include "SilabsAppTask.h"

#include <device-factory/DeviceFactory.h>
#include <lib/support/CodeUtils.h>

#include <credentials/DeviceAttestationCredsProvider.h>
#ifdef CONFIG_CHIP_FACTORY_DATA
#include <platform/CommissionableDataProvider.h>
#include <platform/DeviceInstanceInfoProvider.h>
#include <platform/Zephyr/ZephyrConfig.h>
#include <provision/ProvisionStorageReader.h>
#else
#include <credentials/examples/DeviceAttestationCredsExample.h>
#endif

namespace chip::app::AllDevices {

CHIP_ERROR InitSilabsCredentials()
{
#if CONFIG_CHIP_FACTORY_DATA
    // Replace all 3 providers to use the Silabs provision storage reader.
    ReturnErrorOnFailure(DeviceLayer::Internal::ZephyrConfig::Init());
    auto & storageReader = DeviceLayer::Silabs::Provision::ProvisionStorageReader::GetInstance();
    DeviceLayer::SetDeviceInstanceInfoProvider(&storageReader);
    DeviceLayer::SetCommissionableDataProvider(&storageReader);
    Credentials::SetDeviceAttestationCredentialsProvider(&storageReader);

#else // CONFIG_CHIP_FACTORY_DATA
    Credentials::SetDeviceAttestationCredentialsProvider(Credentials::Examples::GetExampleDACProvider());
    DeviceLayer::SetDeviceInstanceInfoProvider(&DeviceLayer::DeviceInstanceInfoProviderMgrImpl());

#endif // CONFIG_CHIP_FACTORY_DATA
    return CHIP_NO_ERROR;
}

} // namespace chip::app::AllDevices
