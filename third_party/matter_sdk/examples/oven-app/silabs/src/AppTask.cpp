/*
 *
 *    Copyright (c) 2025 Project CHIP Authors
 *    Copyright (c) 2025 Google LLC.
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

#include "AppTask.h"
#include "AppConfig.h"
#include "AppEvent.h"
#include "CustomerAppTask.h"
#include "LEDWidget.h"

#ifdef DISPLAY_ENABLED
#include "OvenUI.h"
#include "lcd.h"
#ifdef QR_CODE_ENABLED
#include "qrcodegen.h"
#endif // QR_CODE_ENABLED
#endif // DISPLAY_ENABLED

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/cluster-enums.h>
#include <app-common/zap-generated/cluster-objects.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/CASESessionManager.h>
#include <app/ConcreteAttributePath.h>
#include <app/ConcreteCommandPath.h>
#include <app/InteractionModelEngine.h>
#include <app/clusters/bindings/BindingManager.h>
#include <app/data-model-provider/AttributeChangeListener.h>
#include <app/clusters/mode-base-server/mode-base-cluster-objects.h>
#include <app/clusters/network-commissioning/network-commissioning.h>
#include <app/clusters/on-off-server/on-off-server.h>
#include <app/clusters/temperature-control-server/CodegenIntegration.h>
#include <app/clusters/temperature-measurement-server/CodegenIntegration.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>
#include <app/util/endpoint-config-api.h>
#include <app/util/generic-callbacks.h>
#include <assert.h>
#include <controller/InvokeInteraction.h>
#include <controller/WriteInteraction.h>
#include <lib/support/BitMask.h>
#include <lib/support/CodeUtils.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <setup_payload/OnboardingCodesUtil.h>
#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#ifdef SL_CATALOG_SIMPLE_LED_LED1_PRESENT
#define LIGHT_LED 1
#else
#define LIGHT_LED 0
#endif

#define APP_FUNCTION_BUTTON 0
#define APP_ACTION_BUTTON 1

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace ::chip::DeviceLayer;
using namespace ::chip::DeviceLayer::Silabs;
using namespace ::chip::DeviceLayer::Internal;
using namespace chip::TLV;
using chip::Protocols::InteractionModel::Status;

LEDWidget sLightLED; // Use LEDWidget for basic LED functionality

namespace {
bool sDnssdReady = false;

CustomerAppTask & AppInstance()
{
    return CustomerAppTask::GetAppTask();
}

// Drop cached CASE sessions to bound peers so BindingManager re-handshakes after every binding action.
void ReleaseBoundPeerSessions(EndpointId localEndpoint)
{
    auto & sessionManager                   = Server::GetInstance().GetSecureSessionManager();
    CASESessionManager * caseSessionManager = Server::GetInstance().GetCASESessionManager();

    for (const Binding::TableEntry & entry : Binding::Manager::GetInstance().GetBindingTable())
    {
        if (entry.local == localEndpoint && entry.type == Binding::MATTER_UNICAST_BINDING)
        {
            const ScopedNodeId peerId(entry.nodeId, entry.fabricIndex);
            sessionManager.ExpireAllSessions(peerId);
            if (caseSessionManager != nullptr)
            {
                caseSessionManager->ReleaseSession(peerId);
            }
        }
    }
}

void ContextReleaseHandler(void * context)
{
    if (context)
    {
        Platform::Delete(static_cast<CookTopBindingContext *>(context));
    }
}
} // namespace

CHIP_ERROR AppTask::AppInit()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(&CustomerAppTask::ButtonEventHandler);

#ifdef DISPLAY_ENABLED
    SuccessOrLog(GetLCD().Init((uint8_t *) "Oven-App"), AppServer, "Failed to initialize LCD");
    GetLCD().SetCustomUI(OvenUI::DrawUI);
#endif
    DeviceLayer::PlatformMgr().LockChipStack();
    err = AppInstance().InitOven();
    DeviceLayer::PlatformMgr().UnlockChipStack();
    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(AppServer, "InitOven failed"));

    ReturnErrorOnFailure(PlatformMgr().AddEventHandler(&CustomerAppTask::ConnectivityEventHandler, 0));

    sLightLED.Init(LIGHT_LED);
    sLightLED.Set(AppInstance().GetCookTopState());

// Update the LCD with the Stored value. Show QR Code if not provisioned
#ifdef DISPLAY_ENABLED
    GetLCD().WriteDemoUI(false);
#ifdef QR_CODE_ENABLED
    if (!BaseApplication::GetProvisionStatus())
    {
        GetLCD().ShowQRCode(true);
    }
#endif // QR_CODE_ENABLED
#endif

    return err;
}

CHIP_ERROR AppTask::InitOven()
{
    DataModel::Provider * provider = InteractionModelEngine::GetInstance()->GetDataModelProvider();
    VerifyOrReturnError(provider != nullptr, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "DataModel provider not available"));
    if (!mAttributeListenerRegistered)
    {
        provider->RegisterAttributeChangeListener(*this);
        mAttributeListenerRegistered = true;
    }

    ReturnErrorOnFailure(mTemperatureControlledCabinetEndpoint.Init());

    // AppTask is the shared TemperatureLevelsDelegate for all the cooksurface endpoints
    TemperatureControl::SetDelegate(this);

    ReturnErrorOnFailure(SetTemperatureControlledCabinetInitialState(kTemperatureControlledCabinetEndpoint));
    ReturnErrorOnFailure(SetCookSurfaceInitialState(mCookSurfaceEndpoint1.GetEndpointId()));
    ReturnErrorOnFailure(SetCookSurfaceInitialState(mCookSurfaceEndpoint2.GetEndpointId()));

    ReturnErrorOnFailure(DeviceLayer::PlatformMgr().ScheduleWork(&CustomerAppTask::InitBindingHandler, 0));

    // Cooktop is a cooking appliance. Setting the state to false after reboot to avoid fire/safety hazards.
    EnforceCookTopOffAtStartup();

    static const CharSpan kCookSurfaceLevels[] = { CharSpan::fromCharString("Low"), CharSpan::fromCharString("Medium"),
                                                   CharSpan::fromCharString("High") };
    ReturnErrorOnFailure(RegisterSupportedLevels(kCookSurfaceEndpoint1, kCookSurfaceLevels,
                                                 static_cast<uint8_t>(kNumTemperatureLevels)));
    ReturnErrorOnFailure(RegisterSupportedLevels(kCookSurfaceEndpoint2, kCookSurfaceLevels,
                                                 static_cast<uint8_t>(kNumTemperatureLevels)));

    VerifyOrReturnError(OnOffServer::Instance().getOnOffValue(kCookTopEndpoint, &mIsCookTopOn) == Status::Success,
                        CHIP_ERROR_INTERNAL, ChipLogError(AppServer, "Getting CookTop OnOff state failed"));
    VerifyOrReturnError(OnOffServer::Instance().getOnOffValue(kCookSurfaceEndpoint1, &mIsCookSurface1On) == Status::Success,
                        CHIP_ERROR_INTERNAL, ChipLogError(AppServer, "Getting CookSurfaceEndpoint1 OnOff state failed"));
    VerifyOrReturnError(OnOffServer::Instance().getOnOffValue(kCookSurfaceEndpoint2, &mIsCookSurface2On) == Status::Success,
                        CHIP_ERROR_INTERNAL, ChipLogError(AppServer, "Getting CookSurfaceEndpoint2 OnOff state failed"));

    mCurrentOvenMode = mTemperatureControlledCabinetEndpoint.GetOvenModeInstance().GetCurrentMode();

    return CHIP_NO_ERROR;
}

CHIP_ERROR AppTask::SetCookSurfaceInitialState(EndpointId cookSurfaceEndpoint)
{
    TemperatureMeasurementCluster * temperatureMeasurementCluster =
        TemperatureMeasurement::FindClusterOnEndpoint(cookSurfaceEndpoint);
    VerifyOrReturnError(temperatureMeasurementCluster != nullptr, CHIP_ERROR_INTERNAL);

    auto * temperatureControlCluster = TemperatureControl::FindClusterOnEndpoint(kTemperatureControlledCabinetEndpoint);
    VerifyOrReturnError(temperatureControlCluster != nullptr, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "TemperatureControl cluster not found on endpoint"));

    DataModel::Nullable<int16_t> minMeasuredValue(temperatureControlCluster->GetMinTemperature());
    DataModel::Nullable<int16_t> maxMeasuredValue(temperatureControlCluster->GetMaxTemperature());

    ReturnErrorOnFailure(temperatureMeasurementCluster->SetMeasuredValue(minMeasuredValue));
    return temperatureMeasurementCluster->SetMeasuredValueRange(minMeasuredValue, maxMeasuredValue);
}

CHIP_ERROR AppTask::SetTemperatureControlledCabinetInitialState(EndpointId temperatureControlledCabinetEndpoint)
{
    auto * cluster = TemperatureControl::FindClusterOnEndpoint(temperatureControlledCabinetEndpoint);
    VerifyOrReturnError(cluster != nullptr, CHIP_ERROR_INTERNAL,
                        ChipLogError(AppServer, "TemperatureControl cluster not found on endpoint"));

    return cluster->SetTemperatureSetpoint(cluster->GetMinTemperature());
}

void AppTask::EnforceCookTopOffAtStartup()
{
    for (EndpointId ep : { kCookTopEndpoint, kCookSurfaceEndpoint1, kCookSurfaceEndpoint2 })
    {
        Status status = OnOffServer::Instance().setOnOffValue(ep, OnOff::Commands::Off::Id, /*initiatedByLevelChange=*/false);
        if (status != Status::Success)
        {
            ChipLogError(AppServer, "EnforceCookTopOffAtStartup: setOnOffValue(ep=%u) failed: %u", ep, to_underlying(status));
        }
    }
}

