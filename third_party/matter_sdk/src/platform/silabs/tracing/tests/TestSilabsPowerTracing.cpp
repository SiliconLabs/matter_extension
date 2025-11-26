/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/**
 *    @file
 *      This file implements a unit test suite for the SilabsPowerTracing
 *      code functionality.
 */

#include <cstdint>
#include <pw_unit_test/framework.h>

// #include <lib/core/StringBuilderAdapters.h>
// #include <lib/support/UnitTestUtils.h>
#include <system/SystemClock.h>

#include <platform/internal/CHIPDeviceLayerInternal.h>

// Define test configuration constants if not already defined
#ifndef SL_TRACING_ENERGY_TRACES_MAX
#define SL_TRACING_ENERGY_TRACES_MAX 100
#endif

#ifndef SL_TRACING_ENERGY_TRACES_SECONDS
#define SL_TRACING_ENERGY_TRACES_SECONDS 10
#endif

// Mock clock for testing
namespace {
chip::System::Clock::Internal::MockClock gMockClock;
chip::System::Clock::ClockBase * gRealClock;
} // namespace

// Provide the test time source function for macro injection
extern "C" uint32_t TestTimeSource_GetMilliseconds()
{
    return static_cast<uint32_t>(gMockClock.GetMonotonicMilliseconds64().count());
}

// Define the macro before including the implementation
#define SL_GET_SLEEPTIMER_TIME() TestTimeSource_GetMilliseconds()

// Include the implementation with our custom time source
#include <platform/silabs/tracing/SilabsPowerTracing.cpp> // nogncheck

using namespace chip;
using namespace chip::Logging;
using namespace chip::System;
using namespace chip::System::Clock::Literals;

using namespace chip::Tracing::Silabs;

class TestSilabsPowerTracing : public ::testing::Test
{
public:
    static void SetUpTestSuite()
    {
        ASSERT_EQ(chip::Platform::MemoryInit(), CHIP_NO_ERROR);

        gRealClock = &chip::System::SystemClock();
        chip::System::Clock::Internal::SetSystemClockForTesting(&gMockClock);
    }

    static void TearDownTestSuite()
    {
        chip::System::Clock::Internal::SetSystemClockForTesting(gRealClock);
        chip::Platform::MemoryShutdown();
    }

    void SetUp() override
    {
        // Reset the singleton between tests by destroying and reinitializing
        SilabsPowerTracing::Instance().~SilabsPowerTracing();
        new (&SilabsPowerTracing::Instance()) SilabsPowerTracing();
    }
};

TEST_F(TestSilabsPowerTracing, TestBasicFunctionality)
{
    gMockClock.SetMonotonic(0_ms64);

    // Initialize the power tracing system
    EXPECT_EQ(SilabsPowerTracing::Instance().Init(), CHIP_NO_ERROR);
    EXPECT_TRUE(SilabsPowerTracing::Instance().IsInitialized());

    // Record energy mode transitions at different timestamps
    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM0, SL_POWER_MANAGER_EM1);
    gMockClock.AdvanceMonotonic(100_ms64);

    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM1, SL_POWER_MANAGER_EM2);
    gMockClock.AdvanceMonotonic(200_ms64);

    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM2, SL_POWER_MANAGER_EM0);
    gMockClock.AdvanceMonotonic(50_ms64);

    // Verify trace count and contents
    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTraceCount(), 3u);

    const EnergyTrace * trace0 = SilabsPowerTracing::Instance().GetEnergyTrace(0);
    ASSERT_NE(trace0, nullptr);
    EXPECT_EQ(trace0->mEntryTime, 0u);
    EXPECT_EQ(trace0->mEnergyMode, SL_POWER_MANAGER_EM1);

    const EnergyTrace * trace1 = SilabsPowerTracing::Instance().GetEnergyTrace(1);
    ASSERT_NE(trace1, nullptr);
    EXPECT_EQ(trace1->mEntryTime, 100u);
    EXPECT_EQ(trace1->mEnergyMode, SL_POWER_MANAGER_EM2);

    const EnergyTrace * trace2 = SilabsPowerTracing::Instance().GetEnergyTrace(2);
    ASSERT_NE(trace2, nullptr);
    EXPECT_EQ(trace2->mEntryTime, 300u);
    EXPECT_EQ(trace2->mEnergyMode, SL_POWER_MANAGER_EM0);

    // Verify output succeeds
    EXPECT_EQ(SilabsPowerTracing::Instance().OutputPowerManagerTraces(), CHIP_NO_ERROR);

    // Add one more trace and verify
    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM0, SL_POWER_MANAGER_EM3);
    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTraceCount(), 4u);

    const EnergyTrace * trace3 = SilabsPowerTracing::Instance().GetEnergyTrace(3);
    ASSERT_NE(trace3, nullptr);
    EXPECT_EQ(trace3->mEntryTime, 350u);
    EXPECT_EQ(trace3->mEnergyMode, SL_POWER_MANAGER_EM3);

    EXPECT_EQ(SilabsPowerTracing::Instance().OutputPowerManagerTraces(), CHIP_NO_ERROR);
}

