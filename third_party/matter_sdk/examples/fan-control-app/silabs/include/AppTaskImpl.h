/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
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
 * @brief CRTP base for fan-control AppTask, exposing override hooks for customizable APIs.
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
    // Common AppTask bring up
    CHIP_ERROR AppInit() override { CRTP_OPTIONAL_DISPATCH(AppTaskImpl, Derived, AppInitImpl); }

    // Fan control specific initialization
    CHIP_ERROR InitFanControl() { CRTP_OPTIONAL_DISPATCH(AppTaskImpl, Derived, InitFanControlImpl); }

    // Handle the Fan Control Step command
    Status HandleStep(StepDirectionEnum aDirection, bool aWrap, bool aLowestOff) override
    {
        CRTP_OPTIONAL_DISPATCH_ARGS(AppTaskImpl, Derived, HandleStepImpl, aDirection, aWrap, aLowestOff);
    }

    // Handle button press
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, ButtonEventHandlerImpl, button, btnAction);
    }

    // AppTask thread event handler that updates the fan UI
    static void FanUiUpdateEventHandler(AppEvent * aEvent)
    {
        CRTP_OPTIONAL_STATIC_DISPATCH(AppTaskImpl, Derived, FanUiUpdateEventHandlerImpl, aEvent);
    }

    // Handle FanMode attribute changes
    void HandleFanModeChange(FanModeEnum aNewFanMode)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, HandleFanModeChangeImpl, aNewFanMode);
    }

    // Handle PercentSetting attribute changes
    void HandlePercentSettingChange(uint8_t aNewPercentSetting)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, HandlePercentSettingChangeImpl, aNewPercentSetting);
    }

    // Handle SpeedSetting attribute changes
    void HandleSpeedSettingChange(uint8_t aNewSpeedSetting)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, HandleSpeedSettingChangeImpl, aNewSpeedSetting);
    }

    // Data model hook invoked when a cluster attribute changes
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
        uint8_t * value)
    {
        CRTP_OPTIONAL_VOID_DISPATCH(AppTaskImpl, Derived, DMPostAttributeChangeCallbackImpl, attributePath, type, size, value);
    }

private:
    friend Derived;

    CHIP_ERROR AppInitImpl() { return AppTask::AppInit(); }

    CHIP_ERROR InitFanControlImpl() { return AppTask::InitFanControl(); }

    Status HandleStepImpl(StepDirectionEnum aDirection, bool aWrap, bool aLowestOff)
    {
        return AppTask::HandleStep(aDirection, aWrap, aLowestOff);
    }

    void ButtonEventHandlerImpl(uint8_t button, uint8_t btnAction) { AppTask::ButtonEventHandler(button, btnAction); }

    void FanUiUpdateEventHandlerImpl(AppEvent * aEvent) { AppTask::FanUiUpdateEventHandler(aEvent); }

    void HandleFanModeChangeImpl(FanModeEnum aNewFanMode) { AppTask::HandleFanModeChange(aNewFanMode); }

    void HandlePercentSettingChangeImpl(uint8_t aNewPercentSetting)
    {
        AppTask::HandlePercentSettingChange(aNewPercentSetting);
    }

    void HandleSpeedSettingChangeImpl(uint8_t aNewSpeedSetting) { AppTask::HandleSpeedSettingChange(aNewSpeedSetting); }

    void DMPostAttributeChangeCallbackImpl(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                           uint8_t * value)
    {
        AppTask::DMPostAttributeChangeCallback(attributePath, type, size, value);
    }
};