void AppTask::OnOffAttributeChangeHandler(EndpointId endpointId, AttributeId attributeId, uint8_t * value, uint16_t size)
{
    VerifyOrReturn(value != nullptr, ChipLogError(AppServer, "OnOffAttributeChangeHandler: value pointer is null"));

    Action_t action = INVALID_ACTION;
    switch (endpointId)
    {
    case kCookTopEndpoint: {
        mIsCookTopOn = (*value != 0);
        VerifyOrReturn(mCookSurfaceEndpoint1.SetOnOffState(*value) == Status::Success,
                       ChipLogError(AppServer, "Failed to set CookSurfaceEndpoint1 state"));
        VerifyOrReturn(mCookSurfaceEndpoint2.SetOnOffState(*value) == Status::Success,
                       ChipLogError(AppServer, "Failed to set CookSurfaceEndpoint2 state"));

        action = (*value != 0) ? COOK_TOP_ON_ACTION : COOK_TOP_OFF_ACTION;

        CustomerAppTask::CookTopBindingPropagateState(kCookTopEndpoint, *value != 0);
        break;
    }
    case kCookSurfaceEndpoint1:
    case kCookSurfaceEndpoint2:
        if (endpointId == kCookSurfaceEndpoint1)
        {
            mIsCookSurface1On = (*value != 0);
        }
        else
        {
            mIsCookSurface2On = (*value != 0);
        }

        if (!mIsCookSurface1On && !mIsCookSurface2On)
        {
            VerifyOrReturn(mCookTopEndpoint.SetOnOffState(false) == Status::Success,
                           ChipLogError(AppServer, "Failed to set CookTopEndpoint state"));

            mIsCookTopOn = false;
        }
        break;
    default:
        break;
    }

    if (action != INVALID_ACTION)
    {
        AppEvent event         = {};
        event.Type             = AppEvent::kEventType_Oven;
        event.OvenEvent.Action = action;
        event.Handler          = &CustomerAppTask::OvenActionHandler;
        AppTask::GetAppTask().PostEvent(&event);
    }
}

