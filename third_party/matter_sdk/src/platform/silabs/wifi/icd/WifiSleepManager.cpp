/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#include <app/icd/server/ICDConfigurationData.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/silabs/wifi/icd/WifiSleepManager.h>

using namespace chip::DeviceLayer::Silabs;

namespace chip {
namespace DeviceLayer {
namespace Silabs {

// Initialize the static instance
WifiSleepManager WifiSleepManager::mInstance;

CHIP_ERROR WifiSleepManager::Init(PowerSaveInterface * platformInterface, WifiStateProvider * wifiStateProvider)
{
    VerifyOrReturnError(platformInterface != nullptr, CHIP_ERROR_INVALID_ARGUMENT);
    VerifyOrReturnError(wifiStateProvider != nullptr, CHIP_ERROR_INVALID_ARGUMENT);

    mPowerSaveInterface = platformInterface;
    mWifiStateProvider  = wifiStateProvider;

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    ReturnErrorOnFailure(mPowerSaveInterface->InitLitPrecheckInReconnectTimer());
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)

    return VerifyAndTransitionToLowPowerMode(PowerEvent::kGenericEvent);
}

CHIP_ERROR WifiSleepManager::RequestHighPerformance(bool triggerTransition)
{
    VerifyOrReturnError(mHighPerformanceRequestCounter < std::numeric_limits<uint8_t>::max(), CHIP_ERROR_INTERNAL,
                        ChipLogError(DeviceLayer, "High performance request counter overflow"));

    mHighPerformanceRequestCounter++;

    if (triggerTransition)
    {
        // We don't do the mHighPerformanceRequestCounter check here; the check is in the VerifyAndTransitionToLowPowerMode function
        ReturnErrorOnFailure(VerifyAndTransitionToLowPowerMode(PowerEvent::kGenericEvent));
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::RemoveHighPerformanceRequest()
{
    VerifyOrReturnError(mHighPerformanceRequestCounter > 0, CHIP_NO_ERROR,
                        ChipLogError(DeviceLayer, "Wi-Fi configuration already in low power mode"));

    mHighPerformanceRequestCounter--;

    // We don't do the mHighPerformanceRequestCounter check here; the check is in the VerifyAndTransitionToLowPowerMode function
    ReturnErrorOnFailure(VerifyAndTransitionToLowPowerMode(PowerEvent::kGenericEvent));

    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::HandlePowerEvent(PowerEvent event)
{
    switch (event)
    {
    case PowerEvent::kCommissioningComplete:
        ChipLogProgress(AppServer, "WifiSleepManager: Handling Commissioning Complete Event");
        break;

    case PowerEvent::kConnectivityChange:
    case PowerEvent::kGenericEvent:
        // Preserve mActiveMode; HP cycles and connectivity use these events.
        break;
    case PowerEvent::kActiveMode:
    case PowerEvent::kConnectedActiveMode:
        mActiveMode = true;
        break;
    case PowerEvent::kIdleMode:
        mActiveMode = false;
        break;

    default:
        ChipLogError(AppServer, "Unknown Power Event");
        return CHIP_ERROR_INVALID_ARGUMENT;
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::VerifyAndTransitionToLowPowerMode(PowerEvent event)
{
    VerifyOrDieWithMsg(mWifiStateProvider != nullptr, DeviceLayer, "WifiStateProvider is not initialized");
    VerifyOrDieWithMsg(mPowerSaveInterface != nullptr, DeviceLayer, "PowerSaveInterface is not initialized");

    ReturnErrorOnFailure(HandlePowerEvent(event));

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    if (event == PowerEvent::kActiveMode)
    {
        mPowerSaveInterface->CancelLitPrecheckInReconnectTimer();
        return ConfigureLITConnect();
    }
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)

    if (mHighPerformanceRequestCounter > 0)
    {
        return ConfigureHighPerformance();
    }

    if (!mWifiStateProvider->IsWifiProvisioned())
    {
        return ConfigureDeepSleep();
    }

    if (mCallback && mCallback->CanGoToLIBasedSleep())
    {
#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
        if (!mActiveMode)
        {
            // ICD may enter idle while a btn0/precheck-in reconnect is still joining.
            // Defer LIT disconnect until the join finishes.
            if (mWifiStateProvider->IsStationConnecting())
            {
                ChipLogProgress(DeviceLayer, "WifiSleepManager: deferring LIT disconnect while station is connecting");
                return CHIP_NO_ERROR;
            }
            return ConfigureLITDisconnect();
        }

        return ConfigureLIBasedSleep();
#else  // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
        return ConfigureLIBasedSleep();
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    }

    return ConfigureDTIMBasedSleep();
}

CHIP_ERROR WifiSleepManager::ConfigureDTIMBasedSleep()
{
    VerifyOrDieWithMsg(mPowerSaveInterface != nullptr, DeviceLayer, "PowerSaveInterface is not initialized");

    // Filter disabled: Matter mDNS (ff02::fb) remains allowlisted.
    ReturnLogErrorOnFailure(mPowerSaveInterface->ConfigureBroadcastFilter(false));

    // Allowing the device to go to sleep must be the last actions to avoid configuration failures.
    ReturnLogErrorOnFailure(
        mPowerSaveInterface->ConfigurePowerSave(PowerSaveInterface::PowerSaveConfiguration::kConnectedSleep, 0));

    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::ConfigureDeepSleep()
{
    VerifyOrDieWithMsg(mPowerSaveInterface != nullptr, DeviceLayer, "PowerSaveInterface is not initialized");

    ReturnLogErrorOnFailure(mPowerSaveInterface->ConfigurePowerSave(PowerSaveInterface::PowerSaveConfiguration::kDeepSleep, 0));
    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::ConfigureHighPerformance()
{
    VerifyOrDieWithMsg(mPowerSaveInterface != nullptr, DeviceLayer, "PowerSaveInterface is not initialized");

    ReturnLogErrorOnFailure(
        mPowerSaveInterface->ConfigurePowerSave(PowerSaveInterface::PowerSaveConfiguration::kHighPerformance, 0));
    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::ConfigureLIBasedSleep()
{
    // LI sleep requires an active Wi-Fi association (connected to an AP).
    // Skip while joining or after a join failure.
    VerifyOrReturnError(!mWifiStateProvider->IsStationConnecting(), CHIP_NO_ERROR);
    VerifyOrReturnError(mWifiStateProvider->IsStationConnected(), CHIP_NO_ERROR);

    ReturnLogErrorOnFailure(mPowerSaveInterface->ConfigureBroadcastFilter(true));

    // Allowing the device to go to sleep must be the last actions to avoid configuration failures.
    ReturnLogErrorOnFailure(
        mPowerSaveInterface->ConfigurePowerSave(PowerSaveInterface::PowerSaveConfiguration::kLIConnectedSleep,
                                                chip::ICDConfigurationData::GetInstance().GetSlowPollingInterval().count()));

    return CHIP_NO_ERROR;
}

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
CHIP_ERROR WifiSleepManager::ConfigureLITDisconnect()
{
    // Do not tear down an in-progress join (e.g. ICD idle during reconnect).
    // Re-entry after the join finishes:
    // - Join failure: WifiInterfaceImpl calls VerifyAndTransitionToLowPowerMode(kGenericEvent),
    //   which re-enters here while still idle.
    // - Join success: kConnectedActiveMode selects LI sleep (stay associated); LIT disconnect
    //   is not re-run for that idle edge.
    VerifyOrReturnError(!mWifiStateProvider->IsStationConnecting(), CHIP_NO_ERROR);

    // Capture before the platform call: when already down, ConfigureLITDisconnect
    // skips sl_net_down but still returns success.
    const bool wasConnected = mWifiStateProvider->IsStationConnected();

    // Platform skips sl_net_down when already down (avoids 0x10021 + fake kSuccess disconnect).
    ReturnLogErrorOnFailure(mPowerSaveInterface->ConfigureLITDisconnect());
    ReturnLogErrorOnFailure(mPowerSaveInterface->ConfigureBroadcastFilter(false));
    ReturnLogErrorOnFailure(mPowerSaveInterface->ConfigurePowerSave(PowerSaveInterface::PowerSaveConfiguration::kDeepSleep, 0));

    // Only arm the precheck-in timer when we actually tore the STA down.
    // A failed join via kGenericEvent re-enters here while already disconnected;
    // restarting would reset the full idle delay and can miss the next check-in.
    if (wasConnected)
    {
        mPowerSaveInterface->StartLitPrecheckInReconnectTimer();
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::ConfigureLITConnect()
{
    // Wake + join are handled inside ConfigureLITConnect (high performance, then scan).
    ReturnErrorOnFailure(mPowerSaveInterface->ConfigureLITConnect());
    return CHIP_NO_ERROR;
}
#endif // CHIP_CONFIG_ENABLE_ICD_LIT

} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
