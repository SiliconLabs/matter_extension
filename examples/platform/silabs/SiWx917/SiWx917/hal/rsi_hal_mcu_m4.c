/*
 *
 *    Copyright (c) 2022 Project CHIP Authors
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

#include "rsi_board.h"
#include "rsi_chip.h"
#include "rsi_m4.h"
#ifdef COMMON_FLASH_EN
#include "rsi_power_save.h"
#endif

/**
 * GPIO state: false for Pressed, true for released
 */
bool gpio0_current_state = true;
bool gpio2_current_state = true;

void sl_button_on_change(uint8_t btn, uint8_t btnAction);

uint32_t NVIC_GetIRQEnable(IRQn_Type IRQn)
{
    return ((NVIC->ICER[((uint32_t)(IRQn) >> 5)] & (1 << ((uint32_t)(IRQn) &0x1F))) ? 1 : 0);
}

void rsi_assertion(uint16_t assertion_val, const char * string)
{
    uint16_t i;
    if (assertion_val == 0)
    {
        for (i = 0; i < strlen(string); i++)
        {
#ifdef DEBUG_UART
#ifdef DEBUG_ASSERTION
            Board_UARTPutChar(string[i]);
#endif
#endif
        }

        return;
    }
    else
    {
        for (i = 0; i < strlen(string); i++)
        {
#ifdef DEBUG_UART
#ifdef DEBUG_ASSERTION
            Board_UARTPutChar(string[i]);
#endif
#endif
        }

        while (1)
            ;
    }
}

#if SI917_RADIO_BOARD_V2
void IRQ059_Handler(void) {
  // TODO: Replace with rsi_delay once that is fixed
  for (int i = 0; i < 10000; i++)
    __asm__("nop;");

  RSI_EGPIO_IntClr(EGPIO, PIN_INT, INTERRUPT_STATUS_CLR);
  RSI_EGPIO_GetPin(EGPIO, RSI_BTN1_PORT, RSI_BTN1_PIN)
      ? sl_button_on_change(BTN1, BTN_RELEASED)
      : sl_button_on_change(BTN1, BTN_PRESSED);
}
#endif // SI917_RADIO_BOARD_V2

void IRQ021_Handler(void) {
  // TODO: Replace with rsi_delay once that is fixed
  for (int i = 0; i < 10000; i++)
    __asm__("nop;");
  /* clear NPSS GPIO interrupt*/
  RSI_NPSSGPIO_ClrIntr(NPSS_GPIO_0_INTR);
  RSI_NPSSGPIO_ClrIntr(NPSS_GPIO_2_INTR);
  // if the btn is not pressed setting the state to 1
  if (RSI_NPSSGPIO_GetPin(NPSS_GPIO_2) && (!gpio2_current_state)) {
    gpio2_current_state = true;
#ifdef SI917_RADIO_BOARD_V2
    sl_button_on_change(BTN0, BTN_RELEASED);
#else
    sl_button_on_change(BTN1, BTN_RELEASED);
#endif // SI917_RADIO_BOARD_V2
  }
  // geting the state of the gpio 2 pin and checking if the btn is already
  // pressed or not
  if (!RSI_NPSSGPIO_GetPin(NPSS_GPIO_2) && gpio2_current_state) {
    gpio2_current_state = false;
#ifdef SI917_RADIO_BOARD_V2
    sl_button_on_change(BTN0, BTN_PRESSED);
#else
    sl_button_on_change(BTN1, BTN_PRESSED);
#endif // SI917_RADIO_BOARD_V2
  }
  if (RSI_NPSSGPIO_GetPin(NPSS_GPIO_0) && (!gpio0_current_state)) {
    gpio0_current_state = true;
    sl_button_on_change(BTN0, BTN_RELEASED);
  }
  if (!RSI_NPSSGPIO_GetPin(NPSS_GPIO_0) && gpio0_current_state) {
    gpio0_current_state = false;
    sl_button_on_change(BTN0, BTN_PRESSED);
  }
}