void AppTask::OnAttributeChanged(const ConcreteAttributePath & path, DataModel::AttributeChangeType)
{
    VerifyOrReturn(path.mEndpointId == kTemperatureControlledCabinetEndpoint,
                   ChipLogError(AppServer, "OnAttributeChanged: path.mEndpointId is invalid"));
    VerifyOrReturn(path.mClusterId == OvenMode::Id, ChipLogError(AppServer, "OnAttributeChanged: path.mClusterId is invalid"));
    VerifyOrReturn(path.mAttributeId == OvenMode::Attributes::CurrentMode::Id,
                   ChipLogError(AppServer, "OnAttributeChanged: path.mAttributeId is invalid"));

    HandleOvenModeChanged(mTemperatureControlledCabinetEndpoint.GetOvenModeInstance().GetCurrentMode());
}

void AppTask::HandleOvenModeChanged(uint8_t newMode)
{
    VerifyOrReturn(mCurrentOvenMode != newMode, ChipLogProgress(AppServer, "AppTask: newMode is the same as current mode"));

    mCurrentOvenMode       = newMode;
    AppEvent event         = {};
    event.Type             = AppEvent::kEventType_Oven;
    event.OvenEvent.Action = OVEN_MODE_UPDATE_ACTION;
    event.Handler          = &CustomerAppTask::OvenActionHandler;
    AppTask::GetAppTask().PostEvent(&event);
}

