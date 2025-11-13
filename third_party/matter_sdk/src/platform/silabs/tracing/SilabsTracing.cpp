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
#include <cstdio> // for snprintf
#include <cstring>
#include <lib/support/CodeUtils.h>
#include <lib/support/PersistentData.h>
#include <string> // Include the necessary header for std::string

// Include FreeRTOS configuration first
#if defined(TRACING_RUNTIME_STATS) && TRACING_RUNTIME_STATS
extern "C" {
#include "FreeRTOSConfig.h"
}
#endif
// FreeRTOS includes for task statistics
#if defined(configGENERATE_RUN_TIME_STATS) && configGENERATE_RUN_TIME_STATS == 1
extern "C" {
#include "FreeRTOS.h"
#include "FreeRTOSRuntimeStats.h"
#include "task.h"
}
#endif

#if defined(SL_RAIL_LIB_MULTIPROTOCOL_SUPPORT) && SL_RAIL_LIB_MULTIPROTOCOL_SUPPORT
#include <rail.h>
// RAIL_GetTime() returns time in usec
#define SILABS_GET_TIME() System::Clock::Milliseconds32(RAIL_GetTime() / 1000)
#define SILABS_GET_DURATION(tracker)                                                                                               \
    (tracker.mEndTime < tracker.mStartTime)                                                                                        \
        ? (tracker.mEndTime + System::Clock::Milliseconds32((UINT32_MAX / 1000)) - tracker.mStartTime)                             \
        : tracker.mEndTime - tracker.mStartTime
#else
#define SILABS_GET_TIME() System::SystemClock().GetMonotonicTimestamp()
#define SILABS_GET_DURATION(tracker) tracker.mEndTime - tracker.mStartTime
#endif

#if defined(SILABS_LOG_OUT_UART) && SILABS_LOG_OUT_UART
#include "uart.h"
#endif

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

int FormatTimeStamp(std::chrono::milliseconds time, MutableCharSpan & buffer)
{
    using namespace std::chrono;
    auto h = duration_cast<hours>(time);
    time -= duration_cast<milliseconds>(h);
    auto m = duration_cast<minutes>(time);
    time -= duration_cast<milliseconds>(m);
    auto s = duration_cast<seconds>(time);
    time -= duration_cast<milliseconds>(s);

    return snprintf(buffer.data(), buffer.size(), "%02d:%02d:%02d.%03d", static_cast<int>(h.count()), static_cast<int>(m.count()),
                    static_cast<int>(s.count()), static_cast<int>(time.count()));
}

namespace {
// Size in bytes for serialized time tracker storage
// Metrics store 6 uint32_t, which is 24 bytes. We currently have 19 operations to track, so 19 * 24 = 456 bytes.
// 512 bytes should be enough including the serialization overhead
constexpr size_t kPersistentTimeTrackerBufferMax = SERIALIZED_TIME_TRACKERS_SIZE_BYTES;

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

} // namespace
struct TimeTrackerStorage : public TimeTracker, PersistentData<kPersistentTimeTrackerBufferMax>
{
    // TODO implement the Persistent Array class and use it here for logging the metric array
};

