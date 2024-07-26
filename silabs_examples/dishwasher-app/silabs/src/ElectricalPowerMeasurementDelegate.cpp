/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
 *    All rights reserved.
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

#include <app/reporting/reporting.h>
#include <app/util/af-types.h>
#include <lib/core/CHIPError.h>

#include "ElectricalPowerMeasurementDelegate.h"

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::ElectricalPowerMeasurement;
using namespace chip::app::Clusters::ElectricalPowerMeasurement::Structs;
using namespace chip::app::DataModel;

static const MeasurementAccuracyRangeStruct::Type kActivePowerAccuracyRanges[] = {
    // 2 - 5%, 3% Typ
    {
        .rangeMin       = -50'000'000, // -50kW
        .rangeMax       = -10'000'000, // -10kW
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(5000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(2000)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(3000)),
    },
    // 0.1 - 1%, 0.5% Typ
    {
        .rangeMin       = -9'999'999, // -9.999kW
        .rangeMax       = 9'999'999,  //  9.999kW
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(1000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(100)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(500)),
    },
    // 2 - 5%, 3% Typ
    {
        .rangeMin       = 10'000'000, // 10 kW
        .rangeMax       = 50'000'000, // 50 kW
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(5000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(2000)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(3000)),
    },
};

static const MeasurementAccuracyRangeStruct::Type kActiveCurrentAccuracyRanges[] = {
    // 2 - 5%, 3% Typ
    {
        .rangeMin       = -100'000, // -100A
        .rangeMax       = -5'000,   // -5A
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(5000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(2000)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(3000)),
    },
    // 0.1 - 1%, 0.5% Typ
    {
        .rangeMin       = -4'999, // -4.999A
        .rangeMax       = 4'999,  //  4.999A
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(1000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(100)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(500)),
    },
    // 2 - 5%, 3% Typ
    {
        .rangeMin       = 5'000,   // 5A
        .rangeMax       = 100'000, // 100 A
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(5000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(2000)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(3000)),
    },
};

static const MeasurementAccuracyRangeStruct::Type kVoltageAccuracyRanges[] = {
    // 2 - 5%, 3% Typ
    {
        .rangeMin       = -500'000, // -500V
        .rangeMax       = -100'000, // -100V
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(5000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(2000)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(3000)),
    },
    // 0.1 - 1%, 0.5% Typ
    {
        .rangeMin       = -99'999, // -99.999V
        .rangeMax       = 99'999,  //  99.999V
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(1000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(100)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(500)),
    },
    // 2 - 5%, 3% Typ
    {
        .rangeMin       = 100'000, // 100 V
        .rangeMax       = 500'000, // 500 V
        .percentMax     = MakeOptional(static_cast<chip::Percent100ths>(5000)),
        .percentMin     = MakeOptional(static_cast<chip::Percent100ths>(2000)),
        .percentTypical = MakeOptional(static_cast<chip::Percent100ths>(3000)),
    }
};

static const MeasurementAccuracyStruct::Type kMeasurementAccuracies[] = {
    {
        .measurementType  = MeasurementTypeEnum::kActivePower,
        .measured         = true,
        .minMeasuredValue = -50'000'000, // -50 kW
        .maxMeasuredValue = 50'000'000,  //  50 kW
        .accuracyRanges   = List<const MeasurementAccuracyRangeStruct::Type>(kActivePowerAccuracyRanges),
    },
    {
        .measurementType  = MeasurementTypeEnum::kActiveCurrent,
        .measured         = true,
        .minMeasuredValue = -100'000, // -100A
        .maxMeasuredValue = 100'000,  //  100A
        .accuracyRanges   = List<const MeasurementAccuracyRangeStruct::Type>(kActiveCurrentAccuracyRanges),
    },
    {
        .measurementType  = MeasurementTypeEnum::kVoltage,
        .measured         = true,
        .minMeasuredValue = -500'000, // -500V
        .maxMeasuredValue = 500'000,  //  500V
        .accuracyRanges   = List<const MeasurementAccuracyRangeStruct::Type>(kVoltageAccuracyRanges),
    },
};

