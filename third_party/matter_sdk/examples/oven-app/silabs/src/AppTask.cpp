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
#include "LEDWidget.h"
#include "OvenBindingHandler.h"

#ifdef DISPLAY_ENABLED
#include "OvenUI.h"
#include "lcd.h"
#ifdef QR_CODE_ENABLED
#include "qrcodegen.h"
#endif // QR_CODE_ENABLED
#endif // DISPLAY_ENABLED

#include <OvenManager.h>
#include <app-common/zap-generated/cluster-enums.h>
#include <app-common/zap-generated/cluster-objects.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/ConcreteAttributePath.h>
#include <app/clusters/network-commissioning/network-commissioning.h>
#include <app/clusters/on-off-server/on-off-server.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>
#include <app/util/endpoint-config-api.h>
#include <assert.h>
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

LEDWidget sLightLED; // Use LEDWidget for basic LED functionality

AppTask AppTask::sAppTask;

CHIP_ERROR AppTask::AppInit()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(AppTask::ButtonEventHandler);

#ifdef DISPLAY_ENABLED
    GetLCD().Init((uint8_t *) "Oven-App");
    GetLCD().SetCustomUI(OvenUI::DrawUI);
#endif
    DeviceLayer::PlatformMgr().LockChipStack();
    // Initialization of Oven Manager and endpoints of oven.
    OvenManager::GetInstance().Init();
    DeviceLayer::PlatformMgr().UnlockChipStack();

    sLightLED.Init(LIGHT_LED);
    sLightLED.Set(OvenManager::GetInstance().GetCookTopState());

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
        ChipLogError(AppServer, "AppTask.Init() failed");
        appError(err);
    }

    sAppTask.StartStatusLEDTimer();

    ChipLogProgress(AppServer, "App Task started");

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

    // Handle button1 specifically for oven functionality
    if (button == APP_ACTION_BUTTON)
    {
        button_event.Handler = OvenButtonHandler;
    }
    else
    {
        button_event.Handler = BaseApplication::ButtonHandler;
    }

    AppTask::GetAppTask().PostEvent(&button_event);
}

void AppTask::OvenButtonHandler(AppEvent * aEvent)
{
    // Handle button press to toggle cooktop and cook surface
    if (aEvent->ButtonEvent.Action == static_cast<uint8_t>(SilabsPlatform::ButtonAction::ButtonPressed))
    {
        ChipLogDetail(AppServer, "Oven button pressed - starting toggle action");

        // Determine new state (toggle current state)
        bool newOnOffState = !OvenManager::GetInstance().GetCookTopState();

        // Schedule work to set the OnOff attribute.
        chip::DeviceLayer::PlatformMgr().ScheduleWork(UpdateClusterState, static_cast<intptr_t>(newOnOffState));
    }
}

void AppTask::UpdateClusterState(intptr_t context)
{
    bool newOnOffState = static_cast<bool>(context);

    ChipLogDetail(AppServer, "Updating cooktop OnOff cluster state to %s", newOnOffState ? "On" : "Off");

    // Set the OnOff attribute value for the cooktop endpoint
    DeviceLayer::PlatformMgr().LockChipStack();
    Protocols::InteractionModel::Status status =
        OnOffServer::Instance().setOnOffValue(OvenManager::GetCookTopEndpoint(), newOnOffState, false);
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
    case OvenManager::COOK_TOP_ON_ACTION:
    case OvenManager::COOK_TOP_OFF_ACTION: {
        sLightLED.Set(OvenManager::GetInstance().GetCookTopState());
#ifdef DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // DISPLAY_ENABLED
        break;
    }
    case OvenManager::OVEN_MODE_UPDATE_ACTION:
#ifdef DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // DISPLAY_ENABLED
        break;
    default:
        break;
    }
}
