/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
 *    Copyright (c) 2019 Google LLC.
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
#include "WakeUpMgr.h"

#include <app/InteractionModelEngine.h>
#include <app/clusters/access-control-server/access-control-cluster.h>
#include <app/clusters/administrator-commissioning-server/AdministratorCommissioningCluster.h>
#include <app/clusters/basic-information/BasicInformationCluster.h>
#include <app/clusters/descriptor/DescriptorCluster.h>
#include <app/clusters/general-commissioning-server/GeneralCommissioningCluster.h>
#include <app/clusters/general-diagnostics-server/GeneralDiagnosticsCluster.h>
#include <app/clusters/group-key-mgmt-server/GroupKeyManagementCluster.h>
#include <app/clusters/network-commissioning/NetworkCommissioningCluster.h>
#include <app/clusters/operational-credentials-server/OperationalCredentialsCluster.h>
#include <app/persistence/DefaultAttributePersistenceProvider.h> // nogncheck
#include <app/server/Server.h>
#include <credentials/GroupDataProvider.h>
#include <data-model-providers/codedriven/CodeDrivenDataModelProvider.h>
#include <lib/support/CodeUtils.h>
#include <platform/CHIPDeviceLayer.h>

#include <data-model-providers/codedriven/CodeDrivenDataModelProvider.h>
#include <data-model-providers/codedriven/endpoint/EndpointInterfaceRegistry.h>
#include <platform/OpenThread/GenericNetworkCommissioningThreadDriver.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#include <em_device.h>
#include "sl_gpio.h"

#include "mmic_task.h"

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::DeviceLayer;
using namespace chip::DeviceLayer::Silabs;
using chip::Silabs::WakeUpMgr;

namespace {

constexpr EndpointId kRootEndpointId = 0;
using SemanticTag                    = Globals::Structs::SemanticTagStruct::Type;

constexpr DataModel::DeviceTypeEntry kRootNodeDeviceType = { .deviceTypeId = 0x0016, .deviceTypeRevision = 3 };

class RootNodeEndpoint : public EndpointInterface
{
public:
    RootNodeEndpoint() : mEndpointRegistration(*this, {}) {}

    CHIP_ERROR DeviceTypes(ReadOnlyBufferBuilder<DataModel::DeviceTypeEntry> & out) const override
    {
        return out.ReferenceExisting(Span<const DataModel::DeviceTypeEntry>(&kRootNodeDeviceType, 1));
    }

    CHIP_ERROR ClientClusters(ReadOnlyBufferBuilder<ClusterId> & out) const override
    {
        return out.ReferenceExisting(Span<const ClusterId>());
    }

#if CHIP_CONFIG_USE_ENDPOINT_UNIQUE_ID
    CharSpan EndpointUniqueID() const override { return CharSpan(); }
#endif