void AppTask::DMOvenModeClusterInitCallback(EndpointId) {}

void AppTask::DMOvenModeClusterShutdownCallback(EndpointId, MatterClusterShutdownType) {}

bool AppTask::IsTransitionBlocked(uint8_t fromMode, uint8_t toMode)
{
    for (auto const & bt : kBlockedTransitions)
    {
        if (bt.fromMode == fromMode && bt.toMode == toMode)
        {
            return true;
        }
    }
    return false;
}

CHIP_ERROR AppTask::RegisterSupportedLevels(EndpointId endpoint, const CharSpan * levels, uint8_t levelCount)
{
    VerifyOrReturnError(levels != nullptr && levelCount > 0, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(AppServer, "RegisterSupportedLevels: invalid levels/null or count=0"));

    VerifyOrReturnError(mRegisteredEndpointCount < kNumCookSurfaceEndpoints, CHIP_ERROR_NO_MEMORY,
                        ChipLogError(AppServer, "RegisterSupportedLevels: capacity exceeded (%u)",
                                     static_cast<unsigned>(mRegisteredEndpointCount)));
    for (size_t i = 0; i < mRegisteredEndpointCount; ++i)
    {
        VerifyOrReturnError(supportedOptionsByEndpoints[i].mEndpointId != endpoint, CHIP_ERROR_ENDPOINT_EXISTS,
                            ChipLogError(AppServer, "RegisterSupportedLevels: duplicate endpoint %u", endpoint));
    }

    supportedOptionsByEndpoints[mRegisteredEndpointCount++] = EndpointPair(endpoint, levels, levelCount);
    ChipLogProgress(AppServer, "Registered %u levels for endpoint %u", static_cast<unsigned>(levelCount), endpoint);
    return CHIP_NO_ERROR;
}

uint8_t AppTask::Size()
{
    for (size_t i = 0; i < mRegisteredEndpointCount; ++i)
    {
        const EndpointPair & endpointPair = supportedOptionsByEndpoints[i];
        if (endpointPair.mEndpointId == mEndpoint)
        {
            ChipLogProgress(AppServer, "Found endpoint %d with size %d", mEndpoint, endpointPair.mSize);
            return endpointPair.mSize;
        }
    }
    ChipLogError(AppServer, "No matching endpoint found for %d in Size()", mEndpoint);
    return 0;
}

CHIP_ERROR AppTask::Next(MutableCharSpan & item)
{
    for (size_t i = 0; i < mRegisteredEndpointCount; ++i)
    {
        const EndpointPair & endpointPair = supportedOptionsByEndpoints[i];
        if (endpointPair.mEndpointId == mEndpoint)
        {
            if (mIndex < endpointPair.mSize)
            {
                CHIP_ERROR err = CopyCharSpanToMutableCharSpan(endpointPair.mTemperatureLevels[mIndex], item);
                if (err == CHIP_NO_ERROR)
                {
                    mIndex++;
                }
                return err;
            }
            return CHIP_ERROR_PROVIDER_LIST_EXHAUSTED;
        }
    }
    ChipLogProgress(AppServer, "No matching endpoint found for %d in Next()", mEndpoint);
    return CHIP_ERROR_PROVIDER_LIST_EXHAUSTED;
}

void AppTask::ConnectivityEventHandler(const ChipDeviceEvent * event, intptr_t)
{
    VerifyOrReturn(event != nullptr);

    switch (event->Type)
    {
    case DeviceEventType::kDnssdInitialized:
        if (sDnssdReady)
        {
            return;
        }
        sDnssdReady = true;
        CustomerAppTask::CookTopBindingPropagateState(GetCookTopEndpoint(), false);
        break;
    default:
        break;
    }
}

CHIP_ERROR AppTask::StartAppTask()
{
    return BaseApplication::StartAppTask(AppTaskMain);
}

void AppTask::AppTaskMain(void * pvParameter)
{
    AppEvent event;
    osMessageQueueId_t sAppEventQueue = *(static_cast<osMessageQueueId_t *>(pvParameter));

    CHIP_ERROR err = AppInstance().Init();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "AppTask.Init() failed");
        appError(err);
    }

    AppInstance().StartStatusLEDTimer();

    ChipLogProgress(AppServer, "App Task started");

    while (true)
    {
        osStatus_t eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, osWaitForever);
        while (eventReceived == osOK)
        {
            AppInstance().DispatchEvent(&event);
            eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, 0);
        }
    }
}

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    // Handle button1 specifically for oven functionality
    if (button == APP_ACTION_BUTTON)
    {
        button_event.Handler = &CustomerAppTask::OvenButtonHandler;
    }
    else
    {
        button_event.Handler = BaseApplication::ButtonHandler;
    }

    AppInstance().PostEvent(&button_event);
}

