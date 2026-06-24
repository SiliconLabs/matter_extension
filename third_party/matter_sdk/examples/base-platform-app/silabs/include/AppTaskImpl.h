/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
 *    Copyright (c) 2019 Google LLC.
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
 * @brief CRTP override layer for `AppTask` on the Silabs platform template app.
 *
 * Each public entry point dispatches to a corresponding `Derived::*Impl()` hook.
 * Default `*Impl()` methods (private below) forward to `AppTask`, so `Derived`
 * only overrides the hooks it needs.
 *
 * Customer code overrides these hooks in `CustomerAppTask`; see the lighting-app
 * Silabs README ("How to Override APIs") for the same pattern.
 *
 * @tparam Derived The CRTP derived class (`CustomerAppTask`).
 */
template <typename Derived>
class AppTaskImpl : public AppTask
{
public:
    // Common AppTask bring up
    CHIP_ERROR AppInit() override { CRTP_OPTIONAL_DISPATCH(AppTaskImpl, Derived, AppInitImpl); }

    // Handle button press
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, ButtonEventHandlerImpl, button, btnAction);
    }

    // AppTask thread event handler
    static void ApplicationEventHandler(AppEvent * aEvent)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, ApplicationEventHandlerImpl, aEvent);
    }

#if defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER
    // ICD lifecycle hooks invoked by the ICD manager
    // Override to react to power mode transitions
    void OnEnterActiveMode() override
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, OnEnterActiveModeImpl);
    }

    void OnEnterIdleMode() override { CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, OnEnterIdleModeImpl); }

    void OnTransitionToIdle() override { CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, OnTransitionToIdleImpl); }

    void OnICDModeChange() override { CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, OnICDModeChangeImpl); }
#endif // defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER

private:
    friend Derived;

    // Default *Impl() hooks, each forwards to the matching AppTask method
    // Override the corresponding hook in CustomerAppTask to customize behavior

    CHIP_ERROR AppInitImpl() { return AppTask::AppInit(); }

    void ButtonEventHandlerImpl(uint8_t button, uint8_t btnAction) { AppTask::ButtonEventHandler(button, btnAction); }

    void ApplicationEventHandlerImpl(AppEvent * aEvent) { AppTask::ApplicationEventHandler(aEvent); }

#if defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER
    // Default ICD power mode hooks: forward to the AppTask::*Default() behavior
    void OnEnterActiveModeImpl() { AppTask::OnEnterActiveModeDefault(); }

    void OnEnterIdleModeImpl() { AppTask::OnEnterIdleModeDefault(); }

    void OnTransitionToIdleImpl() { AppTask::OnTransitionToIdleDefault(); }

    void OnICDModeChangeImpl() { AppTask::OnICDModeChangeDefault(); }
#endif // defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER
};
