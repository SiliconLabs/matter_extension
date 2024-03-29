/*
 *    Copyright (c) 2023 Project CHIP Authors
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

#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <sl_si91x_button_pin_config.h>

#include <FreeRTOS.h>
#include <task.h>

#if SILABS_LOG_ENABLED
#include "silabs_utils.h"
#endif

// TODO add includes ?
extern "C" {
#include "em_core.h"
#include "sl_event_handler.h"
#include "rsi_chip.h"
#include "rsi_nvic_priorities_config.h"
#include "sl_device_init_nvic.h"
#include "sli_siwx917_soc.h"
#include "rsi_board.h"
#include "rsi_wisemcu_hardware_setup.h"
#include "cmsis_os2.h"
#include "sl_si91x_led_config.h"
#include "sl_si91x_led.h"

void sl_system_init(void);
void soc_pll_config(void);
}

#if SILABS_LOG_ENABLED
#include "silabs_utils.h"
#endif

namespace chip {
namespace DeviceLayer {
namespace Silabs {
namespace {
    uint8_t sButtonStates[SL_SI91x_BUTTON_COUNT] = { 0 };

}

SilabsPlatform SilabsPlatform::sSilabsPlatformAbstractionManager;
SilabsPlatform::SilabsButtonCb SilabsPlatform::mButtonCallback = nullptr;

void sl_si917_platform_init(void)
{
    SystemCoreClockUpdate();
    sl_si91x_device_init_nvic();
    sl_device_init_nvic();
    sli_si91x_platform_init();
    RSI_Board_Init();
#if CHIP_CONFIG_ENABLE_ICD_SERVER && !(defined(DISPLAY_ENABLED))
    sl_si91x_hardware_setup();
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER && !(defined(DISPLAY_ENABLED)
    osKernelInitialize();
}

void sl_si917_system_init(void)
{
    sl_si917_platform_init();
    sl_driver_init();
    sl_service_init();
    sl_stack_init();
    sl_internal_app_init();
}

CHIP_ERROR SilabsPlatform::Init(void)
{
    mButtonCallback = nullptr;

    // TODO: Change this to use sl_system_init()
    sl_si917_system_init();

    // TODO: Setting the highest priority for SVCall_IRQn to avoid the HardFault issue
    NVIC_SetPriority(SVCall_IRQn, CORE_INTERRUPT_HIGHEST_PRIORITY);

    // Configuration the clock rate
    soc_pll_config();

#if SILABS_LOG_ENABLED
    silabsInitLog();
#endif
    return CHIP_NO_ERROR;
}

#ifdef ENABLE_WSTK_LEDS
void SilabsPlatform::InitLed(void)
{
    // TODO
    RSI_Board_Init();
    SilabsPlatformAbstractionBase::InitLed();
}

CHIP_ERROR SilabsPlatform::SetLed(bool state, uint8_t led)
{
    // TODO add range check
    (state) ? sl_si91x_led_set(led ? SL_LED_LED1_PIN : SL_LED_LED0_PIN) : sl_si91x_led_clear(led ? SL_LED_LED1_PIN : SL_LED_LED0_PIN);
    return CHIP_NO_ERROR;
}

bool SilabsPlatform::GetLedState(uint8_t led)
{
    // TODO
    return SilabsPlatformAbstractionBase::GetLedState(led);
}

CHIP_ERROR SilabsPlatform::ToggleLed(uint8_t led)
{
    // TODO add range check
    sl_si91x_led_toggle(led ? SL_LED_LED1_PIN : SL_LED_LED0_PIN);
    return CHIP_NO_ERROR;
}
#endif // ENABLE_WSTK_LEDS

void SilabsPlatform::StartScheduler()
{
    vTaskStartScheduler();
}

extern "C" {
void sl_button_on_change(uint8_t btn, uint8_t btnAction)
{
    if (Silabs::GetPlatform().mButtonCallback == nullptr)
    {
        return;
    }

    if(btn < SL_SI91x_BUTTON_COUNT)
    {
        sButtonStates[btn] = btnAction;
    }
    Silabs::GetPlatform().mButtonCallback(btn, btnAction);
}
}

uint8_t SilabsPlatform::GetButtonState(uint8_t button)
{
    return (button < SL_SI91x_BUTTON_COUNT) ? sButtonStates[button] : 0;
}

} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