static MeasurementRangeStruct::Type sMeasurementRanges[] = {
    {
        .measurementType  = static_cast<MeasurementTypeEnum>(0),
        .min              = static_cast<int64_t>(0),
        .max              = static_cast<int64_t>(300),
    },
    {
        .measurementType  = static_cast<MeasurementTypeEnum>(1),
        .min              = static_cast<int64_t>(0),
        .max              = static_cast<int64_t>(500),
    },
    {
        .measurementType  = static_cast<MeasurementTypeEnum>(2),
        .min              = static_cast<int64_t>(0),
        .max              = static_cast<int64_t>(1000),
    },
};

static const HarmonicMeasurementStruct::Type kHarmonicCurrentMeasurements[] = {
    { .order = 1, .measurement = MakeNullable(static_cast<int64_t>(100000)) }
};

static const HarmonicMeasurementStruct::Type kHarmonicPhaseMeasurements[] = {
    { .order = 1, .measurement = MakeNullable(static_cast<int64_t>(100000)) }
};

/** TODO - Manufacturers wanting to support this could adjust arrays */
static const struct  
{
    PowerModeEnum PowerMode;
    int64_t Voltage;            // mV
    int64_t ActiveCurrent;      // mA
    int64_t ReactiveCurrent;    // mA
    int64_t ApparentCurrent;    // mA
    int64_t ActivePower;        // mW
    int64_t ReactivePower;      // mW
    int64_t ApparentPower;      // mW
    int64_t RMSVoltage;         // mV
    int64_t RMSCurrent;         // mA
    int64_t RMSPower;           // mW
    int64_t Frequency;          // Hz
    int64_t PowerFactor;        // Percent 100ths
    int64_t NeutralCurrent;     // mA
} kAttribute[] =
{
    { PowerModeEnum::kAc,     120'000,      0,      0,      0,        0,         0,        0, 120'000,      0,        0, 60, 98'00,      0 }, // kStopped
    { PowerModeEnum::kAc,     120'000, 15'000, 17'000, 23'000, 1800'000,  2040'000, 3000'000, 120'000, 15'000, 1800'000, 60, 92'00, 15'000 }, // kRunning
    { PowerModeEnum::kAc,     120'000,    125,    150,    190,   17'000,    18'000,   25'000, 120'000,    125,   17'000, 60, 95'00,    125 }, // kPaused 
    { PowerModeEnum::kUnknown,      0,      0,      0,      0,        0,         0,        0,       0,      0,        0,  0,     0,      0 }  // kError
};

uint8_t ElectricalPowerMeasurementDelegate::GetNumberOfMeasurementTypes()
{
    return ArraySize(kMeasurementAccuracies);
};

/* @brief This function is called by the cluster server at the start of read cycle
 *        This could take a semaphore to stop a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::StartAccuracyRead()
{
    /* Since we have a static array we don't need to do anything here */
    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::GetAccuracyByIndex(uint8_t accuracyIndex,
                                                                  Structs::MeasurementAccuracyStruct::Type & accuracy)
{
    VerifyOrReturnError(accuracyIndex < ArraySize(kMeasurementAccuracies), CHIP_ERROR_PROVIDER_LIST_EXHAUSTED);

    accuracy = kMeasurementAccuracies[accuracyIndex];
    
    return CHIP_NO_ERROR;
}

/* @brief This function is called by the cluster server at the end of read cycle
 *        This could release a semaphore to allow a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::EndAccuracyRead()
{
    /* Since we have a static array we don't need to do anything here */
    return CHIP_NO_ERROR;
}

/* @brief This function is called by the cluster server at the start of read cycle
 *        This could take a semaphore to stop a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::StartRangesRead()
{
    /* Since we don't an implementation here we don't need to do anything here */
    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::GetRangeByIndex(uint8_t rangeIndex, Structs::MeasurementRangeStruct::Type & range)
{
    /** TODO - Manufacturers wanting to support this should
     * implement an array of
     * Structs::MeasurementRangeStruct::Type mMeasurementRanges[];
     *
     * their application code should update the relevant measurement 'Range' information including
     *   - .measurementType
     *   - .min
     *   - .max
     *   - .startTimestamp
     *   - .endTimestamp
     *   - .minTimestamp (the time at which the minimum value was recorded)
     *   - .maxTimestamp (the time at which the maximum value was recorded)
     *   (and optionally use sys time equivalents)
     */

    /* Added to support testing using a static array for now */
    VerifyOrReturnError(rangeIndex < ArraySize(sMeasurementRanges), CHIP_ERROR_PROVIDER_LIST_EXHAUSTED);
     
    range = sMeasurementRanges[rangeIndex];

    return CHIP_NO_ERROR;
}

/* @brief This function is called by the cluster server at the end of read cycle
 *        This could release a semaphore to allow a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::EndRangesRead()
{
    /* Since we don't do an implementation here we don't need to do anything here */
    return CHIP_NO_ERROR;
}

