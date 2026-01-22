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

#ifdef DISPLAY_ENABLED
#include "RangeHoodUI.h"
#include "lcd.h"
#ifdef QR_CODE_ENABLED
#include "qrcodegen.h"
#endif // QR_CODE_ENABLED
#endif // DISPLAY_ENABLED

#include "RangeHoodManager.h"
#include <app-common/zap-generated/attribute-type.h>
#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app/clusters/fan-control-server/fan-control-server.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>
#include <lib/support/logging/CHIPLogging.h>

#include <assert.h>

#include <setup_payload/OnboardingCodesUtil.h>
#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#include <lib/support/CodeUtils.h>

#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#define LIGHT_LED 1

#define APP_FUNCTION_BUTTON 0
#define APP_ACTION_BUTTON 1

using namespace chip;
using namespace chip::app;
using namespace chip::TLV;
using namespace ::chip::DeviceLayer;
using namespace chip::app::Clusters::FanControl;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::FanControl::Attributes;

LEDWidget sLightLED; // Use LEDWidget for basic LED functionality

/**********************************************************
 * AppTask Definitions
 *********************************************************/

AppTask AppTask::sAppTask;

CHIP_ERROR AppTask::AppInit()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(AppTask::ButtonEventHandler);

#ifdef DISPLAY_ENABLED
    GetLCD().Init((uint8_t *) "Rangehood-App");
    GetLCD().SetCustomUI(RangeHoodUI::DrawUI);
#endif // DISPLAY_ENABLED

    // Initialization of RangeHoodManager and endpoints of range hood.
    err = RangeHoodManager::GetInstance().Init();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "RangeHoodManager initialization failed");
        return err;
    }

// Update the LCD with the Stored value. Show QR Code if not provisioned
#ifdef DISPLAY_ENABLED
    GetLCD().WriteDemoUI(false);
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
#endif // DISPLAY_ENABLED
    sLightLED.Init(LIGHT_LED);
    bool lightState = false;

    chip::DeviceLayer::PlatformMgr().LockChipStack();
    CHIP_ERROR status = RangeHoodManager::GetInstance().GetLightEndpoint().GetOnOffState(lightState);
    chip::DeviceLayer::PlatformMgr().UnlockChipStack();
    if (status == CHIP_NO_ERROR)
    {
        sLightLED.Set(lightState);
    }
    else
    {
        ChipLogError(AppServer, "AppTask.Init: failed to  read initial light state");
    }

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

#if !(defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER)
    sAppTask.StartStatusLEDTimer();
#endif

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
    // Only invoke our RangeHood ButtonHandler for BTN1 (APP_ACTION_BUTTON) presses.
    if (button == APP_ACTION_BUTTON &&
        btnAction == static_cast<uint8_t>(::chip::DeviceLayer::Silabs::SilabsPlatform::ButtonAction::ButtonPressed))
    {
        button_event.Handler = FanControlButtonHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
    }
    else if (button == APP_FUNCTION_BUTTON)
    {
        // Defer other button events to generic base handler
        button_event.Handler = BaseApplication::ButtonHandler;
        AppTask::GetAppTask().PostEvent(&button_event);
    }
}

void AppTask::ActionTriggerHandler(AppEvent * aEvent)
{
    // Direct action trigger without initiated/completed separation
    RangeHoodManager::Action_t action = static_cast<RangeHoodManager::Action_t>(aEvent->RangeHoodEvent.Action);

    switch (action)
    {
    case RangeHoodManager::LIGHT_ON_ACTION:
        ChipLogProgress(AppServer, "Light ON");
        sLightLED.Set(true);
#ifdef DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // DISPLAY_ENABLED
        break;

    case RangeHoodManager::LIGHT_OFF_ACTION:
        ChipLogProgress(AppServer, "Light OFF");
        sLightLED.Set(false);
#ifdef DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // DISPLAY_ENABLED
        break;

    case RangeHoodManager::FAN_MODE_CHANGE_ACTION:
#ifdef DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // DISPLAY_ENABLED
        break;

    case RangeHoodManager::FAN_PERCENT_CHANGE_ACTION:
        // TODO: Update LCD with new fan percent
        break;

    default:
        ChipLogError(AppServer, "Unknown action: %d", action);
        break;
    }
}

void AppTask::FanControlButtonHandler(AppEvent * aEvent)
{
    /**
     * Handle button press events for range hood control
     * This function processes button events specifically for the action button (BTN1)
     * which controls the fan operation in the range hood application.
     */
    if (aEvent->ButtonEvent.Action ==
        static_cast<uint8_t>(::chip::DeviceLayer::Silabs::SilabsPlatform::ButtonAction::ButtonPressed))
    {
        // Schedule fan mode toggle on CHIP stack thread to avoid direct access causing locking errors.
        chip::DeviceLayer::PlatformMgr().ScheduleWork([](intptr_t) { RangeHoodMgr().GetExtractorHoodEndpoint().ToggleFanMode(); },
                                                      0);
    }
}
