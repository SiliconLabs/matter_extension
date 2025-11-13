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

    // Retrieve the metric for the operation
    auto metric = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSpake2p);

    // Verify the count, moving average, highest, and lowest functionalities
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(trackedTime));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(trackedTime));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(trackedTime));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Repeat and verify the count and moving average, high and low got updated properly
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSpake2p);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(metric.mTotalCount, uint32_t(2));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(125));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(150));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(1));

    // Repeat for another event to verify multiple tracking works
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kPake1);
    gMockClock.AdvanceMonotonic(50_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kPake1);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake1);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kPake1);
    EXPECT_EQ(trackedTime, uint32_t(50));

    // Verify the count, moving average, highest, and lowest functionalities
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), trackedTime);
    EXPECT_EQ(metric.mMaxTimeMs.count(), trackedTime);
    EXPECT_EQ(metric.mMinTimeMs.count(), trackedTime);
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Repeat Again for first event to verify multiple tracking works
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSpake2p);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(metric.mTotalCount, uint32_t(3));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(150));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(3));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(2));

    // Verify a double start to simulate a failure
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSpake2p);
    gMockClock.AdvanceMonotonic(110_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kSpake2p);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSpake2p);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSpake2p);
    EXPECT_EQ(trackedTime, uint32_t(110));
    EXPECT_EQ(metric.mTotalCount, uint32_t(5));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(140));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(4));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(2));

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

    // Retrieve the metric for the operation
    auto metric = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kBootup);

    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(500));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(500));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(500));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSilabsInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSilabsInit);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kMatterInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kMatterInit);
    EXPECT_EQ(trackedTime, uint32_t(300));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(300));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(300));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(300));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Simulate a second simulation where we have a reboot during Silabs Init
    gMockClock.SetMonotonic(0_ms64);
    // TODO : Here we simulate that we have restore the metrics stored in the NVM so we do not do the Init, we should call it
    // and call the LoadMetrics method here

    // SilabsTracer::Instance().Init();

    // traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    // EXPECT_EQ(traceCount, 0u);

    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);

    // Simulate Silabs Init
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kSilabsInit);
    gMockClock.AdvanceMonotonic(150_ms64);
    gMockClock.SetMonotonic(0_ms64); // Resetting to 0 since reboot should reset the monotonic clock
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
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kBootup);
    EXPECT_EQ(trackedTime, uint32_t(600));
    EXPECT_EQ(metric.mTotalCount, uint32_t(3));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(550));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(600));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(500));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(1));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSilabsInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSilabsInit);
    EXPECT_EQ(trackedTime, uint32_t(350));
    EXPECT_EQ(metric.mTotalCount, uint32_t(3));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(275));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(350));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(1));

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kMatterInit);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kMatterInit);
    EXPECT_EQ(trackedTime, uint32_t(250));
    EXPECT_EQ(metric.mTotalCount, uint32_t(2));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(275));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(300));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(250));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

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

    // Retrieve the metric for the operation
    auto metric = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSpake2p);

    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(700));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(700));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(700));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Pake1
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake1);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kPake1);
    EXPECT_EQ(trackedTime, uint32_t(100));
    EXPECT_EQ(metric.mTotalCount, uint32_t(2));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Pake2
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake2);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kPake2);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(metric.mTotalCount, uint32_t(2));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Pake3
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kPake3);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kPake3);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Simulate Operational Credentials steps
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOperationalCredentials);
    gMockClock.AdvanceMonotonic(300_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOperationalCredentials);

    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOperationalCredentials);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kOperationalCredentials);
    EXPECT_EQ(trackedTime, uint32_t(300));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(300));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(300));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(300));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

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
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kTransportLayer);
    EXPECT_EQ(trackedTime, uint32_t(250));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(250));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(250));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(250));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Transport Setup
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kTransportSetup);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kTransportSetup);
    EXPECT_EQ(trackedTime, uint32_t(100));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Find Operational
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kFindOperational);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kFindOperational);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(150));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(150));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(150));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

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
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kCaseSession);
    EXPECT_EQ(trackedTime, uint32_t(550));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(550));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(550));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(550));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Sigma1
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSigma1);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSigma1);
    EXPECT_EQ(trackedTime, uint32_t(100));
    EXPECT_EQ(metric.mTotalCount, uint32_t(2));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Sigma2
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSigma2);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSigma2);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(150));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(150));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(150));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Sigma3
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kSigma3);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kSigma3);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

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

    // Retrieve the metric for the operation
    auto metric = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kOTA);

    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Simulate OTA steps with failure
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOTA);
    gMockClock.AdvanceMonotonic(150_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOTA, CHIP_ERROR_INTERNAL);

    // Verify the time tracker values for OTA after failure
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOTA);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kOTA);
    EXPECT_EQ(trackedTime, uint32_t(150));
    EXPECT_EQ(metric.mTotalCount, uint32_t(2));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Simulate Bootup steps after OTA failure
    gMockClock.SetMonotonic(0_ms64); // Resetting to 0 since reboot should reset the monotonic clock
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kBootup);

    // Verify the time tracker values for Bootup
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kBootup);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kBootup);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Simulate subsequent OTA steps that succeed
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kOTA);
    gMockClock.AdvanceMonotonic(120_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kOTA);

    // Verify the time tracker values for OTA after success
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOTA);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kOTA);
    EXPECT_EQ(trackedTime, uint32_t(120));
    EXPECT_EQ(metric.mTotalCount, uint32_t(3));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(110));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(120));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(2));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(1));

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
    gMockClock.SetMonotonic(0_ms64); // Resetting to 0 since reboot should reset the monotonic clock
    SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kBootup);
    gMockClock.AdvanceMonotonic(200_ms64);
    SilabsTracer::Instance().TimeTraceEnd(TimeTraceOperation::kBootup);

    // Verify the time tracker values for OTA
    auto timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kOTA);
    auto trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    EXPECT_EQ(trackedTime, uint32_t(100));

    // Retrieve the metric for the operation
    auto metric = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kOTA);
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(100));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(100));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Verify the time tracker values for Bootup
    timeTracker = SilabsTracer::Instance().GetTimeTracker(TimeTraceOperation::kBootup);
    trackedTime = timeTracker.mEndTime.count() - timeTracker.mStartTime.count();
    metric      = SilabsTracer::Instance().GetMetric(TimeTraceOperation::kBootup);
    EXPECT_EQ(trackedTime, uint32_t(200));
    EXPECT_EQ(metric.mTotalCount, uint32_t(1));
    EXPECT_EQ(metric.mMovingAverage.count(), uint32_t(200));
    EXPECT_EQ(metric.mMaxTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mMinTimeMs.count(), uint32_t(200));
    EXPECT_EQ(metric.mSuccessfullCount, uint32_t(1));
    EXPECT_EQ(metric.mCountAboveAvg, uint32_t(0));

    // Check that traceCount is equal to the number of TimeTraceBegin and TimeTraceEnd calls
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 4u); // 4 calls: 2 TimeTraceBegin and 2 TimeTraceEnd

    // Verify the output logs using Operation
    char logBuffer[256];
    MutableCharSpan span(logBuffer);

    // Verify OTA log
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kOTA), span), CHIP_NO_ERROR);
    const char * expectedOTALogFormat = "TimeTracker - End      | OTA                              | Status: 0 | Start: "
                                        "00:00:00.000| End: 00:00:00.100| Duration: 00:00:00.100";
    EXPECT_STREQ(span.data(), expectedOTALogFormat);

    // Verify Bootup log
    span = MutableCharSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kBootup), span), CHIP_NO_ERROR);
    const char * expectedBootupLogFormat = "TimeTracker - End      | Bootup                           | Status: 0 | Start: "
                                           "00:00:00.000| End: 00:00:00.200| Duration: 00:00:00.200";
    EXPECT_STREQ(span.data(), expectedBootupLogFormat);

    // Test buffer too small behavior
    char smallBuffer[10];
    MutableCharSpan smallSpan(smallBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kOTA), smallSpan),
              CHIP_ERROR_BUFFER_TOO_SMALL);

    // Test TraceBufferFlushByOperation
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushByOperation(to_underlying(TimeTraceOperation::kOTA)), CHIP_NO_ERROR);
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 2u); // Only Bootup traces should remain

    // Verify Bootup log still exists
    span = MutableCharSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kBootup), span), CHIP_NO_ERROR);
    EXPECT_STREQ(span.data(), expectedBootupLogFormat);

    // Verify OTA log is removed
    span = MutableCharSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kOTA), span), CHIP_ERROR_NOT_FOUND);

    // Test TraceBufferFlushAll
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushAll(), CHIP_NO_ERROR);
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 0u); // All traces should be flushed

    // Verify no logs exist
    span = MutableCharSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kBootup), span), CHIP_ERROR_NOT_FOUND);
    span = MutableCharSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kOTA), span), CHIP_ERROR_NOT_FOUND);

    // Named traces logging
    EXPECT_EQ(
        CHIP_NO_ERROR,
        SilabsTracer::Instance().NamedTraceBegin(CharSpan::fromCharString("CustomOp"), CharSpan::fromCharString("TestGroup")));
    gMockClock.AdvanceMonotonic(150_ms64);
    EXPECT_EQ(CHIP_NO_ERROR,
              SilabsTracer::Instance().NamedTraceEnd(CharSpan::fromCharString("CustomOp"), CharSpan::fromCharString("TestGroup")));

    // Verify named trace log
    span = MutableCharSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(CharSpan::fromCharString("TestGroup:CustomOp"), span), CHIP_NO_ERROR);
    const char * expectedCustomLogFormat = "TimeTracker - End      | TestGroup:CustomOp               | Status: 0 | Start: "
                                           "00:00:00.200| End: 00:00:00.350| Duration: 00:00:00.150";
    EXPECT_STREQ(span.data(), expectedCustomLogFormat);

    // Test OutputAllMetrics including named traces
    EXPECT_EQ(SilabsTracer::Instance().OutputAllMetrics(), CHIP_NO_ERROR);
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
    char logBuffer[256];
    MutableCharSpan logSpan(logBuffer);
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kBufferFull), logSpan), CHIP_NO_ERROR);
    const char * expectedNumLogFormat =
        "TimeTracker - Instant  | BufferFull                       | Status: 19 | Time: 00:00:06.200";
    EXPECT_STREQ(logSpan.data(), expectedNumLogFormat);

    // Verify the kImageUpload operation was not added
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kImageUpload), logSpan),
              CHIP_ERROR_NOT_FOUND);

    // Flush kOTA operation
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushByOperation(to_underlying(TimeTraceOperation::kOTA)), CHIP_NO_ERROR);
    EXPECT_EQ(SilabsTracer::kMaxBufferedTraces - 1, SilabsTracer::Instance().GetTimeTracesCount());

    // Verify that adding a new operation still results in a buffer full operation since we are at size -1
    EXPECT_EQ(CHIP_ERROR_BUFFER_TOO_SMALL, SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kImageUpload));
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kImageUpload), logSpan),
              CHIP_ERROR_NOT_FOUND);

    // Flush the overflow operations
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushByOperation(to_underlying(TimeTraceOperation::kBufferFull)), CHIP_NO_ERROR);
    EXPECT_EQ(SilabsTracer::kMaxBufferedTraces - 2, SilabsTracer::Instance().GetTimeTracesCount());

    // Verify that adding a new operation now succeeds
    EXPECT_EQ(CHIP_NO_ERROR, SilabsTracer::Instance().TimeTraceBegin(TimeTraceOperation::kImageUpload));
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kImageUpload), logSpan),
              CHIP_NO_ERROR);

    // Verify that the buffer full operation is removed
    EXPECT_EQ(SilabsTracer::Instance().GetTraceByOperation(to_underlying(TimeTraceOperation::kBufferFull), logSpan),
              CHIP_ERROR_NOT_FOUND);

    // Flush all operations
    EXPECT_EQ(SilabsTracer::Instance().TraceBufferFlushAll(), CHIP_NO_ERROR);
    EXPECT_EQ(0u, SilabsTracer::Instance().GetTimeTracesCount());
}

