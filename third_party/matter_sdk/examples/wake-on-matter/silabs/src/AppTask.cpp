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

#if CHIP_ENABLE_OPENTHREAD
#include <platform/OpenThread/GenericNetworkCommissioningThreadDriver.h>
#endif

#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::DeviceLayer;
using namespace chip::DeviceLayer::Silabs;

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

#if CHIP_ENABLE_OPENTHREAD
DeviceLayer::NetworkCommissioning::GenericThreadDriver sThreadDriver;
#endif

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
#if CHIP_ENABLE_OPENTHREAD
LazyRegisteredServerCluster<NetworkCommissioningCluster> sNetworkCommissioningCluster;
#endif

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

#if CHIP_ENABLE_OPENTHREAD
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
#endif

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
#if CHIP_ENABLE_OPENTHREAD
    if (sNetworkCommissioningCluster.IsConstructed())
    {
        sNetworkCommissioningCluster.Cluster().Deinit();
        LogErrorOnFailure(provider.RemoveCluster(&sNetworkCommissioningCluster.Cluster()));
        sNetworkCommissioningCluster.Destroy();
    }
#endif
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

CHIP_ERROR AppTask::AppInit()
{
    GetPlatform().SetButtonsCb(AppTask::ButtonEventHandler);
    return CHIP_NO_ERROR;
}

CHIP_ERROR AppTask::StartAppTask()
{
    return BaseApplication::StartAppTask(AppTaskMain);
}

void AppTask::AppTaskMain(void * pvParameter)
{
    AppEvent event;
    osMessageQueueId_t sAppEventQueue = *(static_cast<osMessageQueueId_t *>(pvParameter));

    CHIP_ERROR err = sAppTask.Init();
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("AppTask.Init() failed");
        appError(err);
    }

    SILABS_LOG("App Task started");

    while (true)
    {
        osStatus_t eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, osWaitForever);
        while (eventReceived == osOK)
        {
            sAppTask.DispatchEvent(&event);
            eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, 0);
        }
    }
}

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;
    button_event.Handler            = BaseApplication::ButtonHandler;
    AppTask::GetAppTask().PostEvent(&button_event);
}

// To prevent linkage failure
#if SL_OPENTHREAD_MULTI_PAN_ENABLE
extern "C" void otAppNcpInit(otInstance * aInstance);

static otInstance * sInstance = NULL;
#endif

extern "C" void sl_ot_ncp_init(void)
{
#if SL_OPENTHREAD_MULTI_PAN_ENABLE
    // Matter Stack uses instances at index 0
    // NCP instance will be at index 1
    sInstance = otInstanceInitMultiple(1);
    otAppNcpInit(sInstance);
#endif
}
