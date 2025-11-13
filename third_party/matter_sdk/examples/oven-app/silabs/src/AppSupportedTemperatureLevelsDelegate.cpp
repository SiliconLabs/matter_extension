/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
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

#include <AppSupportedTemperatureLevelsDelegate.h>
#include <app/clusters/temperature-control-server/supported-temperature-levels-manager.h>
#include <lib/support/logging/CHIPLogging.h>

using namespace chip;
using namespace chip::app::Clusters;
using namespace chip::app::DataModel;

CHIP_ERROR AppSupportedTemperatureLevelsDelegate::RegisterSupportedLevels(EndpointId endpoint, const CharSpan * levels,
                                                                          uint8_t levelCount)
{
    VerifyOrReturnError(levels != nullptr && levelCount > 0, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(AppServer, "RegisterSupportedLevels: invalid levels/null or count=0"));

    VerifyOrReturnError(mRegisteredEndpointCount < kNumCookSurfaceEndpoints, CHIP_ERROR_NO_MEMORY,
                        ChipLogError(AppServer, "RegisterSupportedLevels: capacity exceeded (%zu)", mRegisteredEndpointCount));

    // Prevent duplicate endpoints
    for (size_t i = 0; i < mRegisteredEndpointCount; ++i)
    {
        VerifyOrReturnError(supportedOptionsByEndpoints[i].mEndpointId != endpoint, CHIP_ERROR_ENDPOINT_EXISTS,
                            ChipLogError(AppServer, "RegisterSupportedLevels: duplicate endpoint %u", endpoint));
    }

    supportedOptionsByEndpoints[mRegisteredEndpointCount++] = EndpointPair(endpoint, levels, levelCount);
    ChipLogProgress(AppServer, "Registered %u levels for endpoint %u", static_cast<unsigned>(levelCount), endpoint);
    return CHIP_NO_ERROR;
}

uint8_t AppSupportedTemperatureLevelsDelegate::Size()
{
    for (size_t i = 0; i < mRegisteredEndpointCount; ++i)
    {
        const EndpointPair & endpointPair = supportedOptionsByEndpoints[i];
        if (endpointPair.mEndpointId == mEndpoint)
        {
            ChipLogProgress(AppServer, "Found endpoint %d with size %d", mEndpoint, endpointPair.mSize);
            return endpointPair.mSize;
        }
    }
    ChipLogError(AppServer, "No matching endpoint found for %d in Size()", mEndpoint);
    return 0;
}

CHIP_ERROR AppSupportedTemperatureLevelsDelegate::Next(MutableCharSpan & item)
{
    for (size_t i = 0; i < mRegisteredEndpointCount; ++i)
    {
        const EndpointPair & endpointPair = supportedOptionsByEndpoints[i];
        if (endpointPair.mEndpointId == mEndpoint)
        {
            if (mIndex < endpointPair.mSize)
            {
                CHIP_ERROR err = CopyCharSpanToMutableCharSpan(endpointPair.mTemperatureLevels[mIndex], item);
                if (err == CHIP_NO_ERROR)
                {
                    mIndex++;
                }
                return err;
            }
            return CHIP_ERROR_PROVIDER_LIST_EXHAUSTED;
        }
    }
    ChipLogProgress(AppServer, "No matching endpoint found for %d in Next()", mEndpoint);
    return CHIP_ERROR_PROVIDER_LIST_EXHAUSTED;
}
