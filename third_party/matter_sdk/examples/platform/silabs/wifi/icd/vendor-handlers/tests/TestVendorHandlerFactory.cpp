/*******************************************************************************
 * @file TestVendorHandlerFactory.cpp
 * @brief Unit Test File for the VendorHandlerFactory source file
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

#include <lib/core/StringBuilderAdapters.h>
#include <pw_unit_test/framework.h>

#include <VendorHandlerFactory.h>

namespace {

// Mock implementations for testing
class MockVendorHandlerA : public chip::app::Silabs::VendorHandler<MockVendorHandlerA>
{
public:
    static bool ProcessVendorCaseImpl(chip::app::SubscriptionsInfoProvider *, chip::FabricTable *)
    {
        return true; // Mock logic for VendorHandlerA
    }

    static bool IsMatchingVendorIDImpl(chip::VendorId vendorId)
    {
        return vendorId == chip::VendorId(0x1234); // Mock Vendor ID for VendorHandlerA
    }
};

class MockVendorHandlerB : public chip::app::Silabs::VendorHandler<MockVendorHandlerB>
{
public:
    static bool ProcessVendorCaseImpl(chip::app::SubscriptionsInfoProvider *, chip::FabricTable *)
    {
        return false; // Mock logic for VendorHandlerB
    }

    static bool IsMatchingVendorIDImpl(chip::VendorId vendorId)
    {
        return vendorId == chip::VendorId(0x5678); // Mock Vendor ID for VendorHandlerB
    }
};

// Define the VendorHandlerFactory with mock handlers
using TestVendorHandlerFactory = chip::app::Silabs::VendorHandlerFactory<MockVendorHandlerA, MockVendorHandlerB>;

// Test cases
TEST(VendorHandlerFactoryTest, MatchingVendorIDHandlerA)
{
    EXPECT_TRUE(TestVendorHandlerFactory::ProcessVendorCase(chip::VendorId(0x1234), nullptr, nullptr));
}

TEST(VendorHandlerFactoryTest, MatchingVendorIDHandlerB)
{
    EXPECT_FALSE(TestVendorHandlerFactory::ProcessVendorCase(chip::VendorId(0x5678), nullptr, nullptr));
}

TEST(VendorHandlerFactoryTest, NonMatchingVendorID)
{
    EXPECT_FALSE(TestVendorHandlerFactory::ProcessVendorCase(chip::VendorId(0x1111), nullptr, nullptr));
}

} // namespace