void AppTask::OvenButtonHandler(AppEvent * aEvent)
{
    // Handle button press to toggle cooktop and cook surface
    if (aEvent->ButtonEvent.Action == static_cast<uint8_t>(SilabsPlatform::ButtonAction::ButtonPressed))
    {
        ChipLogDetail(AppServer, "Oven button pressed - starting toggle action");

        // Determine new state (toggle current state)
        bool newOnOffState = !AppInstance().GetCookTopState();

        // Schedule work to set the OnOff attribute.
        SuccessOrLog(chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, static_cast<intptr_t>(newOnOffState)),
                     AppServer, "Failed to schedule work UpdateClusterState");
    }
}

void AppTask::UpdateClusterState(intptr_t context)
{
    bool newOnOffState = static_cast<bool>(context);

    ChipLogDetail(AppServer, "Updating cooktop OnOff cluster state to %s", newOnOffState ? "On" : "Off");

    // Set the OnOff attribute value for the cooktop endpoint
    DeviceLayer::PlatformMgr().LockChipStack();
    Protocols::InteractionModel::Status status = OnOffServer::Instance().setOnOffValue(GetCookTopEndpoint(), newOnOffState, false);
    DeviceLayer::PlatformMgr().UnlockChipStack();

    if (status != Protocols::InteractionModel::Status::Success)
    {
        ChipLogError(AppServer, "Failed to update cooktop OnOff cluster state: %x", to_underlying(status));
    }
}

void AppTask::OvenActionHandler(AppEvent * aEvent)
{
    // Emulate hardware Action : Update the LEDs and LCD of oven-app as required.
    switch (aEvent->OvenEvent.Action)
    {
    case COOK_TOP_ON_ACTION:
    case COOK_TOP_OFF_ACTION: {
        sLightLED.Set(AppInstance().GetCookTopState());
#ifdef DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // DISPLAY_ENABLED
        break;
    }
    case OVEN_MODE_UPDATE_ACTION:
#ifdef DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // DISPLAY_ENABLED
        break;
    default:
        break;
    }
}

void AppTask::BoundDeviceChangedHandler(const Binding::TableEntry & binding, OperationalDeviceProxy * peerDevice, void * context)
{
    VerifyOrReturn(context != nullptr);
    auto * data = static_cast<CookTopBindingContext *>(context);

    // Group bindings are not used by the CookTop/RangeHood pairing.
    VerifyOrReturn(binding.type == Binding::MATTER_UNICAST_BINDING);
    VerifyOrReturn(peerDevice != nullptr && peerDevice->ConnectionReady());

    switch (data->clusterId)
    {
    case OnOff::Id:
        AppTask::ProcessOnOffUnicast(data->cookTopOn, binding, peerDevice->GetExchangeManager(),
                                     peerDevice->GetSecureSession().Value());
        break;
    case FanControl::Id:
        AppTask::ProcessFanControlUnicast(data->cookTopOn, binding, peerDevice->GetSecureSession().Value());
        break;
    default:
        break;
    }
}

void AppTask::ProcessOnOffUnicast(bool cookTopOn, const Binding::TableEntry & binding, Messaging::ExchangeManager * exchangeMgr,
                                 const SessionHandle & sessionHandle)
{
    auto onSuccess = [](const ConcreteCommandPath &, const StatusIB &, const auto &) {
        ChipLogDetail(AppServer, "CookTop OnOff bound unicast command success");
    };
    auto onFailure = [](CHIP_ERROR error) {
        ChipLogError(AppServer, "CookTop OnOff bound unicast failed: %s", error.AsString());
    };

    if (cookTopOn)
    {
        OnOff::Commands::On::Type cmd;
        SuccessOrLog(Controller::InvokeCommandRequest(exchangeMgr, sessionHandle, binding.remote, cmd, onSuccess, onFailure),
                     AppServer, "Failed to invoke On command");
    }
    else
    {
        OnOff::Commands::Off::Type cmd;
        SuccessOrLog(Controller::InvokeCommandRequest(exchangeMgr, sessionHandle, binding.remote, cmd, onSuccess, onFailure),
                     AppServer, "Failed to invoke Off command");
    }
}

