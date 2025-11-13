/*******************************************************************************
 * @file ApplicationSleepManager.h
 * @brief Header for the buisness logic around Optimizing Wi-Fi sleep states
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#pragma once

#include <app/ReadHandler.h>
#include <app/SubscriptionsInfoProvider.h>
#include <app/icd/server/ICDStateObserver.h>
#include <app/server/CommissioningWindowManager.h>
#include <credentials/FabricTable.h>
#include <platform/silabs/wifi/icd/WifiSleepManager.h>

namespace chip {
namespace app {
namespace Silabs {

class ApplicationSleepManager : public chip::app::ReadHandler::ApplicationCallback,
                                public chip::DeviceLayer::Silabs::WifiSleepManager::ApplicationCallback,
                                public chip::FabricTable::Delegate,
                                public chip::app::ICDStateObserver
{
public:
    static ApplicationSleepManager & GetInstance() { return mInstance; }

    /**
     * @brief Init function validates that the necessary pointers where correctly set
     *        before registering the object with the FabricTable and the WifiSleepManager.
     *
     *        Init function does not register with the InteractionModelEngine since depending on the whole interation model engine
     *        complexifies unit testing when we can use the SubscriptionInfoProvider which provides the necessary APIs.
     *
     *
     * @return CHIP_ERROR CHIP_NO_ERROR if the init succeed
     *         CHIP_ERROR_INVALID_ARGUMENT, if the fabricTable, subscriptionsInfoProvider or commissioningWindowManager,
     *                                      wifiSleepManager were not set correctly
     *         other, if the FabricTable::AddFabricDelegate failed
     */
    CHIP_ERROR Init();

    ApplicationSleepManager & SetFabricTable(chip::FabricTable * fabricTable)
    {
        mFabricTable = fabricTable;
        return *this;
    }

    ApplicationSleepManager & SetSubscriptionInfoProvider(chip::app::SubscriptionsInfoProvider * subscriptionsInfoProvider)
    {
        mSubscriptionsInfoProvider = subscriptionsInfoProvider;
        return *this;
    }

    ApplicationSleepManager & SetWifiSleepManager(chip::DeviceLayer::Silabs::WifiSleepManager * wifiSleepManager)
    {
        mWifiSleepManager = wifiSleepManager;
        return *this;
    }

    /**
     * @brief Sets the commissioning window state to open and calls the WifiSleepManager VerifyAndTransitionToLowPowerMode.
     *        The VerifyAndTransitionToLowPowerMode function is responsible of then queriyng the ApplicationSleepManager to
     *        determine in which low power state the Wi-Fi device can transition to.
     */
    void OnCommissioningWindowOpened();

    /**
     * @brief Sets the commissioning window state to open and calls the WifiSleepManager VerifyAndTransitionToLowPowerMode.
     *        The VerifyAndTransitionToLowPowerMode function is responsible of then queriyng the ApplicationSleepManager to
     *        determine in which low power state the Wi-Fi device can transition to.
     */
    void OnCommissioningWindowClosed();

    // ReadHandler::ApplicationCallback implementation

    /**
     * @brief Calls the WifiSleepManager VerifyAndTransitionToLowPowerMode.
     *        The VerifyAndTransitionToLowPowerMode function is responsible of then queriyng the ApplicationSleepManager to
     *        determine in which low power state the Wi-Fi device can transition to.
     */
    void OnSubscriptionTerminated(chip::app::ReadHandler & aReadHandler);

    /**
     * @brief Calls the WifiSleepManager VerifyAndTransitionToLowPowerMode.
     *        The VerifyAndTransitionToLowPowerMode function is responsible of then queriyng the ApplicationSleepManager to
     *        determine in which low power state the Wi-Fi device can transition to.
     */
    void OnSubscriptionEstablished(chip::app::ReadHandler & aReadHandler);

    CHIP_ERROR OnSubscriptionRequested(chip::app::ReadHandler & aReadHandler, chip::Transport::SecureSession & aSecureSession);

    // WifiSleepManager::ApplicationCallback implementation

    /**
     * @brief Function encapsulates the application logic to determine if the Wi-Fi device can go into LI based sleep.
     *
     *        - 1. Check if the commissioning window is open. If it is open, the Wi-Fi device cannot go to LI based sleep.
     *        - 2. Check if all Fabrics have at least 1 subscription. If there is at least one fabric without a subscription, the
     *             Wi-Fi cannot go to LI based sleep.
     *
     * @return true if the device can go to LI sleep
     *         false if the device cannot go to LI sleep
     */
    bool CanGoToLIBasedSleep() override;

    // FabricTable::Delegate implementation

    /**
     * @brief Calls the WifiSleepManager VerifyAndTransitionToLowPowerMode.
     *        The VerifyAndTransitionToLowPowerMode function is responsible of queriyng the ApplicationSleepManager to
     *        determine in which low power state the Wi-Fi device can transition to.
     */
    void OnFabricRemoved(const chip::FabricTable & fabricTable, chip::FabricIndex fabricIndex) override;

    /**
     * @brief Calls the WifiSleepManager VerifyAndTransitionToLowPowerMode.
     *        The VerifyAndTransitionToLowPowerMode function is responsible of queriyng the ApplicationSleepManager to
     *        determine in which low power state the Wi-Fi device can transition to.
     */
    void OnFabricCommitted(const chip::FabricTable & fabricTable, chip::FabricIndex fabricIndex) override;

    void OnFabricUpdated(const chip::FabricTable & fabricTable, chip::FabricIndex fabricIndex) override {}

    // ICDStateObserver implementation
    void OnEnterActiveMode() override;
    void OnEnterIdleMode() override;
    void OnTransitionToIdle() override;
    void OnICDModeChange() override;

private:
    ApplicationSleepManager()  = default;
    ~ApplicationSleepManager() = default;

    ApplicationSleepManager(const ApplicationSleepManager &)             = delete;
    ApplicationSleepManager & operator=(const ApplicationSleepManager &) = delete;

    /**
     * @brief Processes special cases based on the vendor ID.
     *
     * This method checks if the given vendor ID has any special cases that allow
     * the device to go to LI based sleep when the fabric associated to the vendor ID does not have an active subscription.
     *
     * @param vendorId The vendor ID to check for special cases.
     * @return true if the vendor ID has a special case that allows LI based sleep, false otherwise.
     */
    bool ProcessVendorIdExceptions(chip::VendorId vendorId);

    static ApplicationSleepManager mInstance;
    chip::FabricTable * mFabricTable                                  = nullptr;
    chip::app::SubscriptionsInfoProvider * mSubscriptionsInfoProvider = nullptr;
    chip::CommissioningWindowManager * mCommissioningWindowManager    = nullptr;
    chip::DeviceLayer::Silabs::WifiSleepManager * mWifiSleepManager   = nullptr;

    bool mIsCommissionningWindowOpen = false;
    bool mIsInActiveMode             = false;
};

} // namespace Silabs
} // namespace app
} // namespace chip
