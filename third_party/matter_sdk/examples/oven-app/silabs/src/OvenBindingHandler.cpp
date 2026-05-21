/*
 *  OvenBindingHandler.cpp
 *  Simplified binding command propagation for CookTop OnOff changes.
 */

#include "OvenBindingHandler.h"
#include "AppConfig.h"
#include <app/clusters/bindings/BindingManager.h>
#include <app/server/Server.h>
#include <controller/InvokeInteraction.h>
#include <lib/support/CodeUtils.h>
#include <platform/CHIPDeviceLayer.h>

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;

namespace {

void ProcessOnOffUnicast(CommandId commandId, const Binding::TableEntry & binding, Messaging::ExchangeManager * exchangeMgr,
                         const SessionHandle & sessionHandle)
{
    auto onSuccess = [](const ConcreteCommandPath &, const StatusIB &, const auto &) {
        ChipLogDetail(AppServer, "CookTop OnOff bound unicast command success");
    };
    auto onFailure = [](CHIP_ERROR error) { ChipLogError(AppServer, "CookTop OnOff bound unicast failed: %s", error.AsString()); };

    switch (commandId)
    {
    case Clusters::OnOff::Commands::On::Id: {
        Clusters::OnOff::Commands::On::Type cmd;
        SuccessOrLog(Controller::InvokeCommandRequest(exchangeMgr, sessionHandle, binding.remote, cmd, onSuccess, onFailure),
                     AppServer, "Failed to invoke On command");
        break;
    }
    case Clusters::OnOff::Commands::Off::Id: {
        Clusters::OnOff::Commands::Off::Type cmd;
        SuccessOrLog(Controller::InvokeCommandRequest(exchangeMgr, sessionHandle, binding.remote, cmd, onSuccess, onFailure),
                     AppServer, "Failed to invoke Off command");
        break;
    }
    default:
        break;
    }
}

void BoundDeviceChangedHandler(const Binding::TableEntry & binding, OperationalDeviceProxy * peerDevice, void * context)
{
    VerifyOrReturn(context != nullptr);
    auto * data = static_cast<OnOffBindingContext *>(context);

    if (binding.clusterId != Clusters::OnOff::Id)
    {
        return; // Only propagate OnOff
    }

    // Only handle unicast bindings - groups are not supported
    if (binding.type == Binding::MATTER_UNICAST_BINDING)
    {
        VerifyOrReturn(peerDevice != nullptr && peerDevice->ConnectionReady());
        ProcessOnOffUnicast(data->commandId, binding, peerDevice->GetExchangeManager(), peerDevice->GetSecureSession().Value());
    }
}

void ContextReleaseHandler(void * context)
{
    if (context)
    {
        Platform::Delete(static_cast<OnOffBindingContext *>(context));
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
    auto * ctx = reinterpret_cast<OnOffBindingContext *>(context);
    VerifyOrReturn(ctx != nullptr, ChipLogError(AppServer, "TriggerBindingWork: null context"));

    // Notify all OnOff bindings from the specified endpoint
    SuccessOrLog(Binding::Manager::GetInstance().NotifyBoundClusterChanged(ctx->localEndpointId, Clusters::OnOff::Id, ctx),
                 AppServer, "Failed to notify bound cluster changed");
}

} // namespace

CHIP_ERROR InitOvenBindingHandler()
{
    return DeviceLayer::PlatformMgr().ScheduleWork(InitBindingMgrWork);
}

CHIP_ERROR CookTopOnOffBindingTrigger(OnOffBindingContext * context)
{
    VerifyOrReturnError(context != nullptr, CHIP_ERROR_INVALID_ARGUMENT,
                        ChipLogError(AppServer, "CookTopOnOffBindingTrigger: null context"));
    return DeviceLayer::PlatformMgr().ScheduleWork(TriggerBindingWork, reinterpret_cast<intptr_t>(context));
}
