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

#include <stdbool.h>
#include <stdint.h>

#include "AppEvent.h"
#include "BaseApplication.h"

#include <app/ConcreteAttributePath.h>
#include <app/clusters/fan-control-server/fan-control-delegate.h>
#include <ble/Ble.h>
#include <cmsis_os2.h>
#include <lib/core/CHIPError.h>
#include <platform/CHIPDeviceLayer.h>
#include <protocols/interaction_model/StatusCode.h>

class AppTask : public BaseApplication, public chip::app::Clusters::FanControl::Delegate
{
public:
    // Bring frequently-used cluster types into class scope. Available to derived classes
    // (e.g. AppTaskImpl, CustomerAppTask) without re-qualification.
    using FanModeEnum       = chip::app::Clusters::FanControl::FanModeEnum;
    using Percent           = chip::Percent;
    using StepDirectionEnum = chip::app::Clusters::FanControl::StepDirectionEnum;
    using Status            = chip::Protocols::InteractionModel::Status;

    struct AttributeUpdateInfo
    {
        FanModeEnum fanMode;
        uint8_t speedCurrent;
        uint8_t percentCurrent;
        uint8_t speedSetting;
        uint8_t percentSetting;
        bool isPercentCurrent = false;
        bool isSpeedCurrent   = false;
        bool isSpeedSetting   = false;
        bool isFanMode        = false;
        bool isPercentSetting = false;
        chip::EndpointId endPoint;
    };

    AppTask();

    static AppTask & GetAppTask();

    /**
     * @brief AppTask task main loop function
     *
     * @param pvParameter FreeRTOS task parameter
     */
    static void AppTaskMain(void * pvParameter);

    CHIP_ERROR StartAppTask();

    /**
     * @brief Bring up the fan-control app: register the FanControl delegate, link the LED,
     *        seed PercentSetting / SpeedSetting from the data model.
     */
    CHIP_ERROR InitFanControl();

    /**
     * @brief Handle the Step command from the FanControl cluster.
     */
    Status HandleStep(StepDirectionEnum aDirection, bool aWrap, bool aLowestOff) override;

    /**
     * @brief Post-attribute-change callback for all clusters on this endpoint.
     */
    void DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value);

    /**
     * @brief Event handler when a button is pressed
     *
     * @param button     APP_FUNCTION_BUTTON
     * @param btnAction  SL_SIMPLE_BUTTON_PRESSED, SL_SIMPLE_BUTTON_RELEASED or SL_SIMPLE_BUTTON_DISABLED
     */
    static void ButtonEventHandler(uint8_t button, uint8_t btnAction);

    /**
     * @brief AppTask-thread handler that refreshes the fan LED (and LCD when enabled)
     *        from the latest FanMode. Posted from DMPostAttributeChangeCallback to keep
     *        UI work off the Matter thread.
     */
    static void FanUiUpdateEventHandler(AppEvent * aEvent);

    /**
     * @brief Reconcile PercentSetting or SpeedSetting when FanMode changes, depending on
     *        MultiSpeed feature support. Invoked from DMPostAttributeChangeCallback when
     *        MultiSpeed is disabled.
     */
    void HandleFanModeChange(FanModeEnum aNewFanMode);

    /**
     * @brief Mirror PercentSetting writes onto PercentCurrent (when not in Auto and not a no-op).
     *        FanMode is updated by the cluster on PercentSetting writes; the app does not re-derive it.
     */
    void HandlePercentSettingChange(uint8_t aNewPercentSetting);

    /**
     * @brief Derive FanMode from a PercentSetting value using SpeedMax-derived bands.
     *        Optional customer override hook; default handlers rely on cluster FanMode updates.
     */
    FanModeEnum DeriveFanModeFromPercent(Percent percent);

    /**
     * @brief Mirror SpeedSetting writes onto SpeedCurrent when MultiSpeed is enabled.
     */
    void HandleSpeedSettingChange(uint8_t aNewSpeedSetting);

    /**
     * @brief Read MultiSpeed support from the FanControl FeatureMap and refresh the
     *        sSupportsMultiSpeed cache. Call during InitFanControl() (including custom
     *        overrides) with the chip stack locked. Exposed for customer code; not overridable.
     */
    bool ReadSupportsMultiSpeedFromFeatureMap();

    /**
     * @brief Convert a discrete speed step into a percent using SpeedMax.
     */
    static uint8_t SpeedToPercent(uint8_t speed, uint8_t speedMax);

    chip::app::DataModel::Nullable<uint8_t> GetSpeedSetting();
    chip::app::DataModel::Nullable<Percent> GetPercentSetting();

    /**
     * @brief Write SpeedSetting synchronously on the Matter thread. No-op when MultiSpeed is
     *        disabled. Exposed for customer code; not overridable.
     */
    Status SetSpeedSetting(uint8_t aNewSpeedSetting);

    /**
     * @brief Schedule a PercentSetting write on the Matter thread. Exposed for customer code;
     *        not overridable.
     */
    Status SetPercentSetting(Percent aNewPercentSetting);

    /**
     * @brief PlatformMgr().ScheduleWork() callback that flushes pending FanControl attribute writes
     *        on the Matter thread. Exposed as a public API but not part of the CRTP override surface.
     */
    static void UpdateClusterState(intptr_t arg);

    /**
     * @brief Read the current FanMode attribute. Used by FanControlUI.
     */
    FanModeEnum GetFanMode();

protected:
    /** Override of `BaseApplication::AppInit()`. */
    CHIP_ERROR AppInit() override;

    /**
     * @brief Write FanMode when it differs from the data model. Used by default attribute
     *        handlers; exposed for customer overrides that reuse SDK sync behavior.
     */
    void SyncFanMode(FanModeEnum aNewFanMode);
};
