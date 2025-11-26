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

#include <app/clusters/on-off-server/on-off-server.h>
#include <lib/core/CHIPError.h>
#include <lib/core/DataModelTypes.h>

class LightEndpoint
{
public:
    LightEndpoint(chip::EndpointId endpointId) : mEndpointId(endpointId) {}

    /**
     * @brief Get the current On/Off state from the Matter attribute.
     * The caller MUST hold the CHIP stack lock before calling this function,
     * unless calling from a CHIP task context where the lock is already held.
     * @param[out] state true if light is on, false if off on success.
     * @return Interaction Model status code.
     */
    CHIP_ERROR GetOnOffState(bool & state);

    /**
     * @brief Set On/Off state for the Light.
     * The caller MUST hold the CHIP stack lock before calling this function,
     * unless calling from a CHIP task context where the lock is already held.
     * @param[in] state Desired state (true => On, false => Off).
     * @return Interaction Model status code.
     */
    CHIP_ERROR SetOnOffState(bool state);

private:
    chip::EndpointId mEndpointId = chip::kInvalidEndpointId;
};