    EndpointInterfaceRegistration & GetRegistration() { return mEndpointRegistration; }

private:
    EndpointInterfaceRegistration mEndpointRegistration;
};

DeviceLayer::NetworkCommissioning::GenericThreadDriver sThreadDriver;

// Code-driven data model infrastructure
DefaultAttributePersistenceProvider sAttributePersistence;
std::unique_ptr<CodeDrivenDataModelProvider> sDataModelProvider;
RootNodeEndpoint sRootNodeEndpoint;

// Root node cluster instances
LazyRegisteredServerCluster<DescriptorCluster> sDescriptorCluster;
LazyRegisteredServerCluster<BasicInformationCluster> sBasicInformationCluster;
LazyRegisteredServerCluster<GeneralCommissioningCluster> sGeneralCommissioningCluster;
LazyRegisteredServerCluster<AdministratorCommissioningWithBasicCommissioningWindowCluster> sAdministratorCommissioningCluster;
LazyRegisteredServerCluster<GeneralDiagnosticsCluster> sGeneralDiagnosticsCluster;
LazyRegisteredServerCluster<GroupKeyManagementCluster> sGroupKeyManagementCluster;
LazyRegisteredServerCluster<AccessControlCluster> sAccessControlCluster;
LazyRegisteredServerCluster<OperationalCredentialsCluster> sOperationalCredentialsCluster;
LazyRegisteredServerCluster<NetworkCommissioningCluster> sNetworkCommissioningCluster;

CHIP_ERROR RegisterRootNodeClusters(CodeDrivenDataModelProvider & provider, Credentials::GroupDataProvider * groupDataProvider)
{
    Server & server = Server::GetInstance();

    SILABS_LOG("=== Registering Root Node Clusters (Code-Driven) ===");

    // Descriptor
    sDescriptorCluster.Create(kRootEndpointId, DescriptorCluster::OptionalAttributesSet(0), Span<const SemanticTag>());
    ReturnErrorOnFailure(provider.AddCluster(sDescriptorCluster.Registration()));

    // BasicInformation
    const BasicInformationOptionalAttributesSet optionalAttributeSet =
        BasicInformationOptionalAttributesSet()
            .template Set<BasicInformation::Attributes::ManufacturingDate::Id>()
            .template Set<BasicInformation::Attributes::PartNumber::Id>()
            .template Set<BasicInformation::Attributes::ProductURL::Id>()
            .template Set<BasicInformation::Attributes::ProductLabel::Id>()
            .template Set<BasicInformation::Attributes::SerialNumber::Id>()
            .template Set<BasicInformation::Attributes::LocalConfigDisabled::Id>()
            .template Set<BasicInformation::Attributes::Reachable::Id>();

    sBasicInformationCluster.Create(optionalAttributeSet, *GetDeviceInstanceInfoProvider(), ConfigurationMgr(), PlatformMgr(),
                                    InteractionModelEngine::GetInstance()->GetMinGuaranteedSubscriptionsPerFabric());
    ReturnErrorOnFailure(provider.AddCluster(sBasicInformationCluster.Registration()));

    // GeneralCommissioning
    sGeneralCommissioningCluster.Create(
        GeneralCommissioningCluster::Context {
            .commissioningWindowManager = server.GetCommissioningWindowManager(), .configurationManager = ConfigurationMgr(),
            .deviceControlServer = DeviceControlServer::DeviceControlSvr(), .fabricTable = server.GetFabricTable(),
            .failSafeContext = server.GetFailSafeContext(), .platformManager = PlatformMgr(),
#if CHIP_CONFIG_TERMS_AND_CONDITIONS_REQUIRED
            .termsAndConditionsProvider = TermsAndConditionsManager::GetInstance(),
#endif
        },
        GeneralCommissioningCluster::OptionalAttributes());
    ReturnErrorOnFailure(provider.AddCluster(sGeneralCommissioningCluster.Registration()));

    // NetworkCommissioning (Thread)
    sNetworkCommissioningCluster.Create(kRootEndpointId, &sThreadDriver,
                                        NetworkCommissioningCluster::Context{
                                            .breadcrumbTracker   = sGeneralCommissioningCluster.Cluster(),
                                            .failSafeContext     = server.GetFailSafeContext(),
                                            .platformManager     = PlatformMgr(),
                                            .deviceControlServer = DeviceControlServer::DeviceControlSvr(),
                                        });
    ReturnErrorOnFailure(sNetworkCommissioningCluster.Cluster().Init());
    ReturnErrorOnFailure(provider.AddCluster(sNetworkCommissioningCluster.Registration()));

    // GeneralDiagnostics
    sGeneralDiagnosticsCluster.Create(GeneralDiagnosticsCluster::OptionalAttributeSet{}, BitFlags<GeneralDiagnostics::Feature>{},
                                      GeneralDiagnosticsCluster::Context{
                                          .deviceLoadStatusProvider = *InteractionModelEngine::GetInstance(),
                                          .diagnosticDataProvider   = GetDiagnosticDataProvider(),
                                          .testEventTriggerDelegate = nullptr,
                                      });
    ReturnErrorOnFailure(provider.AddCluster(sGeneralDiagnosticsCluster.Registration()));

    // AdministratorCommissioning
    sAdministratorCommissioningCluster.Create(kRootEndpointId, BitFlags<AdministratorCommissioning::Feature>{},
                                              AdministratorCommissioningCluster::Context{
                                                  .commissioningWindowManager = server.GetCommissioningWindowManager(),
                                                  .fabricTable                = server.GetFabricTable(),
                                                  .failSafeContext            = server.GetFailSafeContext(),
                                              });
    ReturnErrorOnFailure(provider.AddCluster(sAdministratorCommissioningCluster.Registration()));

    // OperationalCredentials
    sOperationalCredentialsCluster.Create(kRootEndpointId,
                                          OperationalCredentialsCluster::Context{
                                              .fabricTable                = server.GetFabricTable(),
                                              .failSafeContext            = server.GetFailSafeContext(),
                                              .sessionManager             = server.GetSecureSessionManager(),
                                              .dnssdServer                = DnssdServer::Instance(),
                                              .commissioningWindowManager = server.GetCommissioningWindowManager(),
                                              .dacProvider                = *Credentials::GetDeviceAttestationCredentialsProvider(),
                                              .groupDataProvider          = *groupDataProvider,
                                              .accessControl              = server.GetAccessControl(),
                                              .platformManager            = PlatformMgr(),
                                              .eventManagement            = EventManagement::GetInstance(),
                                          });
    ReturnErrorOnFailure(provider.AddCluster(sOperationalCredentialsCluster.Registration()));

    // GroupKeyManagement
    sGroupKeyManagementCluster.Create(GroupKeyManagementCluster::Context{
        .fabricTable       = server.GetFabricTable(),
        .groupDataProvider = *groupDataProvider,
    });
    ReturnErrorOnFailure(provider.AddCluster(sGroupKeyManagementCluster.Registration()));

    // AccessControl
    sAccessControlCluster.Create(AccessControlCluster::Context{
        .persistentStorage = server.GetPersistentStorage(),
        .fabricTable       = server.GetFabricTable(),
        .accessControl     = server.GetAccessControl(),
    });
    ReturnErrorOnFailure(provider.AddCluster(sAccessControlCluster.Registration()));

    // Register endpoint
    sRootNodeEndpoint.GetRegistration().endpointEntry = DataModel::EndpointEntry{
        .id                 = kRootEndpointId,
        .parentId           = kInvalidEndpointId,
        .compositionPattern = DataModel::EndpointCompositionPattern::kFullFamily,
    };
    ReturnErrorOnFailure(provider.AddEndpoint(sRootNodeEndpoint.GetRegistration()));

    SILABS_LOG("=== Root Node Registration Complete ===");
    return CHIP_NO_ERROR;
}

void UnregisterRootNodeClusters(CodeDrivenDataModelProvider & provider)
{
    if (sAccessControlCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sAccessControlCluster.Cluster()));
        sAccessControlCluster.Destroy();
    }
    if (sGroupKeyManagementCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sGroupKeyManagementCluster.Cluster()));
        sGroupKeyManagementCluster.Destroy();
    }
    if (sOperationalCredentialsCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sOperationalCredentialsCluster.Cluster()));
        sOperationalCredentialsCluster.Destroy();
    }
    if (sAdministratorCommissioningCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sAdministratorCommissioningCluster.Cluster()));
        sAdministratorCommissioningCluster.Destroy();
    }
    if (sGeneralDiagnosticsCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sGeneralDiagnosticsCluster.Cluster()));
        sGeneralDiagnosticsCluster.Destroy();
    }

    if (sNetworkCommissioningCluster.IsConstructed())
    {
        sNetworkCommissioningCluster.Cluster().Deinit();
        LogErrorOnFailure(provider.RemoveCluster(&sNetworkCommissioningCluster.Cluster()));
        sNetworkCommissioningCluster.Destroy();
    }

    if (sGeneralCommissioningCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sGeneralCommissioningCluster.Cluster()));
        sGeneralCommissioningCluster.Destroy();
    }
    if (sBasicInformationCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sBasicInformationCluster.Cluster()));
        sBasicInformationCluster.Destroy();
    }
    if (sDescriptorCluster.IsConstructed())
    {
        LogErrorOnFailure(provider.RemoveCluster(&sDescriptorCluster.Cluster()));
        sDescriptorCluster.Destroy();
    }
}

