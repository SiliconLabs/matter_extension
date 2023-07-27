/*******************************************************************************
* @file  rsi_wisemcu_hardware_setup.h
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

/*Includes*/

#include "rsi_chip.h"

/*Configure the PMU and XTAL good times */
#define PMU_GOOD_TIME  31 /*Duration in us*/
#define XTAL_GOOD_TIME 31 /*Duration in us*/

#ifdef COMMON_FLASH_EN
#define NWPAON_MEM_HOST_ACCESS_CTRL_SET_1     (*(volatile uint32_t *)(0x41300000 + 0x0))
#define NWPAON_MEM_HOST_ACCESS_CTRL_CLEAR_1   (*(volatile uint32_t *)(0x41300000 + 0x4))
#define M4SS_TASS_CTRL_SET_REG                (*(volatile uint32_t *)(0x24048400 + 0x34))
#define M4SS_TASS_CTRL_CLR_REG                (*(volatile uint32_t *)(0x24048400 + 0x38))
#define M4SS_REF_CLK_MUX_CTRL                 BIT(24)
#define TASS_REF_CLK_MUX_CTRL                 BIT(25)
#define M4SS_CTRL_TASS_AON_PWR_DMN_RST_BYPASS BIT(2)
#endif

#ifdef CHIP_9118
/*Macro to be used for configuring the 'rams_in_use' parameter in 'RSI_WISEMCU_ConfigRamRetention()' function*/
#define WISEMCU_0KB_RAM_IN_USE                                                                                        \
  (RAM_BANK_0 | RAM_BANK_1 | RAM_BANK_2 | RAM_BANK_3 | RAM_BANK_4 | RAM_BANK_5 | RAM_BANK_6 | RAM_BANK_7 | RAM_BANK_8 \
   | RAM_BANK_9 | RAM_BANK_10 | RAM_BANK_11 | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_16KB_RAM_IN_USE                                                                            \
  (RAM_BANK_0 | RAM_BANK_1 | RAM_BANK_2 | RAM_BANK_7 | RAM_BANK_8 | RAM_BANK_9 | RAM_BANK_10 | RAM_BANK_11 \
   | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_48KB_RAM_IN_USE                                                                             \
  (RAM_BANK_0 | RAM_BANK_1 | RAM_BANK_2 | RAM_BANK_8 | RAM_BANK_9 | RAM_BANK_10 | RAM_BANK_11 | RAM_BANK_12 \
   | RAM_BANK_13)
#define WISEMCU_112KB_RAM_IN_USE \
  (RAM_BANK_0 | RAM_BANK_1 | RAM_BANK_2 | RAM_BANK_9 | RAM_BANK_10 | RAM_BANK_11 | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_128KB_RAM_IN_USE \
  (RAM_BANK_0 | RAM_BANK_1 | RAM_BANK_2 | RAM_BANK_10 | RAM_BANK_11 | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_144KB_RAM_IN_USE (RAM_BANK_1 | RAM_BANK_2 | RAM_BANK_10 | RAM_BANK_11 | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_176KB_RAM_IN_USE (RAM_BANK_2 | RAM_BANK_10 | RAM_BANK_11 | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_192KB_RAM_IN_USE (RAM_BANK_10 | RAM_BANK_11 | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_208KB_RAM_IN_USE (RAM_BANK_11 | RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_240KB_RAM_IN_USE (RAM_BANK_12 | RAM_BANK_13)
#define WISEMCU_320KB_RAM_IN_USE (RAM_BANK_13)
#define WISEMCU_384KB_RAM_IN_USE (0)
#endif

#ifdef CHIP_9117
/*Macro to be used for configuring the 'rams_in_use' parameter in 'RSI_WISEMCU_ConfigRamRetention()' function*/
#define WISEMCU_0KB_RAM_IN_USE                                                                                        \
  (RAM_BANK_0 | RAM_BANK_1 | RAM_BANK_2 | RAM_BANK_3 | RAM_BANK_4 | RAM_BANK_5 | RAM_BANK_6 | RAM_BANK_7 | RAM_BANK_8 \
   | RAM_BANK_9)
#define WISEMCU_16KB_RAM_IN_USE  (RAM_BANK_4 | RAM_BANK_5 | RAM_BANK_6 | RAM_BANK_7 | RAM_BANK_8 | RAM_BANK_9)
#define WISEMCU_64KB_RAM_IN_USE  (RAM_BANK_6 | RAM_BANK_7 | RAM_BANK_8 | RAM_BANK_9)
#define WISEMCU_128KB_RAM_IN_USE (RAM_BANK_7 | RAM_BANK_8 | RAM_BANK_9)
#define WISEMCU_192KB_RAM_IN_USE (RAM_BANK_8 | RAM_BANK_9)
#define WISEMCU_256KB_RAM_IN_USE (RAM_BANK_9)
#define WISEMCU_320KB_RAM_IN_USE (0U)
#endif

/*Macro to be used for configuring the 'rams_retention_during_sleep' parameter in 'RSI_WISEMCU_ConfigRamRetention()' function*/
#define WISEMCU_RETAIN_DEFAULT_RAM_DURING_SLEEP (1)
#define WISEMCU_RETAIN_16K_RAM_DURING_SLEEP     (M4ULP_RAM16K_RETENTION_MODE_EN)
#define WISEMCU_RETAIN_128K_RAM_DURING_SLEEP    (M4ULP_RAM16K_RETENTION_MODE_EN | M4ULP_RAM_RETENTION_MODE_EN)
#define WISEMCU_RETAIN_192K_RAM_DURING_SLEEP \
  (M4ULP_RAM16K_RETENTION_MODE_EN | M4ULP_RAM_RETENTION_MODE_EN | M4SS_RAM_RETENTION_MODE_EN)
#define WISEMCU_RETAIN_384K_RAM_DURING_SLEEP \
  (M4ULP_RAM16K_RETENTION_MODE_EN | M4ULP_RAM_RETENTION_MODE_EN | M4SS_RAM_RETENTION_MODE_EN | TA_RAM_RETENTION_MODE_EN)
#define WISEMCU_RETAIN_M4SS_RAM_DURING_SLEEP  (M4SS_RAM_RETENTION_MODE_EN)
#define WISEMCU_RETAIN_ULPSS_RAM_DURING_SLEEP (ULPSS_RAM_RETENTION_MODE_EN)
#define WISEMCU_RETAIN_TASS_RAM_DURING_SLEEP  (TA_RAM_RETENTION_MODE_EN)
#define WISEMCU_RETAIN_M4ULP_RAM_DURING_SLEEP (M4ULP_RAM_RETENTION_MODE_EN)

/*Function proto-types*/
void RSI_WISEMCU_HardwareSetup(void);
void RSI_WISEMCU_TriggerSleep(SLEEP_TYPE_T sleepType,
                              uint8_t lf_clk_mode,
                              uint32_t stack_address,
                              uint32_t jump_cb_address,
                              uint32_t vector_offset,
                              uint32_t mode);
void RSI_WISEMCU_ConfigRamRetention(uint32_t rams_in_use, uint32_t rams_retention_during_sleep);

/*End of file not truncated*/
