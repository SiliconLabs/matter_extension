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
#include "AppEvent.h"

#include "LEDWidget.h"

#include <app/DeferredAttributePersistenceProvider.h>
#include <app/clusters/on-off-server/on-off-server.h>
#include <app/server/OnboardingCodesUtil.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>

#ifdef MATTER_DM_PLUGIN_SCENES_MANAGEMENT
#include <app/clusters/scenes-server/scenes-server.h>
#endif

#include <assert.h>

#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#include <lib/support/CodeUtils.h>

#include <platform/CHIPDeviceLayer.h>

#include "ZigbeeCallbacks.h"
#include "sl_cmp_config.h"
#include "sl_matter_config.h"

#if (defined(SL_CATALOG_SIMPLE_LED_LED1_PRESENT) || defined(SIWX_917))
#define LIGHT_LED 1
#else
#define LIGHT_LED 0
#endif

#define APP_FUNCTION_BUTTON 0
#define APP_LIGHT_SWITCH 1

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace ::chip::DeviceLayer;
using namespace ::chip::DeviceLayer::Silabs;

namespace {
LEDWidget sLightLED;

// Array of attributes that will have their non-volatile storage deferred/delayed.
// This is useful for attributes that change frequently over short periods of time, such as during transitions.
// In this example, we defer the storage of the Level Control's CurrentLevel attribute and the Color Control's
// CurrentHue and CurrentSaturation attributes for the LIGHT_ENDPOINT.
DeferredAttribute gDeferredAttributeTable[] = {
    DeferredAttribute(ConcreteAttributePath(LIGHT_ENDPOINT, LevelControl::Id, LevelControl::Attributes::CurrentLevel::Id)),
    DeferredAttribute(ConcreteAttributePath(LIGHT_ENDPOINT, ColorControl::Id, ColorControl::Attributes::CurrentHue::Id)),
    DeferredAttribute(ConcreteAttributePath(LIGHT_ENDPOINT, ColorControl::Id, ColorControl::Attributes::CurrentSaturation::Id))
};

// The DeferredAttributePersistenceProvider will persist the attribute value in non-volatile memory
// once it remains constant for SL_MATTER_DEFERRED_ATTRIBUTE_STORE_DELAY_MS milliseconds.
// For all other attributes not listed in gDeferredAttributeTable, the default GetDefaultAttributePersister is used.
DeferredAttributePersistenceProvider
    gDeferredAttributePersister(Server::GetInstance().GetDefaultAttributePersister(),
                                Span<DeferredAttribute>(gDeferredAttributeTable, ArraySize(gDeferredAttributeTable)),
                                System::Clock::Milliseconds32(SL_MATTER_DEFERRED_ATTRIBUTE_STORE_DELAY_MS));

} // namespace

using namespace chip::TLV;
using namespace ::chip::DeviceLayer;

AppTask AppTask::sAppTask;

CHIP_ERROR AppTask::Init()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    app::SetAttributePersistenceProvider(&gDeferredAttributePersister);
    chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(AppTask::ButtonEventHandler);

#ifdef DISPLAY_ENABLED
    GetLCD().Init((uint8_t *) "CMP-Lighting-App");
#endif

#ifdef SL_MATTER_ZIGBEE_CMP
    ChipLogProgress(AppServer, "Concurrent CMP app");
#else
    ChipLogProgress(AppServer, "Sequential CMP app");
#endif

    err = BaseApplication::Init();
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("BaseApplication::Init() failed");
        appError(err);
    }

    err = LightMgr().Init();
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("LightMgr::Init() failed");
        appError(err);
    }

    LightMgr().SetCallbacks(ActionInitiated, ActionCompleted);

    sLightLED.Init(LIGHT_LED);
    sLightLED.Set(LightMgr().IsLightOn());

// Update the LCD with the Stored value. Show QR Code if not provisioned
#ifdef DISPLAY_ENABLED
    GetLCD().WriteDemoUI(LightMgr().IsLightOn());
#ifdef QR_CODE_ENABLED
#ifdef SL_WIFI
    if (!ConnectivityMgr().IsWiFiStationProvisioned())
#else
    if (!ConnectivityMgr().IsThreadProvisioned())
#endif /* !SL_WIFI */
    {
        GetLCD().ShowQRCode(true);
    }
