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
#include <platform/silabs/tracing/SilabsTracingConfig.h>
#if defined(SL_TRACING_ENERGY_STATS) && SL_TRACING_ENERGY_STATS == 1
#include <sl_power_manager.h>
#define SLEEP_EM_EVENT_MASK                                                                                                        \
    (SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM0 | SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM1 |                             \
     SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM2)
#endif // SL_TRACING_ENERGY_STATS
#include <stdint.h>
#include <system/SystemClock.h>

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

struct Metric
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
    static constexpr size_t kNumTraces = to_underlying(TimeTraceOperation::kNumTraces); // Number of TimeTraceOperation types
    static constexpr size_t kMaxAppOperationKeys      = 5;
    static constexpr size_t kMaxAppOperationKeyLength = 16;
    static constexpr size_t kMaxBufferedTraces        = 64;
    static constexpr size_t kMaxTraceSize             = 128;
    // If the number of named traces exceeds this value at runtime, the exceeding traces will be dropped.
    static constexpr size_t kMaxNamedTraces = 64;

    /** @brief Get the singleton instance of SilabsTracer */
    static SilabsTracer & Instance() { return sInstance; }

    /** @brief Initialize the SilabsTracer
     *  This method initializes sets the metrics and time trackers to 0 and clears the traces buffer.
     *  @return CHIP_ERROR, currently no failure is implemented but when the NVM is added this will return an error if the NVM
     * initialization fails.
     */
    CHIP_ERROR Init();

    /** @brief Start storing metrics in persistent storage
     *  @param storage Pointer to the persistent storage delegate
     *  @return CHIP_ERROR, returns an error if the storage is null
     */
    CHIP_ERROR StartMetricsStorage(PersistentStorageDelegate * storage);

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
    /** @brief Trace an instant time operation using a Named Trace
     *  @param label The label for the trace
     *  @param group The group for the trace
     * @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is full
     */
    CHIP_ERROR TimeTraceInstant(const CharSpan label, const CharSpan group, CHIP_ERROR error = CHIP_NO_ERROR);

    /** @brief Begin a named trace with a label and group
     *  @param label The label for the trace
     *  @param group The group for the trace
     *  @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is full.
     */
    CHIP_ERROR NamedTraceBegin(const CharSpan label, const CharSpan group);

    /** @brief End a named trace with a label and group
     *  @param label The label for the trace
     *  @param group The group for the trace
     *  @return CHIP_ERROR, returns CHIP_ERROR_NOT_FOUND if a NamedTraceBegin was not found
     */
    CHIP_ERROR NamedTraceEnd(const CharSpan label, const CharSpan group);

    /**
     * @brief Helper method to save end, duration and calculate statistics of a Metric
     * @param metric Metric instance to be modified
     * @param duration Duration of the TimeTracker
     */
    CHIP_ERROR FinishMetric(Metric & metric, System::Clock::Milliseconds32 duration);

    /** @brief Output a time tracker
     * This will output the latest time tracker for a specific operation, without affecting the buffer.
     *  @param tracker The time tracker to output
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the log is not initialized
     */
    /** @brief Output a specific time tracker
     *  @param tracker The TimeTracker to output.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the log is not initialized.
     */
    CHIP_ERROR OutputTimeTracker(const TimeTracker & tracker);

    /** @brief Output the metric for a specific operation by index
     *  @param aOperationIdx The index of the operation.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the log is not initialized.
     */
    CHIP_ERROR OutputMetric(size_t aOperationIdx);

    /** @brief Output the metric for a specific operation by name
     *  @param aOperation The name of the operation.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the log is not initialized.
     */
    CHIP_ERROR OutputMetric(CharSpan aOperation);

    /** @brief Output all metrics for all operations
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if any metric output fails.
     */
    CHIP_ERROR OutputAllMetrics();

    /** @brief Output all currently active operations
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the log is not initialized.
     */
    CHIP_ERROR OutputAllCurrentOperations();

    /** @brief Flush all traces from the buffer in the order they were added
     *  Outputs all traces currently stored in the buffer and clears the buffer if logs are enabled.
     *  If logs are not enabled, returns an error and preserves the traces in the buffer.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the logs are not initialized.
     */
    CHIP_ERROR TraceBufferFlushAll();

    /** @brief Flush traces for a specific operation from the buffer by index
     *  Outputs and clears all traces for the specified operation index from the buffer if logs are enabled.
     *  If logs are not enabled, returns an error and preserves the traces in the buffer.
     *  @param aOperationIdx The index of the operation to flush traces for.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the logs are not initialized.
     */
    CHIP_ERROR TraceBufferFlushByOperation(size_t aOperationIdx);

    /** @brief Flush traces for a specific app operation key from the buffer
     *  Outputs and clears all traces for the specified app operation key from the buffer if logs are enabled.
     *  If logs are not enabled, returns an error and preserves the traces in the buffer.
     *  @param appOperationKey The key identifying the app operation.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the logs are not initialized.
     */
    CHIP_ERROR TraceBufferFlushByOperation(CharSpan appOperationKey);

    // prevent copy constructor and assignment operator
    SilabsTracer(SilabsTracer const &)             = delete;
    SilabsTracer & operator=(SilabsTracer const &) = delete;

    /** @brief Save the metrics to persistent storage
     *  @return CHIP_ERROR, returns an error if the storage is not initialized
     */
    CHIP_ERROR SaveMetrics();

    /** @brief Load the metrics from persistent storage
     *  @return CHIP_ERROR, returns an error if the storage is not initialized
     */
    CHIP_ERROR LoadMetrics();

    // Methods to get the time trackers metrics values

    /** @brief Get the latest time tracker for a specific operation
     *  @param aOperation The operation to get the time tracker for
     *  @return TimeTracker, the latest time tracker for the operation
     */
    TimeTracker GetTimeTracker(TimeTraceOperation aOperation) { return mLatestTimeTrackers[to_underlying(aOperation)]; }

    /** @brief Get the metric for a specific operation
     *  @param aOperation The operation to get the metric for
     *  @return Metric, the metric for the operation
     */
    Metric GetMetric(TimeTraceOperation aOperation) { return mMetrics[to_underlying(aOperation)]; }

    /** @brief Get a specific trace by operation
     *  Retrieves and formats the most recent trace for the specified operation.
     *  Does not modify the trace buffer.
     *  @param aOperationIdx The operation index to retrieve
     *  @param buffer The buffer to write the formatted trace into
     *  @return CHIP_ERROR_NOT_FOUND if no trace exists for the operation,
     *          CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is too small,
     *          CHIP_NO_ERROR on success
     */
    CHIP_ERROR GetTraceByOperation(size_t aOperationIdx, MutableCharSpan & buffer) const;

    /** @brief Get a specific trace by operation name
     *  @param aOperation The operation name or "group:label" format for named traces
     *  @param buffer The buffer to write the formatted trace into
     *  @return CHIP_ERROR_NOT_FOUND if no trace exists for the operation,
     *          CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is too small,
     *          CHIP_ERROR_INVALID_ARGUMENT if operation format is invalid,
     *          CHIP_NO_ERROR on success
     */
    CHIP_ERROR GetTraceByOperation(CharSpan aOperation, MutableCharSpan & buffer) const;

    size_t GetTimeTracesCount() { return mBufferedTrackerCount; }

    /** @brief Convert a string to a TimeTraceOperation enum value
     *  @param aOperation The string representation of the operation
     *  @return TimeTraceOperation, the corresponding enum value or kNumTraces if not found
     */
    TimeTraceOperation StringToTimeTraceOperation(CharSpan aOperation) const;

    /** @brief Get the string representation of an operation by its index
     *  @param aOperationIdx The index of the operation
     *  @param buffer The output buffer to write the string to
     *  @return const CharSpan, the string representation of the operation
     */
    CHIP_ERROR OperationIndexToString(size_t aOperationIdx, MutableCharSpan buffer);

    /** @brief Output FreeRTOS task statistics
     * This function uses uxTaskGetSystemState() and FreeRTOSRuntimeStats.h to retrieve task information and displays task name,
     * state, priority, stack high water mark, and CPU usage percentage.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the logs or RTOS features required are not initialized
     */
    CHIP_ERROR OutputTaskStatistics();

    /** @brief Output power manager energy mode statistics
     * This function outputs the total time spent in each energy mode and the percentage of total time.
     *  @return CHIP_ERROR, returns CHIP_ERROR_UNINITIALIZED if the feature or logs are not initialized
     */
    CHIP_ERROR OutputPowerManagerStatistics();

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

    struct NamedTrace
    {
        static constexpr size_t kMaxLabelLength = kMaxAppOperationKeyLength;
        static constexpr size_t kMaxGroupLength = kMaxAppOperationKeyLength;

        uint8_t labelLen = 0;
        uint8_t groupLen = 0;
        char label[kMaxLabelLength];
        char group[kMaxGroupLength];
        TimeTracker tracker;
        Metric metric;
    };

    // Singleton class with a static instance
    static SilabsTracer sInstance;

    SilabsTracer();

    // List of past time trackers
    TimeTrackerList mTimeTrackerList;

    // Time trackers to store time stamps for ongoing operations
    TimeTracker mLatestTimeTrackers[kNumTraces];

    // Metrics for each operation
    Metric mMetrics[kNumTraces];

    // Contains all the named traces
    NamedTrace mNamedTraces[kMaxNamedTraces];

    PersistentStorageDelegate * mStorage = nullptr;

    size_t mBufferedTrackerCount = 0;
