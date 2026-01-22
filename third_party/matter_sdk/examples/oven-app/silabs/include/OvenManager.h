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
 * @class OvenManager
 * @brief Manages the initialization and operations related to oven,
 *        temperature controlled cabinet, cook top, and cook surface endpoints
 *        in the application.
 *
 * @note This class is part of the oven application example
 */

#pragma once

#include "AppSupportedTemperatureLevelsDelegate.h"
#include "CookEndpoints.h"
#include "OvenEndpoint.h"

#include "AppEvent.h"

#include <app-common/zap-generated/ids/Attributes.h>
#include <app/clusters/mode-base-server/mode-base-cluster-objects.h>
#include <app/clusters/on-off-server/on-off-server.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/TypeTraits.h>
#include <platform/CHIPDeviceLayer.h>

class OvenManager
{

public:
    enum Action_t
    {
        COOK_TOP_ON_ACTION = 0,
        COOK_TOP_OFF_ACTION,
        OVEN_MODE_UPDATE_ACTION,

        INVALID_ACTION
    } Action;

    /**
     * @brief Initializes the OvenManager and its associated resources.
     *
     */
    void Init();

    /**
     * @brief Returns the singleton instance of the OvenManager.
     *
     * @return Reference to the singleton OvenManager instance.
     */
    static OvenManager & GetInstance() { return sOvenMgr; }

    CHIP_ERROR SetCookSurfaceInitialState(chip::EndpointId cookSurfaceEndpoint);

    CHIP_ERROR SetTemperatureControlledCabinetInitialState(chip::EndpointId temperatureControlledCabinetEndpoint);

    /**
     * @brief Handles on/off attribute changes.
     *
     * @param endpointId The ID of the endpoint.
     * @param attributeId The ID of the attribute.
     * @param value Pointer to the new value.
     * @param size Size of the new value.
     */
    void OnOffAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value, uint16_t size);

    /**
     * @brief Handles oven mode attribute changes.
     *
     * @param endpointId The ID of the endpoint.
     * @param attributeId The ID of the attribute.
     * @param value Pointer to the new value.
     * @param size Size of the new value.
     */
    void OvenModeAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value, uint16_t size);

    /**
     * @brief Checks if a transition between two oven modes is blocked.
     *
     * @param fromMode The current mode.
     * @param toMode The desired mode.
     * @return True if the transition is blocked, false otherwise.
     */
    bool IsTransitionBlocked(uint8_t fromMode, uint8_t toMode);

    /**
     * @brief Gets the current state of the CookTop.
     *
     * @return true if CookTop is On, false if Off
     */
    bool GetCookTopState() const { return mIsCookTopOn; }

    /**
     * @brief Gets the current oven mode.
     */
    uint8_t GetCurrentOvenMode() const { return mCurrentOvenMode; }

    /**
     * @brief Get the endpoint ID for the CookTop endpoint
     */
    static constexpr chip::EndpointId GetCookTopEndpoint() { return kCookTopEndpoint; }

private:
    static constexpr uint8_t kBlockedTransitionCount = 3; // Number of blocked transitions
    struct BlockedTransition
    {
        uint8_t fromMode;
        uint8_t toMode;
    };

    // Disallowed OvenMode Transitions.
    static constexpr BlockedTransition kBlockedTransitions[kBlockedTransitionCount] = {
        { chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeGrill),
          chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeProofing) },
        { chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeProofing),
          chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeClean) },
        { chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeClean),
          chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeBake) },
    };

    static OvenManager sOvenMgr;
    chip::app::Clusters::AppSupportedTemperatureLevelsDelegate mTemperatureControlDelegate;

    // Default values for the states of the endpoints
    bool mIsCookTopOn      = false;
    bool mIsCookSurface1On = false;
    bool mIsCookSurface2On = false;
    // Default value for the current oven mode
    uint8_t mCurrentOvenMode =
        chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeBake);

    // Define the endpoint ID constants
    static constexpr chip::EndpointId kOvenEndpoint                         = 1;
    static constexpr chip::EndpointId kTemperatureControlledCabinetEndpoint = 2;
    static constexpr chip::EndpointId kCookTopEndpoint                      = 3;
    static constexpr chip::EndpointId kCookSurfaceEndpoint1                 = 4;
    static constexpr chip::EndpointId kCookSurfaceEndpoint2                 = 5;

    chip::app::Clusters::Oven::OvenEndpoint mOvenEndpoint;
    chip::app::Clusters::TemperatureControlledCabinet::TemperatureControlledCabinetEndpoint mTemperatureControlledCabinetEndpoint{
        kTemperatureControlledCabinetEndpoint
    };
    chip::app::Clusters::CookTop::CookTopEndpoint mCookTopEndpoint{ kCookTopEndpoint };
    chip::app::Clusters::CookSurface::CookSurfaceEndpoint mCookSurfaceEndpoint1{ kCookSurfaceEndpoint1 };
    chip::app::Clusters::CookSurface::CookSurfaceEndpoint mCookSurfaceEndpoint2{ kCookSurfaceEndpoint2 };
};