#endif // QR_CODE_ENABLED
#endif
#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
#if defined(SL_MATTER_ZIGBEE_SEQUENTIAL) || (defined(SL_MATTER_ZIGBEE_CMP) && defined(_SILICON_LABS_32B_SERIES_3))
    PlatformMgr().LockChipStack();
    uint16_t nbOfMatterFabric = chip::Server::GetInstance().GetFabricTable().FabricCount();
    PlatformMgr().UnlockChipStack();
    if (nbOfMatterFabric != 0)
    {
#ifdef SL_MATTER_ZIGBEE_CMP
        uint8_t channel = otLinkGetChannel(DeviceLayer::ThreadStackMgrImpl().OTInstance());
        SILABS_LOG("Setting Zigbee channel to %d", channel);
        Zigbee::RequestStart(channel);
#else
        Zigbee::RequestLeave();
#endif // SL_MATTER_ZIGBEE_CMP
    }
    else
#endif // SL_MATTER_ZIGBEE_SEQUENTIAL || (SL_MATTER_ZIGBEE_CMP && _SILICON_LABS_32B_SERIES_3)
    {
        Zigbee::RequestStart();
    }
#endif // SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT

    return err;
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

#if !(defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER)
    sAppTask.StartStatusLEDTimer();
#endif

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

void AppTask::LightActionEventHandler(AppEvent * aEvent)
{
    bool initiated = false;
    LightingManager::Action_t action;
    int32_t actor;
    CHIP_ERROR err = CHIP_NO_ERROR;

    if (aEvent->Type == AppEvent::kEventType_Light)
    {
        action = static_cast<LightingManager::Action_t>(aEvent->LightEvent.Action);
        actor  = aEvent->LightEvent.Actor;
    }
    else if (aEvent->Type == AppEvent::kEventType_Button)
    {
        action = (LightMgr().IsLightOn()) ? LightingManager::OFF_ACTION : LightingManager::ON_ACTION;
        actor  = AppEvent::kEventType_Button;
    }
    else
    {
        err = APP_ERROR_UNHANDLED_EVENT;
    }

    if (err == CHIP_NO_ERROR)
    {
        initiated = LightMgr().InitiateAction(actor, action);

        if (!initiated)
        {
            SILABS_LOG("Action is already in progress or active.");
        }
    }
}

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    if (button == APP_LIGHT_SWITCH && btnAction == static_cast<uint8_t>(SilabsPlatform::ButtonAction::ButtonPressed))
    {
        button_event.Handler = LightActionEventHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
    }
    else if (button == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
    }
}

void AppTask::ActionInitiated(LightingManager::Action_t aAction, int32_t aActor)
{
    // Action initiated, update the light led
    bool lightOn = aAction == LightingManager::ON_ACTION;
    SILABS_LOG("Turning light %s", (lightOn) ? "On" : "Off")

    sLightLED.Set(lightOn);

#ifdef DISPLAY_ENABLED
    sAppTask.GetLCD().WriteDemoUI(lightOn);
#endif

    if (aActor == AppEvent::kEventType_Button)
    {
        sAppTask.mSyncClusterToButtonAction = true;
    }
}

void AppTask::ActionCompleted(LightingManager::Action_t aAction)
{
    // action has been completed bon the light
    if (aAction == LightingManager::ON_ACTION)
    {
        SILABS_LOG("Light ON")
    }
    else if (aAction == LightingManager::OFF_ACTION)
    {
        SILABS_LOG("Light OFF")
    }

    if (sAppTask.mSyncClusterToButtonAction)
    {
        chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, reinterpret_cast<intptr_t>(nullptr));
        sAppTask.mSyncClusterToButtonAction = false;
    }
}

void AppTask::PostLightActionRequest(int32_t aActor, LightingManager::Action_t aAction)
{
    AppEvent event;
    event.Type              = AppEvent::kEventType_Light;
    event.LightEvent.Actor  = aActor;
    event.LightEvent.Action = aAction;
    event.Handler           = LightActionEventHandler;
    PostEvent(&event);
}

void AppTask::UpdateClusterState(intptr_t context)
{
    uint8_t newValue = LightMgr().IsLightOn();

    // write the new on/off value
    Protocols::InteractionModel::Status status = OnOffServer::Instance().setOnOffValue(LIGHT_ENDPOINT, newValue, false);

    if (status != Protocols::InteractionModel::Status::Success)
    {
        SILABS_LOG("ERR: updating on/off %x", to_underlying(status));
    }
}
