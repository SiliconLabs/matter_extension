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
#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/cluster-objects.h>

#include "OvenManager.h"
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
using detail::Structs::ModeTagStruct::Type;

// Static member definitions
const Type OvenModeDelegate::sModeTagsBake[1] = { { .value = to_underlying(ModeTag::kBake) } };

const Type OvenModeDelegate::sModeTagsConvection[1] = { { .value = to_underlying(ModeTag::kConvection) } };

const Type OvenModeDelegate::sModeTagsGrill[1] = { { .value = to_underlying(ModeTag::kGrill) } };

const Type OvenModeDelegate::sModeTagsRoast[1] = { { .value = to_underlying(ModeTag::kRoast) } };

const Type OvenModeDelegate::sModeTagsClean[1] = { { .value = to_underlying(ModeTag::kClean) } };

const Type OvenModeDelegate::sModeTagsConvectionBake[1] = { { .value = to_underlying(ModeTag::kConvectionBake) } };

const Type OvenModeDelegate::sModeTagsConvectionRoast[1] = { { .value = to_underlying(ModeTag::kConvectionRoast) } };

const Type OvenModeDelegate::sModeTagsWarming[1] = { { .value = to_underlying(ModeTag::kWarming) } };

const Type OvenModeDelegate::sModeTagsProofing[1] = { { .value = to_underlying(ModeTag::kProofing) } };

const detail::Structs::ModeOptionStruct::Type OvenModeDelegate::skModeOptions[to_underlying(OvenModes::kModeCount)] = {
    { .label    = CharSpan::fromCharString("Bake"),
      .mode     = to_underlying(OvenModes::kModeBake),
      .modeTags = DataModel::List<const Type>(sModeTagsBake) },
    { .label    = CharSpan::fromCharString("Convection"),
      .mode     = to_underlying(OvenModes::kModeConvection),
      .modeTags = DataModel::List<const Type>(sModeTagsConvection) },
    { .label    = CharSpan::fromCharString("Grill"),
      .mode     = to_underlying(OvenModes::kModeGrill),
      .modeTags = DataModel::List<const Type>(sModeTagsGrill) },
    { .label    = CharSpan::fromCharString("Roast"),
      .mode     = to_underlying(OvenModes::kModeRoast),
      .modeTags = DataModel::List<const Type>(sModeTagsRoast) },
    { .label    = CharSpan::fromCharString("Clean"),
      .mode     = to_underlying(OvenModes::kModeClean),
      .modeTags = DataModel::List<const Type>(sModeTagsClean) },
    { .label    = CharSpan::fromCharString("Convection Bake"),
      .mode     = to_underlying(OvenModes::kModeConvectionBake),
      .modeTags = DataModel::List<const Type>(sModeTagsConvectionBake) },
    { .label    = CharSpan::fromCharString("Convection Roast"),
      .mode     = to_underlying(OvenModes::kModeConvectionRoast),
      .modeTags = DataModel::List<const Type>(sModeTagsConvectionRoast) },
    { .label    = CharSpan::fromCharString("Warming"),
      .mode     = to_underlying(OvenModes::kModeWarming),
      .modeTags = DataModel::List<const Type>(sModeTagsWarming) },
    { .label    = CharSpan::fromCharString("Proofing"),
      .mode     = to_underlying(OvenModes::kModeProofing),
      .modeTags = DataModel::List<const Type>(sModeTagsProofing) }
};

CHIP_ERROR OvenModeDelegate::Init()
{
    // No initialization required for OvenModeDelegate
    return CHIP_NO_ERROR;
}

void OvenModeDelegate::HandleChangeToMode(uint8_t NewMode, ModeBase::Commands::ChangeToModeResponse::Type & response)
{
    ChipLogProgress(Zcl, "OvenModeDelegate forwarding mode change to OvenManager (ep=%u newMode=%u)", mEndpointId, NewMode);
    // Lambda helper to set response status and optional statusText
    auto setResponse = [&](ModeBase::StatusCode code, const char * text = nullptr) {
        response.status = to_underlying(code);
        if (text != nullptr)
        {
            response.statusText.SetValue(CharSpan::fromCharString(text));
        }
    };

    // Verify newMode is among supported modes
    if (!IsSupportedMode(NewMode))
    {
        setResponse(ModeBase::StatusCode::kUnsupportedMode);
        return;
    }

    // Read Current Oven Mode
    uint8_t currentMode;
    Status attrStatus = OvenMode::Attributes::CurrentMode::Get(mEndpointId, &currentMode);
    if (attrStatus != Status::Success)
    {
        ChipLogError(AppServer, "OvenManager: Failed to read CurrentMode");
        setResponse(ModeBase::StatusCode::kGenericFailure, "Read CurrentMode failed");
        return;
    }

    // No action needed if current mode is the same as new mode
    if (currentMode == NewMode)
    {
        setResponse(ModeBase::StatusCode::kSuccess);
        return;
    }

    if (OvenManager::GetInstance().IsTransitionBlocked(currentMode, NewMode))
    {
        ChipLogProgress(AppServer, "OvenManager: Blocked transition %u -> %u", currentMode, NewMode);
        setResponse(ModeBase::StatusCode::kGenericFailure, "Transition blocked");
        return;
    }

    // Write new mode
    Status writeStatus = OvenMode::Attributes::CurrentMode::Set(mEndpointId, NewMode);
    if (writeStatus != Status::Success)
    {
        ChipLogError(AppServer, "OvenManager: Failed to write CurrentMode");
        setResponse(ModeBase::StatusCode::kGenericFailure, "Write CurrentMode failed");
        return;
    }

    setResponse(ModeBase::StatusCode::kSuccess);
}

CHIP_ERROR OvenModeDelegate::GetModeLabelByIndex(uint8_t modeIndex, MutableCharSpan & label)
{
    VerifyOrReturnError(modeIndex < to_underlying(OvenModes::kModeCount), CHIP_ERROR_PROVIDER_LIST_EXHAUSTED);
    return CopyCharSpanToMutableCharSpan(skModeOptions[modeIndex].label, label);
}

CHIP_ERROR OvenModeDelegate::GetModeValueByIndex(uint8_t modeIndex, uint8_t & value)
{
    VerifyOrReturnError(modeIndex < to_underlying(OvenModes::kModeCount), CHIP_ERROR_PROVIDER_LIST_EXHAUSTED);
    value = skModeOptions[modeIndex].mode;
    return CHIP_NO_ERROR;
}

CHIP_ERROR OvenModeDelegate::GetModeTagsByIndex(uint8_t modeIndex, DataModel::List<detail::Structs::ModeTagStruct::Type> & tags)
{
    VerifyOrReturnError(modeIndex < MATTER_ARRAY_SIZE(skModeOptions), CHIP_ERROR_PROVIDER_LIST_EXHAUSTED);

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

bool OvenModeDelegate::IsSupportedMode(uint8_t mode)
{
    for (auto const & opt : skModeOptions)
    {
        if (opt.mode == mode)
        {
            return true;
        }
    }
    return false;
}
