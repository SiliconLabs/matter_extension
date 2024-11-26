/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
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
 *      This file implements a unit test suite for the Platform Time
 *      code functionality.
 *
 */

#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <pw_unit_test/framework.h>

#include <lib/core/StringBuilderAdapters.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/UnitTestUtils.h>
#include <system/SystemClock.h>

#include <platform/internal/CHIPDeviceLayerInternal.h>

#include <platform/silabs/tracing/SilabsTracing.h>

using namespace chip;
using namespace chip::Logging;
using namespace chip::System;
using namespace chip::System::Clock::Literals;

using namespace chip::Tracing::Silabs;

namespace {
chip::System::Clock::Internal::MockClock gMockClock;
chip::System::Clock::ClockBase * gRealClock;
#ifndef SILABS_LOG_ENABLED
bool logInitialized = false;
#endif
} // namespace

#ifndef SILABS_LOG_ENABLED
bool isLogInitialized()
{
    return logInitialized;
}
#endif

class TestSilabsTracing : public ::testing::Test
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
};

TEST_F(TestSilabsTracing, TestTimeTrackerMethods)
{
    gMockClock.SetMonotonic(0_ms64);
    size_t traceCount = 0;

    SilabsTracer::Instance().Init();

    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 0u);

    // Start tracking time for a specific event
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    // Simulate some delay or work
    gMockClock.AdvanceMonotonic(100_ms64);
    // Stop tracking time for the event
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    // Retrieve the tracked time
    auto timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    auto trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();

    // Check that the tracked time is within an expected range
    EXPECT_EQ(trackedTime, uint32_t(100));

    // Retrieve the watermark for the operation
    auto watermark = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSpake2p);

    // Verify the count, moving average, highest, and lowest functionalities
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(trackedTime));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(trackedTime));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(trackedTime));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Repeat and verify the count and moving average, high and low got updated properly
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSpake2p);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(2));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(125));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(150));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(1));

    // Repeat for another event to verify multiple tracking works
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kPake1);
    gMockClock.AdvanceMonotonic(50_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kPake1);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake1);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kPake1);
    EXPECT_EQ(trackedTime, uint32_t(50));

    // Verify the count, moving average, highest, and lowest functionalities
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), trackedTime);
    EXPECT_EQ(watermark.mMaxTimeMs.count(), trackedTime);
    EXPECT_EQ(watermark.mMinTimeMs.count(), trackedTime);
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Repeat Again for first event to verify multiple tracking works
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSpake2p);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(3));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(150));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(3));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(2));

    // Verify a double start to simulate a failure
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(110_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSpake2p);
    EXPECT_EQ(trackedTime, uint32_t(110));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(5));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(140));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(4));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(2));

    // Check that traceCount is equal to the number of TimeTraceBegin and TimeTraceEnd calls
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 11u); // 11 calls: 6 TimeTraceBegin and 5 TimeTraceEnd
}

TEST_F(TestSilabsTracing, TestBootupSequence)
{
    gMockClock.SetMonotonic(0_ms64);
    SilabsTracer::Instance().Init();

    size_t traceCount = 0;
    traceCount        = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 0u);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);
    // Simulate Silabs Init
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSilabsInit);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSilabsInit);

    // Simulate Matter Init
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kMatterInit);
    gMockClock.AdvanceMonotonic(300_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kMatterInit);

    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kBootup);

    // Verify the time tracker values for each operation
    auto timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kBootup);
    auto trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    EXPECT_EQ(trackedTime, uint32_t(500));

    // Retrieve the watermark for the operation
    auto watermark = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kBootup);

    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(500));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(500));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(500));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSilabsInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSilabsInit);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kMatterInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kMatterInit);
    EXPECT_EQ(trackedTime, uint32_t(300));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(300));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(300));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(300));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Simulate a second simulation where we have a reboot during Silabs Init
    gMockClock.SetMonotonic(0_ms64);
    // TODO : Here we simulate that we have restore the watermarks stored in the NVM so we do not do the Init, we should call it
    // and call the LoadWatermarks method here

    // SilabsTracer::Instance().Init();

    // traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    // EXPECT_EQ(traceCount, 0u);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);

    // Simulate Silabs Init
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSilabsInit);
    gMockClock.AdvanceMonotonic(150_ms64);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);
    // Simulate Silabs Init
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSilabsInit);
    gMockClock.AdvanceMonotonic(350_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSilabsInit);

    // Simulate Matter Init
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kMatterInit);
    gMockClock.AdvanceMonotonic(250_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kMatterInit);

    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kBootup);

    // Verify the time tracker values for each operation after reboot
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kBootup);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kBootup);
    EXPECT_EQ(trackedTime, uint32_t(600));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(3));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(550));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(600));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(500));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(1));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSilabsInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSilabsInit);
    EXPECT_EQ(trackedTime, uint32_t(350));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(3));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(275));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(350));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(1));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kMatterInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kMatterInit);
    EXPECT_EQ(trackedTime, uint32_t(250));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(2));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(275));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(300));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(250));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Check that traceCount is equal to the number of TimeTraceBegin and TimeTraceEnd calls
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 14u); // 14 calls: 8 TimeTraceBegin and 6 TimeTraceEnd
}

