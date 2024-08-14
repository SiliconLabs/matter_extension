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
#include <app/ConcreteAttributePath.h>
#include <app/util/attribute-storage.h>
#include <lib/core/ClusterEnums.h>

#include "AppConfig.h"
#include "AppTask.h"
#include "DishwasherManager.h"
#include "ElectricalEnergyMeasurementInstance.h"
#include "ElectricalPowerMeasurementDelegate.h"
#include "ElectricalSensorManager.h"
#include "PowerTopologyDelegate.h"

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::ElectricalEnergyMeasurement;
using namespace chip::app::Clusters::ElectricalPowerMeasurement;
using namespace chip::app::Clusters::OperationalState;
using namespace chip::app::Clusters::PowerTopology;
using namespace chip::app::DataModel;

ElectricalSensorManager ElectricalSensorManager::sElectricalSensor;

static std::unique_ptr<ElectricalEnergyMeasurementInstance> gEEMInstance;
static std::unique_ptr<ElectricalPowerMeasurementDelegate> gEPMDelegate;
static std::unique_ptr<ElectricalPowerMeasurementInstance> gEPMInstance;
static std::unique_ptr<PowerTopologyDelegate> gPTDelegate;
static std::unique_ptr<PowerTopologyInstance> gPTInstance;

/*
 *  @brief  Creates a Delegate and Instance for Electrical Power/Energy Measurement and Power Topology clusters
 *
 * The Instance is a container around the Delegate, so
 * create the Delegate first, then wrap it in the Instance
 * Then call the Instance->Init() to register the attribute and command handlers
 */
CHIP_ERROR ElectricalSensorManager::Init()
{
    EndpointId EPMEndpointId = GetEndpointIdFromCluster(ElectricalPowerMeasurement::Id);
    EndpointId EEMEndpointId = GetEndpointIdFromCluster(ElectricalEnergyMeasurement::Id);
    EndpointId PTEndpointId = GetEndpointIdFromCluster(PowerTopology::Id);
    CHIP_ERROR err;
  
    VerifyOrReturnError((EPMEndpointId != kInvalidEndpointId) && (EEMEndpointId != kInvalidEndpointId) && (PTEndpointId != kInvalidEndpointId),
                        CHIP_ERROR_INCORRECT_STATE, ChipLogError(AppServer, "EPM, EEM or PT Cluster not configured"));
 
    // Initialize EPM (Electrical Power Management)
    VerifyOrReturnError(!gEPMDelegate && !gEPMInstance, CHIP_ERROR_INCORRECT_STATE, 
                        ChipLogError(AppServer, "EPM Delegate or Instance already exist"));

    gEPMDelegate = std::make_unique<ElectricalPowerMeasurementDelegate>();
    VerifyOrReturnError(gEPMDelegate, CHIP_ERROR_NO_MEMORY, ChipLogError(AppServer, "Failed to allocate memory for EPM Delegate"));

    /* Manufacturer may optionally not support all features, commands & attributes */
    /* Turning on all optional features and attributes for test certification purposes */
    gEPMInstance = std::make_unique<ElectricalPowerMeasurementInstance>(
        EPMEndpointId, *gEPMDelegate,
        BitMask<ElectricalPowerMeasurement::Feature, uint32_t>(
                ElectricalPowerMeasurement::Feature::kDirectCurrent, 
                ElectricalPowerMeasurement::Feature::kAlternatingCurrent,
                ElectricalPowerMeasurement::Feature::kPolyphasePower, 
                ElectricalPowerMeasurement::Feature::kHarmonics,
                ElectricalPowerMeasurement::Feature::kPowerQuality),
        BitMask<ElectricalPowerMeasurement::OptionalAttributes, uint32_t>(
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeRanges,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeVoltage,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeActiveCurrent,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeReactiveCurrent,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeApparentCurrent,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeReactivePower,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeApparentPower,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeRMSVoltage,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeRMSCurrent,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeRMSPower,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeFrequency,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributePowerFactor,
                ElectricalPowerMeasurement::OptionalAttributes::kOptionalAttributeNeutralCurrent));

    VerifyOrReturnError(gEPMInstance, CHIP_ERROR_NO_MEMORY, 
                        ChipLogError(AppServer, "Failed to allocate memory for EPM Instance"); gEPMDelegate.reset());

    // Register Attribute & Command handlers 
    err = gEPMInstance->Init();
    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(AppServer, "Init failed on gEPMInstance"); 
                        gEPMInstance.reset();  gEPMDelegate.reset());
                        
    // Initialize EPM attributes 
    // DishwasherMgr().Init() must be initialized before ElectricalSensorMgr().Init()
    // inside Apptask::Init()
    OperationalStateEnum state = DishwasherMgr().GetOperationalState();
    UpdateEPMAllAttributes(state);

    // Initialize EEM (Electrical Energy Management)
    VerifyOrReturnError(!gEEMInstance, CHIP_ERROR_INCORRECT_STATE, ChipLogError(AppServer, "EEM Instance already exist"));

    gEEMInstance = std::make_unique<ElectricalEnergyMeasurementInstance>(
        EEMEndpointId, *gEPMDelegate,
        BitMask<ElectricalEnergyMeasurement::Feature, uint32_t>(
                ElectricalEnergyMeasurement::Feature::kImportedEnergy, 
                ElectricalEnergyMeasurement::Feature::kCumulativeEnergy),
        BitMask<ElectricalEnergyMeasurement::OptionalAttributes, uint32_t>(
                ElectricalEnergyMeasurement::OptionalAttributes::kOptionalAttributeCumulativeEnergyReset));
    
    VerifyOrReturnError(gEEMInstance, CHIP_ERROR_NO_MEMORY, ChipLogError(AppServer, "Failed to allocate memory for EEM Instance"));

    // Register Attribute & Command handlers 
    err = gEEMInstance->Init();
    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(AppServer, "Init failed on gEEMInstance"); gPTInstance.reset());

    // Initialize PT (Power Topology)
    VerifyOrReturnError(!gPTDelegate && !gPTInstance, CHIP_ERROR_INCORRECT_STATE, 
                        ChipLogError(AppServer, "PowerTopology Delegate or Instance already exist"));

    gPTDelegate = std::make_unique<PowerTopologyDelegate>();
    VerifyOrReturnError(gPTDelegate, CHIP_ERROR_NO_MEMORY, ChipLogError(AppServer, "Failed to allocate memory for PT Delegate"));

    gPTInstance = std::make_unique<PowerTopologyInstance>(
        PTEndpointId, *gPTDelegate,
        BitMask<PowerTopology::Feature, uint32_t>(
                PowerTopology::Feature::kSetTopology, 
                PowerTopology::Feature::kDynamicPowerFlow),
        BitMask<PowerTopology::OptionalAttributes, uint32_t>(
                PowerTopology::OptionalAttributes::kOptionalAttributeAvailableEndpoints,
                PowerTopology::OptionalAttributes::kOptionalAttributeActiveEndpoints));

    VerifyOrReturnError(gPTInstance, CHIP_ERROR_NO_MEMORY, ChipLogError(AppServer, "Failed to allocate memory for PT Instance");
                        gPTDelegate.reset());

    // Register Attribute & Command handlers 
    err = gPTInstance->Init(); 
    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(AppServer, "Init failed on gPTInstance");
                        gPTInstance.reset(); gPTDelegate.reset(););

    return CHIP_NO_ERROR;
}

