/*
 *
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

#include <app/clusters/on-off-server/on-off-server.h>
#include <cmsis_os2.h>
#include <lib/core/CHIPError.h>

class LightingManager
{
public:
    enum Action_t
    {
        ON_ACTION = 0,
        OFF_ACTION,

        INVALID_ACTION
    } Action;

    enum State_t
    {
        kState_OffInitiated = 0,
        kState_OffCompleted,
        kState_OnInitiated,
        kState_OnCompleted,
    } State;

    LightingManager() { mInitialized = false; };

    CHIP_ERROR Init();
    bool IsLightOn();
    void EnableAutoTurnOff(bool aOn);
    void SetAutoTurnOffDuration(uint32_t aDurationInSecs);
    bool IsActionInProgress();
    bool InitiateAction(int32_t aActor, Action_t aAction);
    inline bool IsInitialized() { return mInitialized; }

    typedef void (*Callback_fn_initiated)(Action_t, int32_t aActor);
    typedef void (*Callback_fn_completed)(Action_t);
    void SetCallbacks(Callback_fn_initiated aActionInitiated_CB, Callback_fn_completed aActionCompleted_CB);

    static void OnTriggerOffWithEffect(OnOffEffect * effect);

private:
    friend LightingManager & LightMgr(void);
    bool mInitialized;
    State_t mState;

    Callback_fn_initiated mActionInitiated_CB;
    Callback_fn_completed mActionCompleted_CB;

    bool mAutoTurnOff;
    uint32_t mAutoTurnOffDuration;
    bool mAutoTurnOffTimerArmed;
    bool mOffEffectArmed;
    osTimerId_t mLightTimer;

    void CancelTimer(void);
    void StartTimer(uint32_t aTimeoutMs);

    static void TimerEventHandler(void * timerCbArg);
    static void AutoTurnOffTimerEventHandler(AppEvent * aEvent);
    static void ActuatorMovementTimerEventHandler(AppEvent * aEvent);
    static void OffEffectTimerEventHandler(AppEvent * aEvent);

    static LightingManager sLight;
};

inline LightingManager & LightMgr(void)
{
    return LightingManager::sLight;
}