TEST_F(TestSilabsTracing, TestCommissioning)
{
    gMockClock.SetMonotonic(0_ms64);
    SilabsTracer::Instance().Init();

    size_t traceCount = 0;
    traceCount        = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 0u);

    // Simulate Spake2p steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kPake1);
    gMockClock.AdvanceMonotonic(50_ms64);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kPake1);
    gMockClock.AdvanceMonotonic(100_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kPake1);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kPake2);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kPake2);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kPake2);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kPake3);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kPake3);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    // Verify the time tracker values for Spake2p
    auto timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    auto trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    EXPECT_EQ(trackedTime, uint32_t(700));

    // Retrieve the watermark for the operation
    auto watermark = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSpake2p);

    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(700));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(700));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(700));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Pake1
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake1);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kPake1);
    EXPECT_EQ(trackedTime, uint32_t(100));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(2));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Pake2
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake2);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kPake2);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(2));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Pake3
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake3);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kPake3);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Simulate Operational Credentials steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOperationalCredentials);
    gMockClock.AdvanceMonotonic(300_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOperationalCredentials);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOperationalCredentials);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kOperationalCredentials);
    EXPECT_EQ(trackedTime, uint32_t(300));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(300));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(300));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(300));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Simulate Transport Layer steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kTransportLayer);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kTransportSetup);
    gMockClock.AdvanceMonotonic(100_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kTransportSetup);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kFindOperational);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kFindOperational);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kTransportLayer);

    // Verify the time tracker values for Transport Layer
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kTransportLayer);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kTransportLayer);
    EXPECT_EQ(trackedTime, uint32_t(250));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(250));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(250));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(250));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Transport Setup
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kTransportSetup);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kTransportSetup);
    EXPECT_EQ(trackedTime, uint32_t(100));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Find Operational
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kFindOperational);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kFindOperational);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(150));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(150));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(150));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Simulate Case Session steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kCaseSession);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSigma1);
    gMockClock.AdvanceMonotonic(100_ms64);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSigma1);
    gMockClock.AdvanceMonotonic(100_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSigma1);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSigma2);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSigma2);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSigma3);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSigma3);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kCaseSession);

    // Verify the time tracker values for Case Session
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kCaseSession);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kCaseSession);
    EXPECT_EQ(trackedTime, uint32_t(550));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(550));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(550));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(550));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Sigma1
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSigma1);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSigma1);
    EXPECT_EQ(trackedTime, uint32_t(100));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(2));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Sigma2
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSigma2);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSigma2);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(150));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(150));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(150));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Sigma3
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSigma3);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kSigma3);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Check that traceCount is equal to the number of TimeTraceBegin and TimeTraceEnd calls
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 27u);
}

TEST_F(TestSilabsTracing, TestOTA)
{
    gMockClock.SetMonotonic(0_ms64);
    SilabsTracer::Instance().Init();
    size_t traceCount = 0;
    traceCount        = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 0u);

    // Simulate OTA steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOTA);
    gMockClock.AdvanceMonotonic(100_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOTA);

    // Verify the time tracker values for OTA
    auto timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOTA);
    auto trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    EXPECT_EQ(trackedTime, uint32_t(100));

    // Retrieve the watermark for the operation
    auto watermark = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kOTA);

    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Simulate OTA steps with failure
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOTA);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOTA, CHIP_ERROR_INTERNAL);

    // Verify the time tracker values for OTA after failure
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOTA);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kOTA);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(2));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Simulate Bootup steps after OTA failure
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kBootup);

    // Verify the time tracker values for Bootup
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kBootup);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kBootup);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Simulate subsequent OTA steps that succeed
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOTA);
    gMockClock.AdvanceMonotonic(120_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOTA);

    // Verify the time tracker values for OTA after success
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOTA);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kOTA);
    EXPECT_EQ(trackedTime, uint32_t(120));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(3));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(110));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(120));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(1));

    // Check that traceCount is equal to the number of TimeTraceBegin and TimeTraceEnd calls
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 8u); // 8 calls: 4 TimeTraceBegin and 4 TimeTraceEnd
}

