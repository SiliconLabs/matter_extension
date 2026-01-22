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

#pragma once

#include <app/clusters/temperature-control-server/supported-temperature-levels-manager.h>
#include <lib/core/CHIPError.h>
#include <lib/core/DataModelTypes.h>

namespace chip {
namespace app {
namespace Clusters {

/**
 * @brief Endpoint to temperature levels mapping. The endpoint must have a temperature control cluster.
 * Represents a pair of endpoints and temperature levels supported by that endpoint.
 */
struct EndpointPair
{
    /// An endpoint having temperature control cluster.
    EndpointId mEndpointId = kInvalidEndpointId;
    /// Temperature levels supported by the temperature control cluster in this endpoint.
    const CharSpan * mTemperatureLevels = nullptr;
    /// Size of the temperature levels array.
    uint8_t mSize = 0;

    EndpointPair() = default;
    EndpointPair(EndpointId aEndpointId, const CharSpan * aTemperatureLevels, uint8_t aSize) :
        mEndpointId(aEndpointId), mTemperatureLevels(aTemperatureLevels), mSize(aSize)
    {}
};

/**
 * Implementation of SupportedTemperatureLevelsIteratorDelegate for the oven app.
 * This class provides supported temperature levels for temperature control clusters.
 */
class AppSupportedTemperatureLevelsDelegate : public TemperatureControl::SupportedTemperatureLevelsIteratorDelegate
{
public:
    // Use a fixed size for oven app (cook-surface multiple endpoints: 4, 5)
    static constexpr size_t kNumCookSurfaceEndpoints = 2;
    // Number of supported temperature levels
    static constexpr size_t kNumTemperatureLevels = 3;

    AppSupportedTemperatureLevelsDelegate(){};

    // Internal table of endpoint -> levels mapping (filled via RegisterSupportedLevels()).
    EndpointPair supportedOptionsByEndpoints[kNumCookSurfaceEndpoints];
    size_t mRegisteredEndpointCount = 0;

    /**
     * @brief Register supported temperature level strings for a given endpoint.
     *
     * The caller supplies an array of CharSpan entries whose lifetime exceeds that of this delegate.
     * @return CHIP_NO_ERROR on success,
     *         CHIP_ERROR_NO_MEMORY if capacity exceeded,
     *         CHIP_ERROR_ENDPOINT_EXISTS if duplicate endpoint provided.
     */
    CHIP_ERROR RegisterSupportedLevels(EndpointId endpoint, const CharSpan * levels, uint8_t levelCount);

    uint8_t Size() override;

    CHIP_ERROR Next(MutableCharSpan & item) override;
};

} // namespace Clusters
} // namespace app
} // namespace chip
