/*******************************************************************************
 * @file VendorHandler.h
 * @brief Header for the Vendor ID edge-case processing logic.
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

#include <app/SubscriptionsInfoProvider.h>
#include <credentials/FabricTable.h>

namespace chip {
namespace app {
namespace Silabs {

/**
 * @brief Delegate innterface class that defines edge-case processing logic.
 *
 * @tparam VendorHandlerImpl The derived class that implements the edge-case processing logic.
 */
template <typename VendorHandlerImpl>
class VendorHandler
{
public:
    /**
     * @brief Function to process the vendor ID edge-case.
     *        This function is called to dermine if the device can go to LI based sleep.
     *
     * @param[in] subscriptionsInfoProvider Validation of the pointer is left to the derived class if they require the object.
     * @param[in] fabricTable Validation of the pointer is left to the derived class if they require the object.
     *
     * @return true, if the device can go to LI based sleep.
     *         false, if the device cannot go to LI based sleep.
     */
    static bool ProcessVendorCase(chip::app::SubscriptionsInfoProvider * subscriptionsInfoProvider, chip::FabricTable * fabricTable)
    {
        return VendorHandlerImpl::ProcessVendorCaseImpl(subscriptionsInfoProvider, fabricTable);
    }

    /**
     * @brief Function call the derived class function to check if the vendor ID is the supported special case.
     *
     * @param vendorId The vendor ID to check agaisnt the supported derived class vendor ID.
     *
     * @return true, if the vendor ID matches the derived class vendor ID.
     *         false, if the vendor ID does not match the derived class vendor ID.
     */
    static bool IsMatchingVendorID(chip::VendorId vendorId) { return VendorHandlerImpl::IsMatchingVendorIDImpl(vendorId); }
};

} // namespace Silabs
} // namespace app
} // namespace chip