/* @brief This function is called by the cluster server at the start of read cycle
 *        This could take a semaphore to stop a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::StartHarmonicCurrentsRead()
{
    /* Since we have a static array we don't need to do anything here */
    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::GetHarmonicCurrentsByIndex(uint8_t harmonicCurrentsIndex,
                                                                          Structs::HarmonicMeasurementStruct::Type & harmonicCurrent)
{
    /** TODO - Manufacturers wanting to support this could implement an array of
     * Structs::HarmonicMeasurementStruct::Type mHarmonicCurrentMeasurements[];
     *
     * The application code should update the relevant harmonic 'order' information including
     *   - .order
     *   - .measurement
     *
     * The application should also ensure it notifies remote clients that the value has changed
     *  MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, HarmonicCurrents::Id);
     */

    /* Added to support testing using a static array for now */
    VerifyOrReturnError(harmonicCurrentsIndex < ArraySize(kHarmonicCurrentMeasurements), CHIP_ERROR_PROVIDER_LIST_EXHAUSTED);

    harmonicCurrent = kHarmonicCurrentMeasurements[harmonicCurrentsIndex];

    return CHIP_NO_ERROR;
}

/* @brief This function is called by the cluster server at the end of read cycle
 *        This could release a semaphore to allow a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::EndHarmonicCurrentsRead()
{
    /* Since we have a static array we don't need to do anything here */
    return CHIP_NO_ERROR;
}

/* @brief This function is called by the cluster server at the start of read cycle
 *        This could take a semaphore to stop a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::StartHarmonicPhasesRead()
{
    /* Since we have a static array we don't need to do anything here */
    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::GetHarmonicPhasesByIndex(uint8_t harmonicPhaseIndex,
                                                                        Structs::HarmonicMeasurementStruct::Type & harmonicPhase)
{
    /** TODO - Manufacturers wanting to support this could implement an array of
     * Structs::HarmonicMeasurementStruct::Type mHarmonicPhaseMeasurements[];
     *
     * The application code should update the relevant harmonic 'order' information including
     *   - .order
     *   - .measurement
     *
     * The application should also ensure it notifies remote clients that the value has changed
     *  MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, HarmonicPhases::Id);
     */

    /* Added to support testing using a static array for now */
    VerifyOrReturnError(harmonicPhaseIndex < ArraySize(kHarmonicPhaseMeasurements), CHIP_ERROR_PROVIDER_LIST_EXHAUSTED);

    harmonicPhase = kHarmonicPhaseMeasurements[harmonicPhaseIndex];

    return CHIP_NO_ERROR;
}

/* @brief This function is called by the cluster server at the end of read cycle
 *        This could release a semaphore to allow a background update of the data
 */
