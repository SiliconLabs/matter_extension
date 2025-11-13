/*******************************************************************************
 * @file TestVendorHandler.cpp
 * @brief Unit Test File for the VendorHandler source file
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

#include <VendorHandler.h>

#include <app/SubscriptionsInfoProvider.h>
#include <credentials/FabricTable.h>
#include <lib/core/DataModelTypes.h>

namespace {

bool wasProcessVendorCaseImplCalled = false;
bool wasIsMatchingVendorIDCalled    = false;

void Reset()
{
    wasProcessVendorCaseImplCalled = false;
    wasIsMatchingVendorIDCalled    = false;
}

class MockVendorHandler : public chip::app::Silabs::VendorHandler<MockVendorHandler>
{

public:
    static bool ProcessVendorCaseImpl(chip::app::SubscriptionsInfoProvider * subscriptionsInfoProvider,
                                      chip::FabricTable * fabricTable)
    {
        wasProcessVendorCaseImplCalled = true;
        return false;
    }

    static bool IsMatchingVendorIDImpl(chip::VendorId vendorId)
    {
        wasIsMatchingVendorIDCalled = true;
        return false;
    }
};

class TestVendorHandler : public ::testing::Test
{
public:
    void SetUp() override { Reset(); }
};

TEST_F(TestVendorHandler, ProcessVendorCase)
{
    EXPECT_FALSE(chip::app::Silabs::VendorHandler<MockVendorHandler>::ProcessVendorCase(nullptr, nullptr));

    EXPECT_TRUE(wasProcessVendorCaseImplCalled);
    EXPECT_FALSE(wasIsMatchingVendorIDCalled);
}

TEST_F(TestVendorHandler, IsMatchingVendorID)
{
    EXPECT_FALSE(chip::app::Silabs::VendorHandler<MockVendorHandler>::IsMatchingVendorID(chip::VendorId(1234)));

    EXPECT_FALSE(wasProcessVendorCaseImplCalled);
    EXPECT_TRUE(wasIsMatchingVendorIDCalled);
}

} // namespace
