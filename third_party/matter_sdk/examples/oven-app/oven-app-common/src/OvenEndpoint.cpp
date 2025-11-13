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

#include "OvenEndpoint.h"
#include <app-common/zap-generated/cluster-objects.h>
#include <app/clusters/mode-base-server/mode-base-cluster-objects.h>
#include <lib/core/CHIPError.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/logging/CHIPLogging.h>

using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::Oven;
using namespace chip::app::Clusters::OvenMode;
using namespace chip::app::Clusters::TemperatureControlledCabinet;
using chip::Protocols::InteractionModel::Status;

// Static member definitions
const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsBake[1] = { { .value = to_underlying(ModeTag::kBake) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsConvection[1] = { { .value = to_underlying(
                                                                                              ModeTag::kConvection) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsGrill[1] = { { .value = to_underlying(ModeTag::kGrill) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsRoast[1] = { { .value = to_underlying(ModeTag::kRoast) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsClean[1] = { { .value = to_underlying(ModeTag::kClean) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsConvectionBake[1] = { { .value = to_underlying(
                                                                                                  ModeTag::kConvectionBake) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsConvectionRoast[1] = { { .value = to_underlying(
                                                                                                   ModeTag::kConvectionRoast) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsWarming[1] = { { .value =
                                                                                           to_underlying(ModeTag::kWarming) } };

const detail::Structs::ModeTagStruct::Type OvenModeDelegate::sModeTagsProofing[1] = { { .value =
                                                                                            to_underlying(ModeTag::kProofing) } };

const detail::Structs::ModeOptionStruct::Type OvenModeDelegate::skModeOptions[to_underlying(OvenModes::kModeCount)] = {
    { .label    = CharSpan::fromCharString("Bake"),
      .mode     = to_underlying(OvenModes::kModeBake),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsBake) },
    { .label    = CharSpan::fromCharString("Convection"),
      .mode     = to_underlying(OvenModes::kModeConvection),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsConvection) },
    { .label    = CharSpan::fromCharString("Grill"),
      .mode     = to_underlying(OvenModes::kModeGrill),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsGrill) },
    { .label    = CharSpan::fromCharString("Roast"),
      .mode     = to_underlying(OvenModes::kModeRoast),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsRoast) },
    { .label    = CharSpan::fromCharString("Clean"),
      .mode     = to_underlying(OvenModes::kModeClean),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsClean) },
    { .label    = CharSpan::fromCharString("Convection Bake"),
      .mode     = to_underlying(OvenModes::kModeConvectionBake),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsConvectionBake) },
    { .label    = CharSpan::fromCharString("Convection Roast"),
      .mode     = to_underlying(OvenModes::kModeConvectionRoast),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsConvectionRoast) },
    { .label    = CharSpan::fromCharString("Warming"),
      .mode     = to_underlying(OvenModes::kModeWarming),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsWarming) },
    { .label    = CharSpan::fromCharString("Proofing"),
      .mode     = to_underlying(OvenModes::kModeProofing),
      .modeTags = DataModel::List<const detail::Structs::ModeTagStruct::Type>(sModeTagsProofing) }
};

CHIP_ERROR OvenModeDelegate::Init()
{
    // No initialization required for OvenModeDelegate
    return CHIP_NO_ERROR;
}

void OvenModeDelegate::HandleChangeToMode(uint8_t NewMode, ModeBase::Commands::ChangeToModeResponse::Type & response)
{
    ChipLogProgress(Zcl, "OvenModeDelegate::HandleChangeToMode: NewMode=%d", NewMode);
    // TODO: Implement logic to change the oven mode.
    response.status = to_underlying(ModeBase::StatusCode::kSuccess);
}

CHIP_ERROR OvenModeDelegate::GetModeLabelByIndex(uint8_t modeIndex, MutableCharSpan & label)
{
    VerifyOrReturnError(modeIndex < to_underlying(OvenModes::kModeCount), CHIP_ERROR_INVALID_LIST_LENGTH);
    return CopyCharSpanToMutableCharSpan(skModeOptions[modeIndex].label, label);
}

CHIP_ERROR OvenModeDelegate::GetModeValueByIndex(uint8_t modeIndex, uint8_t & value)
{
    VerifyOrReturnError(modeIndex < to_underlying(OvenModes::kModeCount), CHIP_ERROR_INVALID_LIST_LENGTH);
    value = skModeOptions[modeIndex].mode;
    return CHIP_NO_ERROR;
}

CHIP_ERROR OvenModeDelegate::GetModeTagsByIndex(uint8_t modeIndex, DataModel::List<detail::Structs::ModeTagStruct::Type> & tags)
{
    VerifyOrReturnError(modeIndex < MATTER_ARRAY_SIZE(skModeOptions), CHIP_ERROR_INVALID_LIST_LENGTH);

    VerifyOrReturnError(tags.size() >= skModeOptions[modeIndex].modeTags.size(), CHIP_ERROR_INVALID_ARGUMENT);

    std::copy(skModeOptions[modeIndex].modeTags.begin(), skModeOptions[modeIndex].modeTags.end(), tags.begin());
    tags.reduce_size(skModeOptions[modeIndex].modeTags.size());

    return CHIP_NO_ERROR;
}

CHIP_ERROR TemperatureControlledCabinetEndpoint::Init()
{
    // Initialize the Oven Mode instance and delegate
    ReturnErrorOnFailure(mOvenModeInstance.Init());
    ReturnErrorOnFailure(mOvenModeDelegate.Init());

    return CHIP_NO_ERROR;
}

CHIP_ERROR OvenEndpoint::Init()
{
    return CHIP_NO_ERROR;
}
