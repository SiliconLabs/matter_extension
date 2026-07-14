/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
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
 * @brief CRTP override layer for `AppTask`.
 *
 * Each public entry point dispatches to a corresponding `Derived::*Impl()` hook.
 * The default `*Impl()` (declared private below) forwards to `AppTask`, so
 * `Derived` only needs to override the hooks whose behavior it wants to
 * customize.
 *
 * Customer code overrides these hooks in `CustomerAppTask`; see the app README
 * ("How to Override APIs").
 *
 * @tparam Derived The CRTP derived class (`CustomerAppTask`).
 */
template <typename Derived>
class AppTaskImpl : public AppTask
{
public:
    // Common AppTask bring up
    CHIP_ERROR AppInit() override { CRTP_OPTIONAL_DISPATCH(AppTaskImpl, Derived, AppInitImpl); }

    // Multi sensor specific initialization
    CHIP_ERROR InitSensorManager() { CRTP_OPTIONAL_DISPATCH(AppTaskImpl, Derived, InitSensorManagerImpl); }

    // Reads the current temperature and humidity from the sensor or simulation.
    CHIP_ERROR GetTemperatureAndHumidity(int16_t & temperature, uint16_t & humidity)
    {
        CRTP_OPTIONAL_DISPATCH_ARGS(AppTaskImpl, Derived, GetTemperatureAndHumidityImpl, temperature, humidity);
    }

    // Handle button press
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, ButtonEventHandlerImpl, button, btnAction);
    }

    // Application-button event handler, toggles OccupancySensing::Occupancy
    static void ProcessButtonEvent(AppEvent * aEvent)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, ProcessButtonEventImpl, aEvent);
    }

    // chip::System::Layer timer handler, reads sensor values and updates measurement clusters
    static void TriggerSensorAction(chip::System::Layer * aLayer, void * aAppState)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, TriggerSensorActionImpl, aLayer, aAppState);
    }

    // Asynchronous event handler, drives occupancy LED and refreshes LCD on occupancy change
    static void OccupancyAttributeUpdateEvent(AppEvent * aEvent)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, OccupancyAttributeUpdateEventImpl, aEvent);
    }

    // Asynchronous event handler, refreshes sensor LCD on temperature / humidity change
    static void SensorAttributeUpdateEvent(AppEvent * aEvent)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, SensorAttributeUpdateEventImpl, aEvent);
    }

    // AttributeChangeListener hook, posts application events on cluster attribute changes
    void OnAttributeChanged(const chip::app::ConcreteAttributePath & path, chip::app::DataModel::AttributeChangeType type) override
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, OnAttributeChangedImpl, path, type);
    }

    // Data model hook invoked when a cluster attribute changes
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, DMPostAttributeChangeCallbackImpl, attributePath, type, size, value);
    }

private:
    friend Derived;

    // Default *Impl() hooks, each forwards to the matching AppTask method.
    // Override the corresponding hook in CustomerAppTask to customize behavior.

    CHIP_ERROR AppInitImpl() { return AppTask::AppInit(); }

    CHIP_ERROR InitSensorManagerImpl() { return AppTask::InitSensorManager(); }

    CHIP_ERROR GetTemperatureAndHumidityImpl(int16_t & temperature, uint16_t & humidity)
    {
        return AppTask::GetTemperatureAndHumidity(temperature, humidity);
    }

    void ButtonEventHandlerImpl(uint8_t button, uint8_t btnAction) { AppTask::ButtonEventHandler(button, btnAction); }

    void ProcessButtonEventImpl(AppEvent * aEvent) { AppTask::ProcessButtonEvent(aEvent); }

    void TriggerSensorActionImpl(chip::System::Layer * aLayer, void * aAppState)
    {
        AppTask::TriggerSensorAction(aLayer, aAppState);
    }

    void OccupancyAttributeUpdateEventImpl(AppEvent * aEvent) { AppTask::OccupancyAttributeUpdateEvent(aEvent); }

    void SensorAttributeUpdateEventImpl(AppEvent * aEvent) { AppTask::SensorAttributeUpdateEvent(aEvent); }

    void OnAttributeChangedImpl(const chip::app::ConcreteAttributePath & path, chip::app::DataModel::AttributeChangeType type)
    {
        AppTask::OnAttributeChanged(path, type);
    }

    void DMPostAttributeChangeCallbackImpl(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                           uint8_t * value)
    {
        AppTask::DMPostAttributeChangeCallback(attributePath, type, size, value);
    }
};