TEST_F(TestSilabsPowerTracing, TestBufferFull)
{
    gMockClock.SetMonotonic(0_ms64);

    EXPECT_EQ(SilabsPowerTracing::Instance().Init(), CHIP_NO_ERROR);

    // Fill the buffer to capacity
    for (size_t i = 0; i < SL_TRACING_ENERGY_TRACES_MAX; i++)
    {
        sl_power_manager_em_t from = static_cast<sl_power_manager_em_t>(i % 4);
        sl_power_manager_em_t to   = static_cast<sl_power_manager_em_t>((i + 1) % 4);
        SilabsPowerTracing::StaticPowerManagerTransitionCallback(from, to);
        gMockClock.AdvanceMonotonic(10_ms64);
    }

    // Verify buffer is at capacity
    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTraceCount(), static_cast<size_t>(SL_TRACING_ENERGY_TRACES_MAX));

    // Verify sample traces at beginning, middle, and end
    const EnergyTrace * trace0 = SilabsPowerTracing::Instance().GetEnergyTrace(0);
    ASSERT_NE(trace0, nullptr);
    EXPECT_EQ(trace0->mEntryTime, 0u);
    EXPECT_EQ(trace0->mEnergyMode, SL_POWER_MANAGER_EM1);

    const EnergyTrace * trace50 = SilabsPowerTracing::Instance().GetEnergyTrace(50);
    ASSERT_NE(trace50, nullptr);
    EXPECT_EQ(trace50->mEntryTime, 500u);
    EXPECT_EQ(trace50->mEnergyMode, SL_POWER_MANAGER_EM3);

    const EnergyTrace * trace99 = SilabsPowerTracing::Instance().GetEnergyTrace(99);
    ASSERT_NE(trace99, nullptr);
    EXPECT_EQ(trace99->mEntryTime, 990u);
    EXPECT_EQ(trace99->mEnergyMode, SL_POWER_MANAGER_EM0);

    // Verify additional transitions don't overflow the buffer
    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM0, SL_POWER_MANAGER_EM1);
    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTraceCount(), static_cast<size_t>(SL_TRACING_ENERGY_TRACES_MAX));

    // Verify output works with full buffer
    EXPECT_EQ(SilabsPowerTracing::Instance().OutputPowerManagerTraces(), CHIP_NO_ERROR);

    // Add more transitions to ensure buffer stays capped
    for (int i = 0; i < 10; i++)
    {
        SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM1, SL_POWER_MANAGER_EM2);
        gMockClock.AdvanceMonotonic(5_ms64);
    }

    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTraceCount(), static_cast<size_t>(SL_TRACING_ENERGY_TRACES_MAX));
    EXPECT_EQ(SilabsPowerTracing::Instance().OutputPowerManagerTraces(), CHIP_NO_ERROR);
}

TEST_F(TestSilabsPowerTracing, TestInitFailureHandling)
{
    gMockClock.SetMonotonic(0_ms64);

    // Reset the singleton and reinitialize with nullptr to simulate allocation failure
    SilabsPowerTracing::Instance().~SilabsPowerTracing();
    new (&SilabsPowerTracing::Instance()) SilabsPowerTracing();

    // Verify the system is not initialized
    EXPECT_FALSE(SilabsPowerTracing::Instance().IsInitialized());

    // Attempt to record energy mode transitions - should be ignored gracefully
    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM0, SL_POWER_MANAGER_EM1);
    gMockClock.AdvanceMonotonic(100_ms64);
    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM1, SL_POWER_MANAGER_EM2);

    // Verify no traces were recorded
    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTraceCount(), 0u);
    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTrace(0), nullptr);

    // Verify output operation doesn't crash when not initialized
    EXPECT_EQ(SilabsPowerTracing::Instance().OutputPowerManagerTraces(), CHIP_ERROR_UNINITIALIZED);

    // Now initialize properly and verify system recovers
    EXPECT_EQ(SilabsPowerTracing::Instance().Init(), CHIP_NO_ERROR);
    EXPECT_TRUE(SilabsPowerTracing::Instance().IsInitialized());

    // Verify system works after proper initialization
    SilabsPowerTracing::StaticPowerManagerTransitionCallback(SL_POWER_MANAGER_EM2, SL_POWER_MANAGER_EM0);
    EXPECT_EQ(SilabsPowerTracing::Instance().GetEnergyTraceCount(), 1u);

    const EnergyTrace * trace = SilabsPowerTracing::Instance().GetEnergyTrace(0);
    ASSERT_NE(trace, nullptr);
    EXPECT_EQ(trace->mEnergyMode, SL_POWER_MANAGER_EM0);

    EXPECT_EQ(SilabsPowerTracing::Instance().OutputPowerManagerTraces(), CHIP_NO_ERROR);
}
