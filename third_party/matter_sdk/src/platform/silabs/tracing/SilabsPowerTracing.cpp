#include "SilabsPowerTracing.h"
#include <lib/support/CodeUtils.h>
#include <platform/silabs/tracing/SilabsTracingConfig.h>
#include <platform/silabs/tracing/SilabsTracingMacros.h>

namespace chip {
namespace Tracing {
namespace Silabs {

// Timer callback function - defined before use
namespace {
void OnPowerManagerStatisticsTimer(void * argument)
{
    SilabsPowerTracing::Instance().OutputPowerManagerTraces();
}
} // namespace

// Define the static singleton instance
SilabsPowerTracing SilabsPowerTracing::sInstance;

// singleton instance constructor
SilabsPowerTracing::SilabsPowerTracing() :
    mEnergyTraces(nullptr), mEnergyTraceCount(0), mPowerManagerEmTransitionEventHandle(),
    mPowerManagerEmTransitionEventInfo{ (SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM0 |
                                         SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM1 |
                                         SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM2),
                                        StaticPowerManagerTransitionCallback },
    mStatisticsTimer(nullptr), mInitialized(false)
{}

CHIP_ERROR SilabsPowerTracing::Init()
{
    CHIP_ERROR err = CHIP_NO_ERROR;

    // Return early if already initialized
    VerifyOrReturnError(!mInitialized, CHIP_NO_ERROR);

    // Allocate energy trace storage
    if (mEnergyTraces == nullptr)
    {
        mEnergyTraces = static_cast<EnergyTrace *>(calloc(SL_TRACING_ENERGY_TRACES_MAX, sizeof(EnergyTrace)));
        VerifyOrReturnError(mEnergyTraces != nullptr, CHIP_ERROR_NO_MEMORY);
    }

    mEnergyTraceCount = 0;

    sl_power_manager_subscribe_em_transition_event(&mPowerManagerEmTransitionEventHandle, &mPowerManagerEmTransitionEventInfo);

    // Create and start one-shot timer for statistics output
    mStatisticsTimer = osTimerNew(OnPowerManagerStatisticsTimer, osTimerOnce, nullptr, nullptr);
    if (mStatisticsTimer == nullptr)
    {
        ChipLogError(DeviceLayer, "Failed to create power manager statistics timer");
        err = CHIP_ERROR_NO_MEMORY;
    }

    if (err == CHIP_NO_ERROR)
    {
        uint32_t ticks = SL_TRACING_ENERGY_TRACES_SECONDS * osKernelGetTickFreq();
        if (osTimerStart(mStatisticsTimer, ticks) != osOK)
        {
            ChipLogError(DeviceLayer, "Failed to start power manager statistics timer");
            err = CHIP_ERROR_INTERNAL;
        }
    }

    // Cleanup on error
    if (err != CHIP_NO_ERROR)
    {
        Cleanup();
    }
    else
    {
        mInitialized = true;
    }

    return err;
}

void SilabsPowerTracing::Cleanup()
{
    if (mStatisticsTimer != nullptr)
    {
        osTimerDelete(mStatisticsTimer);
        mStatisticsTimer = nullptr;
    }

    if (mEnergyTraces != nullptr)
    {
        free(mEnergyTraces);
        mEnergyTraces     = nullptr;
        mEnergyTraceCount = 0;
    }

    sl_power_manager_unsubscribe_em_transition_event(&mPowerManagerEmTransitionEventHandle);
    mInitialized = false;
}

SilabsPowerTracing::~SilabsPowerTracing()
{
    Cleanup();
}

void SilabsPowerTracing::PowerManagerTransitionCallback([[maybe_unused]] sl_power_manager_em_t from, sl_power_manager_em_t to)
{
    if (!mInitialized || mEnergyTraces == nullptr || mEnergyTraceCount >= SL_TRACING_ENERGY_TRACES_MAX)
    {
        return;
    }

    mEnergyTraces[mEnergyTraceCount].mEntryTime  = SL_GET_SLEEPTIMER_TIME();
    mEnergyTraces[mEnergyTraceCount].mEnergyMode = to;
    mEnergyTraceCount++;
}

void SilabsPowerTracing::StaticPowerManagerTransitionCallback(sl_power_manager_em_t from, sl_power_manager_em_t to)
{
    Instance().PowerManagerTransitionCallback(from, to);
}

const EnergyTrace * SilabsPowerTracing::GetEnergyTrace(size_t index) const
{
    if (!mInitialized || mEnergyTraces == nullptr || index >= mEnergyTraceCount)
    {
        return nullptr;
    }
    return &mEnergyTraces[index];
}

CHIP_ERROR SilabsPowerTracing::OutputPowerManagerTraces()
{
    if (!mInitialized)
    {
        return CHIP_ERROR_UNINITIALIZED;
    }

    // Stop further power manager event callbacks while outputting traces
    sl_power_manager_unsubscribe_em_transition_event(&mPowerManagerEmTransitionEventHandle);

    ChipLogProgress(DeviceLayer, "=== Power Manager Energy Mode Traces ===");
    ChipLogProgress(DeviceLayer, "Index | Entry Time | Energy Mode");

    VerifyOrReturnError(mEnergyTraces != nullptr, CHIP_ERROR_UNINITIALIZED);

    for (uint32_t i = 0; i < mEnergyTraceCount; i++)
    {
        // Casting to unsigned long to remove ambiguity for the unit tests.
        ChipLogProgress(DeviceLayer, "%lu | %lu | EM%d", (unsigned long) i, (unsigned long) mEnergyTraces[i].mEntryTime,
                        mEnergyTraces[i].mEnergyMode);
        // Delay so the output is not mangled or skipped.
        // 5 (ticks) is enough for UART, but only 1 is required for RTT.
        // No delay results in missed or mangled output for both.
        osDelay(5);
    }

    return CHIP_NO_ERROR;
}

} // namespace Silabs
} // namespace Tracing
} // namespace chip
