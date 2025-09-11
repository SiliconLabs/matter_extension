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
#include <lib/core/DataModelTypes.h>
#include <lib/support/logging/CHIPLogging.h>

namespace chip {
namespace app {
namespace Silabs {

using chip::DeviceLayer::Silabs::WifiSleepManager;

namespace {

enum class SpecialCaseVendorID : uint16_t
{
    kAppleKeychain = 4996,
};

} // namespace

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
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

void ApplicationSleepManager::OnCommissioningWindowClosed()
{
    mIsCommissionningWindowOpen = false;
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

void ApplicationSleepManager::OnSubscriptionEstablished(chip::app::ReadHandler & aReadHandler)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

void ApplicationSleepManager::OnSubscriptionTerminated(chip::app::ReadHandler & aReadHandler)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

CHIP_ERROR ApplicationSleepManager::OnSubscriptionRequested(chip::app::ReadHandler & aReadHandler,
                                                            chip::Transport::SecureSession & aSecureSession)
{
    // Nothing to execute for the ApplicationSleepManager
    return CHIP_NO_ERROR;
}

void ApplicationSleepManager::OnFabricRemoved(const chip::FabricTable & fabricTable, chip::FabricIndex fabricIndex)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

void ApplicationSleepManager::OnFabricCommitted(const chip::FabricTable & fabricTable, chip::FabricIndex fabricIndex)
{
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

bool ApplicationSleepManager::CanGoToLIBasedSleep()
{
    bool canGoToLIBasedSleep = true;

    if (mIsCommissionningWindowOpen)
    {
        ChipLogProgress(AppServer, "Commissioning Window is Open - Cannot go to LI based sleep");
        canGoToLIBasedSleep = false;
    }
    else if (mIsInActiveMode)
    {
        ChipLogProgress(AppServer, "Device is in active mode - Cannot go to LI based sleep");
        canGoToLIBasedSleep = false;
    }
    else
    {
        for (auto it = mFabricTable->begin(); it != mFabricTable->end(); ++it)
        {
            if (!mSubscriptionsInfoProvider->FabricHasAtLeastOneActiveSubscription(it->GetFabricIndex()))
            {
                ChipLogProgress(AppServer, "Fabric index %u has no active subscriptions", it->GetFabricIndex());
                canGoToLIBasedSleep = ProcessSpecialVendorIDCase(it->GetVendorId());

                if (canGoToLIBasedSleep)
                {
                    ChipLogProgress(AppServer,
                                    "Fabric index %u with vendor ID : %d  has an edge case that allows for LI based sleep",
                                    it->GetFabricIndex(), it->GetVendorId());
                }
                else
                {
                    // Fabric doesn't meet the requirements to allow us to go to LI based sleep
                    break;
                }
            }
        }
    }

    return canGoToLIBasedSleep;
}

bool ApplicationSleepManager::ProcessSpecialVendorIDCase(chip::VendorId vendorId)
{
    bool hasValidException = false;
    switch (to_underlying(vendorId))
    {
    case to_underlying(SpecialCaseVendorID::kAppleKeychain):
        hasValidException = ProcessKeychainEdgeCase();
        break;

    default:
        break;
    }

    return hasValidException;
}

bool ApplicationSleepManager::ProcessKeychainEdgeCase()
{
    bool hasValidException = true; // Default to true if no VendorId::Apple fabric is found

    for (auto it = mFabricTable->begin(); it != mFabricTable->end(); ++it)
    {
        if (it->GetVendorId() == chip::VendorId::Apple)
        {
            if (!mSubscriptionsInfoProvider->FabricHasAtLeastOneActiveSubscription(it->GetFabricIndex()))
            {
                hasValidException = false; // Found an Apple fabric, but no active subscription
            }
            break;
        }
    }

    return hasValidException;
}

void ApplicationSleepManager::OnEnterActiveMode()
{
    mIsInActiveMode = true;
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

void ApplicationSleepManager::OnEnterIdleMode()
{
    mIsInActiveMode = false;
    mWifiSleepManager->VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent);
}

void ApplicationSleepManager::OnTransitionToIdle()
{
    // Nothing to do
}

void ApplicationSleepManager::OnICDModeChange()
{
    // Nothing to do
}

} // namespace Silabs
} // namespace app
} // namespace chip