void ElectricalSensorManager::Shutdown()
{
    /* Do this in the order Instance first, then delegate
     * Ensure we call the Instance->Shutdown to free attribute & command handlers first
     */
    
    // Shutdown PT (Power Topology)
    if (gPTInstance)
    {
        // Deregister attribute & command handlers
        gPTInstance->Shutdown();
        gPTInstance.reset();
    }

    if (gPTDelegate)
    {
        gPTDelegate.reset();
    }

    // Shutdown EEM (Electrical Energy Management)
    if (gEEMInstance)
    {
        // Deregister attribute & command handlers
        gEEMInstance->Shutdown();
        gEEMInstance.reset();
    }

    // Shutdown EPM (Electrical Power Management)
    if (gEPMInstance)
    {
        // Deregister attribute & command handlers
        gEPMInstance->Shutdown();
        gEPMInstance.reset();
    }

    if (gEPMDelegate)
    {
        gEPMDelegate.reset();
    }
}

void ElectricalSensorManager::UpdateEPMAllAttributes(OperationalStateEnum state)
{
    // Update only when EPM instance and EPM delegate are allocated
    if (gEPMInstance && gEPMDelegate)
    {
        gEPMInstance->GetDelegate()->UpdateAllAttributes(to_underlying(state));
    }
}

EndpointId ElectricalSensorManager::GetEndpointIdFromCluster(ClusterId clusterId)
{
    EndpointId endpointIdFromCluster = kInvalidEndpointId;

    for (uint16_t index = 0; index < emberAfEndpointCount(); index++)
    {
        if (!emberAfEndpointIndexIsEnabled(index))
        {
            continue;
        }
        
        EndpointId endpointId = emberAfEndpointFromIndex(index);
        
        if (emberAfContainsServer(endpointId, clusterId))   
        {
            endpointIdFromCluster = endpointId;
            break;
        }      
    }

    return endpointIdFromCluster;
}