/*
 *  OvenBindingHandler.cpp
 *  Propagates CookTop state changes (OnOff + FanControl) to bound peers.
 */

#include "OvenBindingHandler.h"
#include "AppConfig.h"
#include <app-common/zap-generated/cluster-objects.h>
#include <app/clusters/bindings/BindingManager.h>
#include <app/server/Server.h>
#include <controller/InvokeInteraction.h>
#include <controller/WriteInteraction.h>
#include <lib/support/CodeUtils.h>
#include <platform/CHIPDeviceLayer.h>

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;

namespace {

void ProcessOnOffUnicast(bool cookTopOn, const Binding::TableEntry & binding, Messaging::ExchangeManager * exchangeMgr,
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

void ProcessFanControlUnicast(bool cookTopOn, const Binding::TableEntry & binding, const SessionHandle & sessionHandle)
{
    auto onSuccess = [](const ConcreteAttributePath &) {
        ChipLogDetail(AppServer, "CookTop FanControl FanMode bound write success");
    };
    auto onFailure = [](const ConcreteAttributePath *, CHIP_ERROR error) {
        ChipLogError(AppServer, "CookTop FanControl FanMode bound write failed: %s", error.AsString());
    };

    FanControl::FanModeEnum fanMode = cookTopOn ? FanControl::FanModeEnum::kOn : FanControl::FanModeEnum::kOff;

    SuccessOrLog(Controller::WriteAttribute<FanControl::Attributes::FanMode::TypeInfo>(
                     sessionHandle, binding.remote, fanMode, onSuccess, onFailure),
                 AppServer, "Failed to write FanMode attribute");
}

void BoundDeviceChangedHandler(const Binding::TableEntry & binding, OperationalDeviceProxy * peerDevice, void * context)
{
    VerifyOrReturn(context != nullptr);
    auto * data = static_cast<CookTopBindingContext *>(context);

    // Group bindings are not used by the CookTop/RangeHood pairing.
    VerifyOrReturn(binding.type == Binding::MATTER_UNICAST_BINDING);
    VerifyOrReturn(peerDevice != nullptr && peerDevice->ConnectionReady());

    switch (data->clusterId)
    {
    case OnOff::Id:
        ProcessOnOffUnicast(data->cookTopOn, binding, peerDevice->GetExchangeManager(),
                            peerDevice->GetSecureSession().Value());
        break;
    case FanControl::Id:
        ProcessFanControlUnicast(data->cookTopOn, binding, peerDevice->GetSecureSession().Value());
        break;
    default:
        break;
    }
}

void ContextReleaseHandler(void * context)
{
    if (context)
    {
        Platform::Delete(static_cast<CookTopBindingContext *>(context));
    }
}

void InitBindingMgrWork(intptr_t)
{
    auto & server = Server::GetInstance();
    VerifyOrDieWithMsg(CHIP_NO_ERROR ==
                           Binding::Manager::GetInstance().Init(
                               { &server.GetFabricTable(), server.GetCASESessionManager(), &server.GetPersistentStorage() }),
                       AppServer, "Failed to initialize binding manager");
    Binding::Manager::GetInstance().RegisterBoundDeviceChangedHandler(BoundDeviceChangedHandler);
    Binding::Manager::GetInstance().RegisterBoundDeviceContextReleaseHandler(ContextReleaseHandler);
    ChipLogDetail(AppServer, "Oven binding manager initialized");
}

void TriggerBindingWork(intptr_t context)
{
    auto * ctx = reinterpret_cast<CookTopBindingContext *>(context);
    VerifyOrReturn(ctx != nullptr, ChipLogError(AppServer, "TriggerBindingWork: null context"));

    SuccessOrLog(Binding::Manager::GetInstance().NotifyBoundClusterChanged(ctx->localEndpointId, ctx->clusterId, ctx),
                 AppServer, "Failed to notify bound cluster changed");
}

} // namespace

CHIP_ERROR InitOvenBindingHandler()
{
    return DeviceLayer::PlatformMgr().ScheduleWork(InitBindingMgrWork);
}

CHIP_ERROR CookTopBindingTrigger(CookTopBindingContext * context)
{
    VerifyOrReturnError(context != nullptr, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(AppServer, "CookTopBindingTrigger: null context"));
    return DeviceLayer::PlatformMgr().ScheduleWork(TriggerBindingWork, reinterpret_cast<intptr_t>(context));
}
