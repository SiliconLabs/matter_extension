/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
 *    Copyright (c) 2014-2017 Nest Labs, Inc.
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

/**
 *    @file
 *      This file implements LayerImplFreeRTOSSockets. Used by device using FreeRTOS and Sockets
 */

#include <lib/support/CodeUtils.h>
#include <platform/CHIPDeviceEvent.h>
#include <platform/LockTracker.h>
#include <platform/PlatformManager.h>
#include <system/PlatformEventSupport.h>
#include <system/SystemFaultInjection.h>
#include <system/SystemLayer.h>
#include <system/SystemLayerImplFreeRTOSSockets.h>

namespace chip {
namespace System {

LayerImplFreeRTOSSockets::LayerImplFreeRTOSSockets() : mHandlingTimerComplete(false) {}

CHIP_ERROR LayerImplFreeRTOSSockets::Init()
{
    VerifyOrReturnError(mLayerState.SetInitializing(), CHIP_ERROR_INCORRECT_STATE);

    for (auto & w : mSocketWatchPool)
    {
        w.Clear();
    }

    VerifyOrReturnError(mLayerState.SetInitialized(), CHIP_ERROR_INCORRECT_STATE);
    return CHIP_NO_ERROR;
}

void LayerImplFreeRTOSSockets::Shutdown()
{
    mLayerState.ResetFromInitialized();
}

CHIP_ERROR LayerImplFreeRTOSSockets::StartTimer(Clock::Timeout delay, TimerCompleteCallback onComplete, void * appState)
{
    assertChipStackLockedByCurrentThread();

    VerifyOrReturnError(mLayerState.IsInitialized(), CHIP_ERROR_INCORRECT_STATE);

    CHIP_SYSTEM_FAULT_INJECT(FaultInjection::kFault_TimeoutImmediate, delay = Clock::kZero);

    CancelTimer(onComplete, appState);

    TimerList::Node * timer = mTimerPool.Create(*this, SystemClock().GetMonotonicTimestamp() + delay, onComplete, appState);
    VerifyOrReturnError(timer != nullptr, CHIP_ERROR_NO_MEMORY);

    if (mTimerList.Add(timer) == timer)
    {
        // this is the new earliest timer and so the timer needs (re-)starting provided that
        // the system is not currently processing expired timers, in which case it is left to
        // HandleExpiredTimers() to re-start the timer.
        if (!mHandlingTimerComplete)
        {
            StartPlatformTimer(delay);
        }
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR LayerImplFreeRTOSSockets::ExtendTimerTo(Clock::Timeout delay, TimerCompleteCallback onComplete, void * appState)
{
    VerifyOrReturnError(delay.count() > 0, CHIP_ERROR_INVALID_ARGUMENT);

    assertChipStackLockedByCurrentThread();

    Clock::Timeout remainingTime = mTimerList.GetRemainingTime(onComplete, appState);
    if (remainingTime.count() < delay.count())
    {
        return StartTimer(delay, onComplete, appState);
    }

    return CHIP_NO_ERROR;
}

bool LayerImplFreeRTOSSockets::IsTimerActive(TimerCompleteCallback onComplete, void * appState)
{
    return (mTimerList.GetRemainingTime(onComplete, appState) > Clock::kZero);
}

Clock::Timeout LayerImplFreeRTOSSockets::GetRemainingTime(TimerCompleteCallback onComplete, void * appState)
{
    return mTimerList.GetRemainingTime(onComplete, appState);
}

void LayerImplFreeRTOSSockets::CancelTimer(TimerCompleteCallback onComplete, void * appState)
{
    assertChipStackLockedByCurrentThread();

    VerifyOrReturn(mLayerState.IsInitialized());

    TimerList::Node * timer = mTimerList.Remove(onComplete, appState);
    if (timer != nullptr)
    {
        mTimerPool.Release(timer);
    }
}

CHIP_ERROR LayerImplFreeRTOSSockets::ScheduleWork(TimerCompleteCallback onComplete, void * appState)
{
    assertChipStackLockedByCurrentThread();

    VerifyOrReturnError(mLayerState.IsInitialized(), CHIP_ERROR_INCORRECT_STATE);

    // Ideally we would not use a timer here at all, but if we try to just
    // ScheduleLambda the lambda needs to capture the following:
    // 1) onComplete
    // 2) appState
    // 3) The `this` pointer, because onComplete needs to be passed a pointer to
    //    the System::Layer.
    //
    // On a 64-bit system that's 24 bytes, but lambdas passed to ScheduleLambda
    // are capped at CHIP_CONFIG_LAMBDA_EVENT_SIZE which is 16 bytes.
    //
    // So for now use a timer as a poor-man's closure that captures `this` and
    // onComplete and appState in a single pointer, so we fit inside the size
    // limit.
    //
    // TODO: We could do something here where we compile-time condition on the
    // sizes of things and use a direct ScheduleLambda if it would fit and this
    // setup otherwise.
    TimerList::Node * timer = mTimerPool.Create(*this, SystemClock().GetMonotonicTimestamp(), onComplete, appState);
    VerifyOrReturnError(timer != nullptr, CHIP_ERROR_NO_MEMORY);

    CHIP_ERROR err = ScheduleLambda([this, timer] { this->mTimerPool.Invoke(timer); });
    if (err != CHIP_NO_ERROR)
    {
        mTimerPool.Release(timer);
    }
    return err;
}

/**
 * Start the platform timer with specified millsecond duration.
 */
CHIP_ERROR LayerImplFreeRTOSSockets::StartPlatformTimer(System::Clock::Timeout aDelay)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INCORRECT_STATE);
    CHIP_ERROR status = PlatformEventing::StartTimer(*this, aDelay);
    return status;
}

/**
 * Handle the platform timer expiration event. Completes any timers that have expired.
 *
 * A static API that gets called when the platform timer expires. Any expired timers are completed and removed from the list
 * of active timers in the layer object. If unexpired timers remain on completion, StartPlatformTimer will be called to
 * restart the platform timer.
 *
 * It is assumed that this API is called only while on the thread which owns the CHIP System Layer object.
 *
 * @note
 *      It's harmless if this API gets called and there are no expired timers.
 *
 *  @return CHIP_NO_ERROR on success, error code otherwise.
 *
 */
CHIP_ERROR LayerImplFreeRTOSSockets::HandlePlatformTimer()
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INCORRECT_STATE);