CHIP_ERROR ElectricalPowerMeasurementDelegate::EndHarmonicPhasesRead()
{
    /* Since we have a static array we don't need to do anything here */
    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetPowerMode(PowerModeEnum newValue)
{
    PowerModeEnum oldValue = mPowerMode;

    if (EnsureKnownEnumValue(newValue) == PowerModeEnum::kUnknownEnumValue)
    {
        return CHIP_IM_GLOBAL_STATUS(ConstraintError);
    }

    mPowerMode = newValue;
    if (oldValue != newValue)
    {
        ChipLogDetail(AppServer, "mPowerMode updated to %d", static_cast<int>(mPowerMode));
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, PowerMode::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetVoltage(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mVoltage;

    mVoltage = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, Voltage::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetActiveCurrent(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mActiveCurrent;

    mActiveCurrent = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, ActiveCurrent::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetReactiveCurrent(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mReactiveCurrent;

    mReactiveCurrent = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, ReactiveCurrent::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetApparentCurrent(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mApparentCurrent;

    mApparentCurrent = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, ApparentCurrent::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetActivePower(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mActivePower;

    mActivePower = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, ActivePower::Id);
    }

    return CHIP_NO_ERROR;
}
CHIP_ERROR ElectricalPowerMeasurementDelegate::SetReactivePower(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mReactivePower;

    mReactivePower = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, ReactivePower::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetApparentPower(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mApparentPower;

    mApparentPower = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, ApparentPower::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetRMSVoltage(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mRMSVoltage;

    mRMSVoltage = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, RMSVoltage::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetRMSCurrent(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mRMSCurrent;

    mRMSCurrent = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, RMSCurrent::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetRMSPower(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mRMSPower;

    mRMSPower = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, RMSPower::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetFrequency(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mFrequency;

    mFrequency = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, Frequency::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetPowerFactor(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mPowerFactor;

    mPowerFactor = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, PowerFactor::Id);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalPowerMeasurementDelegate::SetNeutralCurrent(Nullable<int64_t> newValue)
{
    Nullable<int64_t> oldValue = mNeutralCurrent;

    mNeutralCurrent = newValue;
    if (oldValue != newValue)
    {
        // We won't log raw values since these could change frequently
        MatterReportingAttributeChangeCallback(mEndpointId, ElectricalPowerMeasurement::Id, NeutralCurrent::Id);
    }

    return CHIP_NO_ERROR;
}

void ElectricalPowerMeasurementDelegate::UpdateAllAttributes(uint16_t state)
{
    uint16_t ERROR_STATE_INDEX = ArraySize(kAttribute) - 1;

    // Check index range
    if ((state < 0) || (state > ERROR_STATE_INDEX))
    {
        state = ERROR_STATE_INDEX;
    }
    
    ChipLogDetail(AppServer, "UpdateAllAttributes to Operational State : %d", state);

    // Added to support testing using a static array for now 
    SetPowerMode(kAttribute[state].PowerMode);
    SetVoltage(MakeNullable(kAttribute[state].Voltage));
    SetActiveCurrent(MakeNullable(kAttribute[state].ActiveCurrent));
    SetReactiveCurrent(MakeNullable(kAttribute[state].ReactiveCurrent));
    SetApparentCurrent(MakeNullable(kAttribute[state].ApparentCurrent));
    SetActivePower(MakeNullable(kAttribute[state].ActivePower));
    SetReactivePower(MakeNullable(kAttribute[state].ReactivePower));
    SetApparentPower(MakeNullable(kAttribute[state].ApparentPower));
    SetRMSVoltage(MakeNullable(kAttribute[state].RMSVoltage));
    SetRMSCurrent(MakeNullable(kAttribute[state].RMSCurrent));
    SetRMSPower(MakeNullable(kAttribute[state].RMSPower));
    SetFrequency(MakeNullable(kAttribute[state].Frequency));
    SetPowerFactor(MakeNullable(kAttribute[state].PowerFactor));
    SetNeutralCurrent(MakeNullable(kAttribute[state].NeutralCurrent));
}

CHIP_ERROR ElectricalPowerMeasurementInstance::Init()
{
    for (uint16_t index = 0; index < ArraySize(sMeasurementRanges); index++)
    {
        sMeasurementRanges[index].startSystime = MakeOptional(System::SystemClock().GetMonotonicTimestamp().count());
        sMeasurementRanges[index].endSystime   = MakeOptional(System::SystemClock().GetMonotonicTimestamp().count());
        sMeasurementRanges[index].minSystime   = MakeOptional(System::SystemClock().GetMonotonicTimestamp().count());
        sMeasurementRanges[index].maxSystime   = MakeOptional(System::SystemClock().GetMonotonicTimestamp().count());
    }

    return Instance::Init();
}

void ElectricalPowerMeasurementInstance::Shutdown()
{
    Instance::Shutdown();
}
