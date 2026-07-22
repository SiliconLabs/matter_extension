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

/**********************************************************
 * Includes
 *********************************************************/

#include <stdbool.h>
#include <stdint.h>

#include "AppEvent.h"
#include "BaseApplication.h"
#include "CookEndpoints.h"
#include "OvenEndpoint.h"

#include "FreeRTOS.h"
#include "timers.h" // provides FreeRTOS timer support
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/ConcreteAttributePath.h>
#include <app/clusters/bindings/BindingManager.h>
#include <app/data-model-provider/AttributeChangeListener.h>
#include <app/util/af-types.h>
#include <app/clusters/mode-base-server/mode-base-cluster-objects.h>
#include <app/clusters/on-off-server/on-off-server.h>
#include <app/clusters/temperature-control-server/supported-temperature-levels-manager.h>
#include <ble/BLEEndPoint.h>
#include <lib/core/CHIPError.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/Span.h>
#include <lib/support/TypeTraits.h>
#include <platform/CHIPDeviceLayer.h>

/**********************************************************
 * Defines
 *********************************************************/

// Application-defined error codes in the CHIP_ERROR space.
#define APP_ERROR_EVENT_QUEUE_FAILED CHIP_APPLICATION_ERROR(0x01)
#define APP_ERROR_CREATE_TASK_FAILED CHIP_APPLICATION_ERROR(0x02)
#define APP_ERROR_UNHANDLED_EVENT CHIP_APPLICATION_ERROR(0x03)
#define APP_ERROR_CREATE_TIMER_FAILED CHIP_APPLICATION_ERROR(0x04)
#define APP_ERROR_START_TIMER_FAILED CHIP_APPLICATION_ERROR(0x05)
#define APP_ERROR_STOP_TIMER_FAILED CHIP_APPLICATION_ERROR(0x06)

/**
 * @brief Data needed to propagate a CookTop state change to a single bound cluster
 *        (OnOff on the RangeHood Light endpoint or FanControl on the Extractor Hood endpoint).
 *        A separate context is allocated per cluster in CookTopBindingPropagateState(); on
 *        success ownership transfers to the binding manager and it is freed via the
 *        context-release handler.
 */
struct CookTopBindingContext
{
    chip::EndpointId localEndpointId;
    chip::ClusterId clusterId;
    bool cookTopOn;
};

/**********************************************************
 * AppTask Declaration
 *********************************************************/

/**
 * @class AppTask
 * @brief Manages oven application lifecycle, endpoints, cooktop binding, and UI state.
 *
 * Owns initialization and operations for the oven, temperature-controlled cabinet,
 * cook top, and cook surface endpoints. Serves as the shared temperature-levels
 * delegate for cook surface endpoints and listens for OvenMode attribute changes
 * via DataModel::AttributeChangeListener.
 */
