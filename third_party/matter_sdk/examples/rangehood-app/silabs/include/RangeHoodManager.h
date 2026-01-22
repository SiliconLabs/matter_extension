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

/*
 * @class RangeHoodManager
 * @brief Manages the initialization and operations related to range hood
 *        extractor hood and light endpoints in the application.
 *
 * @note This class is part of the range hood application example
 */

#pragma once

#include "ExtractorHoodEndpoint.h"
#include "LightEndpoint.h"

#include "AppEvent.h"

#include <app-common/zap-generated/ids/Attributes.h>
#include <app/clusters/fan-control-server/fan-control-server.h>

class RangeHoodManager
{
public:
    enum Action_t
    {
        LIGHT_ON_ACTION = 0,
        LIGHT_OFF_ACTION,
        FAN_PERCENT_CHANGE_ACTION,
        FAN_MODE_CHANGE_ACTION,

        INVALID_ACTION
    } Action;

    RangeHoodManager() = default;

    /**
     * @brief Handles FanControl attribute changes.
     * @param endpointId The ID of the endpoint.
     * @param attributeId The ID of the attribute.
     * @param value Pointer to the new value.
     * @param size Size of the new value.
     */
    void FanControlAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value,
                                          uint16_t size);

    /**
     * @brief Handles on/off attribute changes.
     * @param endpointId The ID of the endpoint.
     * @param attributeId The ID of the attribute.
     * @param value Pointer to the new value.
     * @param size Size of the new value.
     */
    void OnOffAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value, uint16_t size);

    /**
     * @brief Get reference to the ExtractorHood endpoint object
     * @return Reference to ExtractorHoodEndpoint
     */
    ExtractorHoodEndpoint & GetExtractorHoodEndpoint() { return mExtractorHoodEndpoint; }

    /**
     * @brief Get reference to the Light endpoint object
     * @return Reference to LightEndpoint
     */
    LightEndpoint & GetLightEndpoint() { return mLightEndpoint; }

    /**
     * @brief Returns the singleton instance of the RangeHoodManager.
     *
     * @return Reference to the singleton RangeHoodManager instance.
     */
    static RangeHoodManager & GetInstance() { return sRangeHoodMgr; }

    /**
     * @brief Initializes the RangeHoodManager and its associated resources.
     *
     */
    CHIP_ERROR Init();

private:
    friend RangeHoodManager & RangeHoodMgr(void);

    static RangeHoodManager sRangeHoodMgr;

    // Define the endpoint IDs for the RangeHood
    static constexpr chip::EndpointId kExtractorHoodEndpoint = 1;
    static constexpr chip::EndpointId kLightEndpoint         = 2;

    ExtractorHoodEndpoint mExtractorHoodEndpoint{ kExtractorHoodEndpoint, 30, 60, 100 }; // Low=30%, Med=60%, High=100%
    LightEndpoint mLightEndpoint{ kLightEndpoint };
};

inline RangeHoodManager & RangeHoodMgr(void)
{
    return RangeHoodManager::sRangeHoodMgr;
}
