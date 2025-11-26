
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

#include "LightEndpoint.h"

#include <app/clusters/on-off-server/on-off-server.h>
#include <platform/CHIPDeviceLayer.h>
#include <protocols/interaction_model/StatusCode.h>

using namespace chip;
using namespace chip::DeviceLayer;
using namespace chip::Protocols::InteractionModel;
using namespace chip::app::Clusters::OnOff;
using namespace chip::app::Clusters;
using Status = chip::Protocols::InteractionModel::Status;

CHIP_ERROR LightEndpoint::GetOnOffState(bool & state)
{
    Status status = OnOffServer::Instance().getOnOffValue(mEndpointId, &state);

    VerifyOrReturnError(status == Protocols::InteractionModel::Status::Success, CHIP_ERROR_INTERNAL);

    return CHIP_NO_ERROR;
}

CHIP_ERROR LightEndpoint::SetOnOffState(bool state)
{
    CommandId commandId = state ? OnOff::Commands::On::Id : OnOff::Commands::Off::Id;

    Status status = OnOffServer::Instance().setOnOffValue(mEndpointId, commandId, false);

    VerifyOrReturnError(status == Protocols::InteractionModel::Status::Success, CHIP_ERROR_INTERNAL);

    return CHIP_NO_ERROR;
}
