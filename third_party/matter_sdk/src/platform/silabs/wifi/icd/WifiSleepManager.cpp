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
#include <platform/silabs/wifi/WifiInterfaceAbstraction.h>
#include <platform/silabs/wifi/icd/WifiSleepManager.h>

namespace {

#if SLI_SI917 // 917 SoC & NCP

/**
 * @brief Configures the Wi-Fi Chip to go to LI based sleep.
 *        Function sets the listen interval the ICD Transort Slow Poll configuration and enables the broadcast filter.
 *
 * @return CHIP_ERROR CHIP_NO_ERROR if the configuration of the Wi-Fi chip was successful; otherwise MATTER_PLATFORM_ERROR
 *         with the sl_status_t error code from the Wi-Fi driver.
 */
CHIP_ERROR ConfigureLIBasedSleep()
{
    sl_status_t status = ConfigureBroadcastFilter(true);
    VerifyOrReturnError(status == SL_STATUS_OK, MATTER_PLATFORM_ERROR(status),
                        ChipLogError(DeviceLayer, "Failed to configure broadcasts filter."));

    // Allowing the device to go to sleep must be the last actions to avoid configuration failures.
    status = ConfigurePowerSave(RSI_SLEEP_MODE_2, ASSOCIATED_POWER_SAVE,
                                chip::ICDConfigurationData::GetInstance().GetSlowPollingInterval().count());
    VerifyOrReturnError(status == SL_STATUS_OK, MATTER_PLATFORM_ERROR(status),
                        ChipLogError(DeviceLayer, "Failed to enable LI based sleep."));

    return CHIP_NO_ERROR;
}

/**
 * @brief Configures the Wi-Fi Chip to go to DTIM based sleep.
 *        Function sets the listen interval to be synced with the DTIM beacon and disables the broadcast filter.
 *
 * @return CHIP_ERROR CHIP_NO_ERROR if the configuration of the Wi-Fi chip was successful; otherwise MATTER_PLATFORM_ERROR
 *         with the sl_status_t error code from the Wi-Fi driver.
 */
CHIP_ERROR ConfigureDTIMBasedSleep()
{
    sl_status_t status = ConfigureBroadcastFilter(false);
    VerifyOrReturnError(status == SL_STATUS_OK, MATTER_PLATFORM_ERROR(status),
                        ChipLogError(DeviceLayer, "Failed to configure broadcasts filter."));

    // Allowing the device to go to sleep must be the last actions to avoid configuration failures.
    status = ConfigurePowerSave(RSI_SLEEP_MODE_2, ASSOCIATED_POWER_SAVE, 0);
    VerifyOrReturnError(status == SL_STATUS_OK, MATTER_PLATFORM_ERROR(status),
                        ChipLogError(DeviceLayer, "Failed to enable DTIM based sleep."));

    return CHIP_NO_ERROR;
}

/**
 * @brief Configures the Wi-Fi chip to go Deep Sleep.
 *        Function doesn't change the state of the broadcast filter.
 *
 * @return CHIP_ERROR CHIP_NO_ERROR if the configuration of the Wi-Fi chip was successful; otherwise MATTER_PLATFORM_ERROR
 *         with the sl_status_t error code from the Wi-Fi driver.
 */
CHIP_ERROR ConfigureDeepSleep()
{
    sl_status_t status = ConfigurePowerSave(RSI_SLEEP_MODE_2, DEEP_SLEEP_WITH_RAM_RETENTION, 0);
    VerifyOrReturnError(status == SL_STATUS_OK, MATTER_PLATFORM_ERROR(status),
                        ChipLogError(DeviceLayer, "Failed to set Wi-FI configuration to DeepSleep."));
    return CHIP_NO_ERROR;
}

/**
 * @brief Configures the Wi-Fi chip to go to High Performance.
 *        Function doesn't change the broad cast filter configuration.
 *
 * @return CHIP_ERROR CHIP_NO_ERROR if the configuration of the Wi-Fi chip was successful; otherwise MATTER_PLATFORM_ERROR
 *         with the sl_status_t error code from the Wi-Fi driver.
 */
CHIP_ERROR ConfigureHighPerformance()
{
    sl_status_t status = ConfigurePowerSave(RSI_ACTIVE, HIGH_PERFORMANCE, 0);
    VerifyOrReturnError(status == SL_STATUS_OK, MATTER_PLATFORM_ERROR(status),
                        ChipLogError(DeviceLayer, "Failed to set Wi-FI configuration to HighPerformance."));
    return CHIP_NO_ERROR;
}
#endif // SLI_SI917

} // namespace

