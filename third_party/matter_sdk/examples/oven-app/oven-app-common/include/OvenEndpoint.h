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

#include <app-common/zap-generated/cluster-objects.h>
#include <app/clusters/mode-base-server/mode-base-server.h>
#include <app/clusters/temperature-control-server/supported-temperature-levels-manager.h>
#include <app/data-model/List.h>
#include <lib/core/CHIPError.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/Span.h>

namespace chip {
namespace app {
namespace Clusters {
namespace TemperatureControlledCabinet {
class OvenModeDelegate : public ModeBase::Delegate
{
public:
    // Oven mode enum for better type safety and code clarity
    enum class OvenModes : uint8_t
    {
        kModeBake            = 0,
        kModeConvection      = 1,
        kModeGrill           = 2,
        kModeRoast           = 3,
        kModeClean           = 4,
        kModeConvectionBake  = 5,
        kModeConvectionRoast = 6,
        kModeWarming         = 7,
        kModeProofing        = 8,
        kModeCount           = 9,
    };

    OvenModeDelegate(EndpointId endpointId) : mEndpointId(endpointId) {}

    // ModeBase::Delegate interface
    CHIP_ERROR Init() override;
    void HandleChangeToMode(uint8_t mode, ModeBase::Commands::ChangeToModeResponse::Type & response) override;
    CHIP_ERROR GetModeLabelByIndex(uint8_t modeIndex, MutableCharSpan & label) override;
    CHIP_ERROR GetModeValueByIndex(uint8_t modeIndex, uint8_t & value) override;
    CHIP_ERROR GetModeTagsByIndex(uint8_t modeIndex, DataModel::List<detail::Structs::ModeTagStruct::Type> & tags) override;

private:
    EndpointId mEndpointId;

    // Static arrays moved to implementation file to reduce header size
    static const detail::Structs::ModeTagStruct::Type sModeTagsBake[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsConvection[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsGrill[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsRoast[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsClean[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsConvectionBake[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsConvectionRoast[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsWarming[];
    static const detail::Structs::ModeTagStruct::Type sModeTagsProofing[];

    static const detail::Structs::ModeOptionStruct::Type skModeOptions[];
};

class TemperatureControlledCabinetEndpoint
{
public:
    TemperatureControlledCabinetEndpoint(EndpointId endpointId) :
        mEndpointId(endpointId), mOvenModeDelegate(mEndpointId), mOvenModeInstance(&mOvenModeDelegate, mEndpointId, OvenMode::Id, 0)
    {}

    /**
     * @brief Initialize the temperature controlled cabinet endpoint. Sets the oven mode cluster instance with the appropriate
     * delegate.
     *
     * @return returns CHIP_NO_ERROR on success, or an error code on failure.
     */
    CHIP_ERROR Init();

private:
    EndpointId mEndpointId = kInvalidEndpointId;
    OvenModeDelegate mOvenModeDelegate;
    ModeBase::Instance mOvenModeInstance;
};

} // namespace TemperatureControlledCabinet

namespace Oven {
/**
 * @brief Base oven endpoint placeholder.
 */
class OvenEndpoint
{
public:
    OvenEndpoint() {}

    /**
     * @brief Initialize the oven endpoint.
     *
     * @return returns CHIP_NO_ERROR on success, or an error code on failure.
     */
    CHIP_ERROR Init();
};

} // namespace Oven
} // namespace Clusters
} // namespace app
} // namespace chip