class AppTask : public BaseApplication,
                public chip::app::DataModel::AttributeChangeListener,
                public chip::app::Clusters::TemperatureControl::SupportedTemperatureLevelsIteratorDelegate
{

public:
    /** @brief Oven action identifiers posted to the AppTask event queue. */
    enum Action_t
    {
        COOK_TOP_ON_ACTION = 0,
        COOK_TOP_OFF_ACTION,
        OVEN_MODE_UPDATE_ACTION,

        INVALID_ACTION
    };

    AppTask() = default;

    /** @brief Returns the active app instance. */
    static AppTask & GetAppTask();

    /**
     * @brief AppTask task main loop function
     *
     * @param pvParameter FreeRTOS task parameter
     */
    static void AppTaskMain(void * pvParameter);

    /** @brief Creates and starts the AppTask thread. */
    CHIP_ERROR StartAppTask();

    /**
     * @brief Event handler when a button is pressed
     * Function posts an event for button processing
     *
     * @param buttonHandle APP_FUNCTION_BUTTON
     * @param btnAction button action - SL_SIMPLE_BUTTON_PRESSED,
     *                  SL_SIMPLE_BUTTON_RELEASED or SL_SIMPLE_BUTTON_DISABLED
     */
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction);

    /**
     * @brief PB1 Button event processing function for oven functionality
     *        Press and release will toggle cooktop and cook surface states
     *
     * @param aEvent button event being processed
     */
    static void OvenButtonHandler(AppEvent * aEvent);

    /**
     * @brief Handle oven-related AppEvents to update UI and LEDs.
     *
     * @param aEvent Oven Event to process
     */
    static void OvenActionHandler(AppEvent * aEvent);

    /**
     * @brief After reboot, send CookTop Off to bound rangehood peers once IP and DNS-SD are ready.
     */
    static void ConnectivityEventHandler(const chip::DeviceLayer::ChipDeviceEvent * event, intptr_t arg);

    /**
     * @brief Data model hook invoked after a cluster attribute changes; routes OnOff changes
     *        and logs Identify/TemperatureControl changes.
     */
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value);

    /**
     * @brief AttributeChangeListener hook invoked after a cluster attribute changes.
     *        Filters OvenMode::CurrentMode on the temperature-controlled cabinet endpoint.
     */
    void OnAttributeChanged(const chip::app::ConcreteAttributePath & path,
                            chip::app::DataModel::AttributeChangeType type) override;

    /**
     * @brief Updates cached oven mode and posts OVEN_MODE_UPDATE_ACTION to OvenActionHandler.
     *
     * @param newMode The new oven mode value.
     */
    void HandleOvenModeChanged(uint8_t newMode);

    /**
     * @brief Data model hook invoked when the OvenMode cluster server is initialized.
     */
    void DMOvenModeClusterInitCallback(chip::EndpointId endpointId);

    /**
     * @brief Data model hook invoked when the OvenMode cluster server is shut down.
     */
    void DMOvenModeClusterShutdownCallback(chip::EndpointId endpointId, MatterClusterShutdownType shutdownType);

    /**
     * @brief Schedules initialization of the binding manager on the Matter thread.
     */
    static void InitBindingHandler(intptr_t arg);

    /**
     * @brief Propagate the CookTop OnOff state to bound OnOff and FanControl peers.
     */
    static void CookTopBindingPropagateState(chip::EndpointId cookTopEndpoint, bool cookTopOn);

    /**
     * @brief Sends an OnOff cluster command to a bound peer to mirror CookTop state.
     */
    static void ProcessOnOffUnicast(bool cookTopOn, const chip::app::Clusters::Binding::TableEntry & binding,
                                   chip::Messaging::ExchangeManager * exchangeMgr, const chip::SessionHandle & sessionHandle);

    /**
     * @brief Writes the FanControl FanMode attribute on a bound peer to mirror CookTop state.
     */
    static void ProcessFanControlUnicast(bool cookTopOn, const chip::app::Clusters::Binding::TableEntry & binding,
                                       const chip::SessionHandle & sessionHandle);

    /**
     * @brief Binding manager callback invoked per bound device to propagate a CookTop state change.
     */
    static void BoundDeviceChangedHandler(const chip::app::Clusters::Binding::TableEntry & binding,
                                          chip::OperationalDeviceProxy * peerDevice, void * context);

    /** @brief Oven-specific initialization (endpoints, temperature levels, binding). */
    CHIP_ERROR InitOven();

    /**
     * @brief Sets the initial temperature-measurement value and range for a CookSurface endpoint
     *        from the TemperatureControlledCabinet min/max temperature.
     *
     * @param cookSurfaceEndpoint Endpoint to initialize.
     */
    CHIP_ERROR SetCookSurfaceInitialState(chip::EndpointId cookSurfaceEndpoint);

    /**
     * @brief Sets the initial temperature setpoint for the TemperatureControlledCabinet endpoint
     *        to its minimum supported temperature.
     *
     * @param temperatureControlledCabinetEndpoint Endpoint to initialize.
     */
    CHIP_ERROR SetTemperatureControlledCabinetInitialState(chip::EndpointId temperatureControlledCabinetEndpoint);

    /** @brief Force CookTop and CookSurface OnOff attributes to Off at startup. */
    void EnforceCookTopOffAtStartup();

    /**
     * @brief Handles OnOff cluster attribute changes.
     *
     * @param endpointId The ID of the endpoint.
     * @param attributeId The ID of the attribute.
     * @param value Pointer to the new value.
     * @param size Size of the new value.
     */
    void OnOffAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value,
                                     uint16_t size);

    /**
     * @brief Checks if a transition between two oven modes is blocked.
     *
     * Virtual so oven-app-common can call through `AppTask::GetAppTask()`.
     *
     * @param fromMode The current mode.
     * @param toMode The desired mode.
     * @return True if the transition is blocked, false otherwise.
     */
    virtual bool IsTransitionBlocked(uint8_t fromMode, uint8_t toMode);

    bool GetCookTopState() const { return mIsCookTopOn; }

    uint8_t GetCurrentOvenMode() const { return mCurrentOvenMode; }

    static constexpr chip::EndpointId GetCookTopEndpoint() { return kCookTopEndpoint; }

    /** @brief Fixed number of CookSurface endpoints served by the temperature-levels delegate. */
    static constexpr size_t kNumCookSurfaceEndpoints = 2;
    /** @brief Number of supported temperature levels (Low, Medium, High). */
    static constexpr size_t kNumTemperatureLevels    = 3;

    /**
     * @brief Register supported temperature level strings for a given endpoint.
     *
     * The caller supplies an array of CharSpan entries whose lifetime exceeds that of this delegate.
     *
     * @return CHIP_NO_ERROR on success,
     *         CHIP_ERROR_NO_MEMORY if capacity exceeded,
     *         CHIP_ERROR_ENDPOINT_EXISTS if duplicate endpoint provided.
     */
    CHIP_ERROR RegisterSupportedLevels(chip::EndpointId endpoint, const chip::CharSpan * levels, uint8_t levelCount);

    // Prototypes from inherited TemperatureControl::SupportedTemperatureLevelsIteratorDelegate interface

    /** @brief Returns the number of supported temperature levels for the active endpoint. */
    uint8_t Size() override;
    /** @brief Returns the next supported temperature level label for the active endpoint. */
    CHIP_ERROR Next(chip::MutableCharSpan & item) override;

