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
#include "CustomerAppTask.h"

#include "LEDWidget.h"

#if SL_MATTER_DISPLAY_ENABLED
#include "lcd.h"
#if SL_MATTER_QR_CODE_ENABLED
#include "qrcodegen.h"
#endif // SL_MATTER_QR_CODE_ENABLED
#endif // SL_MATTER_DISPLAY_ENABLED

#include <app/server/Server.h>
#include <lib/support/CodeUtils.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#ifdef SL_CATALOG_SIMPLE_LED_LED1_PRESENT
#define LIGHT_LED 1
#else
#define LIGHT_LED 0
#endif

#define APP_FUNCTION_BUTTON 0
#define APP_USER_ACTION 1

using namespace chip;
using namespace chip::app;
using namespace ::chip::DeviceLayer;
using namespace ::chip::DeviceLayer::Silabs;

namespace {

CustomerAppTask & appInstance()
{
    return CustomerAppTask::GetAppTask();
}

LEDWidget sLightLED;
} // namespace

CHIP_ERROR AppTask::AppInit()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    GetPlatform().SetButtonsCb(&CustomerAppTask::ButtonEventHandler);

    sLightLED.Init(LIGHT_LED);
    sLightLED.Set(false);

#if SL_MATTER_DISPLAY_ENABLED
    GetLCD().WriteDemoUI(true);
#if SL_MATTER_QR_CODE_ENABLED
#ifdef SL_WIFI
    if (!ConnectivityMgr().IsWiFiStationProvisioned())
#else
    if (!ConnectivityMgr().IsThreadProvisioned())
#endif /* !SL_WIFI */
    {
        GetLCD().ShowQRCode(true);
    }
#endif // SL_MATTER_QR_CODE_ENABLED
#endif // SL_MATTER_DISPLAY_ENABLED

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

    CHIP_ERROR err = appInstance().Init();

    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("AppTask.Init() failed");
        appError(err);
    }

#if (defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER)
    Server::GetInstance().GetICDManager().RegisterObserver(&appInstance());
#else
    appInstance().StartStatusLEDTimer();
#endif

    SILABS_LOG("App Task started");

    while (true)
    {
        osStatus_t eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, osWaitForever);
        while (eventReceived == osOK)
        {
            appInstance().DispatchEvent(&event);
            eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, 0);
        }
    }
}

void AppTask::ApplicationEventHandler(AppEvent * aEvent)
{
    VerifyOrReturn(aEvent->Type == AppEvent::kEventType_Button);
    VerifyOrReturn(aEvent->ButtonEvent.Action == static_cast<uint8_t>(SilabsPlatform::ButtonAction::ButtonPressed));

    sLightLED.GetLEDStatus(LIGHT_LED) ? sLightLED.Set(false) : sLightLED.Set(true);
}

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    if (button == APP_USER_ACTION)
    {
        button_event.Handler = &CustomerAppTask::ApplicationEventHandler;
        appInstance().PostEvent(&button_event);
    }
    if (button == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        appInstance().PostEvent(&button_event);
    }
}

#if defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER
// DO NOT COPY for product logic. This is only a showcase of the Platform app support for the LIT ICD feature in test.
void AppTask::OnEnterActiveModeDefault()
{
#if SL_MATTER_DISPLAY_ENABLED
    appInstance().GetLCD().WriteDemoUI(true);
#endif
}

// DO NOT COPY for product logic. This is only a showcase of the Platform app support for the LIT ICD feature in test.
void AppTask::OnEnterIdleModeDefault()
{
#if SL_MATTER_DISPLAY_ENABLED
    appInstance().GetLCD().WriteDemoUI(false);
#endif
}

void AppTask::OnTransitionToIdleDefault()
{
    ChipLogDetail(DeviceLayer, "AppTask transitioning to idle");
}

void AppTask::OnICDModeChangeDefault()
{
    if (ICDConfigurationData::GetInstance().GetICDMode() == ICDConfigurationData::ICDMode::SIT)
    {
        ChipLogDetail(DeviceLayer, "Entering SIT Mode");
    }
    else
    {
        ChipLogDetail(DeviceLayer, "Entering LIT Mode");
    }
}
#endif // defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER
