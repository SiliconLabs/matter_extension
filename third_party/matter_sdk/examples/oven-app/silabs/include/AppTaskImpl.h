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

#include "AppTask.h"
#include "CRTPHelpers.h"

/**
 * @brief CRTP base for oven AppTask, exposing override hooks for customizable APIs.
 *
 * Each public method dispatches to `Derived::*Impl()`. Overrides are optional: default
 * `*Impl()` implementations in the private section forward to `AppTask`. Override in
 * `Derived` only for the behaviors you want to customize.
 *
 * @tparam Derived The derived class type (CRTP pattern)
 */
template <typename Derived>
class AppTaskImpl : public AppTask
{
public:
    CHIP_ERROR AppInit() override { CRTP_OPTIONAL_DISPATCH(AppTaskImpl, Derived, AppInitImpl); }

    // Platform button callback, posts oven or base application events.
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, ButtonEventHandlerImpl, button, btnAction);
    }

    // PB1 button handler, toggles cooktop and cook surface states.
    static void OvenButtonHandler(AppEvent * aEvent)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, OvenButtonHandlerImpl, aEvent);
    }

    // Updates LED and display for queued oven action events.
    static void OvenActionHandler(AppEvent * aEvent)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, OvenActionHandlerImpl, aEvent);
    }

    // Platform event handler, propagates CookTop Off to bound peers after reboot.
    static void ConnectivityEventHandler(const chip::DeviceLayer::ChipDeviceEvent * event, intptr_t arg)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, ConnectivityEventHandlerImpl, event, arg);
    }

    // Schedules binding manager initialization on the Matter thread.
    static void InitBindingHandler(intptr_t arg)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, InitBindingHandlerImpl, arg);
    }

    // Propagates CookTop OnOff state to bound OnOff and FanControl peers.
    static void CookTopBindingPropagateState(chip::EndpointId cookTopEndpoint, bool cookTopOn)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, CookTopBindingPropagateStateImpl, cookTopEndpoint, cookTopOn);
    }

    // Binding manager callback, propagates CookTop state changes per bound device.
    static void BoundDeviceChangedHandler(const chip::app::Clusters::Binding::TableEntry & binding,
                                          chip::OperationalDeviceProxy * peerDevice, void * context)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, BoundDeviceChangedHandlerImpl, binding, peerDevice, context);
    }

    // Matter stack callback after a server attribute write, routes OnOff updates.
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, DMPostAttributeChangeCallbackImpl, attributePath, type, size, value);
    }

    // AttributeChangeListener hook, filters OvenMode::CurrentMode changes.
    void OnAttributeChanged(const chip::app::ConcreteAttributePath & path, chip::app::DataModel::AttributeChangeType type) override
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, OnAttributeChangedImpl, path, type);
    }

    // Data model hook invoked when the OvenMode cluster server is initialized.
    void DMOvenModeClusterInitCallback(chip::EndpointId endpointId)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, DMOvenModeClusterInitCallbackImpl, endpointId);
    }

    // Data model hook invoked when the OvenMode cluster server is shut down.
    void DMOvenModeClusterShutdownCallback(chip::EndpointId endpointId, MatterClusterShutdownType shutdownType)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, DMOvenModeClusterShutdownCallbackImpl, endpointId, shutdownType);
    }

    // Initializes oven endpoints, temperature levels, and binding.
    CHIP_ERROR InitOven() { CRTP_OPTIONAL_DISPATCH(AppTaskImpl, Derived, InitOvenImpl); }

    // Updates cooktop/cook surface state and queues LED/LCD updates on OnOff changes.
    void OnOffAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value,
                                     uint16_t size)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, OnOffAttributeChangeHandlerImpl, endpointId, attributeId, value, size);
    }

    // Checks whether a transition between two oven modes is blocked.
    bool IsTransitionBlocked(uint8_t fromMode, uint8_t toMode) override
    {
        CRTP_OPTIONAL_DISPATCH_ARGS(AppTaskImpl, Derived, IsTransitionBlockedImpl, fromMode, toMode);
    }

private:
    friend Derived;

    // Default *Impl() hooks, each forwards to the matching AppTask method
    // Override the corresponding hook in CustomerAppTask to customize behavior

    CHIP_ERROR AppInitImpl() { return AppTask::AppInit(); }

    void ButtonEventHandlerImpl(uint8_t button, uint8_t btnAction) { AppTask::ButtonEventHandler(button, btnAction); }

    void OvenButtonHandlerImpl(AppEvent * aEvent) { AppTask::OvenButtonHandler(aEvent); }

    void OvenActionHandlerImpl(AppEvent * aEvent) { AppTask::OvenActionHandler(aEvent); }

    void ConnectivityEventHandlerImpl(const chip::DeviceLayer::ChipDeviceEvent * event, intptr_t arg)
    {
        AppTask::ConnectivityEventHandler(event, arg);
    }

    void InitBindingHandlerImpl(intptr_t arg) { AppTask::InitBindingHandler(arg); }

    void CookTopBindingPropagateStateImpl(chip::EndpointId cookTopEndpoint, bool cookTopOn)
    {
        AppTask::CookTopBindingPropagateState(cookTopEndpoint, cookTopOn);
    }

    void BoundDeviceChangedHandlerImpl(const chip::app::Clusters::Binding::TableEntry & binding,
                                       chip::OperationalDeviceProxy * peerDevice, void * context)
    {
        AppTask::BoundDeviceChangedHandler(binding, peerDevice, context);
    }

    void DMPostAttributeChangeCallbackImpl(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                           uint8_t * value)
    {
        AppTask::DMPostAttributeChangeCallback(attributePath, type, size, value);
    }

    CHIP_ERROR InitOvenImpl() { return AppTask::InitOven(); }

    void OnOffAttributeChangeHandlerImpl(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value,
                                         uint16_t size)
    {
        AppTask::OnOffAttributeChangeHandler(endpointId, attributeId, value, size);
    }

    void OnAttributeChangedImpl(const chip::app::ConcreteAttributePath & path, chip::app::DataModel::AttributeChangeType type)
    {
        AppTask::OnAttributeChanged(path, type);
    }

    void DMOvenModeClusterInitCallbackImpl(chip::EndpointId endpointId)
    {
        AppTask::DMOvenModeClusterInitCallback(endpointId);
    }

    void DMOvenModeClusterShutdownCallbackImpl(chip::EndpointId endpointId, MatterClusterShutdownType shutdownType)
    {
        AppTask::DMOvenModeClusterShutdownCallback(endpointId, shutdownType);
    }

    bool IsTransitionBlockedImpl(uint8_t fromMode, uint8_t toMode) { return AppTask::IsTransitionBlocked(fromMode, toMode); }
};
