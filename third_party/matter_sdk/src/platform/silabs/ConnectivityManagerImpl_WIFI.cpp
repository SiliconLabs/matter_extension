/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
 *    Copyright (c) 2019 Nest Labs, Inc.
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
/* this file behaves like a config.h, comes first */
#include <platform/internal/CHIPDeviceLayerInternal.h>

#include <lib/support/CodeUtils.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/ConnectivityManager.h>
#include <platform/internal/BLEManager.h>
#include <platform/silabs/NetworkCommissioningWiFiDriver.h>

#include <lwip/dns.h>
#include <lwip/ip_addr.h>
#include <lwip/nd6.h>
#include <lwip/netif.h>

#include <platform/internal/GenericConnectivityManagerImpl_UDP.ipp>

#if INET_CONFIG_ENABLE_TCP_ENDPOINT
#include <platform/internal/GenericConnectivityManagerImpl_TCP.ipp>
#endif

#if CHIP_DEVICE_CONFIG_ENABLE_CHIPOBLE
#include <platform/internal/GenericConnectivityManagerImpl_BLE.ipp>
#endif

#include <platform/internal/GenericConnectivityManagerImpl_WiFi.ipp>

#include "CHIPDevicePlatformConfig.h"
#include <platform/silabs/wifi/WifiInterface.h>

using namespace ::chip;
using namespace ::chip::Inet;
using namespace ::chip::System;
using namespace ::chip::DeviceLayer::Internal;
using namespace ::chip::DeviceLayer::Silabs;