int TimeTracker::ToCharArray(MutableCharSpan & buffer) const
{
    // Note: We mimic the snprintf behavior where the output of the function is the number of characters that WOULD be
    // written to the buffer regardless of the success or failure of the operation. This is to allow the caller to know
    // the size of the buffer required to store the output by calling this function with a buffer of size 0.

    // Get the operation as a string
    char opStr[SilabsTracer::kMaxAppOperationKeyLength * 2] = { 0 }; // label + group
    chip::MutableCharSpan opSpan(opStr, sizeof(opStr));

    // Validate it is a known operation
    VerifyOrReturnValue(SilabsTracer::Instance().OperationIndexToString(mOperation, opSpan) == CHIP_NO_ERROR, 0xFFFF);

    switch (mType)
    {
    case OperationType::kBegin: {
        int offset = snprintf(buffer.data(), buffer.size(),
                              "TimeTracker - %-8s | %-32s | Status: %" PRIx32 " | Start: ", OperationTypeToString(mType),
                              opSpan.data(), mError.AsInteger());

        MutableCharSpan subSpan;
        if (offset < static_cast<int>(buffer.size()))
            subSpan = buffer.SubSpan(static_cast<size_t>(offset));
        offset += FormatTimeStamp(mStartTime, subSpan);

        return offset;
    }
    case OperationType::kEnd: {
        int offset = snprintf(buffer.data(), buffer.size(),
                              "TimeTracker - %-8s | %-32s | Status: %" PRIx32 " | Start: ", OperationTypeToString(mType),
                              opSpan.data(), mError.AsInteger());

        MutableCharSpan subSpan;

        // Print Start time
        if (offset < static_cast<int>(buffer.size()))
            subSpan = buffer.SubSpan(static_cast<size_t>(offset));
        offset += FormatTimeStamp(mStartTime, subSpan);

        // Print End label
        if (offset < static_cast<int>(buffer.size()))
            subSpan = buffer.SubSpan(static_cast<size_t>(offset));
        offset += snprintf(subSpan.data(), subSpan.size(), "| End: ");

        // Print End time
        if (offset < static_cast<int>(buffer.size()))
            subSpan = buffer.SubSpan(static_cast<size_t>(offset));
        offset += FormatTimeStamp(mEndTime, subSpan);

        // Print Duration label
        if (offset < static_cast<int>(buffer.size()))
            subSpan = buffer.SubSpan(static_cast<size_t>(offset));
        offset += snprintf(subSpan.data(), subSpan.size(), "| Duration: ");

        // Print Duration time
        if (offset < static_cast<int>(buffer.size()))
            subSpan = buffer.SubSpan(static_cast<size_t>(offset));
        offset += FormatTimeStamp(mEndTime - mStartTime, subSpan);

        return offset;
    }
    case OperationType::kInstant: {
        int offset = snprintf(buffer.data(), buffer.size(),
                              "TimeTracker - %-8s | %-32s | Status: %" PRIx32 " | Time: ", OperationTypeToString(mType),
                              opSpan.data(), mError.AsInteger());

        MutableCharSpan subSpan;
        if (offset < static_cast<int>(buffer.size()))
            subSpan = buffer.SubSpan(static_cast<size_t>(offset));
        offset += FormatTimeStamp(mStartTime, subSpan);

        return offset;
    }
    default:
        return snprintf(buffer.data(), buffer.size(), "TimeTracker - Unknown operation type");
    }
}

TimeTraceOperation SilabsTracer::StringToTimeTraceOperation(CharSpan aOperation) const
{
    for (size_t i = 0; i < kNumTraces; i++)
    {
        TimeTraceOperation op = static_cast<TimeTraceOperation>(i);
        CharSpan needle       = CharSpan::fromCharString(TimeTraceOperationToString(op));
        VerifyOrReturnValue(!aOperation.data_equal(needle), op);
    }
    // Unable to match, return value for unknown
    return TimeTraceOperation::kNumTraces;
}