TEST_F(TestSilabsTracing, TestLogs)
{
    gMockClock.SetMonotonic(0_ms64);
    SilabsTracer::Instance().Init();

#ifndef SILABS_LOG_ENABLED
    logInitialized = true;
#endif
    size_t traceCount = 0;

    // Simulate OTA steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOTA);
    gMockClock.AdvanceMonotonic(100_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOTA);

    // Simulate Bootup steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kBootup);

    // Verify the time tracker values for OTA
    auto timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOTA);
    auto trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    EXPECT_EQ(trackedTime, uint32_t(100));

    // Retrieve the watermark for the operation
    auto watermark = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kOTA);
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Bootup
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kBootup);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    watermark   = SilabsTracer::Instance().GetWatermark(TimeTraceOperation::kBootup);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(watermark.mTotalCount, uint32_t(1));
    EXPECT_EQ(watermark.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(watermark.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(watermark.mCountAboveAvg, uint32_t(0));

    // Check that traceCount is equal to the number of TimeTraceBegin and TimeTraceEnd calls
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 4u); // 4 calls: 2 TimeTraceBegin and 2 TimeTraceEnd

    // Verify the output logs using GetTraceByOperation
    uint8_t logBuffer[256];
    MutableByteSpan span(logBuffer);

    // Verify OTA log
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kOTA, span), CHIP_NO_ERROR);
    const char * expectedOTALogFormat =
        "TimeTracker - StartTime: 0, EndTime: 100, Duration: 100 ms, Operation: OTA, Type: End, Error: 0x0";
    EXPECT_STREQ(reinterpret_cast<const char *>(span.data()), expectedOTALogFormat);

    // Verify Bootup log
    span = MutableByteSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kBootup, span), CHIP_NO_ERROR);
    const char * expectedBootupLogFormat =
        "TimeTracker - StartTime: 100, EndTime: 300, Duration: 200 ms, Operation: Bootup, Type: End, Error: 0x0";
    EXPECT_STREQ(reinterpret_cast<const char *>(span.data()), expectedBootupLogFormat);

    // Test buffer too small behavior
    uint8_t smallBuffer[10];
    MutableByteSpan smallSpan(smallBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kOTA, smallSpan), CHIP_ERROR_BUFFER_TOO_SMALL);

    // Test TraceBufferFlushByOperation
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushByOperation(TimeTraceOperation::kOTA), CHIP_NO_ERROR);
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 2u); // Only Bootup traces should remain

    // Verify Bootup log still exists
    span = MutableByteSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kBootup, span), CHIP_NO_ERROR);
    EXPECT_STREQ(reinterpret_cast<const char *>(span.data()), expectedBootupLogFormat);

    // Verify OTA log is removed
    span = MutableByteSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kOTA, span), CHIP_ERROR_NOT_FOUND);

    // Test TraceBufferFlushAll
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushAll(), CHIP_NO_ERROR);
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 0u); // All traces should be flushed

    // Verify no logs exist
    span = MutableByteSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kBootup, span), CHIP_ERROR_NOT_FOUND);
    span = MutableByteSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kOTA, span), CHIP_ERROR_NOT_FOUND);
}

TEST_F(TestSilabsTracing, TestBufferBusting)
{
    gMockClock.SetMonotonic(0_ms64);
    SilabsTracer::Instance().Init();
    size_t traceCount = 0;
    traceCount        = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 0u);

    // Simulate a large number of traces
    while (traceCount < SilabsTracer::kMaxBufferedTraces - 2)
    {
        EXPECT_EQ(CHIP_NO_ERROR, SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kCaseSession));
        gMockClock.AdvanceMonotonic(100_ms64);
        traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    }

    EXPECT_EQ(SilabsTracer::kMaxBufferedTraces - 2, SilabsTracer::Instance().GetTimeTracesCount());
    EXPECT_EQ(CHIP_NO_ERROR, SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOTA));
    EXPECT_EQ(CHIP_ERROR_BUFFER_TOO_SMALL, SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kImageUpload));

    // Verify an overflow operation is added (kBufferFull)
    EXPECT_EQ(SilabsTracer::kMaxBufferedTraces, SilabsTracer::Instance().GetTimeTracesCount());
    uint8_t logBuffer[256];
    MutableByteSpan logSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kBufferFull, logSpan), CHIP_NO_ERROR);
    const char * expectedNumLogFormat = "TimeTracker - EventTime: 6200, Operation: BufferFull, Type: Instant, Error: 0x19";
    EXPECT_STREQ(reinterpret_cast<const char *>(logSpan.data()), expectedNumLogFormat);

    // Verify the kImageUpload operation was not added
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kImageUpload, logSpan), CHIP_ERROR_NOT_FOUND);

    // Flush kOTA operation
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushByOperation(TimeTraceOperation::kOTA), CHIP_NO_ERROR);
    EXPECT_EQ(SilabsTracer::kMaxBufferedTraces - 1, SilabsTracer::Instance().GetTimeTracesCount());

    // Verify that adding a new operation still results in a buffer full operation since we are at size -1
    EXPECT_EQ(CHIP_ERROR_BUFFER_TOO_SMALL, SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kImageUpload));
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kImageUpload, logSpan), CHIP_ERROR_NOT_FOUND);

    // Flush the overflow operations
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushByOperation(TimeTraceOperation::kBufferFull), CHIP_NO_ERROR);
    EXPECT_EQ(SilabsTracer::kMaxBufferedTraces - 2, SilabsTracer::Instance().GetTimeTracesCount());

    // Verify that adding a new operation now succeeds
    EXPECT_EQ(CHIP_NO_ERROR, SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kImageUpload));
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kImageUpload, logSpan), CHIP_NO_ERROR);

    // Verify that the buffer full operation is removed
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(TimeTraceOperation::kBufferFull, logSpan), CHIP_ERROR_NOT_FOUND);

    // Flush all operations
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushAll(), CHIP_NO_ERROR);
    EXPECT_EQ(0u, SilabsTracer::Instance().GetTimeTracesCount());
}