namespace chip {
namespace DeviceLayer {

ConnectivityManagerImpl ConnectivityManagerImpl::sInstance;

CHIP_ERROR ConnectivityManagerImpl::_Init()
{
    mWiFiStationMode              = kWiFiStationMode_Disabled;
    mWiFiStationState             = kWiFiStationState_NotConnected;
    mWiFiStationAutoConnect       = true;
    mWiFiStationDisconnectPending = false;
    mLastStationConnectFailTime   = System::Clock::kZero;
    mWiFiStationReconnectInterval = System::Clock::Milliseconds32(CHIP_DEVICE_CONFIG_WIFI_STATION_RECONNECT_INTERVAL);
    mWiFiStationReconnectCount    = 1;
    mFlags.ClearAll();

    // TODO Initialize the Chip Addressing and Routing Module.

    // Ensure that station mode is enabled.
    ReturnErrorOnFailure(SetWiFiStationMode(kWiFiStationMode_Enabled));

    // Queue work items to bootstrap the AP and station state machines once the Chip event loop is running.
    ReturnErrorOnFailure(DeviceLayer::SystemLayer().ScheduleWork(DriveStationState, NULL));
    return CHIP_NO_ERROR;
}

void ConnectivityManagerImpl::_OnPlatformEvent(const ChipDeviceEvent * event)
{
    // Forward the event to the generic base classes as needed.
    // Handle Wfx wifi events...
    if (event->Type == DeviceEventType::kPlatformSLEvent)
    {

        switch (event->Platform.event.WFXSystemEvent.data.genericMsgEvent.header.id)
        {
        case to_underlying(WifiInterface::WifiEvent::kStartUp):
            ChipLogProgress(DeviceLayer, "STARTUP EVENT");
            DriveStationState();
            break;

        case to_underlying(WifiInterface::WifiEvent::kConnect):
            ChipLogProgress(DeviceLayer, "CONNECT EVENT");
            ChangeWiFiStationState(kWiFiStationState_Connected);
            break;

        case to_underlying(WifiInterface::WifiEvent::kDisconnect):
            ChipLogProgress(DeviceLayer, "DISCONNECT EVENT");
            switch (WifiInterface::GetInstance().GetLastDisconnectionReason())
            {
            // User initiated disconnection outside of the ConnectivityManager
            case NetworkCommissioning::Status::kSuccess:
                if (mWiFiStationDisconnectPending)
                {
                    mWiFiStationDisconnectPending = false;
                    ChangeWiFiStationState(kWiFiStationState_NotConnected);
                }
                else
                {
                    // out of bound disconnect event, since WifiInterface::TriggerDisconnection() is not called
                    // from the ConnectivityManager, so we need to set the auto connect flag to false
                    // and drive the station state to not connected
                    mWiFiStationAutoConnect = false;
                    DriveStationState();
                }
                break;
            // Disconnection due to WiFi connectivity error
            default:
                VerifyOrReturn(
                    mWiFiStationState == kWiFiStationState_Connecting ||
                        mWiFiStationState == kWiFiStationState_Connecting_Succeeded ||
                        mWiFiStationState == kWiFiStationState_Connected,
                    ChipLogDetail(DeviceLayer, "Discard disconnect event as WiFi station was not connecting or connected"));
                ChangeWiFiStationState(kWiFiStationState_Connecting_Failed);
                break;
            }
            break;

        case to_underlying(WifiInterface::WifiEvent::kGotIPv4):
        case to_underlying(WifiInterface::WifiEvent::kGotIPv6):
        case to_underlying(WifiInterface::WifiEvent::kLostIP):
            ChipLogProgress(DeviceLayer, "IP CHANGE EVENT");
            UpdateInternetConnectivityState();
            break;
        default:
            break;
        }
    }
}

ConnectivityManager::WiFiStationMode ConnectivityManagerImpl::_GetWiFiStationMode(void)
{
    VerifyOrReturnValue(mWiFiStationMode != kWiFiStationMode_ApplicationControlled, mWiFiStationMode);
    return WifiInterface::GetInstance().IsStationModeEnabled() ? kWiFiStationMode_Enabled : kWiFiStationMode_Disabled;
}

bool ConnectivityManagerImpl::_IsWiFiStationProvisioned(void)
{
    return WifiInterface::GetInstance().IsWifiProvisioned();
}

bool ConnectivityManagerImpl::_IsWiFiStationEnabled(void)
{
    return WifiInterface::GetInstance().IsStationModeEnabled();
}

CHIP_ERROR ConnectivityManagerImpl::_SetWiFiStationMode(ConnectivityManager::WiFiStationMode val)
{
    // If the new WiFi station mode is the same as the current WiFi station mode, return success.
    VerifyOrReturnError(val != mWiFiStationMode, CHIP_NO_ERROR,
                        ChipLogDetail(DeviceLayer, "SetWiFiStationMode ignored: %s", WiFiStationModeToStr(val)));

    ChipLogProgress(DeviceLayer, "WiFiStationMode: %s -> %s", WiFiStationModeToStr(mWiFiStationMode), WiFiStationModeToStr(val));

    mWiFiStationMode = val;
    CHIP_ERROR err   = CHIP_NO_ERROR;
    switch (mWiFiStationMode)
    {
    case kWiFiStationMode_Disabled: {
        // disconnect if wifi is connected
        if (IsWiFiStationConnected())
        {
            ReturnErrorOnFailure(DisconnectNetwork());
        }
        err = WifiInterface::GetInstance().DisableStationMode();
        VerifyOrReturnError(err == CHIP_NO_ERROR || err == CHIP_ERROR_NOT_IMPLEMENTED, err);
    }
    break;
    case kWiFiStationMode_Enabled: {
        ReturnErrorOnFailure(WifiInterface::GetInstance().EnableStationMode());
    }
    break;
    default:
        // kWiFiStationMode_Application
        break;
    }
    ChangeWiFiStationState(kWiFiStationState_NotConnected, false);
    mWiFiStationAutoConnect = true;
    // do not schedule the DriveStationState if the station is not ready to be driven once the START UP EVENT is received
    VerifyOrReturnError(WifiInterface::GetInstance().IsStationReady(), CHIP_NO_ERROR,
                        ChipLogDetail(DeviceLayer, "WiFi station is not ready"));
    ReturnErrorOnFailure(DeviceLayer::SystemLayer().ScheduleWork(DriveStationState, NULL));

    return CHIP_NO_ERROR;
}

CHIP_ERROR ConnectivityManagerImpl::_SetWiFiStationReconnectInterval(System::Clock::Timeout timeoutMs)
{
    mWiFiStationReconnectInterval = timeoutMs;
    return CHIP_NO_ERROR;
}

void ConnectivityManagerImpl::_ClearWiFiStationProvision(void)
{
    // If the WiFi station mode is application controlled, do not clear the WiFi credentials.
    VerifyOrReturn(mWiFiStationMode != kWiFiStationMode_ApplicationControlled,
                   ChipLogProgress(DeviceLayer, "WiFi station is application controlled"));

    WifiInterface::GetInstance().ClearWifiCredentials();
    LogErrorOnFailure(DeviceLayer::SystemLayer().ScheduleWork(DriveStationState, NULL));
}

CHIP_ERROR ConnectivityManagerImpl::_GetAndLogWifiStatsCounters(void)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

void ConnectivityManagerImpl::_OnWiFiScanDone()
{
    // CHIP_ERROR_NOT_IMPLEMENTED
}

void ConnectivityManagerImpl::_OnWiFiStationProvisionChange()
{
    // Schedule a call to the DriveStationState method to adjust the station state as needed.
    ChipLogProgress(DeviceLayer, "_ON WIFI PROVISION CHANGE");
    LogErrorOnFailure(DeviceLayer::SystemLayer().ScheduleWork(DriveStationState, NULL));
}

CHIP_ERROR ConnectivityManagerImpl::_DisconnectNetwork(void)
{
    // if the station is not connected, return success
    VerifyOrReturnError(mWiFiStationState != kWiFiStationState_NotConnected, CHIP_NO_ERROR);

    mWiFiStationAutoConnect = false;

    if (mWiFiStationState == kWiFiStationState_Connecting)
    {
        // user requested to disconnect the network, while the device in connecting state
        // reset the reconnection state to avoid the device to reconnect to the network
        // if the on going connection attempt failed, the station will be in the NotConnected state.
        // if the on going connection attempt succeeded, the station will be in the Connected state,
        // driven by the OnPlatformEvent() callback
        ChangeWiFiStationState(kWiFiStationState_NotConnected, false);
    }
    else if (mWiFiStationState == kWiFiStationState_Connected || mWiFiStationState == kWiFiStationState_Connecting_Succeeded)
    {
        VerifyOrReturnError(!mWiFiStationDisconnectPending, CHIP_ERROR_IN_PROGRESS);

        mWiFiStationDisconnectPending = true;
        ChangeWiFiStationState(kWiFiStationState_Disconnecting, false);
        // ChangeWiFiStationState() is called in the OnPlatformEvent() callback as per result of TriggerDisconnection()
        // next time DriveStationState() will be called, the station will be in the NotConnected state
        WifiInterface::GetInstance().TriggerDisconnection();
    }
    LogErrorOnFailure(DeviceLayer::SystemLayer().ScheduleWork(DriveStationState, NULL));
    return CHIP_NO_ERROR;
}

#if CHIP_CONFIG_ENABLE_ICD_SERVER
CHIP_ERROR ConnectivityManagerImpl::_SetPollingInterval(System::Clock::Milliseconds32 pollingInterval)
{
    // TODO: The polling interval feature is not implemented on this platform. Return success to prevent spurious error logs from
    // ICDManager. Revisit this once we complete the ICD integration
    (void) pollingInterval;
    return CHIP_NO_ERROR;
}
#endif /* CHIP_CONFIG_ENABLE_ICD_SERVER */

// == == == == == == == == == == ConnectivityManager Private Methods == == == == == == == == == ==

void ConnectivityManagerImpl::DriveStationState()
{
    // Refresh the current state and store it in `mWiFiStationMode`
    WiFiStationMode stationMode = GetWiFiStationMode();
    CHIP_ERROR err              = CHIP_NO_ERROR;
    bool isStationConnected     = WifiInterface::GetInstance().IsStationConnected();
    bool isStationProvisioned   = WifiInterface::GetInstance().IsWifiProvisioned();

    // if the station mode is application controlled or disabled, return
    VerifyOrReturn(stationMode != kWiFiStationMode_ApplicationControlled,
                   ChipLogProgress(DeviceLayer, "WiFi station is application controlled"));
    // If the station interface is NOT under application control...
    // Ensure that the WiFi task is started.
    // returns CHIP_NO_ERROR if the task is started successfully, also when the task is already started
    err = WifiInterface::GetInstance().StartWifiTask();
    VerifyOrReturn(err == CHIP_NO_ERROR, ChipLogError(DeviceLayer, "StartWifiTask failed: %" CHIP_ERROR_FORMAT, err.Format()));
    // if the station mode is disabled, return
    VerifyOrReturn(stationMode != kWiFiStationMode_Disabled, ChipLogProgress(DeviceLayer, "WiFi station is disabled"));
    ChipLogDetail(DeviceLayer, "DriveStationState: %s", WiFiStationStateToStr(mWiFiStationState));
    ChipLogDetail(DeviceLayer, "isStationConnected: %d, isStationProvisioned: %d, mWiFiStationAutoConnect: %d", isStationConnected,
                  isStationProvisioned, mWiFiStationAutoConnect);
    if (isStationConnected)
    {
        // sync the station state with the actual state
        switch (mWiFiStationState)
        {
        case kWiFiStationState_NotConnected:
        case kWiFiStationState_Connecting_Succeeded:
            ChangeWiFiStationState(kWiFiStationState_Connected, false);
            break;
        default:
            break;
        }

        // if the station is not provisioned, disconnect it
        if (!isStationProvisioned)
        {
            ChipLogDetail(DeviceLayer, "WiFi station is not provisioned and is connected, disconnecting");
            ReturnOnFailure(DisconnectNetwork());
        }
    }

    // if the station is not connected
    VerifyOrReturn(!isStationConnected);

    // if the station is provisioned and auto connect is enabled and the station is not connected,
    // connect it to the access point using the credentials from the staging network
    if (mWiFiStationAutoConnect && isStationProvisioned)
    {
        // if the station is not connected, set the state to connecting
        if (mWiFiStationState == kWiFiStationState_NotConnected)
        {
            ChangeWiFiStationState(kWiFiStationState_Connecting, false);
        }
    }

    // TODO: Verify why `now` is always the same value
    System::Clock::Timestamp now               = System::SystemClock().GetMonotonicTimestamp();
    System::Clock::Timestamp timeToNextConnect = System::Clock::kZero;

    switch (mWiFiStationState)
    {
    case kWiFiStationState_Connecting: {
        // connect the station to the access point using the credentials from the staging network
        err = WifiInterface::GetInstance().ConnectToAccessPoint(); // using the credentials from the staging network
        VerifyOrReturn(err == CHIP_NO_ERROR || err == CHIP_ERROR_IN_PROGRESS,
                       ChipLogError(DeviceLayer, "ConnectToAccessPoint failed: %" CHIP_ERROR_FORMAT, err.Format()));
        // ChangeWiFiStationState() is called in the OnPlatformEvent() callback as per result of ConnectWiFiNetwork()
        return;
    }
    break;
    case kWiFiStationState_Connecting_Failed: {
        // if the station is connecting failed,
        // arrange another connection attempt at a suitable point in the future
        // TODO: Verify why `mLastStationConnectFailTime` is not assigned the value of `now`
        mLastStationConnectFailTime = now;
        // Reset the station state to kWiFiStationState_Connecting to start a new connection attempt
        timeToNextConnect = (mWiFiStationReconnectInterval * mWiFiStationReconnectCount);
        // DriveStationState() will be called again to start a new connection attempt
        ChipLogProgress(DeviceLayer, "Next WiFi station reconnect in %" PRIu32 " ms",
                        System::Clock::Milliseconds32(timeToNextConnect).count());

        // drive the station state to connecting
        ChangeWiFiStationState(kWiFiStationState_Connecting, false);
        LogErrorOnFailure(DeviceLayer::SystemLayer().StartTimer(timeToNextConnect, DriveStationState, NULL));

        // TODO: Revisit this logic
        // increase the reconnect interval by the previous interval, for telescoping effect and reduce the frequency of
        // reconnect attempts thus saving power
        // TODO: Guard this with commissioning mode flag
        // mWiFiStationReconnectCount++;
    }
    break;
    case kWiFiStationState_Connected:
    case kWiFiStationState_Connecting_Succeeded: {
        // Unexpected radio-down while still Connected/Connecting_Succeeded.
        // Prefer Connecting_Failed so reconnect is scheduled (same as error
        // kDisconnect). Going straight to NotConnected resets the retry timer
        // and skips a new join; a later kDisconnect is then discarded.
        if (mWiFiStationAutoConnect && isStationProvisioned)
        {
            ChangeWiFiStationState(kWiFiStationState_Connecting_Failed);
        }
        else
        {
            ChangeWiFiStationState(kWiFiStationState_NotConnected, false);
        }
    }
    break;
    case kWiFiStationState_Disconnecting: {
        ChangeWiFiStationState(kWiFiStationState_NotConnected, false);
    }
    break;
    default: {
        // do nothing
    }
    break;
    }
    // Kick-off any pending network scan that might have been deferred due to the activity
    // of the WiFi station.
}

void ConnectivityManagerImpl::OnStationConnected()
{
    NetworkCommissioning::SlWiFiDriver * nwDriver = NetworkCommissioning::SlWiFiDriver::GetInstance();
    // Cannot use the driver if the instance is not initialized.
    VerifyOrDie(nwDriver != nullptr); // should never be null
    nwDriver->UpdateNetworkingStatus();
    nwDriver->OnConnectWiFiNetwork();

    UpdateInternetConnectivityState();
    // Alert other components of the new state.
    ChipDeviceEvent event;
    event.Type                          = DeviceEventType::kWiFiConnectivityChange;
    event.WiFiConnectivityChange.Result = kConnectivity_Established;
    (void) PlatformMgr().PostEvent(&event);
}

void ConnectivityManagerImpl::OnStationDisconnected()
{
    NetworkCommissioning::SlWiFiDriver * nwDriver = NetworkCommissioning::SlWiFiDriver::GetInstance();
    // Cannot use the driver if the instance is not initialized.
    VerifyOrDie(nwDriver != nullptr); // should never be null
    nwDriver->UpdateNetworkingStatus();

    // TODO: Invoke WARM to perform actions that occur when the WiFi station interface goes down.
    UpdateInternetConnectivityState();
    // Alert other components of the new state.
    ChipDeviceEvent event;
    event.Type                          = DeviceEventType::kWiFiConnectivityChange;
    event.WiFiConnectivityChange.Result = kConnectivity_Lost;
    (void) PlatformMgr().PostEvent(&event);
}

void ConnectivityManagerImpl::ResetReconnectionWiFiStationState()
{
    mLastStationConnectFailTime = System::Clock::kZero;
    mWiFiStationReconnectCount  = 1;
    DeviceLayer::SystemLayer().CancelTimer(DriveStationState, NULL);
}

void ConnectivityManagerImpl::DriveStationState(::chip::System::Layer * aLayer, void * aAppState)
{
    sInstance.DriveStationState();
}

void ConnectivityManagerImpl::ChangeWiFiStationState(WiFiStationState newState, bool driveStationState)
{
    VerifyOrReturn(mWiFiStationState != newState,
                   ChipLogDetail(DeviceLayer, "ChangeWiFiStationState ignored: %s", WiFiStationStateToStr(newState)));
    ChipLogProgress(DeviceLayer, "WiFiStationState: %s -> %s", WiFiStationStateToStr(mWiFiStationState),
                    WiFiStationStateToStr(newState));
    // Commit the state before notifying. OnStationConnected() calls
    // UpdateInternetConnectivityState(), which only reports IPv6 when already Connected.
    WiFiStationState prevState = mWiFiStationState;
    mWiFiStationState          = newState;
    switch (newState)
    {
    case kWiFiStationState_NotConnected:
        ResetReconnectionWiFiStationState();
        OnStationDisconnected();
        break;

    case kWiFiStationState_Connecting_Failed:
        // TODO: Currently, `ConfigureLITConnect` is not managed by the ConnectivityManager.
        // Once it is managed by the ConnectivityManager, this check can be removed.
        if (prevState == kWiFiStationState_NotConnected)
        {
            mWiFiStationAutoConnect = true;
        }
        // Only notify link loss when an established (or succeeded) link dropped.
        // Connecting -> Connecting_Failed is a failed join/retry, not a drop.
        if (prevState == kWiFiStationState_Connected || prevState == kWiFiStationState_Connecting_Succeeded)
        {
            OnStationDisconnected();
        }
        break;

    case kWiFiStationState_Connecting_Succeeded:
    case kWiFiStationState_Connected:
        // TODO: Currently, `ConfigureLITConnect` is not managed by the ConnectivityManager.
        // Once it is managed by the ConnectivityManager, this check can be removed.
        if (prevState == kWiFiStationState_NotConnected)
        {
            mWiFiStationAutoConnect = true;
        }
        ResetReconnectionWiFiStationState();
        OnStationConnected();
        break;

    case kWiFiStationState_Disconnecting:
        ResetReconnectionWiFiStationState();
        break;

    default:
        // do nothing
        break;
    }

    if (driveStationState)
    {
        DriveStationState();
    }
}

void ConnectivityManagerImpl::UpdateInternetConnectivityState(void)
{
    bool haveIPv4Conn = false;
    bool haveIPv6Conn = false;
    bool hadIPv4Conn  = mFlags.Has(ConnectivityFlags::kHaveIPv4InternetConnectivity);
    bool hadIPv6Conn  = mFlags.Has(ConnectivityFlags::kHaveIPv6InternetConnectivity);
    IPAddress addr;

    // If the WiFi station is currently in the connected state...
    if (IsWiFiStationConnected())
    {
#if CHIP_DEVICE_CONFIG_ENABLE_IPV4
        haveIPv4Conn = WifiInterface::GetInstance().HasAnIPv4Address();
#endif /* CHIP_DEVICE_CONFIG_ENABLE_IPV4 */
        haveIPv6Conn = WifiInterface::GetInstance().HasAnIPv6Address();
    }

    // If the internet connectivity state has changed...
    if (haveIPv4Conn != hadIPv4Conn || haveIPv6Conn != hadIPv6Conn)
    {
        // Update the current state.
        mFlags.Set(ConnectivityFlags::kHaveIPv4InternetConnectivity, haveIPv4Conn)
            .Set(ConnectivityFlags::kHaveIPv6InternetConnectivity, haveIPv6Conn);

        // Alert other components of the state change.
        ChipDeviceEvent event;
        event.Type                                 = DeviceEventType::kInternetConnectivityChange;
        event.InternetConnectivityChange.IPv4      = GetConnectivityChange(hadIPv4Conn, haveIPv4Conn);
        event.InternetConnectivityChange.IPv6      = GetConnectivityChange(hadIPv6Conn, haveIPv6Conn);
        event.InternetConnectivityChange.ipAddress = addr;

        if (haveIPv4Conn != hadIPv4Conn)
        {
            ChipLogProgress(DeviceLayer, "%s Internet connectivity %s", "IPv4", (haveIPv4Conn) ? "ESTABLISHED" : "LOST");
        }

        if (haveIPv6Conn != hadIPv6Conn)
        {
            ChipLogProgress(DeviceLayer, "%s Internet connectivity %s", "IPv6", (haveIPv6Conn) ? "ESTABLISHED" : "LOST");
        }
        (void) PlatformMgr().PostEvent(&event);
    }
}

} // namespace DeviceLayer
} // namespace chip
