/***************************************************************************
 * @file SilabsTracing.h
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
#pragma once

#include "SilabsTracingTypes.h"
#include <cstddef>
#include <cstdlib>
#include <lib/core/CHIPError.h>
#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/support/LinkedList.h>
#include <lib/support/Span.h>
#include <stdint.h>
#include <system/SystemClock.h>

#ifndef SERIALIZED_TIME_TRACKERS_SIZE_BYTES
// Default size, watermarks store 6 uint32_t, which is 24 bytes
// We currently have 19 operations to track, so 19 * 24 = 456 bytes
// 512 bytes should be enough including the serialization overhead
#define SERIALIZED_TIME_TRACKERS_SIZE_BYTES 512
#endif

namespace chip {
namespace Tracing {
namespace Silabs {

struct TimeTracker
{
    // Temporary values
    System::Clock::Milliseconds32 mStartTime;
    System::Clock::Milliseconds32 mEndTime;
    size_t mOperation;
    OperationType mType;
    CHIP_ERROR mError;

    /** @brief Convert the TimeTracker to a string for logs
     * Behaves like snprintf, but formats the output differently based on the OperationType
     * May be used with a buffer of size == 0 to get the required buffer size
     * @param buffer The buffer to write the string to
     * @return The number of characters written to the buffer, or the size of the buffer required if the buffer is too small
     */
    int ToCharArray(MutableCharSpan & buffer) const;

    /** @brief Get the size of the string representation of the TimeTracker
     * @return The size of the string representation of the TimeTracker
     */
    int GetSize() const
    {
        MutableCharSpan temp;
        return ToCharArray(temp);
    }
};

struct Watermark
{
    // Values that will be stored in the NVM
    System::Clock::Milliseconds32 mMovingAverage; // Successful operation average time
    System::Clock::Milliseconds32 mMaxTimeMs;     // Successful operation max time
    System::Clock::Milliseconds32 mMinTimeMs;     // Successful operation min time
    uint32_t mTotalCount;                         // Total number of times the operation was initiated
    uint32_t mSuccessfullCount;                   // Number of times the operation was completed without error
    uint32_t mCountAboveAvg;                      // Number of times the operation was above the average time
};

// This class instantiates a buffer to store the traces before logs are enabled.
//
class SilabsTracer
{
public:
    static constexpr size_t kNumTraces                = to_underlying(TimeTraceOperation::kNumTraces);
    static constexpr size_t kMaxAppOperationKeys      = 5;
    static constexpr size_t kMaxAppOperationKeyLength = 16;
    static constexpr size_t kMaxBufferedTraces        = 64;
    static constexpr size_t kMaxTraceSize             = 128;

    /** @brief Get the singleton instance of SilabsTracer */
    static SilabsTracer & Instance() { return sInstance; }

    /** @brief Initialize the SilabsTracer
     *  This method initializes sets the watermarks and time trackers to 0 and clears the traces buffer.
     *  @return CHIP_ERROR, currently no failure is implemented but when the NVM is added this will return an error if the NVM
     * initialization fails.
     */
    CHIP_ERROR Init();

    /** @brief Start storing watermarks in persistent storage
     *  @param storage Pointer to the persistent storage delegate
     *  @return CHIP_ERROR, returns an error if the storage is null
     */
    CHIP_ERROR StartWatermarksStorage(PersistentStorageDelegate * storage);

    /** @brief Begin tracing a time operation
     * This calls the OutputTrace method to log the trace if logs are enabled, and stores the time tracker in the buffer if the
     * buffer is not full.
     *  @param aOperation
     * @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is full
     */
    CHIP_ERROR TimeTraceBegin(TimeTraceOperation aOperation);

    /** @brief End tracing a time operation
     * This calls the OutputTrace method to log the trace if logs are enabled, and stores the time tracker in the buffer if the
     * buffer is not full.
     *  @param aOperation
     *  @param error
     * @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is full
     */
    CHIP_ERROR TimeTraceEnd(TimeTraceOperation aOperation, CHIP_ERROR error = CHIP_NO_ERROR);
    CHIP_ERROR TimeTraceEnd(TimeTraceOperation aOperation, uint32_t error) { return TimeTraceEnd(aOperation, ChipError((error))); }