CHIP_ERROR SilabsTracer::OperationIndexToString(size_t aOperationIdx, MutableCharSpan buffer)
{
    if (aOperationIdx < kNumTraces) // If value is in operation enum, return it.
    {
        snprintf(buffer.data(), buffer.size(), "%s", TimeTraceOperationToString(static_cast<TimeTraceOperation>(aOperationIdx)));
    }
    else
    {
        size_t namedTraceIdx = aOperationIdx - kNumTraces;
        VerifyOrReturnError(namedTraceIdx < kMaxNamedTraces, CHIP_ERROR_INVALID_ARGUMENT);

        const auto & trace = mNamedTraces[namedTraceIdx];
        snprintf(buffer.data(), buffer.size(), "%s:%s", trace.group, trace.label);
    }

    return CHIP_NO_ERROR;
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
    memset(mMetrics, 0, sizeof(mMetrics));
    for (size_t i = 0; i < kMaxNamedTraces; ++i)
    {
        mNamedTraces[i] = NamedTrace{};
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::StartMetricsStorage(PersistentStorageDelegate * storage)
{
    VerifyOrReturnError(nullptr != storage, CHIP_ERROR_INCORRECT_STATE);
    mStorage = storage;
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::TimeTraceBegin(TimeTraceOperation aOperation)
{
    // Log the start time of the operation
    auto & tracker = mLatestTimeTrackers[to_underlying(aOperation)];

    // Corner case since no hardware clock is available at this point
    if (aOperation == TimeTraceOperation::kBootup || aOperation == TimeTraceOperation::kSilabsInit)
    {
        tracker.mStartTime = System::Clock::Milliseconds32(0);
    }
    else
    {
        tracker.mStartTime = SILABS_GET_TIME();
    }

    tracker.mOperation = to_underlying(aOperation);
    tracker.mType      = OperationType::kBegin;
    tracker.mError     = CHIP_NO_ERROR;

    auto & metric = mMetrics[to_underlying(aOperation)];
    metric.mTotalCount++;

    return OutputTrace(tracker);
}

CHIP_ERROR SilabsTracer::TimeTraceEnd(TimeTraceOperation aOperation, CHIP_ERROR error)
{
    auto & tracker   = mLatestTimeTrackers[to_underlying(aOperation)];
    tracker.mEndTime = SILABS_GET_TIME();
    tracker.mType    = OperationType::kEnd;
    tracker.mError   = error;

    if (error == CHIP_NO_ERROR)
    {
        // Calculate the duration and update the time tracker
        auto duration = SILABS_GET_DURATION(tracker);

        auto & metric = mMetrics[to_underlying(aOperation)];

        FinishMetric(metric, duration);
    }
    return OutputTrace(tracker);
}

CHIP_ERROR SilabsTracer::TimeTraceInstant(TimeTraceOperation aOperation, CHIP_ERROR error)
{
    TimeTracker tracker;

    tracker.mStartTime = SILABS_GET_TIME();
    tracker.mEndTime   = tracker.mStartTime;
    tracker.mOperation = to_underlying(aOperation);
    tracker.mType      = OperationType::kInstant;
    tracker.mError     = error;

    return OutputTrace(tracker);
}

CHIP_ERROR SilabsTracer::TimeTraceInstant(const CharSpan label, const CharSpan group, CHIP_ERROR error)
{
    size_t index = 0;
    ReturnErrorOnFailure(FindOrCreateTrace(label, group, index));

    auto & trace = mNamedTraces[index];

    trace.tracker.mStartTime = SILABS_GET_TIME();
    trace.metric.mTotalCount++;
    trace.tracker.mOperation = kNumTraces + index;
    trace.tracker.mEndTime   = trace.tracker.mStartTime;
    trace.tracker.mType      = OperationType::kInstant;
    trace.tracker.mError     = error;

    return OutputTrace(trace.tracker);
}

CHIP_ERROR SilabsTracer::NamedTraceBegin(const CharSpan label, const CharSpan group)
{
    VerifyOrReturnError(label.size() != 0 && group.size() != 0, CHIP_ERROR_INVALID_ARGUMENT);

    size_t index = 0;
    ReturnErrorOnFailure(FindOrCreateTrace(label, group, index));

    auto & trace = mNamedTraces[index];

    trace.tracker.mStartTime = SILABS_GET_TIME();
    trace.metric.mTotalCount++;
    trace.tracker.mOperation = kNumTraces + index;
    trace.tracker.mType      = OperationType::kBegin;
    trace.tracker.mError     = CHIP_NO_ERROR;

    return OutputTrace(trace.tracker);
}

CHIP_ERROR SilabsTracer::NamedTraceEnd(const CharSpan label, const CharSpan group)
{
    size_t mIndex = 0;
    ReturnErrorOnFailure(FindExistingTrace(label, group, mIndex));

    auto & trace = mNamedTraces[mIndex];

    VerifyOrReturnError(trace.tracker.mType == OperationType::kBegin, CHIP_ERROR_INCORRECT_STATE);

    trace.tracker.mEndTime = SILABS_GET_TIME();
    trace.tracker.mType    = OperationType::kEnd;

    auto duration = SILABS_GET_DURATION(trace.tracker);

    ReturnErrorOnFailure(FinishMetric(trace.metric, duration));

    return OutputTrace(trace.tracker);
}

CHIP_ERROR SilabsTracer::FinishMetric(Metric & metric, System::Clock::Milliseconds32 duration)
{
    metric.mSuccessfullCount++;
    metric.mMovingAverage = System::Clock::Milliseconds32(
        (static_cast<uint64_t>(metric.mMovingAverage.count()) * (metric.mSuccessfullCount - 1) + duration.count()) /
        metric.mSuccessfullCount);

    if (duration > metric.mMaxTimeMs)
    {
        metric.mMaxTimeMs = System::Clock::Milliseconds32(duration);
    }

    if (metric.mSuccessfullCount <= 1 || duration < metric.mMinTimeMs)
    {
        metric.mMinTimeMs = System::Clock::Milliseconds32(duration);
    }

    if (duration > metric.mMovingAverage)
    {
        metric.mCountAboveAvg++;
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::OutputTimeTracker(const TimeTracker & tracker)
{
    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);

    char buffer[kMaxTraceSize];
    MutableCharSpan span(buffer);
    tracker.ToCharArray(span);
    ChipLogProgress(DeviceLayer, "%s", buffer);

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
        // Save a tracker with TimeTraceOperation::kNumTraces and CHIP_ERROR_BUFFER_TOO_SMALL to indicate that the
        // buffer is full
        TimeTracker resourceExhaustedTracker = tracker;
        resourceExhaustedTracker.mStartTime  = SILABS_GET_TIME();
        resourceExhaustedTracker.mEndTime    = resourceExhaustedTracker.mStartTime;
        resourceExhaustedTracker.mOperation  = to_underlying(TimeTraceOperation::kBufferFull);
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
CHIP_ERROR SilabsTracer::OutputMetric(size_t aOperationIdx)
{
    VerifyOrReturnError(aOperationIdx < kNumTraces + kMaxNamedTraces - 1, CHIP_ERROR_INVALID_ARGUMENT);
    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);
    if (aOperationIdx < kNumTraces)
    {
        ChipLogProgress(DeviceLayer,
                        "| Operation: %-25s| MaxTime:%-5" PRIu32 "| MinTime:%-5" PRIu32 "| AvgTime:%-5" PRIu32
                        "| TotalCount:%-8" PRIu32 ", SuccessFullCount:%-8" PRIu32 "| CountAboveAvg:%-8" PRIu32 "|",
                        TimeTraceOperationToString(static_cast<TimeTraceOperation>(aOperationIdx)),
                        mMetrics[aOperationIdx].mMaxTimeMs.count(), mMetrics[aOperationIdx].mMinTimeMs.count(),
                        mMetrics[aOperationIdx].mMovingAverage.count(), mMetrics[aOperationIdx].mTotalCount,
                        mMetrics[aOperationIdx].mSuccessfullCount, mMetrics[aOperationIdx].mCountAboveAvg);
    }
    else
    {

        const auto & trace = mNamedTraces[aOperationIdx - kNumTraces];
        ChipLogProgress(DeviceLayer,
                        "| Op: %-15s:%-16s| MaxTime:%-5" PRIu32 "| MinTime:%-5" PRIu32 "| AvgTime:%-5" PRIu32
                        "| TotalCount:%-8" PRIu32 ", SuccessFullCount:%-8" PRIu32 "| CountAboveAvg:%-8" PRIu32 "|",
                        trace.group, trace.label, trace.metric.mMaxTimeMs.count(), trace.metric.mMinTimeMs.count(),
                        trace.metric.mMovingAverage.count(), trace.metric.mTotalCount, trace.metric.mSuccessfullCount,
                        trace.metric.mCountAboveAvg);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::OutputMetric(CharSpan aOperation)
{
    TimeTraceOperation operationKey = StringToTimeTraceOperation(aOperation);
    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);

    // Check if operation is part of the operations enum =
    VerifyOrReturnValue(operationKey == TimeTraceOperation::kNumTraces, OutputMetric(to_underlying(operationKey)));

    // Otherwise, check if it is a named trace
    CharSpan groupSpan;
    CharSpan labelSpan;
    ReturnErrorOnFailure(SplitNamedTraceString(aOperation, groupSpan, labelSpan));

    size_t idx = 0;
    ReturnErrorOnFailure(FindExistingTrace(labelSpan, groupSpan, idx));
    return OutputMetric(idx + kNumTraces);
}

CHIP_ERROR SilabsTracer::OutputAllMetrics()
{
    for (size_t i = 0; i < kNumTraces; ++i)
    {
        ReturnErrorOnFailure(OutputMetric(i));
    }
    for (size_t i = 0; i < kMaxNamedTraces; i++)
    {
        if (mNamedTraces[i].labelLen == 0 && mNamedTraces[i].groupLen == 0)
            break; // Beginning of empty items, can stop printing.

        ReturnErrorOnFailure(OutputMetric(i + kNumTraces));
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::OutputAllCurrentOperations()
{
    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);

    // Print defined operations
    for (size_t i = 0; i < kNumTraces; i++)
    {
        ChipLogProgress(DeviceLayer, "Operation: %-25s", TimeTraceOperationToString(static_cast<TimeTraceOperation>(i)));
    }

    // Print named operations
    for (size_t i = 0; i < SilabsTracer::kMaxNamedTraces; i++)
    {
        const auto & trace = mNamedTraces[i];

        if (trace.labelLen == 0 && trace.groupLen == 0)
            break; // No more named traces, rest of the array is empty

        ChipLogProgress(DeviceLayer, "Operation: %-15s:%-16s", trace.group, trace.label);
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

CHIP_ERROR SilabsTracer::TraceBufferFlushByOperation(size_t aOperationIdx)
{
    auto * current = mTimeTrackerList.head;
    auto * prev    = static_cast<chip::SingleLinkedListNode<TimeTracker> *>(nullptr);
    while (current != nullptr)
    {
        if (current->mValue.mOperation == aOperationIdx)
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

CHIP_ERROR SilabsTracer::TraceBufferFlushByOperation(CharSpan appOperationKey)
{
    size_t index = 0;

    TimeTraceOperation operationKey = StringToTimeTraceOperation(appOperationKey);
    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);
    if (operationKey != TimeTraceOperation::kNumTraces)
    {
        index = to_underlying(operationKey);
    }
    else
    {
        // Check if it is a named trace
        // Otherwise, check if it is a named trace
        CharSpan groupSpan;
        CharSpan labelSpan;
        ReturnErrorOnFailure(SplitNamedTraceString(appOperationKey, groupSpan, labelSpan));

        ReturnErrorOnFailure(FindExistingTrace(labelSpan, groupSpan, index));
        index = (index + kNumTraces);
    }
    return SilabsTracer::Instance().TraceBufferFlushByOperation(index);
}

// Save the traces in the NVM
CHIP_ERROR SilabsTracer::SaveMetrics()
{
    VerifyOrReturnError(nullptr != mStorage, CHIP_ERROR_INCORRECT_STATE);
    // TODO implement the save of the metrics in the NVM
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::LoadMetrics()
{
    VerifyOrReturnError(nullptr != mStorage, CHIP_ERROR_INCORRECT_STATE);
    // TODO implement the load of the metrics from the NVM
    return CHIP_NO_ERROR;
}

CHIP_ERROR SilabsTracer::GetTraceByOperation(size_t aOperationIdx, MutableCharSpan & buffer) const
{
    auto * current = mTimeTrackerList.head;
    while (current != nullptr)
    {
        if (current->mValue.mOperation == aOperationIdx)
        {
            // Found matching trace, format it
            auto required = current->mValue.ToCharArray(buffer);
            if (required > static_cast<int>(buffer.size()))
                return CHIP_ERROR_BUFFER_TOO_SMALL;

            return CHIP_NO_ERROR;
        }

        current = current->mpNext;
    }

    return CHIP_ERROR_NOT_FOUND;
}

// Overload for string-based operation lookup
CHIP_ERROR SilabsTracer::GetTraceByOperation(CharSpan aOperation, MutableCharSpan & buffer) const
{
    TimeTraceOperation operationKey = StringToTimeTraceOperation(aOperation);
    if (operationKey != TimeTraceOperation::kNumTraces)
    {
        return GetTraceByOperation(to_underlying(operationKey), buffer);
    }

    // Otherwise, check if it is a named trace
    CharSpan groupSpan;
    CharSpan labelSpan;
    ReturnErrorOnFailure(SplitNamedTraceString(aOperation, groupSpan, labelSpan));

    size_t mIndex = 0;
    ReturnErrorOnFailure(FindExistingTrace(labelSpan, groupSpan, mIndex));

    return GetTraceByOperation(mIndex + kNumTraces, buffer);
}

CHIP_ERROR SilabsTracer::FindOrCreateTrace(const CharSpan label, const CharSpan group, size_t & outIdx)
{
    VerifyOrReturnError(FindExistingTrace(label, group, outIdx) != CHIP_NO_ERROR, CHIP_NO_ERROR);

    // Find first empty slot
    for (size_t i = 0; i < kMaxNamedTraces; i++)
    {
        if (mNamedTraces[i].labelLen == 0)
        {
            auto & trace    = mNamedTraces[i];
            size_t labelLen = label.size();
            size_t groupLen = group.size();

            // Truncate label and group if too long
            if (labelLen >= NamedTrace::kMaxLabelLength)
                labelLen = NamedTrace::kMaxLabelLength - 1;

            if (groupLen >= NamedTrace::kMaxGroupLength)
                groupLen = NamedTrace::kMaxGroupLength - 1;

            memcpy(trace.label, label.data(), labelLen);
            trace.labelLen = labelLen;

            memcpy(trace.group, group.data(), groupLen);
            trace.groupLen = groupLen;

            outIdx = i;
            return CHIP_NO_ERROR;
        }
    }
    return CHIP_ERROR_BUFFER_TOO_SMALL;
}

CHIP_ERROR SilabsTracer::FindExistingTrace(const CharSpan label, const CharSpan group, size_t & outIdx) const
{
    for (size_t i = 0; i < kMaxNamedTraces; ++i)
    {
        const auto & t = mNamedTraces[i];
        if (t.labelLen == 0)
            return CHIP_ERROR_NOT_FOUND; // empty slot

        // prefix semantics: stored must fit within incoming, then bytes must match
        if (std::memcmp(t.group, group.data(), t.groupLen) == 0 && std::memcmp(t.label, label.data(), t.labelLen) == 0)
        {
            outIdx = i;
            return CHIP_NO_ERROR;
        }
    }
    return CHIP_ERROR_NOT_FOUND;
}

CHIP_ERROR SilabsTracer::SplitNamedTraceString(CharSpan appOperationKey, CharSpan & groupSpan, CharSpan & labelSpan) const
{
    // Parse appOperationKey as "group:label"
    const void * pos = memchr(appOperationKey.data(), ':', appOperationKey.size());
    VerifyOrReturnError(pos != nullptr, CHIP_ERROR_INVALID_ARGUMENT, ChipLogError(DeviceLayer, "Invalid Trace Operation format"));

    const char * colon = static_cast<const char *>(pos);

    size_t groupLen   = static_cast<size_t>(colon - appOperationKey.data());
    size_t labelStart = groupLen + 1;
    VerifyOrReturnError(labelStart <= appOperationKey.size(), CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(DeviceLayer, "Invalid Trace Operation format"));
    size_t labelLen = appOperationKey.size() - labelStart;

    groupLen = std::min(groupLen, static_cast<size_t>(NamedTrace::kMaxGroupLength > 0 ? NamedTrace::kMaxGroupLength - 1 : 0));
    labelLen = std::min(labelLen, static_cast<size_t>(NamedTrace::kMaxLabelLength > 0 ? NamedTrace::kMaxLabelLength - 1 : 0));

    groupSpan = CharSpan(appOperationKey.SubSpan(0, groupLen));
    labelSpan = CharSpan(appOperationKey.SubSpan(labelStart, labelLen));

    return CHIP_NO_ERROR;
}

#if defined(configGENERATE_RUN_TIME_STATS) && configGENERATE_RUN_TIME_STATS == 1

namespace {
const char * FreeRTOSTaskStateToString(eTaskState state)
{
    switch (state)
    {
    case eRunning:
        return "Running";
    case eReady:
        return "Ready";
    case eBlocked:
        return "Blocked";
    case eSuspended:
        return "Suspend";
    case eDeleted:
        return "Deleted";
    default:
        return "Unknown";
    }
}
} // namespace

CHIP_ERROR SilabsTracer::OutputTaskStatistics()
{
    VerifyOrReturnError(isLogInitialized(), CHIP_ERROR_UNINITIALIZED);

    TaskInfo taskInfoArray[TRACING_RUNTIME_STATS_MAX_TASKS];
    SystemTaskStats systemStats;

    uint32_t taskCount = ulGetAllTaskInfo(taskInfoArray, TRACING_RUNTIME_STATS_MAX_TASKS, &systemStats);

    VerifyOrReturnError(taskCount > 0, CHIP_ERROR_INTERNAL, ChipLogError(DeviceLayer, "Failed to get task information"));

    ChipLogProgress(DeviceLayer, "=== Task Statistics ===");
    ChipLogProgress(DeviceLayer, "Active tasks: %lu | Terminated tasks: %lu | Total tasks: %lu", systemStats.activeTaskCount,
                    systemStats.terminatedTaskCount, systemStats.totalTaskCount);
    ChipLogProgress(DeviceLayer, "Total Runtime: %lu ms", systemStats.totalRunTime);
    ChipLogProgress(DeviceLayer, "System Preemption Ratio: %lu.%02lu%% (%lu/%lu switches)",
                    (systemStats.systemPreemptionRatio / 100), (systemStats.systemPreemptionRatio % 100),
                    systemStats.totalPreemptionCount, systemStats.totalSwitchOutCount);

    ChipLogProgress(DeviceLayer, "| %-23s| %-7s | %-4s | %-9s | %-9s | %-6s | %-12s | %-6s | %-10s | %-7s | %-7s | %-7s |",
                    "Task Name", "State", "Prio", "Stack HWM", "Stack Max", "CPU %", "Preempted", "Pre. %", "Last Time", "Rdy HWM",
                    "Run Tot", "Rdy Tot");
    ChipLogProgress(DeviceLayer, "|%-24s|%-9s|%-6s|%-11s|%-11s|%-8s|%-14s|%-8s|%-12s|%-9s|%-9s|%-9s|", "------------------------",
                    "---------", "------", "-----------", "-----------", "--------", "--------------", "--------", "------------",
                    "---------", "---------", "---------");

    // Print each task's information as a row in the table
    for (uint32_t i = 0; i < taskCount; i++)
    {
        const TaskInfo * task = &taskInfoArray[i];

        // Allow time for the UART buffer to empty itself. Without this, some lines may be skipped and a "Missed Logs: X" will
        // appear in the output A delay of 1 tick was not sufficient, so we use 10.
        vTaskDelay(10);

        // This dual check ensures that we do not misclassify tasks that may have a lingering handle after deletion.
        if (task->state == eDeleted && task->stats.handle == NULL)
        {
            // This is deleted task
            ChipLogProgress(DeviceLayer,
                            "| %-23s| %-7s | %-4s | %-9s | %-9s | %-6s | %4lu/%-7lu |%3lu.%02lu%% | %-10lu | %-8lu|"
                            " %-8lu| %-8lu|",
                            task->stats.name, FreeRTOSTaskStateToString(task->state), "N/A", "N/A", "N/A", "N/A",
                            task->stats.preemptionCount, task->stats.switchOutCount, (task->preemptionPercentage / 100),
                            (task->preemptionPercentage % 100), task->stats.lastSwitchOutTime, task->stats.readyTimeHighWaterMark,
                            task->stats.totalRunningTime, task->stats.totalReadyTime);
        }
        else
        {
            // Active task
            ChipLogProgress(DeviceLayer,
                            "| %-23s| %-7s | %-4lu | %-9lu | %-9lu | %2lu.%02lu%% | %4lu/%-7lu |%3lu.%02lu%% | %-10lu | %-8lu|"
                            " %-8lu| %-8lu|",
                            task->stats.name, FreeRTOSTaskStateToString(task->state), task->priority, task->stackHighWaterMark,
                            task->stackMaxSize, (task->cpuPercentage / 100), (task->cpuPercentage % 100),
                            task->stats.preemptionCount, task->stats.switchOutCount, (task->preemptionPercentage / 100),
                            (task->preemptionPercentage % 100), task->stats.lastSwitchOutTime, task->stats.readyTimeHighWaterMark,
                            task->stats.totalRunningTime, task->stats.totalReadyTime);
        }
    }

    return CHIP_NO_ERROR;
}

#else // configGENERATE_RUN_TIME_STATS == 1

CHIP_ERROR SilabsTracer::OutputTaskStatistics()
{
    ChipLogError(DeviceLayer, "Task statistics not available - configGENERATE_RUN_TIME_STATS not enabled");
    return CHIP_ERROR_UNINITIALIZED;
}

#endif // configGENERATE_RUN_TIME_STATS == 1

} // namespace Silabs
} // namespace Tracing
} // namespace chip
