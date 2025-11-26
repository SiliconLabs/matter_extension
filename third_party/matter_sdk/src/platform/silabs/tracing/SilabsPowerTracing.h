#pragma once

#if defined(SL_RAIL_LIB_MULTIPROTOCOL_SUPPORT) && SL_RAIL_LIB_MULTIPROTOCOL_SUPPORT
#include "cmsis_os2.h"
#include <sl_power_manager.h>
#else
// Use stub headers for unit tests
#include <platform/silabs/tracing/tests/mocks/cmsis_os2_stub.h>        // nogncheck
#include <platform/silabs/tracing/tests/mocks/sl_power_manager_stub.h> // nogncheck
#endif

#include <lib/core/CHIPError.h>

namespace chip {
namespace Tracing {
namespace Silabs {

struct EnergyTrace
{
    uint32_t mEntryTime;
    sl_power_manager_em_t mEnergyMode;
};

class SilabsPowerTracing
{
public:
    SilabsPowerTracing();
    ~SilabsPowerTracing();

    static SilabsPowerTracing & Instance() { return sInstance; }

    /** @brief Initialize the power tracing system
     * Allocates energy trace storage, subscribes to power manager events, and starts the statistics timer.
     * @return CHIP_NO_ERROR on success, CHIP_ERROR_NO_MEMORY if allocation fails, CHIP_ERROR_INTERNAL on timer errors
     */
    CHIP_ERROR Init();

    /** @brief Output all recorded power manager energy mode traces
     * Logs the collected energy traces showing timestamps and energy modes to the device layer.
     * @return CHIP_NO_ERROR on success, CHIP_ERROR_UNINITIALIZED if not initialized
     */
    CHIP_ERROR OutputPowerManagerTraces();

    /** @brief Check if the power tracing system is initialized
     *  @return true if initialized, false otherwise
     */
    bool IsInitialized() const { return mInitialized; }

    /** @brief Get the number of recorded energy traces
     *  @return The count of energy traces currently in the buffer
     */
    size_t GetEnergyTraceCount() const { return mEnergyTraceCount; }

    /** @brief Get a specific energy trace by index
     *  @param index The index of the trace to retrieve
     *  @return Pointer to the energy trace, or nullptr if index is out of bounds
     */
    const EnergyTrace * GetEnergyTrace(size_t index) const;

    /** @brief Callback for power manager energy mode transitions
     * This function is called by the power manager when the device transitions between energy modes.
     * It records the timestamp and new energy mode in the trace buffer.
     *  @param from The energy mode the device is transitioning from
     *  @param to The energy mode the device is transitioning to
     */
    void PowerManagerTransitionCallback([[maybe_unused]] sl_power_manager_em_t from, sl_power_manager_em_t to);

    /** @brief Static callback for power manager energy mode transitions
     * This function is a static wrapper that calls the instance method PowerManagerTransitionCallback.
     *  @param from The energy mode the device is transitioning from
     *  @param to The energy mode the device is transitioning to
     */
    static void StaticPowerManagerTransitionCallback(sl_power_manager_em_t from, sl_power_manager_em_t to);

private:
    /** @brief Cleanup resources (timer, power manager subscription, energy traces)
     * This method is called by both the destructor and the Init() error path.
     */
    void Cleanup();

    static SilabsPowerTracing sInstance;

    // Energy trace storage
    EnergyTrace * mEnergyTraces;
    size_t mEnergyTraceCount;

    // Power manager event handling
    sl_power_manager_em_transition_event_handle_t mPowerManagerEmTransitionEventHandle;
    sl_power_manager_em_transition_event_info_t mPowerManagerEmTransitionEventInfo;

    // Statistics timer
    osTimerId_t mStatisticsTimer;

    // Initialization state
    bool mInitialized;
};

} // namespace Silabs
} // namespace Tracing
} // namespace chip