protected:
    /**
     * @brief Override of BaseApplication::AppInit() virtual method, called by BaseApplication::Init()
     *
     * @return CHIP_ERROR
     */
    CHIP_ERROR AppInit() override;

    /**
     * @brief Updates the cluster state for button actions
     *
     * The context parameter contains the desired OnOff state encoded as an intptr_t
     * (0 == Off, non-zero == On). This value is provided by the caller via
     * PlatformMgr().ScheduleWork. The worker will set the OnOff attribute to
     * this boolean value.
     *
     * @param context bool value encoded as intptr_t
     */
    static void UpdateClusterState(intptr_t context);

private:
    /**
     * @brief Endpoint to temperature levels mapping. The endpoint must have a temperature control cluster.
     */
    struct EndpointPair
    {
        chip::EndpointId mEndpointId               = chip::kInvalidEndpointId;
        const chip::CharSpan * mTemperatureLevels = nullptr;
        uint8_t mSize                              = 0;

        EndpointPair() = default;
        EndpointPair(chip::EndpointId aEndpointId, const chip::CharSpan * aTemperatureLevels, uint8_t aSize) :
            mEndpointId(aEndpointId), mTemperatureLevels(aTemperatureLevels), mSize(aSize)
        {}
    };

    static constexpr uint8_t kBlockedTransitionCount = 3;
    struct BlockedTransition
    {
        uint8_t fromMode;
        uint8_t toMode;
    };

    static constexpr BlockedTransition kBlockedTransitions[kBlockedTransitionCount] = {
        { chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeGrill),
          chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeProofing) },
        { chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeProofing),
          chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeClean) },
        { chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeClean),
          chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeBake) },
    };

    EndpointPair supportedOptionsByEndpoints[kNumCookSurfaceEndpoints];
    size_t mRegisteredEndpointCount = 0;

    bool mAttributeListenerRegistered = false;
    bool mIsCookTopOn                 = false;
    bool mIsCookSurface1On            = false;
    bool mIsCookSurface2On            = false;
    uint8_t mCurrentOvenMode =
    chip::to_underlying(chip::app::Clusters::TemperatureControlledCabinet::OvenModeDelegate::OvenModes::kModeBake);

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
