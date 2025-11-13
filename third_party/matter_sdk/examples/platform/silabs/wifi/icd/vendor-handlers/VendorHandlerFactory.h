/*******************************************************************************
 * @file VendorHandlerFactory.h
 * @brief Factory class to call the correct vendor handler based on the vendor ID.
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

#include <AppleKeychainHandler.h>
#include <app/SubscriptionsInfoProvider.h>
#include <credentials/FabricTable.h>
#include <lib/core/DataModelTypes.h>

namespace chip {
namespace app {
namespace Silabs {

template <typename... Handlers>
class VendorHandlerFactory
{
public:
    static bool ProcessVendorCase(chip::VendorId vendorId, chip::app::SubscriptionsInfoProvider * subscriptionsInfoProvider,
                                  chip::FabricTable * fabricTable)
    {
        // Iterate over all handlers and process the applicable one
        return ((Handlers::IsMatchingVendorID(vendorId) && Handlers::ProcessVendorCase(subscriptionsInfoProvider, fabricTable)) ||
                ...);
    }
};

} // namespace Silabs
} // namespace app
} // namespace chip