    // Expire each timer in turn until an unexpired timer is reached or the timerlist is emptied.  We set the current expiration
    // time outside the loop; that way timers set after the current tick will not be executed within this expiration window
    // regardless how long the processing of the currently expired timers took.
    // The platform timer API has MSEC resolution so expire any timer with less than 1 msec remaining.
    Clock::Timestamp expirationTime = SystemClock().GetMonotonicTimestamp() + Clock::Timeout(1);

    // limit the number of timers handled before the control is returned to the event queue.  The bound is similar to
    // (though not exactly same) as that on the sockets-based systems.

    size_t timersHandled    = 0;
    TimerList::Node * timer = nullptr;
    while ((timersHandled < CHIP_SYSTEM_CONFIG_NUM_TIMERS) && ((timer = mTimerList.PopIfEarlier(expirationTime)) != nullptr))
    {
        mHandlingTimerComplete = true;
        mTimerPool.Invoke(timer);
        mHandlingTimerComplete = false;
        timersHandled++;
    }

    if (!mTimerList.Empty())
    {
        // timers still exist so restart the platform timer.
        Clock::Timeout delay = System::Clock::kZero;

        Clock::Timestamp currentTime = SystemClock().GetMonotonicTimestamp();

        if (currentTime < mTimerList.Earliest()->AwakenTime())
        {
            // the next timer expires in the future, so set the delay to a non-zero value
            delay = mTimerList.Earliest()->AwakenTime() - currentTime;
        }

        StartPlatformTimer(delay);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR LayerImplFreeRTOSSockets::StartWatchingSocket(int fd, SocketWatchToken * tokenOut)
{
    // Implementation for FreeRTOS to start watching a socket
    // Allocate a SocketWatch structure and initialize it
    SocketWatch * watch = nullptr;
    for (auto & w : mSocketWatchPool)
    {
        if (w.mFD == fd)
        {
            // Already registered, return the existing token
            *tokenOut = reinterpret_cast<SocketWatchToken>(&w);
            return CHIP_NO_ERROR;
        }
        if ((w.mFD == kInvalidFd) && (watch == nullptr))
        {
            watch = &w;
        }
    }
    VerifyOrReturnError(watch != nullptr, CHIP_ERROR_ENDPOINT_POOL_FULL);

    watch->mFD = fd;
    *tokenOut  = reinterpret_cast<SocketWatchToken>(watch);
    return CHIP_NO_ERROR;
}
CHIP_ERROR LayerImplFreeRTOSSockets::SetCallback(SocketWatchToken token, SocketWatchCallback callback, intptr_t data)
{
    SocketWatch * watch = reinterpret_cast<SocketWatch *>(token);
    VerifyOrReturnError(watch != nullptr, CHIP_ERROR_INVALID_ARGUMENT);

    watch->mCallback     = callback;
    watch->mCallbackData = data;
    return CHIP_NO_ERROR;
}

CHIP_ERROR LayerImplFreeRTOSSockets::RequestCallbackOnPendingRead(SocketWatchToken token)
{
    SocketWatch * watch = reinterpret_cast<SocketWatch *>(token);
    VerifyOrReturnError(watch != nullptr, CHIP_ERROR_INVALID_ARGUMENT);

    // Set the read flag for the socket
    watch->mPendingIO.Set(SocketEventFlags::kRead);

    // Prepare the event and start waiting on the select
    PrepareEvents();
    return CHIP_NO_ERROR;
}

CHIP_ERROR LayerImplFreeRTOSSockets::RequestCallbackOnPendingWrite(SocketWatchToken token)
{
    SocketWatch * watch = reinterpret_cast<SocketWatch *>(token);
    VerifyOrReturnError(watch != nullptr, CHIP_ERROR_INVALID_ARGUMENT);

    // Set the write flag for the socket
    watch->mPendingIO.Set(SocketEventFlags::kWrite);

    // Prepare the event and start waiting on the select
    PrepareEvents();
    return CHIP_NO_ERROR;
}

CHIP_ERROR LayerImplFreeRTOSSockets::ClearCallbackOnPendingRead(SocketWatchToken token)
{
    SocketWatch * watch = reinterpret_cast<SocketWatch *>(token);
    VerifyOrReturnError(watch != nullptr, CHIP_ERROR_INVALID_ARGUMENT);

    // Clear the read flag for the socket
    watch->mPendingIO.Clear(SocketEventFlags::kRead);
    return CHIP_NO_ERROR;
}

CHIP_ERROR LayerImplFreeRTOSSockets::ClearCallbackOnPendingWrite(SocketWatchToken token)
{
    SocketWatch * watch = reinterpret_cast<SocketWatch *>(token);
    VerifyOrReturnError(watch != nullptr, CHIP_ERROR_INVALID_ARGUMENT);

    // Clear the write flag for the socket
    watch->mPendingIO.Clear(SocketEventFlags::kWrite);
    return CHIP_NO_ERROR;
}

CHIP_ERROR LayerImplFreeRTOSSockets::StopWatchingSocket(SocketWatchToken * tokenInOut)
{
    SocketWatch * watch = reinterpret_cast<SocketWatch *>(*tokenInOut);
    *tokenInOut         = InvalidSocketWatchToken();

    VerifyOrReturnError(watch != nullptr, CHIP_ERROR_INVALID_ARGUMENT);

    // Free the SocketWatch structure
    delete watch;
    return CHIP_NO_ERROR;
}

void LayerImplFreeRTOSSockets::SocketWatch::Clear()
{
    mFD = kInvalidFd;
    mPendingIO.ClearAll();
    mCallback     = nullptr;
    mCallbackData = 0;
}

SocketEvents LayerImplFreeRTOSSockets::SocketEventsFromFDs(int socket, const fd_set & readfds, const fd_set & writefds,
                                                           const fd_set & exceptfds)
{
    SocketEvents res;

    if (socket >= 0)
    {
        // POSIX does not define the fd_set parameter of FD_ISSET() as const, even though it isn't modified.
        if (FD_ISSET(socket, const_cast<fd_set *>(&readfds)))
            res.Set(SocketEventFlags::kRead);
        if (FD_ISSET(socket, const_cast<fd_set *>(&writefds)))
            res.Set(SocketEventFlags::kWrite);
        if (FD_ISSET(socket, const_cast<fd_set *>(&exceptfds)))
            res.Set(SocketEventFlags::kExcept);
    }

    return res;
}

void LayerImplFreeRTOSSockets::PrepareEvents()
{
    mMaxFd = -1;

    FD_ZERO(&mSelected.mReadSet);
    FD_ZERO(&mSelected.mWriteSet);
    FD_ZERO(&mSelected.mErrorSet);

    for (auto & w : mSocketWatchPool)
    {
        if (w.mFD != kInvalidFd)
        {
            if (mMaxFd < w.mFD)
            {
                mMaxFd = w.mFD;
            }
            if (w.mPendingIO.Has(SocketEventFlags::kRead))
            {
                FD_SET(w.mFD, &mSelected.mReadSet);
            }
            if (w.mPendingIO.Has(SocketEventFlags::kWrite))
            {
                FD_SET(w.mFD, &mSelected.mWriteSet);
            }
        }
    }

    // Start waiting on the events
    WaitForEvents();
}

void LayerImplFreeRTOSSockets::WaitForEvents()
{
    // Creating the DeviceEvent for the socket select to start
    // when sync select should be called in a loop till we got some data
    chip::DeviceLayer::ChipDeviceEvent event;
    event.Type                       = chip::DeviceLayer::DeviceEventType::kSocketSelectStart;
    event.SocketSelectStart.FD       = mMaxFd + 1;
    event.SocketSelectStart.ReadSet  = mSelected.mReadSet;
    event.SocketSelectStart.WriteSet = mSelected.mWriteSet;
    event.SocketSelectStart.ErrorSet = mSelected.mErrorSet;
    // Since we are going with async select, setting mSelectResult to 1
    // Handle event will be triggered once we get something on select
    mSelectResult  = 1;
    CHIP_ERROR err = chip::DeviceLayer::PlatformMgr().PostEvent(&event);
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "Failed to post event: %" CHIP_ERROR_FORMAT, err.Format());
    }
}

void LayerImplFreeRTOSSockets::HandleEvents()
{
    if (!IsSelectResultValid())
    {
        ChipLogError(DeviceLayer, "Select failed: %" CHIP_ERROR_FORMAT, CHIP_ERROR_POSIX(errno).Format());
        return;
    }
    // Process socket events, if any
    if (mSelectResult > 0)
    {
        for (auto & w : mSocketWatchPool)
        {
            if (w.mFD != kInvalidFd && w.mCallback != nullptr)
            {
                SocketEvents events = SocketEventsFromFDs(w.mFD, mSelected.mReadSet, mSelected.mWriteSet, mSelected.mErrorSet);
                if (events.HasAny())
                {
                    w.mCallback(events, w.mCallbackData);
                }
            }
        }
    }

    // Once the event handling is done, prepare event and wait again
    PrepareEvents();
}

} // namespace System
} // namespace chip
