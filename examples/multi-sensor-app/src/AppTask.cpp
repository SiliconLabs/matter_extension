/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
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
#include "SensorManager.h"
#include <app/server/OnboardingCodesUtil.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>
#include <assert.h>
#include <lib/support/CodeUtils.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#if DISPLAY_ENABLED
#include <SensorsUI.h>
#endif

using namespace chip;
using namespace chip::DeviceLayer::Silabs;

namespace {

LEDWidget sOccupancyLed;

enum class ButtonTypes : uint8_t
{
    kFunctionButton    = 0,
    kApplicationButton = 1,
};

#if defined(SL_CATALOG_SIMPLE_LED_LED1_PRESENT)
constexpr uint8_t kOccupancyLedId = 1;
#else
constexpr uint8_t kOccupancyLedId = 0;
#endif

} // namespace

AppTask AppTask::sAppTask;

CHIP_ERROR AppTask::Init()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    GetPlatform().SetButtonsCb(AppTask::ButtonEventHandler);
#ifdef DISPLAY_ENABLED
    GetLCD().Init((uint8_t *) SENSOR_NAME);
#endif

    err = BaseApplication::Init();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "BaseApplication::Init() failed");
        appError(err);
    }

    sOccupancyLed.Init(kOccupancyLedId);
    sOccupancyLed.Set(false);

    err = SensorManager::Init();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "SensorManager::Init failed");
        appError(err);
    }

    // Initialize mOccupancyInstance with the required feature map
    BitMask<app::Clusters::OccupancySensing::Feature> featureMap(app::Clusters::OccupancySensing::Feature::kOther);
    mOccupancyInstance = std::make_unique<chip::app::Clusters::OccupancySensing::Instance>(featureMap);
    mOccupancyInstance->Init();

#ifdef DISPLAY_ENABLED
    mCurrentSensorUI = kSensorUIEnum::kOccupancySensor;

// Show QR Code if not provisioned
#ifdef QR_CODE_ENABLED
    if (BaseApplication::GetProvisionStatus())
    {
        GetLCD().ShowQRCode(true);
        mCurrentSensorUI = kSensorUIEnum::kQrCode;
    }
#endif // QR_CODE_ENABLED

    UpdateSensorDisplay();

#endif // DISPLAY_ENABLED

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
        ChipLogError(AppServer, "AppTask Init Failed!");
        appError(err);
    }

#if !(defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER)
    sAppTask.StartStatusLEDTimer();
#endif

    ChipLogProgress(AppServer, "AppTask started.");

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

#ifdef DISPLAY_ENABLED
void AppTask::UpdateDisplay()
{
    CycleSensorUI();
    UpdateSensorDisplay();
}

void AppTask::UpdateSensorDisplay(void)
{
    switch (mCurrentSensorUI)
    {
    case kSensorUIEnum::kOccupancySensor:
        GetLCD().SetCustomUI(nullptr);
        GetLCD().WriteDemoUI(SensorManager::IsOccupancyDetected());
        break;
    case kSensorUIEnum::kSensor:
        GetLCD().SetCustomUI(SensorsUI::SensorUI);
        GetLCD().WriteDemoUI();
        break;
    case kSensorUIEnum::kStatusScreen:
        BaseApplication::UpdateLCDStatusScreen();
        GetLCD().WriteStatus();
        break;
#ifdef QR_CODE_ENABLED
    case kSensorUIEnum::kQrCode:
        GetLCD().ShowQRCode(true);
        break;
#endif
    default:
        // Handle unknown sensor
        // This should never happen
        break;
    }
}

void AppTask::CycleSensorUI()
{
    mCurrentSensorUI =
        static_cast<kSensorUIEnum>((static_cast<uint8_t>(mCurrentSensorUI) + 1) % static_cast<uint8_t>(kSensorUIEnum::kCount));
}
#endif // DISPLAY_ENABLED

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{

    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    switch (ButtonTypes(button))
    {
    case ButtonTypes::kFunctionButton:
        button_event.Handler = BaseApplication::ButtonHandler;
        sAppTask.PostEvent(&button_event);
        break;
    case ButtonTypes::kApplicationButton:
        if (SilabsPlatform::ButtonAction(btnAction) == SilabsPlatform::ButtonAction::ButtonPressed)
        {
            button_event.Handler = ProccessButtonEvent;
            sAppTask.PostEvent(&button_event);
        }
        break;

    default:
        // Should never happen
        return;
    }
}

void AppTask::ProccessButtonEvent(AppEvent * event)
{
    VerifyOrReturn(event != nullptr);
    VerifyOrReturn(event->Type == AppEvent::kEventType_Button);

    SensorManager::ButtonActionTriggered(event);
}

void AppTask::SensorAttributeUpdateEvent(AppEvent * event)
{
    VerifyOrReturn(event != nullptr);
    VerifyOrReturn(event->Type == AppEvent::kEventType_SensorAttributeUpdate);

#ifdef DISPLAY_ENABLED
    sAppTask.UpdateSensorDisplay();
#endif // DISPLAY_ENABLED
}

void AppTask::OccupancyAttributeUpdateEvent(AppEvent * event)
{
    VerifyOrReturn(event != nullptr);
    VerifyOrReturn(event->Type == AppEvent::kEventType_OccupancyAttributeUpdate);

    sOccupancyLed.Set(event->OccupancyEvent.occupancyDetected);

#ifdef DISPLAY_ENABLED
    sAppTask.UpdateSensorDisplay();
#endif // DISPLAY_ENABLED
}