TEST_F(TestSilabsTracing, TestNamedTraces)
{
    gMockClock.SetMonotonic(0_ms64);
    SilabsTracer::Instance().Init();
    size_t traceCount = 0;

    // Test creating named traces
    EXPECT_EQ(
        CHIP_NO_ERROR,
        SilabsTracer::Instance().NamedTraceBegin(CharSpan::fromCharString("MyOperation"), CharSpan::fromCharString("TestGroup")));
    gMockClock.AdvanceMonotonic(100_ms64);
    EXPECT_EQ(
        CHIP_NO_ERROR,
        SilabsTracer::Instance().NamedTraceEnd(CharSpan::fromCharString("MyOperation"), CharSpan::fromCharString("TestGroup")));

    // Test creating a second named trace
    EXPECT_EQ(
        CHIP_NO_ERROR,
        SilabsTracer::Instance().NamedTraceBegin(CharSpan::fromCharString("AnotherOp"), CharSpan::fromCharString("TestGroup")));
    gMockClock.AdvanceMonotonic(150_ms64);
    EXPECT_EQ(CHIP_NO_ERROR,
              SilabsTracer::Instance().NamedTraceEnd(CharSpan::fromCharString("AnotherOp"), CharSpan::fromCharString("TestGroup")));

    // Test instant trace for named operation
    EXPECT_EQ(
        CHIP_NO_ERROR,
        SilabsTracer::Instance().TimeTraceInstant(CharSpan::fromCharString("InstantOp"), CharSpan::fromCharString("TestGroup")));

    // Verify trace count
    traceCount = SilabsTracer::Instance().GetTimeTracesCount();
    EXPECT_EQ(traceCount, 5u); // 2 begin, 2 end, 1 instant

    // Test metrics for named traces
    char logBuffer[256];
    MutableCharSpan span(logBuffer);

    EXPECT_EQ(CHIP_NO_ERROR, SilabsTracer::Instance().GetTraceByOperation(CharSpan::fromCharString("TestGroup:MyOperation"), span));

    // Test that ending a non-existent trace returns an error
    EXPECT_EQ(
        CHIP_ERROR_NOT_FOUND,
        SilabsTracer::Instance().NamedTraceEnd(CharSpan::fromCharString("NonExistent"), CharSpan::fromCharString("TestGroup")));

    // Flush trace buffer before trying to fill named trace buffer
    SilabsTracer::Instance().TraceBufferFlushAll();

    // Re-initialize the tracer to clear named traces before buffer overflow test
    SilabsTracer::Instance().Init();

    // Test buffer overflow for named traces
    for (size_t i = 0; i < SilabsTracer::kMaxNamedTraces + 1; i++)
    {
        char label[16];
        snprintf(label, sizeof(label), "Op%04zu", i);
        auto result =
            SilabsTracer::Instance().TimeTraceInstant(CharSpan::fromCharString(label), CharSpan::fromCharString("OverflowTest"));
        SilabsTracer::Instance().TraceBufferFlushAll(); // empty trace buffer as we are testing the NamedTrace one
        if (i < SilabsTracer::kMaxNamedTraces)
        {
            EXPECT_EQ(CHIP_NO_ERROR, result);
        }
        else
        {
            EXPECT_EQ(CHIP_ERROR_BUFFER_TOO_SMALL, result);
        }
    }
}
