/*******************************************************************************
 * @file  rsi_board.h
 * @brief
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#ifndef __RSI_BOARD_H__
#define __RSI_BOARD_H__
/**
 * @defgroup  Board_Specific_Driver   Board specific drivers and support functions
 * @{
 */
#ifdef __cplusplus
extern "C" {
#endif
/**
 * @defgroup  Board_Drivers BOARD: Common board components used with board drivers
 * @{
 */
#include "rsi_ccp_user_config.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/times.h>

/*Sample print prototype*/
void RSI_Board_LED_Set(int x, int y);
void RSI_Board_Init(void);
void RSI_Board_LED_Toggle(int);

#ifdef __cplusplus
}
#endif

#define BTN0 0
#define BTN1 1
#define BTN_PRESSED 1
#define BTN_RELEASED 0

// TODO: can be removed once B0 2.0 board using button init from wifi-sdk platform
#ifdef SI917_RADIO_BOARD_V2
#include "rsi_rom_egpio.h"

#define PIN_INT 7
#define RSI_BTN0_PORT 0
#define RSI_BTN1_PORT 0
#define RSI_BTN0_PIN 2
#define RSI_BTN1_PIN 11
#define PININT_NVIC_NAME EGPIO_PIN_7_IRQn
#define RSI_EGPIO_PAD_SEL 6
#else
#define RSI_BTN0_PIN 0
#define RSI_BTN1_PIN 2
#endif // SI917_RADIO_BOARD_V2
#endif /*__RSI_BOARD_H__*/

/* @} end of Board_Drivers */
/* @} end of Board_Specific_Driver */