/*******************************************************************************
 * @file AppleKeychainHandler.h
 * @brief Handler for the Apple Keychain edge-case processing logic.
 *******************************************************************************
 * # License
 * <b>Copyright 2025 Silicon Laboratories Inc. www.silabs.com</b>
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

#include <VendorHandler.h>
#include <lib/core/DataModelTypes.h>

namespace chip {
namespace app {
namespace Silabs {

/**
 * @brief Processes the Apple Keychain edge case.
 *
 * Apple, when commissioning, adds two fabric to the device. One for Apple Home and one for the Apple Keychain.
 * Apple Home is the active fabric which is used to communication with the device. The associated fabric also has the active
 * subcription. The Apple Keychain fabric acts as a safety and doesn't have an active fabric with the device. As such, we need an
 * alternate method to check if the device can go to LI based sleep.
 *
 * This method checks if there is any fabric with the Apple Home vendor ID that
 * has at least one active subscription. If such a fabric is found, it allows
 * the device to go to LI based sleep.
 * If the device has an Apple Keychain fabric but no Apple fabric, the device can go to LI based
 * sleep.
 */
class AppleKeychainHandler : public VendorHandler<AppleKeychainHandler>
{
public:
    static bool ProcessVendorCaseImpl(chip::app::SubscriptionsInfoProvider * subscriptionsInfoProvider,
                                      chip::FabricTable * fabricTable)
    {
        VerifyOrReturnValue(subscriptionsInfoProvider != nullptr && fabricTable != nullptr, false);

        bool hasValidException = true; // Default to true if no VendorId::Apple fabric is found

        // This condition should never happen in practice. We shouldn't be calling an excepting handler if there are no fabrics.
        // But if it does, we can assume that the device is in a state where it cannot go to LI based sleep.
        VerifyOrReturnValue(fabricTable->FabricCount() > 0, false);

        for (auto it = fabricTable->begin(); it != fabricTable->end(); ++it)
        {
            if (it->GetVendorId() == chip::VendorId::Apple)
            {
                if (!subscriptionsInfoProvider->FabricHasAtLeastOneActiveSubscription(it->GetFabricIndex()))
                {
                    hasValidException = false; // Found an Apple fabric, but no active subscription
                }
                break;
            }
        }

        return hasValidException;
    }

    static bool IsMatchingVendorID(chip::VendorId vendorId) { return vendorId == kAppleKeychainVendorId; }

private:
    // Official Apple Keychain vendor ID from the CSA database
    static constexpr uint16_t kAppleKeychainVendorId = 4996;
};

} // namespace Silabs
} // namespace app
} // namespace chip
