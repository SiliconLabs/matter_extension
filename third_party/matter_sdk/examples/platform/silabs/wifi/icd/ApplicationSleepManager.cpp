/*******************************************************************************
 * @file ApplicationSleepManager.cpp
 * @brief Implementation for the buisness logic around Optimizing Wi-Fi sleep states
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

#include "ApplicationSleepManager.h"
#include <lib/support/logging/CHIPLogging.h>

namespace chip {
namespace app {
namespace Silabs {

ApplicationSleepManager ApplicationSleepManager::mInstance;

CHIP_ERROR ApplicationSleepManager::Init()
{
    VerifyOrReturnError(mFabricTable != nullptr, CHIP_ERROR_INVALID_ARGUMENT, ChipLogError(AppServer, "FabricTable is null"));
    VerifyOrReturnError(mSubscriptionsInfoProvider != nullptr, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(AppServer, "SubscriptionsInfoProvider is null"));
    VerifyOrReturnError(mWifiSleepManager != nullptr, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(AppServer, "WifiSleepManager is null"));

    ReturnErrorOnFailure(mFabricTable->AddFabricDelegate(this));

    // Register WifiSleepManager::ApplicationCallback
    mWifiSleepManager->SetApplicationCallback(this);

    return CHIP_NO_ERROR;
}

void ApplicationSleepManager::OnCommissioningWindowOpened()
{
    mIsCommissionningWindowOpen = true;
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode();
}

void ApplicationSleepManager::OnCommissioningWindowClosed()
{
    mIsCommissionningWindowOpen = false;
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode();
}

void ApplicationSleepManager::OnSubscriptionEstablished(chip::app::ReadHandler & aReadHandler)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode();
}

void ApplicationSleepManager::OnSubscriptionTerminated(chip::app::ReadHandler & aReadHandler)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode();
}

CHIP_ERROR ApplicationSleepManager::OnSubscriptionRequested(chip::app::ReadHandler & aReadHandler,
                                                            chip::Transport::SecureSession & aSecureSession)
{
    // Nothing to execute for the ApplicationSleepManager
    return CHIP_NO_ERROR;
}

void ApplicationSleepManager::OnFabricRemoved(const chip::FabricTable & fabricTable, chip::FabricIndex fabricIndex)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode();
}

void ApplicationSleepManager::OnFabricCommitted(const chip::FabricTable & fabricTable, chip::FabricIndex fabricIndex)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode();
}

bool ApplicationSleepManager::CanGoToLIBasedSleep()
{
    bool canGoToLIBasedSleep = true;

    if (mIsCommissionningWindowOpen)
    {
        ChipLogProgress(AppServer, "Commissioning Window is Open - Cannot go to LI based sleep");
        canGoToLIBasedSleep = false;
    }
    else
    {
        for (auto it = mFabricTable->begin(); it != mFabricTable->end(); ++it)
        {
            if (!mSubscriptionsInfoProvider->FabricHasAtLeastOneActiveSubscription(it->GetFabricIndex()))
            {
                ChipLogProgress(AppServer, "Fabric index %u has no active subscriptions - Cannot go to LI based sleep",
                                it->GetFabricIndex());
                canGoToLIBasedSleep = false;
                break;
            }
            ChipLogProgress(AppServer, "All Fabrics have at least 1 active subscription!");
        }
    }

    return canGoToLIBasedSleep;
}

} // namespace Silabs
} // namespace app
} // namespace chip
