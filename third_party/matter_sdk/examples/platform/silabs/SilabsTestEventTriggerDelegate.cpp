/*
 *
 *    Copyright (c) 2023 Project CHIP Authors
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

#include "SilabsTestEventTriggerDelegate.h"
#include <headers/ProvisionManager.h>
#include <lib/core/ErrorStr.h>

using namespace ::chip::DeviceLayer;

namespace chip {

bool SilabsTestEventTriggerDelegate::DoesEnableKeyMatch(const ByteSpan & enableKey) const
{
    uint8_t storedEnableKey[TestEventTriggerDelegate::kEnableKeyLength] = { 0 };
    MutableByteSpan storedEnableKeySpan(storedEnableKey);

    CHIP_ERROR error = Silabs::Provision::Manager::GetInstance().GetStorage().GetTestEventTriggerKey(storedEnableKeySpan);
    if (error != CHIP_NO_ERROR)
    {
        // If we fail to read the enableKey from storage, the MutableByteSpan is not modified by the getter which leaves the span
        // equal to a zero bytepsan (size = 0). This guarantees that we will be able to inform the stack that the test event trigger
        // is not enabled when the stack tries to match the zero bytespan to our enableKey.
        ChipLogError(DeviceLayer, "Failed to get test event trigger key: %s", ErrorStr(error));
    }

    return storedEnableKeySpan.data_equal(enableKey);
}

} // namespace chip