// GPIO used to wake up the host. For now routed to the LED1 on the MG24 BRD4187c
// Adjust port/pin as needed.
constexpr sl_gpio_t kLightGpio         = { .port = gpioPortB, .pin = 4 };
constexpr uint16_t kLedAutoOffTimeoutS = 5;

void EnsureLightGpioInitialized()
{
    static bool initialized = false;
    if (initialized)
    {
        return;
    }
    (void) sl_gpio_set_pin_mode(&kLightGpio, SL_GPIO_MODE_PUSH_PULL, false);
    initialized = true;
}

void SetLight(bool on)
{
    EnsureLightGpioInitialized();
    (void) (on ? sl_gpio_set_pin(&kLightGpio) : sl_gpio_clear_pin(&kLightGpio));
}

void LedAutoOffTimerHandler(chip::System::Layer * /*layer*/, void * /*appState*/)
{
    SetLight(false);
}

[[maybe_unused]] void subscriptionCallback(uint16_t endpointId, uint32_t clusterId, uint32_t attributeId, uint64_t value)
{
    (void) endpointId;

    if (!WakeUpMgr::Instance().IsWakeUpNeeded(clusterId, attributeId, value))
    {
        ChipLogProgress(DeviceLayer, "Wake Up Not needed");
        return;
    }

    SetLight(true);
    // Cancel any pending auto-off before rearming so back-to-back reports extend the window.
    chip::DeviceLayer::SystemLayer().CancelTimer(LedAutoOffTimerHandler, nullptr);
    CHIP_ERROR err = chip::DeviceLayer::SystemLayer().StartTimer(
        chip::System::Clock::Seconds16(kLedAutoOffTimeoutS), LedAutoOffTimerHandler, nullptr);
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "LED auto-off StartTimer failed: %" CHIP_ERROR_FORMAT, err.Format());
        SetLight(false);
    }
}

} // namespace

AppTask AppTask::sAppTask;

