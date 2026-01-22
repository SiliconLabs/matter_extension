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

namespace chip {
namespace app {
namespace Clusters {
namespace CookTop {

class CookTopEndpoint
{
public:
    CookTopEndpoint(EndpointId endpointId) : mEndpointId(endpointId) {}

    /**
     * @brief Set On/Off state for the CookTop
     * @param state Desired On/Off state.
     *
     * Note: This helper writes the OnOff attribute to the CHIP attribute storage and
     * therefore must be invoked from the CHIP/DeviceLayer task context or while holding
     * the CHIP stack lock (DeviceLayer::PlatformMgr().LockChipStack()). Calling this
     * API from an arbitrary thread can cause asserts / crashes in the CHIP stack.
     * If you are not in the CHIP task, schedule work onto the CHIP task using
     * PlatformMgr().ScheduleWork(...) and call this helper from there.
     *
     * @return Returns Status::Success on success, or an error code on failure.
     */
    chip::Protocols::InteractionModel::Status SetOnOffState(bool state);

private:
    EndpointId mEndpointId = kInvalidEndpointId;
};

} // namespace CookTop

namespace CookSurface {

class CookSurfaceEndpoint
{
public:
    CookSurfaceEndpoint(EndpointId endpointId) : mEndpointId(endpointId) {}

    /**
     * @brief Set On/Off state for the CookSurface
     * @param state Desired On/Off state.
     *
     * Note: This helper writes the OnOff attribute to the CHIP attribute storage and
     * therefore must be invoked from the CHIP/DeviceLayer task context or while holding
     * the CHIP stack lock (DeviceLayer::PlatformMgr().LockChipStack()). Calling this
     * API from an arbitrary thread can cause asserts / crashes in the CHIP stack.
     * If you are not in the CHIP task, schedule work onto the CHIP task using
     * PlatformMgr().ScheduleWork(...) and call this helper from there.
     *
     * @return Returns Status::Success on success, or an error code on failure.
     */
    chip::Protocols::InteractionModel::Status SetOnOffState(bool state);

    /**
     * @brief Get the Endpoint ID.
     */
    EndpointId GetEndpointId() const { return mEndpointId; }

private:
    EndpointId mEndpointId = kInvalidEndpointId;
};

} // namespace CookSurface

} // namespace Clusters
} // namespace app
} // namespace chip