namespace chip {
namespace DeviceLayer {
namespace Silabs {

// Initialize the static instance
WifiSleepManager WifiSleepManager::mInstance;

CHIP_ERROR WifiSleepManager::Init()
{
    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::RequestHighPerformance()
{
    VerifyOrReturnError(mHighPerformanceRequestCounter < std::numeric_limits<uint8_t>::max(), CHIP_ERROR_INTERNAL,
                        ChipLogError(DeviceLayer, "High performance request counter overflow"));

    mHighPerformanceRequestCounter++;

    // We don't do the mHighPerformanceRequestCounter check here; the check is in VerifyAndTransitionToLowPowerMode function
    ReturnErrorOnFailure(VerifyAndTransitionToLowPowerMode());

    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::RemoveHighPerformanceRequest()
{
    VerifyOrReturnError(mHighPerformanceRequestCounter > 0, CHIP_NO_ERROR,
                        ChipLogError(DeviceLayer, "Wi-Fi configuration already in low power mode"));

    mHighPerformanceRequestCounter--;

    // We don't do the mHighPerformanceRequestCounter check here; the check is in VerifyAndTransitionToLowPowerMode function
    ReturnErrorOnFailure(VerifyAndTransitionToLowPowerMode());

    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::HandlePowerEvent(PowerEvent event)
{
    switch (event)
    {
    case PowerEvent::kCommissioningComplete:
        ChipLogProgress(AppServer, "WifiSleepManager: Handling Commissioning Complete Event");
        mIsCommissioningInProgress = false;
        break;
    case PowerEvent::kConnectivityChange:
    case PowerEvent::kGenericEvent:
        // No additional processing needed for these events at the moment
        break;
    default:
        ChipLogError(AppServer, "Unknown Power Event");
        return CHIP_ERROR_INVALID_ARGUMENT;
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR WifiSleepManager::VerifyAndTransitionToLowPowerMode(PowerEvent event)
{
    ReturnErrorOnFailure(HandlePowerEvent(event));

#if SLI_SI917 // 917 SoC & NCP
    if (mHighPerformanceRequestCounter > 0)
    {
        return ConfigureHighPerformance();
    }

    if (mIsCommissioningInProgress)
    {
        // During commissioning, don't let the device to go to sleep
        // This is needed to interrupt the sleep and retry to join the network
        return CHIP_NO_ERROR;
    }

    // TODO: Clean this up when the Wi-Fi interface re-work is finished
    wfx_wifi_provision_t wifiConfig;
    wfx_get_wifi_provision(&wifiConfig);

    if (!(wifiConfig.ssid[0] != 0))
    {
        return ConfigureDeepSleep();
    }

    if (mCallback && mCallback->CanGoToLIBasedSleep())
    {
        return ConfigureLIBasedSleep();
    }

    return ConfigureDTIMBasedSleep();

#elif RS911X_WIFI // rs9116
    sl_status_t status = ConfigurePowerSave();
    VerifyOrReturnError(status == SL_STATUS_OK, MATTER_PLATFORM_ERROR(status));
    return CHIP_NO_ERROR;
#else             // wf200
    return CHIP_NO_ERROR;
#endif
}

} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