CHIP_ERROR AppTask::InitCodeDrivenDataModel(PersistentStorageDelegate & storageDelegate,
                                            chip::Credentials::GroupDataProvider * groupDataProvider)
{
    ReturnErrorOnFailure(sAttributePersistence.Init(&storageDelegate));
    sDataModelProvider = std::make_unique<CodeDrivenDataModelProvider>(storageDelegate, sAttributePersistence);
    return RegisterRootNodeClusters(*sDataModelProvider, groupDataProvider);
}

void AppTask::ShutdownCodeDrivenDataModel()
{
    if (sDataModelProvider)
    {
        UnregisterRootNodeClusters(*sDataModelProvider);
        sDataModelProvider.reset();
    }
}

DataModel::Provider * AppTask::GetDataModelProvider()
{
    return sDataModelProvider.get();
}

CHIP_ERROR AppTask::StartAppTask()
{
    // StartAppTask name is kept for compatibility even if this sample app
    // doesn't have an App Task. All processing is made within the mmic Task context.

    ReturnErrorOnFailure(WakeUpMgr::Instance().Init());

    sl_status_t status = mmic_init(subscriptionCallback);
    VerifyOrReturnError(status == SL_STATUS_OK, CHIP_ERROR_INTERNAL,
                       ChipLogError(DeviceLayer, "Failed to Init Matter MMIC: 0x%02x", status));


    return CHIP_NO_ERROR;
}

// To prevent linkage failure
extern "C" void otAppNcpInit(otInstance * aInstance);
extern "C" otInstance * otGetInstance(void);
extern "C" void sl_ot_create_instance(void);
extern "C" void efr32LogInit(void) {};

#include <openthread/dataset.h>
#include <openthread/instance.h>
#include <openthread/ip6.h>
#include <openthread/thread.h>

#include <platform/ThreadStackManager.h>

extern "C" void AppTaskThreadStateChangedHandler(otChangedFlags aFlags, void * aContext)
{
    if ((aFlags & OT_CHANGED_THREAD_ROLE) == 0)
    {
        return;
    }

    otInstance * instance = static_cast<otInstance *>(aContext);
    otDeviceRole role     = otThreadGetDeviceRole(instance);
    if (role != OT_DEVICE_ROLE_LEADER || !otIp6IsEnabled(instance))
    {
        return;
    }

    // Pull the active operational dataset from the NCP instance and push it to
    // the Matter ThreadStackManager so both instances share the same network.
    otOperationalDatasetTlvs datasetTlvs;
    otError otErr = otDatasetGetActiveTlvs(instance, &datasetTlvs);
    if (otErr != OT_ERROR_NONE)
    {
        SILABS_LOG("otDatasetGetActiveTlvs failed: %d", otErr);
        return;
    }

    ByteSpan dataset(datasetTlvs.mTlvs, datasetTlvs.mLength);
    CHIP_ERROR err = ThreadStackMgr().SetThreadProvision(dataset);
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("SetThreadProvision failed: %" CHIP_ERROR_FORMAT, err.Format());
        return;
    }

    err = ThreadStackMgr().SetThreadEnabled(true);
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("SetThreadEnabled failed: %" CHIP_ERROR_FORMAT, err.Format());
        return;
    }

    // Kick the Matter DNS-SD advertiser so records get (re)published now that
    // the Thread interface is available.
    const bool isCommissioned = (Server::GetInstance().GetFabricTable().FabricCount() > 0);

    PlatformMgr().LockChipStack();
    if (isCommissioned)
    {
        SILABS_LOG("Commissioned: restarting operational DNS-SD advertisement");
        CHIP_ERROR advErr = DnssdServer::Instance().AdvertiseOperational();
        if (advErr != CHIP_NO_ERROR)
        {
            SILABS_LOG("AdvertiseOperational failed: %" CHIP_ERROR_FORMAT, advErr.Format());
        }
    }
    else
    {
        SILABS_LOG("Not commissioned: restarting commissionable DNS-SD advertisement");
        DnssdServer::Instance().StartServer(Dnssd::CommissioningMode::kEnabledBasic);
    }
    PlatformMgr().UnlockChipStack();
}
#if SL_OPENTHREAD_MULTI_PAN_ENABLE
static otInstance * sInstance = NULL;
extern "C" otInstance * otInstanceInitSingle(void) {}
#endif
extern "C" void sl_ot_ncp_init(void)
{
    if(otGetInstance() == nullptr)
    {
        sl_ot_create_instance();
    }
#if SL_OPENTHREAD_MULTI_PAN_ENABLE
    // Matter Stack uses instances at index 0
    // NCP instance will be at index 1
    sInstance = otInstanceInitMultiple(1);
    otAppNcpInit(sInstance);
    otSetStateChangedCallback(sInstance, AppTaskThreadStateChangedHandler, sInstance);
#else
    otAppNcpInit(otGetInstance());
#endif // SL_OPENTHREAD_MULTI_PAN_ENABLE
}