void AppTask::ProcessFanControlUnicast(bool cookTopOn, const Binding::TableEntry & binding, const SessionHandle & sessionHandle)
{
    auto onSuccess = [](const ConcreteAttributePath &) {
        ChipLogDetail(AppServer, "CookTop FanControl FanMode bound write success");
    };
    auto onFailure = [](const ConcreteAttributePath *, CHIP_ERROR error) {
        ChipLogError(AppServer, "CookTop FanControl FanMode bound write failed: %s", error.AsString());
    };

    FanControl::FanModeEnum fanMode = cookTopOn ? FanControl::FanModeEnum::kOn : FanControl::FanModeEnum::kOff;

    SuccessOrLog(Controller::WriteAttribute<FanControl::Attributes::FanMode::TypeInfo>(sessionHandle, binding.remote, fanMode,
                                                                                       onSuccess, onFailure),
                 AppServer, "Failed to write FanMode attribute");
}

void AppTask::InitBindingHandler(intptr_t)
{
    auto & server = Server::GetInstance();
    VerifyOrDieWithMsg(CHIP_NO_ERROR ==
                           Binding::Manager::GetInstance().Init(
                               { &server.GetFabricTable(), server.GetCASESessionManager(), &server.GetPersistentStorage() }),
                       AppServer, "Failed to initialize binding manager");
    Binding::Manager::GetInstance().RegisterBoundDeviceChangedHandler(&CustomerAppTask::BoundDeviceChangedHandler);
    Binding::Manager::GetInstance().RegisterBoundDeviceContextReleaseHandler(&ContextReleaseHandler);
    ChipLogDetail(AppServer, "Oven binding manager initialized");
}

void AppTask::CookTopBindingPropagateState(EndpointId cookTopEndpoint, bool cookTopOn)
{
    // Drop cached CASE sessions to bound peers as there is a chance that the peer has rebooted.
    // The old session may be stale and we need to re-handshake.
    ReleaseBoundPeerSessions(cookTopEndpoint);

    for (ClusterId clusterId : { OnOff::Id, FanControl::Id })
    {
        CookTopBindingContext * context = Platform::New<CookTopBindingContext>();
        if (context == nullptr)
        {
            ChipLogError(AppServer, "Failed to allocate CookTopBindingContext for cluster " ChipLogFormatMEI,
                         ChipLogValueMEI(clusterId));
            continue;
        }
        context->localEndpointId = cookTopEndpoint;
        context->clusterId       = clusterId;
        context->cookTopOn       = cookTopOn;

        CHIP_ERROR err = Binding::Manager::GetInstance().NotifyBoundClusterChanged(context->localEndpointId, context->clusterId,
                                                                                   context);
        if (err != CHIP_NO_ERROR)
        {
            Platform::Delete(context);
            ChipLogError(AppServer, "Failed to schedule binding work for cluster " ChipLogFormatMEI ", context freed",
                         ChipLogValueMEI(clusterId));
        }
    }
}

void AppTask::DMPostAttributeChangeCallback(const ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                            uint8_t * value)
{
    ClusterId clusterId     = attributePath.mClusterId;
    AttributeId attributeId = attributePath.mAttributeId;
    switch (clusterId)
    {
    case Clusters::Identify::Id:
        ChipLogDetail(Zcl, "Identify cluster ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u", ChipLogValueMEI(attributeId),
                      type, *value, size);
        break;
    case Clusters::OnOff::Id:
        ChipLogDetail(Zcl, "OnOff cluster ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u", ChipLogValueMEI(attributeId),
                      type, *value, size);
        CustomerAppTask::GetAppTask().OnOffAttributeChangeHandler(attributePath.mEndpointId, attributeId, value, size);
        break;
    case Clusters::TemperatureControl::Id:
        ChipLogDetail(Zcl, "TemperatureControl cluster ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u",
                      ChipLogValueMEI(attributeId), type, *value, size);
        break;
    default:
        break;
    }
}

void MatterOvenModeClusterInitCallback(EndpointId endpointId)
{
    CustomerAppTask::GetAppTask().DMOvenModeClusterInitCallback(endpointId);
}

void MatterOvenModeClusterShutdownCallback(EndpointId endpointId, MatterClusterShutdownType shutdownType)
{
    CustomerAppTask::GetAppTask().DMOvenModeClusterShutdownCallback(endpointId, shutdownType);
}
