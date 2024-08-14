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

#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/AttributeAccessInterface.h>
#include <app/EventLogging.h>
#include <app/reporting/reporting.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>
#include <lib/core/ClusterEnums.h>
#include <system/SystemClock.h>

#include "AppConfig.h"
#include "AppTask.h"
#include "ElectricalEnergyMeasurementInstance.h"

#define mWms_TO_mWh(power) ((power) / 3600'000)

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::ElectricalEnergyMeasurement;
using namespace chip::app::Clusters::ElectricalEnergyMeasurement::Structs;
using namespace chip::app::DataModel;

// Example of setting CumulativeEnergyReset structure - for now set these to 0
// but the manufacturer may want to store these in non volatile storage for timestamp (based on epoch_s)
// Create an accuracy entry which is between +/-0.5 and +/- 5% across the range of all possible energy readings
static const MeasurementAccuracyRangeStruct::Type kEnergyAccuracyRanges[] = {
    { .rangeMin   = 0,
      .rangeMax   = 1'000'000'000'000'000, // 1 million Mwh
      .percentMax = MakeOptional(static_cast<chip::Percent100ths>(500)),
      .percentMin = MakeOptional(static_cast<chip::Percent100ths>(50)) }
};

static const MeasurementAccuracyStruct::Type kAccuracy = {
    .measurementType  = MeasurementTypeEnum::kElectricalEnergy,
    .measured         = true,
    .minMeasuredValue = 0,
    .maxMeasuredValue = 1'000'000'000'000'000, // 1 million Mwh
    .accuracyRanges   = List<const ElectricalEnergyMeasurement::Structs::MeasurementAccuracyRangeStruct::Type>(kEnergyAccuracyRanges)
};

static const CumulativeEnergyResetStruct::Type kResetStruct = {
    .importedResetTimestamp = MakeOptional(MakeNullable(static_cast<uint32_t>(0))),
    .exportedResetTimestamp = MakeOptional(MakeNullable(static_cast<uint32_t>(0))),
    .importedResetSystime   = MakeOptional(MakeNullable(static_cast<uint64_t>(0))),
    .exportedResetSystime   = MakeOptional(MakeNullable(static_cast<uint64_t>(0))),
};

static EnergyMeasurementStruct::Type gCumulativeImported = {
    .energy = static_cast<int64_t>(0),
};


static const EnergyMeasurementStruct::Type kCumulativeExported = {
    .energy = static_cast<int64_t>(0),
};

static ElectricalPowerMeasurement::ElectricalPowerMeasurementDelegate * gEPMDelegate;
static EndpointId gEndpointId;
static int64_t gCumulativeActivePower = 0;

CHIP_ERROR ElectricalEnergyMeasurementInstance::Init()
{
    // Initialize attributes 
    SetMeasurementAccuracy(mEndpointId, kAccuracy);
    SetCumulativeReset(mEndpointId, MakeOptional(kResetStruct));

    // Assign class attributes to instantiated global variables
    // for the access to TimerEventHandler 
    gEPMDelegate = GetEPMDelegate();
    gEndpointId = mEndpointId;

    CHIP_ERROR err;

    // Initialize and start timer to calculate cumulative energy
    err = InitTimer();
    
    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(AppServer, "Init failed on EEM Timer"));

    StartTimer(kTimerPeriodms);

    return ElectricalEnergyMeasurementAttrAccess::Init();
}

void ElectricalEnergyMeasurementInstance::Shutdown()
{
    CancelTimer();
    ElectricalEnergyMeasurementAttrAccess::Shutdown();
}

