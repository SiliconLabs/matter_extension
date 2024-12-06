/***************************************************************************
 * @file SilabsTracing.cpp
 * @brief Instrumenting for matter operation tracing for the Silicon Labs platform.
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
#include "SilabsTracing.h"
#include <cstring>
#include <lib/support/CodeUtils.h>
#include <lib/support/PersistentData.h>

#if !CONFIG_BUILD_FOR_HOST_UNIT_TEST
#include <platform/silabs/Logging.h> // for isLogInitialized
#endif

// The following functions needs to be implemented by the application to allows logging or storing the traces /
// metrics. If the application does not implement them, the traces will simply be ignored.
bool __attribute__((weak)) isLogInitialized()
{
    return false;
}

namespace chip {
namespace Tracing {
namespace Silabs {

const char * TimeTraceOperationToString(TimeTraceOperation operation)
{
    switch (operation)
    {
    case TimeTraceOperation::kSpake2p:
        return "Spake2p";
    case TimeTraceOperation::kPake1:
        return "Pake1";
    case TimeTraceOperation::kPake2:
        return "Pake2";
    case TimeTraceOperation::kPake3:
        return "Pake3";
    case TimeTraceOperation::kOperationalCredentials:
        return "OperationalCredentials";
    case TimeTraceOperation::kAttestationVerification:
        return "AttestationVerification";
    case TimeTraceOperation::kCSR:
        return "CSR";
    case TimeTraceOperation::kNOC:
        return "NOC";
    case TimeTraceOperation::kTransportLayer:
        return "TransportLayer";
    case TimeTraceOperation::kTransportSetup:
        return "TransportSetup";
    case TimeTraceOperation::kFindOperational:
        return "FindOperational";
    case TimeTraceOperation::kCaseSession:
        return "CaseSession";
    case TimeTraceOperation::kSigma1:
        return "Sigma1";
    case TimeTraceOperation::kSigma2:
        return "Sigma2";
    case TimeTraceOperation::kSigma3:
        return "Sigma3";
    case TimeTraceOperation::kOTA:
        return "OTA";
    case TimeTraceOperation::kImageUpload:
        return "ImageUpload";
    case TimeTraceOperation::kImageVerification:
        return "ImageVerification";
    case TimeTraceOperation::kAppApplyTime:
        return "AppApplyTime";
    case TimeTraceOperation::kBootup:
        return "Bootup";
    case TimeTraceOperation::kSilabsInit:
        return "SilabsInit";
    case TimeTraceOperation::kMatterInit:
        return "MatterInit";
    case TimeTraceOperation::kAppInit:
        return "AppInit";
    case TimeTraceOperation::kNumTraces:
        return "NumTraces";
    case TimeTraceOperation::kBufferFull:
        return "BufferFull";
    default:
        return "Unknown";
    }
}

const char * OperationTypeToString(OperationType type)
{
    switch (type)
    {
    case OperationType::kBegin:
        return "Begin";
    case OperationType::kEnd:
        return "End";
    case OperationType::kInstant:
        return "Instant";
    default:
        return "Unknown";
    }
}

namespace {
constexpr size_t kPersistentTimeTrackerBufferMax = SERIALIZED_TIME_TRACKERS_SIZE_BYTES;
} // namespace
struct TimeTrackerStorage : public TimeTracker, PersistentData<kPersistentTimeTrackerBufferMax>
{
    // TODO implement the Persistent Array class and use it here for logging the watermark array
};

int TimeTracker::ToCharArray(MutableByteSpan & buffer) const
{
    switch (mType)
    {
    case OperationType::kBegin:
        return snprintf(reinterpret_cast<char *>(buffer.data()), buffer.size(),
                        "TimeTracker - Type: %s, Operation: %s, Status: 0x%" PRIx32 ",  StartTime: %" PRIu32 "",
                        OperationTypeToString(mType), TimeTraceOperationToString(mOperation), mError.AsInteger(),
                        mStartTime.count());
    case OperationType::kEnd:
        return snprintf(reinterpret_cast<char *>(buffer.data()), buffer.size(),
                        "TimeTracker - Type: %s, Operation: %s, Status: 0x%" PRIx32 ", StartTime: %" PRIu32 ", EndTime: %" PRIu32
                        ", Duration: %" PRIu32 " ms",
                        OperationTypeToString(mType), TimeTraceOperationToString(mOperation), mError.AsInteger(),
                        mStartTime.count(), mEndTime.count(), (mEndTime - mStartTime).count());
    case OperationType::kInstant:
        return snprintf(reinterpret_cast<char *>(buffer.data()), buffer.size(),
                        "TimeTracker - Type: %s, Operation: %s, Status: 0x%" PRIx32 ", EventTime: %" PRIu32 "",
                        OperationTypeToString(mType), TimeTraceOperationToString(mOperation), mError.AsInteger(),
                        mStartTime.count());
    default:
        return snprintf(reinterpret_cast<char *>(buffer.data()), buffer.size(), "TimeTracker - Unknown operation type");
    }
}

SilabsTracer SilabsTracer::sInstance;

SilabsTracer::SilabsTracer()
{
    VerifyOrDie(Init() == CHIP_NO_ERROR);
}

void SilabsTracer::TraceBufferClear()
{
    // Clear the time tracker list
    while (mTimeTrackerList.head != nullptr)
    {
        mTimeTrackerList.Remove(0);
    }
    mBufferedTrackerCount = 0;
}

CHIP_ERROR SilabsTracer::Init()
{
    TraceBufferClear();

    // Initialize the time trackers
    memset(mLatestTimeTrackers, 0, sizeof(mLatestTimeTrackers));
    memset(mWatermarks, 0, sizeof(mWatermarks));

    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::StartWatermarksStorage(PersistentStorageDelegate * storage)
{
    VerifyOrReturnError(nullptr != storage, CHIP_ERROR_INCORRECT_STATE);
    mStorage = storage;
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::TimeTraceBegin(TimeTraceOperation aOperation)
{
    // Log the start time of the operation
    auto & tracker     = mLatestTimeTrackers[to_underlying(aOperation)];
    tracker.mStartTime = System::SystemClock().GetMonotonicTimestamp();
    tracker.mOperation = aOperation;
    tracker.mType      = OperationType::kBegin;
    tracker.mError     = CHIP_NO_ERROR;

    auto & watermark = mWatermarks[to_underlying(aOperation)];
    watermark.mTotalCount++;

    return OutputTrace(tracker);
}

CHIP_ERROR SilabsTracer::TimeTraceEnd(TimeTraceOperation aOperation, CHIP_ERROR error)
{
    auto & tracker   = mLatestTimeTrackers[to_underlying(aOperation)];
    tracker.mEndTime = System::SystemClock().GetMonotonicTimestamp();
    tracker.mType    = OperationType::kEnd;
    tracker.mError   = error;

    if (error == CHIP_NO_ERROR)
    {
        // Calculate the duration and update the time tracker
        auto duration = tracker.mEndTime - tracker.mStartTime;

        auto & watermark = mWatermarks[to_underlying(aOperation)];
        watermark.mSuccessfullCount++;
        watermark.mMovingAverage = System::Clock::Milliseconds32(
            (watermark.mMovingAverage.count() * (watermark.mSuccessfullCount - 1) + duration.count()) /
            watermark.mSuccessfullCount);

        if (duration > watermark.mMaxTimeMs)
        {
            watermark.mMaxTimeMs = System::Clock::Milliseconds32(duration);
        }

        if (watermark.mMinTimeMs.count() == 0 || duration < watermark.mMinTimeMs)
        {
            watermark.mMinTimeMs = System::Clock::Milliseconds32(duration);
        }

        if (duration > watermark.mMovingAverage)
        {
            watermark.mCountAboveAvg++;
        }
    }

    return OutputTrace(tracker);
}

CHIP_ERROR SilabsTracer::TimeTraceInstant(TimeTraceOperation aOperation, CHIP_ERROR error)
{
    TimeTracker tracker;
    tracker.mStartTime = System::SystemClock().GetMonotonicTimestamp();
    tracker.mEndTime   = tracker.mStartTime;
    tracker.mOperation = aOperation;
    tracker.mType      = OperationType::kInstant;
    tracker.mError     = error;
    return OutputTrace(tracker);
}

CHIP_ERROR SilabsTracer::OutputTimeTracker(const TimeTracker & tracker)
{
    VerifyOrReturnError(to_underlying(tracker.mOperation) < kNumTraces, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(DeviceLayer, "Invalid tracker"));
    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);
    // Allocate a buffer to store the trace
    uint8_t buffer[kMaxTraceSize];
    MutableByteSpan span(buffer);
    tracker.ToCharArray(span);
    ChipLogProgress(DeviceLayer, "%s", buffer); // Use format string literal
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::OutputTrace(const TimeTracker & tracker)
{
    // We allow error here as we want to buffer even if the logs are currently uninitialized
    OutputTimeTracker(tracker);

    if (mBufferedTrackerCount < kMaxBufferedTraces - 1)
    {
        mTimeTrackerList.Insert(tracker);
        mBufferedTrackerCount++;
    }
    else if (mBufferedTrackerCount == kMaxBufferedTraces - 1)
    {
        // Save a tracker with TimeTraceOperation::kNumTraces and CHIP_ERROR_BUFFER_TOO_SMALL to indicate that the buffer is full
        TimeTracker resourceExhaustedTracker = tracker;
        resourceExhaustedTracker.mStartTime  = System::SystemClock().GetMonotonicTimestamp();
        resourceExhaustedTracker.mEndTime    = resourceExhaustedTracker.mStartTime;
        resourceExhaustedTracker.mOperation  = TimeTraceOperation::kBufferFull;
        resourceExhaustedTracker.mType       = OperationType::kInstant;
        resourceExhaustedTracker.mError      = CHIP_ERROR_BUFFER_TOO_SMALL;
        mTimeTrackerList.Insert(resourceExhaustedTracker);
        mBufferedTrackerCount++;
        return CHIP_ERROR_BUFFER_TOO_SMALL;
    }
    else
    {
        return CHIP_ERROR_BUFFER_TOO_SMALL;
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::OutputWaterMark(TimeTraceOperation aOperation)
{
    VerifyOrReturnError(to_underlying(aOperation) < kNumTraces, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(DeviceLayer, "Invalid TimeTraceOperation"));

    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);
    ChipLogProgress(DeviceLayer,
                    "| Operation: %-25s| MaxTime:%-5" PRIu32 "| MinTime:%-5" PRIu32 "| AvgTime:%-5" PRIu32 "| TotalCount:%-8" PRIu32
                    ", SuccessFullCount:%-8" PRIu32 "| CountAboveAvg:%-8" PRIu32 "|",
                    TimeTraceOperationToString(aOperation), mWatermarks[to_underlying(aOperation)].mMaxTimeMs.count(),
                    mWatermarks[to_underlying(aOperation)].mMinTimeMs.count(),
                    mWatermarks[to_underlying(aOperation)].mMovingAverage.count(),
                    mWatermarks[to_underlying(aOperation)].mTotalCount, mWatermarks[to_underlying(aOperation)].mSuccessfullCount,
                    mWatermarks[to_underlying(aOperation)].mCountAboveAvg);

    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::OutputAllWaterMarks()
{
    for (size_t i = 0; i < kNumTraces; ++i)
    {
        CHIP_ERROR err = OutputWaterMark(static_cast<TimeTraceOperation>(i));
        if (err != CHIP_NO_ERROR)
        {
            return err;
        }
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::TraceBufferFlushAll()
{
    auto * current = mTimeTrackerList.head;
    while (current != nullptr)
    {
        // We do not want to loose the traces if the logs are not initialized
        ReturnErrorOnFailure(OutputTimeTracker(current->mValue));
        current = current->mpNext;
    }

    TraceBufferClear();
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::TraceBufferFlushByOperation(TimeTraceOperation aOperation)
{
    VerifyOrReturnError(to_underlying(aOperation) < kNumTraces, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(DeviceLayer, "Invalid TimeTraceOperation"));
    auto * current = mTimeTrackerList.head;
    auto * prev    = static_cast<chip::SingleLinkedListNode<TimeTracker> *>(nullptr);
    while (current != nullptr)
    {
        if (current->mValue.mOperation == aOperation)
        {
            ReturnErrorOnFailure(OutputTimeTracker(current->mValue));
            if (prev == nullptr)
            {
                mTimeTrackerList.head = current->mpNext;
            }
            else
            {
                prev->mpNext = current->mpNext;
            }
            auto * temp = current;
            current     = current->mpNext;
            free(temp);
            mBufferedTrackerCount--;
        }
        else
        {
            prev    = current;
            current = current->mpNext;
        }
    }

    return CHIP_NO_ERROR;
}

// Save the traces in the NVM
CHIP_ERROR SilabsTracer::SaveWatermarks()
{
    VerifyOrReturnError(nullptr != mStorage, CHIP_ERROR_INCORRECT_STATE);
    // TODO implement the save of the watermarks in the NVM
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::LoadWatermarks()
{
    VerifyOrReturnError(nullptr != mStorage, CHIP_ERROR_INCORRECT_STATE);
    // TODO implement the load of the watermarks from the NVM
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::GetTraceByOperation(TimeTraceOperation aOperation, MutableByteSpan & buffer) const
{
    auto * current = mTimeTrackerList.head;
    while (current != nullptr)
    {
        if (current->mValue.mOperation == aOperation)
        {
            // Check if the buffer is large enough
            auto requiredSize = current->mValue.GetSize();

            if (requiredSize < 0)
            {
                return CHIP_ERROR_INTERNAL;
            }

            if (static_cast<size_t>(requiredSize) >= buffer.size())
            {
                return CHIP_ERROR_BUFFER_TOO_SMALL;
            }

            current->mValue.ToCharArray(buffer);
            return CHIP_NO_ERROR;
        }
        current = current->mpNext;
    }
    return CHIP_ERROR_NOT_FOUND;
}

} // namespace Silabs
} // namespace Tracing
} // namespace chip
