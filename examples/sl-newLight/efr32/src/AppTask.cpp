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
#ifdef RGB_LED_ENABLED
#include "led_widget_rgb.h"
#endif // RGB_LED_ENABLED

#include <app/clusters/on-off-server/on-off-server.h>
#include <app/server/OnboardingCodesUtil.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>

#include <assert.h>

#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#include <lib/support/CodeUtils.h>

#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#define LIGHT_LED 1
#define APP_FUNCTION_BUTTON 0
#define APP_LIGHT_SWITCH 1

using namespace chip;
using namespace ::chip::DeviceLayer;

namespace {

#ifdef RGB_LED_ENABLED
#define LIGHT_LED_RGB &sl_led_rgb_pwm
LEDWidgetRGB sLightLED;
#else
LEDWidget sLightLED;
#endif

} // namespace

using namespace chip::TLV;
using namespace ::chip::DeviceLayer;

AppTask AppTask::sAppTask;

CHIP_ERROR AppTask::AppInit()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(AppTask::ButtonEventHandler);

    err = LightMgr().Init();
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("LightMgr::Init() failed");
        appError(err);
    }

    LightMgr().SetCallbacks(ActionInitiated, ActionCompleted);

#if defined(RGB_LED_ENABLED)
    LEDWidgetRGB::InitGpioRGB();
    sLightLED.Init(LIGHT_LED_RGB);
#else
    sLightLED.Init(LIGHT_LED);
#endif

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

    return err;
}

CHIP_ERROR AppTask::StartAppTask()
{
    return BaseApplication::StartAppTask(AppTaskMain);
}

void AppTask::AppTaskMain(void * pvParameter)
{
    AppEvent event;
    QueueHandle_t sAppEventQueue = *(static_cast<QueueHandle_t *>(pvParameter));

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
        BaseType_t eventReceived = xQueueReceive(sAppEventQueue, &event, portMAX_DELAY);
        while (eventReceived == pdTRUE)
        {
            sAppTask.DispatchEvent(&event);
            eventReceived = xQueueReceive(sAppEventQueue, &event, 0);
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
        if (LightMgr().IsLightOn())
        {
            action = LightingManager::OFF_ACTION;
        }
        else
        {
            action = LightingManager::ON_ACTION;
        }
        actor = AppEvent::kEventType_Button;
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
void AppTask::ActionInitiated(LightingManager::Action_t aAction, int32_t aActor)
{
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
    // action has been completed on the light
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

void AppTask::LightControlEventHandler(AppEvent * aEvent)
{
    /* 1. Unpack the AppEvent */
    uint8_t light_action = aEvent->LightControlEvent.Action;
    uint8_t value        = aEvent->LightControlEvent.Value;

    /* 2. Excute the control command. */
    if (light_action == LightingManager::MOVE_TO_LEVEL)
    {
#ifdef RGB_LED_ENABLED
        sLightLED.SetLevel(value);
#endif // RGB_LED_ENABLED
        SILABS_LOG("Level set to: %d.", value);
    }
    else if (light_action == LightingManager::MOVE_TO_HUE)
    {
#ifdef RGB_LED_ENABLED
        sLightLED.SetHue(value);
#endif // RGB_LED_ENABLED
        SILABS_LOG("Light LED hue set.");
    }
    else if (light_action == LightingManager::MOVE_TO_SAT)
    {
#ifdef RGB_LED_ENABLED
        sLightLED.SetSaturation(value);
#endif // RGB_LED_ENABLED
        SILABS_LOG("Light LED saturation set.");
    }
}

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    if (button == APP_LIGHT_SWITCH && btnAction == SL_SIMPLE_BUTTON_PRESSED)
    {
        button_event.Handler = LightActionEventHandler;
        sAppTask.PostEvent(&button_event);
    }
    else if (button == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        sAppTask.PostEvent(&button_event);
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
void AppTask::PostLightControlActionRequest(int32_t aActor, LightingManager::Action_t aAction, uint8_t value)
{
    AppEvent light_event                 = {};
    light_event.Type                     = AppEvent::kEventType_Light;
    light_event.LightControlEvent.Actor  = aActor;
    light_event.LightControlEvent.Action = aAction;
    light_event.LightControlEvent.Value  = value;
    light_event.Handler                  = LightControlEventHandler;
    PostEvent(&light_event);
}
void AppTask::UpdateClusterState(intptr_t context)
{
    uint8_t newValue = LightMgr().IsLightOn();
    // write the new on/off value
    Protocols::InteractionModel::Status status = OnOffServer::Instance().setOnOffValue(1, newValue, false);
    if (status != Protocols::InteractionModel::Status::Success)
    {
        SILABS_LOG("ERR: updating on/off %x", to_underlying(status));
    }
}
