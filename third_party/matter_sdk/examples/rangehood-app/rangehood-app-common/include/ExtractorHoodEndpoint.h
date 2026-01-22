/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
 *    Copyright (c) 2025 Google LLC.
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

#include <stdbool.h>
#include <stdint.h>

#include <app/clusters/fan-control-server/fan-control-server.h>
#include <app/data-model/Nullable.h>
#include <lib/core/CHIPError.h>
#include <lib/core/DataModelTypes.h>

class ExtractorHoodEndpoint
{
public:
    /**
     * @brief Construct the ExtractorHood endpoint.
     * @param endpointId   The endpoint ID
     * @param lowPercent   Percent value for Low mode (default: 30)
     * @param mediumPercent Percent value for Medium mode (default: 60)
     * @param highPercent  Percent value for High/On mode (default: 100)
     *
     * Off is always 0 per spec: "The value 0 SHALL map to Off and be its own range".
     */
    ExtractorHoodEndpoint(chip::EndpointId endpointId, chip::Percent lowPercent = 30, chip::Percent mediumPercent = 60,
                          chip::Percent highPercent = 100) :
        mEndpointId(endpointId),
        mFanModeOffPercent(0), mFanModeLowPercent(lowPercent), mFanModeMediumPercent(mediumPercent),
        mFanModeHighPercent(highPercent)
    {}

    /**
     * @brief Initialize the ExtractorHood endpoint runtime state.
     * Reads current PercentSetting and synchronizes PercentCurrent.
     *
     * @note Must be called after construction and after the Matter stack is initialized.
     * @return CHIP_NO_ERROR on success, error code otherwise
     */
    CHIP_ERROR Init();

    chip::app::DataModel::Nullable<chip::Percent> GetPercentSetting() const;

    /**
     * @brief Get the FanMode attribute.
     * @return CHIP_ERROR on failure, CHIP_NO_ERROR on success
     */
    CHIP_ERROR GetFanMode(chip::app::Clusters::FanControl::FanModeEnum & fanMode) const;

    /** @brief Set the PercentCurrent attribute if it differs from the current value.
     * @return CHIP_ERROR on failure, CHIP_NO_ERROR on success
     */
    CHIP_ERROR SetPercentCurrent(chip::Percent newPercentSetting);

    /**
     * @brief Handle percent setting change and update percent current accordingly
     * @param newPercentSetting The new percent setting value
     * @return CHIP_ERROR on failure, CHIP_NO_ERROR on success
     */
    CHIP_ERROR HandlePercentSettingChange(chip::Percent newPercentSetting);

    /**
     * @brief Handle fan mode change and update percent current accordingly
     * @param newFanMode The new fan mode to apply
     * @return CHIP_ERROR on failure, CHIP_NO_ERROR on success
     */
    CHIP_ERROR HandleFanModeChange(chip::app::Clusters::FanControl::FanModeEnum newFanMode);

    /**
     * @brief Update the FanMode attribute
     * @return CHIP_ERROR on failure, CHIP_NO_ERROR on success
     */
    CHIP_ERROR UpdateFanModeAttribute(chip::app::Clusters::FanControl::FanModeEnum newFanMode);

    /**
     * @brief Toggle fan mode between Off and High
     * @return CHIP_ERROR on failure, CHIP_NO_ERROR on success
     */
    CHIP_ERROR ToggleFanMode();

private:
    chip::EndpointId mEndpointId = chip::kInvalidEndpointId;

    // Fan Mode Percent Mappings (set during initialization)
    chip::Percent mFanModeOffPercent;
    chip::Percent mFanModeLowPercent;
    chip::Percent mFanModeMediumPercent;
    chip::Percent mFanModeHighPercent;
};
