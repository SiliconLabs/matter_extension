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

#include <app/clusters/fan-control-server/fan-control-server.h>
#include <app/clusters/fan-control-server/fan-control-delegate.h>
#include <lib/core/CHIPError.h>

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters::FanControl;
using Protocols::InteractionModel::Status;

class FanControlManager : public Delegate
{
public:
    CHIP_ERROR Init();

    FanControlManager(EndpointId endpoint) : Delegate(endpoint) {}

    /**
     * @brief Handle attribute changes for the Fan Control Cluster
     * @param[in] attributeId    Cluster attribute id that changed
     * @param[in] type           Cluster attribute type
     * @param[in] size           Size of the attribute
     * @param[in] value          Pointer to the new value
     */
    void HandleFanControlAttributeChange(AttributeId attributeId, uint8_t type, uint16_t size, uint8_t * value);

    void PercentSettingWriteCallback(uint8_t aNewPercentSetting);
    void SpeedSettingWriteCallback(uint8_t aNewSpeedSetting);
    void FanModeWriteCallback(FanModeEnum aNewFanMode);

    void SetSpeedSetting(DataModel::Nullable<uint8_t> aNewSpeedSetting);
    DataModel::Nullable<uint8_t> GetSpeedSetting();
    DataModel::Nullable<Percent> GetPercentSetting();
    void UpdateFanMode();

    static void UpdateClusterState(intptr_t arg);

    FanModeEnum GetFanMode();
    void UpdateFanControlLED();
    void UpdateFanControlLCD();
    EndpointId GetEndPoint();

    /**
     * @brief Handle the step command from the Fan Control Cluster
     */
    Status HandleStep(StepDirectionEnum aDirection, bool aWrap, bool aLowestOff) override;

    struct AttributeUpdateInfo 
    {
        FanModeEnum fanMode;
        uint8_t speedCurrent;
        uint8_t percentCurrent;
        uint8_t speedSetting;
        bool isPercentCurrent = false;
        bool isSpeedCurrent = false;
        bool isSpeedSetting = false;
        bool isFanMode = false;
        EndpointId endPoint;
    };

private:
    friend FanControlManager & FanControlMgr(void);

    EndpointId mEndPoint = 1;
    FanModeEnum mFanMode;
    uint8_t mSpeedMax;

    uint8_t percentCurrent;
    uint8_t speedCurrent;

    // Fan Mode Limits
    static constexpr int kFanModeLowLowerBound    = 1;
    static constexpr int kFanModeLowUpperBound    = 3;
    static constexpr int kFanModeMediumLowerBound = 4;
    static constexpr int kFanModeMediumUpperBound = 7;
    static constexpr int kFanModeHighLowerBound   = 8;
    static constexpr int kFanModeHighUpperBound   = 10;

    static constexpr int kaLowestOffTrue = 0;
    static constexpr int kaLowestOffFalse = 1;

    static FanControlManager sFan;
};

inline FanControlManager & FanControlMgr(void)
{
    return FanControlManager::sFan;
}
