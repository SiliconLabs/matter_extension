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
#include "CustomerAppTask.h"
#include "RangeHoodConfig.h"

#include "LEDWidget.h"

#if SL_MATTER_DISPLAY_ENABLED
#include "RangeHoodUI.h"
#include "lcd.h"
#if SL_MATTER_QR_CODE_ENABLED
#include "qrcodegen.h"
#endif // SL_MATTER_QR_CODE_ENABLED
#endif // SL_MATTER_DISPLAY_ENABLED

#include <app-common/zap-generated/attribute-type.h>
#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/clusters/fan-control-server/fan-control-server.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>

#define LIGHT_LED 1

#define APP_FUNCTION_BUTTON 0
#define APP_ACTION_BUTTON 1

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::FanControl;
using namespace chip::app::Clusters::FanControl::Attributes;
using namespace ::chip::DeviceLayer;

namespace {

CustomerAppTask & AppInstance()
{
    return CustomerAppTask::GetAppTask();
}

// Defaults live in RangeHoodConfig.h; consumers tune via the Configuration Wizard.
constexpr chip::EndpointId kExtractorHoodEndpoint = EXTRACTOR_HOOD_ENDPOINT;
constexpr chip::EndpointId kLightEndpoint         = LIGHT_ENDPOINT;

ExtractorHoodEndpoint sExtractorHoodEndpoint{ kExtractorHoodEndpoint, FAN_MODE_LOW_PERCENT, FAN_MODE_MEDIUM_PERCENT,
                                            FAN_MODE_HIGH_PERCENT };
LightEndpoint sLightEndpoint{ kLightEndpoint };

LEDWidget sLightLED;

void FanControlAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value, uint16_t size)
{
    VerifyOrReturn(endpointId == kExtractorHoodEndpoint,
                   ChipLogError(NotSpecified, "FanControlAttributeChangeHandler: Invalid endpoint %u, expected %u", endpointId,
                                kExtractorHoodEndpoint));

    AppTask::Action_t action = AppTask::INVALID_ACTION;

    switch (attributeId)
    {
    case chip::app::Clusters::FanControl::Attributes::PercentSetting::Id: {
        CHIP_ERROR err = sExtractorHoodEndpoint.HandlePercentSettingChange(*value);
        VerifyOrReturn(err == CHIP_NO_ERROR,
                       ChipLogError(NotSpecified, "FanControlAttributeChangeHandler: HandlePercentSettingChange failed: %ld",
                                    err.Format()));
        action = AppTask::FAN_PERCENT_CHANGE_ACTION;
        break;
    }

    case chip::app::Clusters::FanControl::Attributes::FanMode::Id: {
        CHIP_ERROR err = sExtractorHoodEndpoint.HandleFanModeChange(*reinterpret_cast<FanModeEnum *>(value));
        VerifyOrReturn(err == CHIP_NO_ERROR,
                       ChipLogError(NotSpecified, "FanControlAttributeChangeHandler: HandleFanModeChange failed: %ld",
                                    err.Format()));
        action = AppTask::FAN_MODE_CHANGE_ACTION;
        break;
    }

    default:
        return;
    }

    AppEvent event;
    event.Type                  = AppEvent::kEventType_RangeHood;
    event.RangeHoodEvent.Action = static_cast<uint8_t>(action);
    event.Handler               = &CustomerAppTask::ActionTriggerHandler;
    AppInstance().PostEvent(&event);
}

void OnOffAttributeChangeHandler(chip::EndpointId endpointId, chip::AttributeId attributeId, uint8_t * value, uint16_t size)
{
    VerifyOrReturn(
        endpointId == kLightEndpoint,
        ChipLogError(NotSpecified, "OnOffAttributeChangeHandler: Invalid endpoint %u, expected %u", endpointId, kLightEndpoint));

    VerifyOrReturn(value != nullptr, ChipLogError(NotSpecified, "OnOffAttributeChangeHandler: value is null"));
    VerifyOrReturn(size >= sizeof(uint8_t), ChipLogError(NotSpecified, "OnOffAttributeChangeHandler: Invalid size %u", size));

    AppTask::Action_t action = *value ? AppTask::LIGHT_ON_ACTION : AppTask::LIGHT_OFF_ACTION;

    AppEvent event;
    event.Type                  = AppEvent::kEventType_RangeHood;
    event.RangeHoodEvent.Action = static_cast<uint8_t>(action);
    event.Handler               = &CustomerAppTask::ActionTriggerHandler;
    AppInstance().PostEvent(&event);
}

} // namespace

ExtractorHoodEndpoint & AppTask::GetExtractorHoodEndpoint()
{
    return sExtractorHoodEndpoint;
}

LightEndpoint & AppTask::GetLightEndpoint()
{
    return sLightEndpoint;
}

CHIP_ERROR AppTask::AppInit()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    chip::DeviceLayer::Silabs::GetPlatform().SetButtonsCb(&CustomerAppTask::ButtonEventHandler);

#if SL_MATTER_DISPLAY_ENABLED
    SuccessOrLog(GetLCD().Init((uint8_t *) "Rangehood-App"), AppServer, "Failed to initialize LCD");
    GetLCD().SetCustomUI(RangeHoodUI::DrawUI);
#endif // SL_MATTER_DISPLAY_ENABLED

    err = AppInstance().InitRangeHood();
    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(AppServer, "InitRangeHood failed"));

