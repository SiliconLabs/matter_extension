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
#include <app-common/zap-generated/attribute-type.h>
#include <app/ConcreteAttributePath.h>
#include <app/util/attribute-storage.h>
#include <app/util/generic-callbacks.h>

#include "OperationalStateDelegate.h"

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::OperationalState;

static std::unique_ptr<OperationalStateDelegate> gOperationalStateDelegate;
static std::unique_ptr<OperationalState::Instance> gOperationalStateInstance;

CHIP_ERROR OperationalStateDelegate::GetOperationalStateAtIndex(size_t index, GenericOperationalState & operationalState)
{
    VerifyOrReturnError(index < mOperationalStateList.size(), CHIP_ERROR_NOT_FOUND);
    
    operationalState = mOperationalStateList[index];
    
    return CHIP_NO_ERROR;
}

CHIP_ERROR OperationalStateDelegate::GetOperationalPhaseAtIndex(size_t index, MutableCharSpan & operationalPhase)
{
    VerifyOrReturnError(index < mOperationalPhaseList.size(), CHIP_ERROR_NOT_FOUND);

    return CopyCharSpanToMutableCharSpan(mOperationalPhaseList[index], operationalPhase);
}

void OperationalStateDelegate::HandlePauseStateCallback(GenericOperationalError & err)
{
    auto error = GetInstance()->SetOperationalState(to_underlying(OperationalState::OperationalStateEnum::kPaused));
    if (error == CHIP_NO_ERROR)
    {
        err.Set(to_underlying(ErrorStateEnum::kNoError));
        uint8_t value = to_underlying(OperationalStateEnum::kPaused);
        PostAttributeChangeCallback(Attributes::OperationalState::Id, ZCL_INT8U_ATTRIBUTE_TYPE, sizeof(uint8_t), &value);
    }
    else
    {
        err.Set(to_underlying(ErrorStateEnum::kUnableToCompleteOperation));
    }
}

void OperationalStateDelegate::HandleResumeStateCallback(GenericOperationalError & err)
{
    auto error = GetInstance()->SetOperationalState(to_underlying(OperationalStateEnum::kRunning));
    if (error == CHIP_NO_ERROR)
    {
        err.Set(to_underlying(ErrorStateEnum::kNoError));
        uint8_t value = to_underlying(OperationalStateEnum::kRunning);
        PostAttributeChangeCallback(Attributes::OperationalState::Id, ZCL_INT8U_ATTRIBUTE_TYPE, sizeof(uint8_t), &value);
    }
    else
    {
        err.Set(to_underlying(ErrorStateEnum::kUnableToCompleteOperation));
    }
}

void OperationalStateDelegate::HandleStartStateCallback(GenericOperationalError & err)
{
    auto error = GetInstance()->SetOperationalState(to_underlying(OperationalStateEnum::kRunning));
    if (error == CHIP_NO_ERROR)
    {
        err.Set(to_underlying(ErrorStateEnum::kNoError));
        uint8_t value = to_underlying(OperationalStateEnum::kRunning);
        PostAttributeChangeCallback(Attributes::OperationalState::Id, ZCL_INT8U_ATTRIBUTE_TYPE, sizeof(uint8_t), &value);
    }
    else
    {
        err.Set(to_underlying(ErrorStateEnum::kUnableToCompleteOperation));
    }
}

void OperationalStateDelegate::HandleStopStateCallback(GenericOperationalError & err)
{
    auto error = GetInstance()->SetOperationalState(to_underlying(OperationalStateEnum::kStopped));
    if (error == CHIP_NO_ERROR)
    {
        err.Set(to_underlying(ErrorStateEnum::kNoError));
        uint8_t value = to_underlying(OperationalStateEnum::kStopped);
        PostAttributeChangeCallback(Attributes::OperationalState::Id, ZCL_INT8U_ATTRIBUTE_TYPE, sizeof(uint8_t), &value);
    }
    else
    {
        err.Set(to_underlying(ErrorStateEnum::kUnableToCompleteOperation));
    }
}

void OperationalStateDelegate::PostAttributeChangeCallback(AttributeId attributeId, uint8_t type, uint16_t size, uint8_t * value)
{
    chip::app::ConcreteAttributePath  info;
    info.mClusterId   = Clusters::OperationalState::Id;
    info.mAttributeId = attributeId;
    info.mEndpointId  = mEndpointId;
    MatterPostAttributeChangeCallback(info, type, size, value);
}

OperationalState::Instance* OperationalState::GetInstance()
{
    return gOperationalStateInstance.get();
}

OperationalState::OperationalStateDelegate* OperationalState::GetDelegate()
{
    return gOperationalStateDelegate.get();
}

EndpointId OperationalState::GetOperationalStateEndpointId()
{
    EndpointId OperationalStateEndpointId = kInvalidEndpointId;

    for (uint16_t index = 0; index < emberAfEndpointCount(); index++)
    {
        if (!emberAfEndpointIndexIsEnabled(index))
        {
            continue;
        }
        
        EndpointId endpointId = emberAfEndpointFromIndex(index);
        
        if (emberAfContainsServer(endpointId, OperationalState::Id))   
        {
            OperationalStateEndpointId = endpointId;
            break;
        }      
    }

    return OperationalStateEndpointId;
}

void emberAfOperationalStateClusterInitCallback(chip::EndpointId endpointId)
{
    VerifyOrDie(gOperationalStateInstance == nullptr && gOperationalStateDelegate == nullptr);

    EndpointId OperationalStateEndpointId = GetOperationalStateEndpointId();

    VerifyOrDie(OperationalStateEndpointId !=  kInvalidEndpointId);

    gOperationalStateDelegate = std::make_unique<OperationalStateDelegate>();
    gOperationalStateInstance = std::make_unique<OperationalState::Instance>(gOperationalStateDelegate.get(), OperationalStateEndpointId);

    gOperationalStateInstance->SetOperationalState(to_underlying(OperationalStateEnum::kStopped));
    gOperationalStateInstance->Init();
    
    gOperationalStateDelegate->mEndpointId = endpointId;
    uint8_t value = to_underlying(OperationalStateEnum::kStopped);
    gOperationalStateDelegate->PostAttributeChangeCallback(Attributes::OperationalState::Id, ZCL_INT8U_ATTRIBUTE_TYPE, sizeof(uint8_t), &value);
}

void OperationalState::Shutdown()
{
    if (gOperationalStateDelegate)
    {
        gOperationalStateDelegate.reset();
    }

    if (gOperationalStateInstance)
    {
        gOperationalStateInstance.reset();
    }
}