CHIP_ERROR ElectricalEnergyMeasurementInstance::Read(const app::ConcreteReadAttributePath & aPath,
                                                     app::AttributeValueEncoder & aEncoder)
{
    VerifyOrDie(aPath.mClusterId == app::Clusters::ElectricalEnergyMeasurement::Id);

    MeasurementData * data = MeasurementDataForEndpoint(aPath.mEndpointId);

    switch (aPath.mAttributeId)
    {
    case Attributes::CumulativeEnergyImported::Id:
    
        VerifyOrReturnError(
            HasFeature(ElectricalEnergyMeasurement::Feature::kCumulativeEnergy) &&
                HasFeature(ElectricalEnergyMeasurement::Feature::kImportedEnergy),
            CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE,
            ChipLogError(Zcl, "Electrical Energy Measurement: can not get CumulativeEnergyImported, feature is not supported"));
            
        if ((data == nullptr) || !data->cumulativeImported.HasValue())
        {
            return aEncoder.EncodeNull();
        }

        // cumulativeImported update code - To update energy (mWs to mWh), startSystime and endSystime
        // Copy last endSystime into new startSystime if it exists, and set endSystime to present moment
        gCumulativeImported.startSystime.ClearValue();
        if (data->cumulativeImported.HasValue())
        {
            // Convert the unit : mW * ms -> mWh
            gCumulativeImported.energy = mWms_TO_mWh(gCumulativeActivePower * kTimerPeriodms); 
            gCumulativeImported.startTimestamp = data->cumulativeImported.Value().endTimestamp;
            gCumulativeImported.startSystime = data->cumulativeImported.Value().endSystime;
        }

        uint32_t currentTimestamp;
        if (GetEpochTS(currentTimestamp) == CHIP_NO_ERROR)
        {
            // Use EpochTS
            gCumulativeImported.endTimestamp.SetValue(currentTimestamp);
        }
        gCumulativeImported.endSystime.SetValue(System::SystemClock().GetMonotonicTimestamp().count());

        // Initialize energy to 0 for new count start
        gCumulativeActivePower = 0;

        // Update data
        data->cumulativeImported.SetValue(gCumulativeImported);
        // End of cumulativeImported update

        return aEncoder.Encode(data->cumulativeImported.Value());

    // Use original Read() for other IDs
    case Attributes::FeatureMap::Id:
    case Attributes::Accuracy::Id:
    case Attributes::CumulativeEnergyExported::Id:
    case Attributes::PeriodicEnergyImported::Id:
    case Attributes::PeriodicEnergyExported::Id:
    case Attributes::CumulativeEnergyReset::Id:
        return ElectricalEnergyMeasurementAttrAccess::Read(aPath, aEncoder);
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR ElectricalEnergyMeasurementInstance::InitTimer()
{
    // Create cmsis os sw timer for EEM Cumulative timer
    mTimer = osTimerNew(TimerEventHandler,    // Timer callback handler
                        osTimerPeriodic,      // Timer reload
                        (void *) this,        // Pass the app task obj context
                        NULL                  // No osTimerAttr_t to provide.
    );

    VerifyOrReturnError(mTimer != NULL, APP_ERROR_CREATE_TIMER_FAILED, SILABS_LOG("Timer create failed"));

    return CHIP_NO_ERROR;
}

void ElectricalEnergyMeasurementInstance::StartTimer(uint32_t aTimeoutMs)
{
    // Start or restart the function timer
    if (osTimerStart(mTimer, pdMS_TO_TICKS(aTimeoutMs)) != osOK)
    {
        SILABS_LOG("Timer start failed");
        appError(APP_ERROR_START_TIMER_FAILED);
    }

    // Initialize timestamp and systime
    uint32_t currentTimestamp;
    if (GetEpochTS(currentTimestamp) == CHIP_NO_ERROR)
    {
        // Use EpochTS
        gCumulativeImported.startTimestamp.SetValue(currentTimestamp);
        gCumulativeImported.endTimestamp.SetValue(currentTimestamp);
    }
    gCumulativeImported.startSystime.SetValue(System::SystemClock().GetMonotonicTimestamp().count());
    gCumulativeImported.endSystime.SetValue(System::SystemClock().GetMonotonicTimestamp().count());
}

void ElectricalEnergyMeasurementInstance::CancelTimer(void)
{
    if (osTimerStop(mTimer) == osError)
    {
        SILABS_LOG("Timer stop failed");
        appError(APP_ERROR_STOP_TIMER_FAILED);
    }
}

void ElectricalEnergyMeasurementInstance::TimerEventHandler(void* timerCbArg)
{
    // Get different EPM Active Power values according to operational mode change
    Nullable<int64_t> EPMActivePower = gEPMDelegate ? gEPMDelegate->GetActivePower() : Nullable<int64_t>(0); 
    int64_t activePower = (EPMActivePower.IsNull()) ? 0 : EPMActivePower.Value();

    // Calculate cumulative imported active power
    gCumulativeActivePower += activePower;

    // Call the SDK to update attributes and generate an event
    NotifyCumulativeEnergyMeasured(gEndpointId, MakeOptional(gCumulativeImported), MakeOptional(kCumulativeExported));
}

CHIP_ERROR ElectricalEnergyMeasurementInstance::GetEpochTS(uint32_t & chipEpoch)
{
    chipEpoch = 0;

    System::Clock::Milliseconds64 cTMs;
    CHIP_ERROR err = System::SystemClock().GetClock_RealTimeMS(cTMs);

    /* If the GetClock_RealTimeMS returns CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE, then
     * This platform cannot ever report real time !
     * This should not be certifiable since getting time is a mandatory feature
     */
    VerifyOrReturnError(err != CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE, err, 
                        ChipLogError(Zcl, "Platform does not support GetClock_RealTimeMS. Check EVSE certification requirements!"));

    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(Zcl, "Unable to get current time - err:%" CHIP_ERROR_FORMAT, err.Format()));

    auto unixEpoch = std::chrono::duration_cast<System::Clock::Seconds32>(cTMs).count();

    VerifyOrReturnError(UnixEpochToChipEpochTime(unixEpoch, chipEpoch), err, 
                        ChipLogError(Zcl, "Unable to convert Unix Epoch time to Matter Epoch Time"));

    return CHIP_NO_ERROR;
}