#if defined(SL_TRACING_ENERGY_STATS) && SL_TRACING_ENERGY_STATS == 1

    System::Clock::Milliseconds32 mTimeInEnergyState[SL_POWER_MANAGER_EM2 + 1];
    System::Clock::Milliseconds32 mLongestTimeInEnergyState[SL_POWER_MANAGER_EM2 + 1];
    uint16_t mTransitionCountToEnergyState[SL_POWER_MANAGER_EM2 + 1];
    System::Clock::Milliseconds32 mLastEnergyStateTransitionTime;
    sl_power_manager_em_t mCurrentEnergyMode;
    sl_power_manager_em_transition_event_handle_t mPowerManagerEmTransitionEventHandle;
    sl_power_manager_em_transition_event_info_t mPowerManagerEmTransitionEventInfo = { .event_mask = SLEEP_EM_EVENT_MASK,
                                                                                       .on_event =
                                                                                           StaticPowerManagerTransitionCallback };
#endif // SL_TRACING_ENERGY_STATS

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

    /**
     * @brief Find the index of a named trace with the given label and group, or create a new one if it does not exist.
     * @param label The label for the trace.
     * @param group The group for the trace.
     * @param size_t Reference to the found index.
     * @return CHIP_ERROR, returns CHIP_ERROR_BUFFER_TOO_SMALL if the buffer is full
     */
    CHIP_ERROR FindOrCreateTrace(const CharSpan label, const CharSpan group, size_t & outIdx);

    /**
     * @brief Find the index of an existing named trace with the given label and group.
     * @param label The label for the trace.
     * @param group The group for the trace.
     * @param size_t Reference to the found index.
     * @return CHIP_ERROR, returns CHIP_ERROR_NOT_FOUND if it doesn't exist
     */
    CHIP_ERROR FindExistingTrace(const CharSpan label, const CharSpan group, size_t & outIdx) const;

    /**
     * @brief From a string like "Reboot:LighOn", split into "Reboot" and "LightOn"
     * @param appOperationKey the full entry key such as Reboot:LighOn"
     * @param groupSpan reference for the output of group
     * @param labelSpan reference for the output of label
     * @return CHIP_ERROR, returns CHIP_ERROR_INVALID_ARGUMENT if the format is not respected.
     */
    CHIP_ERROR SplitNamedTraceString(CharSpan appOperationKey, CharSpan & groupSpan, CharSpan & labelSpan) const;

#if defined(SL_TRACING_ENERGY_STATS) && SL_TRACING_ENERGY_STATS == 1

    /** @brief Callback for power manager energy mode transitions
     * This function is called by the power manager when the device transitions between energy modes.
     * It updates the time spent in each energy mode.
     *  @param from The energy mode the device is transitioning from
     *  @param to The energy mode the device is transitioning to
     */
    void PowerManagerTransitionCallback(sl_power_manager_em_t from, sl_power_manager_em_t to);

    /** @brief Static callback for power manager energy mode transitions
     * This function is a static wrapper that calls the instance method PowerManagerTransitionCallback.
     *  @param from The energy mode the device is transitioning from
     *  @param to The energy mode the device is transitioning to
     */
    static void StaticPowerManagerTransitionCallback(sl_power_manager_em_t from, sl_power_manager_em_t to);
#endif // SL_TRACING_ENERGY_STATS
};

} // namespace Silabs
} // namespace Tracing
} // namespace chip