#if SL_MATTER_DISPLAY_ENABLED
    GetLCD().WriteDemoUI(false);
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

CHIP_ERROR AppTask::InitRangeHood()
{
    VerifyOrReturnError(sExtractorHoodEndpoint.Init() == CHIP_NO_ERROR, CHIP_ERROR_INTERNAL);

    sLightLED.Init(LIGHT_LED);
    bool lightState = false;

    chip::DeviceLayer::PlatformMgr().LockChipStack();
    CHIP_ERROR status = sLightEndpoint.GetOnOffState(lightState);
    chip::DeviceLayer::PlatformMgr().UnlockChipStack();
    if (status == CHIP_NO_ERROR)
    {
        sLightLED.Set(lightState);
    }
    else
    {
        ChipLogError(AppServer, "InitRangeHood: failed to read initial light state");
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR AppTask::StartAppTask()
{
    return BaseApplication::StartAppTask(&AppTask::AppTaskMain);
}

void AppTask::AppTaskMain(void * pvParameter)
{
    AppEvent event;
    osMessageQueueId_t sAppEventQueue = *(static_cast<osMessageQueueId_t *>(pvParameter));

    CHIP_ERROR err = AppInstance().Init();
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(AppServer, "AppTask.Init() failed");
        appError(err);
    }

#if !(defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER)
    AppInstance().StartStatusLEDTimer();
#endif

    ChipLogProgress(AppServer, "App Task started");

    while (true)
    {
        osStatus_t eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, osWaitForever);
        while (eventReceived == osOK)
        {
            AppInstance().DispatchEvent(&event);
            eventReceived = osMessageQueueGet(sAppEventQueue, &event, NULL, 0);
        }
    }
}

void AppTask::ButtonEventHandler(uint8_t button, uint8_t btnAction)
{
    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;
    if (button == APP_ACTION_BUTTON &&
        btnAction == static_cast<uint8_t>(::chip::DeviceLayer::Silabs::SilabsPlatform::ButtonAction::ButtonPressed))
    {
        button_event.Handler = &CustomerAppTask::FanControlButtonHandler;
        AppInstance().PostEvent(&button_event);
    }
    else if (button == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        AppInstance().PostEvent(&button_event);
    }
}

void AppTask::ActionTriggerHandler(AppEvent * aEvent)
{
    Action_t action = static_cast<Action_t>(aEvent->RangeHoodEvent.Action);

    switch (action)
    {
    case LIGHT_ON_ACTION:
        ChipLogProgress(AppServer, "Light ON");
        sLightLED.Set(true);
#if SL_MATTER_DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // SL_MATTER_DISPLAY_ENABLED
        break;

    case LIGHT_OFF_ACTION:
        ChipLogProgress(AppServer, "Light OFF");
        sLightLED.Set(false);
#if SL_MATTER_DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // SL_MATTER_DISPLAY_ENABLED
        break;

    case FAN_MODE_CHANGE_ACTION:
#if SL_MATTER_DISPLAY_ENABLED
        GetLCD().WriteDemoUI(false);
#endif // SL_MATTER_DISPLAY_ENABLED
        break;

    case FAN_PERCENT_CHANGE_ACTION:
        // TODO: Update LCD with new fan percent
        break;

    default:
        ChipLogError(AppServer, "Unknown action: %d", action);
        break;
    }
}

void AppTask::FanControlButtonHandler(AppEvent * aEvent)
{
    if (aEvent->ButtonEvent.Action ==
        static_cast<uint8_t>(::chip::DeviceLayer::Silabs::SilabsPlatform::ButtonAction::ButtonPressed))
    {
        SuccessOrLog(chip::DeviceLayer::PlatformMgr().ScheduleWork(
                         [](intptr_t) { RETURN_SAFELY_IGNORED sExtractorHoodEndpoint.ToggleFanMode(); }, 0),
                     AppServer, "Failed to schedule work to toggle fan mode");
    }
}

void AppTask::DMPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                            uint8_t * value)
{
    ClusterId clusterId     = attributePath.mClusterId;
    AttributeId attributeId = attributePath.mAttributeId;
    EndpointId endpointId   = attributePath.mEndpointId;

    VerifyOrReturn(value != nullptr);

    ChipLogDetail(Zcl, "Cluster callback: " ChipLogFormatMEI " on endpoint %u", ChipLogValueMEI(clusterId), endpointId);

    switch (clusterId)
    {
    case FanControl::Id:
        ChipLogDetail(Zcl, "FanControl attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u on endpoint %u",
                      ChipLogValueMEI(attributeId), type, *value, size, endpointId);
        FanControlAttributeChangeHandler(endpointId, attributeId, value, size);
        break;

    case OnOff::Id:
        ChipLogDetail(Zcl, "OnOff attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u on endpoint %u",
                      ChipLogValueMEI(attributeId), type, *value, size, endpointId);
        OnOffAttributeChangeHandler(endpointId, attributeId, value, size);
        break;

    case Clusters::Identify::Id:
        ChipLogDetail(Zcl, "Identify attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u on endpoint %u",
                      ChipLogValueMEI(attributeId), type, *value, size, endpointId);
        break;

    default:
        ChipLogDetail(Zcl, "Unhandled cluster " ChipLogFormatMEI " on endpoint %u", ChipLogValueMEI(clusterId), endpointId);
        break;
    }
}
