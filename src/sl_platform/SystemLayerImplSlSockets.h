/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
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
 * Modified by Flipper Devices Inc.
 * Original file: SystemLayerImplFreeRTOS.h
 * List of changes:
 *   - class name: LayerImplFreeRTOS -> LayerImplSlSockets
 *   - class parent: LayerFreeRTOS -> LayerSockets
 *   - operating environment: lwIP + FreeRTOS -> SiLabs sockets + FreeRTOS
 *   - added methods that implement LayerSockets
 *   - added supporting class fields
 */

/**
 *    @file
 *      This file declares an implementation of LayerSockets for SiLabs sockets on FreeRTOS.
 */

#pragma once

#include <lib/support/ObjectLifeCycle.h>
#include <system/SystemLayer.h>
#include <system/SocketEvents.h>
#include <system/SystemTimer.h>
#include <sl_si91x_socket_types.h>

namespace chip {
namespace System {

class LayerImplSlSockets : public LayerSockets
{
public:
    LayerImplSlSockets();
    ~LayerImplSlSockets() { VerifyOrDie(mLayerState.Destroy()); }

    // FreeRTOS layer overrides
    CHIP_ERROR Init();
    void Shutdown();
    bool IsInitialized() const { return mLayerState.IsInitialized(); }
    CHIP_ERROR StartTimer(Clock::Timeout delay, TimerCompleteCallback onComplete, void * appState);
    CHIP_ERROR ExtendTimerTo(Clock::Timeout delay, TimerCompleteCallback onComplete, void * appState);
    bool IsTimerActive(TimerCompleteCallback onComplete, void * appState);
    Clock::Timeout GetRemainingTime(TimerCompleteCallback onComplete, void * appState);
    void CancelTimer(TimerCompleteCallback onComplete, void * appState);
    CHIP_ERROR ScheduleWork(TimerCompleteCallback onComplete, void * appState);

public:
    // Socket Layer overrides
    static void AsyncSocketCallback(uint32_t socket, uint8_t *buffer, uint32_t length, const sl_si91x_socket_metadata_t *firmware_socket_response);
    CHIP_ERROR StartWatchingSocket(int fd, SocketWatchToken * tokenOut);
    CHIP_ERROR SetCallback(SocketWatchToken token, SocketWatchCallback callback, intptr_t data);
    CHIP_ERROR RequestCallbackOnPendingRead(SocketWatchToken token);
    CHIP_ERROR RequestCallbackOnPendingWrite(SocketWatchToken token);
    CHIP_ERROR ClearCallbackOnPendingRead(SocketWatchToken token);
    CHIP_ERROR ClearCallbackOnPendingWrite(SocketWatchToken token);
    CHIP_ERROR StopWatchingSocket(SocketWatchToken * tokenInOut);
    SocketWatchToken InvalidSocketWatchToken();

public:
    // Platform implementation.
    CHIP_ERROR HandlePlatformTimer(void);

private:
    friend class PlatformEventing;

    CHIP_ERROR StartPlatformTimer(System::Clock::Timeout aDelay);

    TimerPool<TimerList::Node> mTimerPool;
    TimerList mTimerList;
    bool mHandlingTimerComplete; // true while handling any timer completion
    ObjectLifeCycle mLayerState;

private:
    typedef struct SlSocketCallbacks SlSocketCallbacks;
    SlSocketCallbacks* mSocketCallbacks;
};

using LayerImpl = LayerImplSlSockets;

} // namespace System
} // namespace chip
