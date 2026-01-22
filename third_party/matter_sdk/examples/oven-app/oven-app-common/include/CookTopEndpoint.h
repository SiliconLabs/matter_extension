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
     * @brief Initialize the cooktop endpoint.
     *
     * @return returns CHIP_NO_ERROR on success, or an error code on failure.
     */
    CHIP_ERROR Init();

    void HandleOffCommand();

private:
    bool currentOnOffState = false;
    EndpointId mEndpointId = kInvalidEndpointId;
};

} // namespace CookTop
} // namespace Clusters
} // namespace app
} // namespace chip