    /** @brief Trace an instant time operation
     * This calls the OutputTrace method to log the trace if logs are enabled, and stores the time tracker in the buffer if the
     * buffer is not full.
     *  @param aOperation
     *  @param error
     * @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is full
     */
    CHIP_ERROR TimeTraceInstant(TimeTraceOperation aOperation, CHIP_ERROR error = CHIP_NO_ERROR);
    CHIP_ERROR TimeTraceInstant(TimeTraceOperation aOperation, uint32_t error)
    {
        return TimeTraceInstant(aOperation, ChipError((error)));
    }
    /** @brief TimeTraceInstant
     *  We currently allow to register App specific operations to be tracked by the time tracer, but only for instant traces, and
     * not for watermarks.
     * @param appOperation The name of the app operation key to generate a trace for
     */
    CHIP_ERROR TimeTraceInstant(CharSpan & appOperationKey, CHIP_ERROR error = CHIP_NO_ERROR);

    /** @brief Output a time tracker
     * This will output the latest time tracker for a specific operation, without affecting the buffer.
     *  @param tracker The time tracker to output
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the log is not initialized
     */
    CHIP_ERROR OutputTimeTracker(const TimeTracker & tracker);

    /** @brief Output a watermark for a specific operation
     *  @param aOperation The operation to output the watermark for
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the log is not initialized
     */
    CHIP_ERROR OutputWaterMark(TimeTraceOperation aOperation);

    /** @brief Output all watermarks
     *  @return CHIP_ERROR, CHIP_ERROR_UNINITIALIZED error if any watermark output fails
     */
    CHIP_ERROR OutputAllWaterMarks();

    /** @brief Flush all traces from the buffer in the order they were added
     * If logs are enabled, this will output all the traces in the buffer and clear the buffer.
     * If logs are not enabled, this will throw an error and preserve the traces in the buffer.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the logs are not initialized
     */
    CHIP_ERROR TraceBufferFlushAll();

    /** @brief Flush traces for a specific operation from the buffer
     * If logs are enabled, this will output all the traces for the operation in the buffer and clear the buffer.
     * If logs are not enabled, this will throw an error and preserve the traces in the buffer.
     *  @param aOperation The operation to flush traces for
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the logs are not initialized
     */
    CHIP_ERROR TraceBufferFlushByOperation(size_t aOperation);
    CHIP_ERROR TraceBufferFlushByOperation(CharSpan & appOperationKey);

    // prevent copy constructor and assignment operator
    SilabsTracer(SilabsTracer const &)             = delete;
    SilabsTracer & operator=(SilabsTracer const &) = delete;

    /** @brief Save the watermarks to persistent storage
     *  @return CHIP_ERROR, returns an error if the storage is not initialized
     */
    CHIP_ERROR SaveWatermarks();

    /** @brief Load the watermarks from persistent storage
     *  @return CHIP_ERROR, returns an error if the storage is not initialized
     */
    CHIP_ERROR LoadWatermarks();

    // Methods to get the time trackers metrics values

    /** @brief Get the latest time tracker for a specific operation
     *  @param aOperation The operation to get the time tracker for
     *  @return TimeTracker, the latest time tracker for the operation
     */
    TimeTracker GetTimeTracker(TimeTraceOperation aOperation) { return mLatestTimeTrackers[to_underlying(aOperation)]; }

    /** @brief Get the watermark for a specific operation
     *  @param aOperation The operation to get the watermark for
     *  @return Watermark, the watermark for the operation
     */
    Watermark GetWatermark(TimeTraceOperation aOperation) { return mWatermarks[to_underlying(aOperation)]; }
    size_t GetTimeTracesCount() { return mBufferedTrackerCount; }

