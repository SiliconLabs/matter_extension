
/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
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
#pragma once

#include <lib/core/CHIPError.h>

namespace chip {
namespace DeviceLayer {
namespace Silabs {

/**
 * @brief Power Save Platform Interface for Wi-Fi platforms
 *
 */
class PowerSaveInterface
{
public:
    virtual ~PowerSaveInterface() = default;

    enum class PowerSaveConfiguration : uint8_t
    {
        kHighPerformance  = 0,
        kDeepSleep        = 1,
        kConnectedSleep   = 2,
        kLIConnectedSleep = 3,
    };

    /**
     * @brief Configures the underlying platform to the requested power save mode.
     *
     * @param configuration PowerSaveConfiguration to configure the platform to
     * @param listenInterval Listen interval to configure the platform to
     *
     * @return CHIP_ERROR CHIP_NO_ERROR, if the configuration was successful
     *                    CHIP_ERROR_INTERNAL, if there was an error when configuring the power save mode
     *                    CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE, if the platform does not support the requested power save mode or if
     *                                                         it is a non-supported configuration
     */
    virtual CHIP_ERROR ConfigurePowerSave(PowerSaveConfiguration configuration, uint32_t listenInterval)
    {
        return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
    }

    /**
     * @brief Configures broadcast and multicast filtering.
     *
     * Platforms that support filtering apply the same enable/disable state to both
     * broadcast and multicast filters. When filtering is disabled, platforms may still allowlist
     * required multicast traffic (e.g. Matter mDNS).
     *
     * @param[in] enableBroadcastFilter Boolean to enable or disable broadcast/multicast filtering.
     *
     * @return CHIP_ERROR CHIP_NO_ERROR, the filters were successfully configured
     *                    CHIP_ERROR_INTERNAL, if there was an error when configuring the filters
     *                    CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE, if the platform does not support the requested configuration
     */
    virtual CHIP_ERROR ConfigureBroadcastFilter(bool enableBroadcastFilter) { return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE; }

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)

    /**
     * @brief Reconnect after Long Idle Time (LIT) sleep disconnect (ICD active mode / reporting window).
     *        Platform implementations start join without periodic backoff used for unintended disconnects.
     */
    virtual CHIP_ERROR ConfigureLITConnect() { return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE; }

    /**
     * @brief Intentional STA disconnect for LIT disconnect sleep (CHIP_CONFIG_ENABLE_ICD_LIT).
     *        Suppresses automatic reconnect until ConfigureLITConnect(); disconnect is processed on the Wi-Fi task.
     */
    virtual CHIP_ERROR ConfigureLITDisconnect() { return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE; }

    /**
     * @brief Stops the LIT precheck-in reconnect timer (e.g. when entering active mode before LIT connect).
     */
    virtual void CancelLitPrecheckInReconnectTimer() {}

    /**
     * @brief Schedules Wi-Fi reconnect before the ICD traffic window after LIT disconnect sleep is configured.
     */
    virtual void StartLitPrecheckInReconnectTimer() {}

    /**
     * @brief Creates OS resources for LIT precheck-in reconnect scheduling. Called during WifiSleepManager::Init.
     *
     * @return CHIP_NO_ERROR on success, CHIP_ERROR_INTERNAL if timer creation fails.
     */
    virtual CHIP_ERROR InitLitPrecheckInReconnectTimer() { return CHIP_NO_ERROR; }
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
protected:
    // Default power save configuration is High Performance as the device starts in high power mode and low power modes need to be
    // explicitly configured
    PowerSaveConfiguration mCurrentPowerSaveConfiguration = PowerSaveConfiguration::kHighPerformance;
    bool mBroadcastFilterEnabled                          = false;
};

} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