    CHIP_ERROR GetTraceByOperation(size_t aOperation, MutableCharSpan & buffer) const;
    CHIP_ERROR GetTraceByOperation(CharSpan & appOperationKey, MutableCharSpan & buffer) const;

    /** @brief Register an App specific time trace operation
     * This will register an App specific operation to be tracked by the time tracer. The string will be mapped to a
     * TimeTraceOperation higher than the kNumTraces value.
     *  @param appOperationKey The key of the custom operation, can only be in the array once
     * @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the key is too long, CHIP_ERROR_NO_MEMORY if the buffer is full,
     * and CHIP_ERROR_INVALID_ARGUMENT if the key is null or already in the array.
     */
    CHIP_ERROR RegisterAppTimeTraceOperation(CharSpan & appOperationKey);

    /** @brief Find the index of a custom operation
     * @param appOperation The key of the custom operation to find
     *  @param index The index of the custom operation
     *  @return CHIP_ERROR, returns CHIP_ERROR_NOT_FOUND if the buffer is full, the index will be set to the maximum number of
     * custom operations if the operationis not found
     */
    CHIP_ERROR FindAppOperationIndex(CharSpan & appOperationKey, size_t & index) const;

    inline size_t GetRegisteredAppOperationsCount() { return mAppOperationKeyCount; }
    inline char * GetAppOperationKey(size_t index) { return mAppOperationKeys[index]; }

private:
    struct TimeTrackerList
    {
        chip::SingleLinkedListNode<TimeTracker> * head = nullptr;

        void Insert(const TimeTracker & tracker)
        {
            auto * newNode =
                static_cast<chip::SingleLinkedListNode<TimeTracker> *>(malloc(sizeof(chip::SingleLinkedListNode<TimeTracker>)));
            if (newNode != nullptr)
            {
                newNode->mValue = tracker;
                newNode->mpNext = head;
                head            = newNode;
            }
        }

        void Remove(size_t index)
        {
            if (index == 0 && head != nullptr)
            {
                auto * temp = head;
                head        = head->mpNext;
                free(temp);
                return;
            }

            auto * current = head;
            for (size_t i = 0; i < index - 1 && current != nullptr; ++i)
            {
                current = current->mpNext;
            }

            if (current && current->mpNext)
            {
                auto * temp     = current->mpNext;
                current->mpNext = current->mpNext->mpNext;
                free(temp);
            }
        }
    };

    // Singleton class with a static instance
    static SilabsTracer sInstance;

    SilabsTracer();

    // List of past time trackers
    TimeTrackerList mTimeTrackerList;

    // Time trackers to store time stamps for ongoing operations
    TimeTracker mLatestTimeTrackers[kNumTraces];

    // Watermarks for each operation
    Watermark mWatermarks[kNumTraces];

    PersistentStorageDelegate * mStorage = nullptr;

    size_t mBufferedTrackerCount = 0;

    // App specific Operation keys buffer
    char mAppOperationKeys[SilabsTracer::kMaxAppOperationKeys][SilabsTracer::kMaxAppOperationKeyLength];
    size_t mAppOperationKeyCount = 0;

    /** @brief Clear the trace buffer */
    void TraceBufferClear();

    /** @brief Output the values of a time tracker formatted as a string
     * This will log the trace if logs are enabled, fruthermore, the time tracker will be stored in the buffer if the buffer is not
     * full, regardless of the logs being enabled. If the buffer is filled at capacity - -1, this will store a tracker indicating
     * when the buffer full event happened for the first time. Afterwards, this will simply return CHIP_ERROR_BUFFER_TOO_SMALL.
     *  @param tracker The time tracker to output
     *  @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is full
     */
    CHIP_ERROR OutputTrace(const TimeTracker & tracker);
};

const char * TimeTraceOperationToString(TimeTraceOperation operation);
const char * TimeTraceOperationToString(size_t operation);

} // namespace Silabs
} // namespace Tracing
} // namespace chip
