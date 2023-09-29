/***************************************************************************//**
 * @file
 * @brief SLEEPTIMER hardware abstraction layer definition.
 *******************************************************************************
 * # License
 * <b>Copyright 2019 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * SPDX-License-Identifier: Zlib
 *
 * The licensor of this software is Silicon Laboratories Inc.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 ******************************************************************************/

#ifndef SL_SLEEPTIMER_HAL_H
#define SL_SLEEPTIMER_HAL_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include "em_device.h"
#include "sli_sleeptimer.h"

#ifdef __cplusplus
extern "C" {
#endif

/*******************************************************************************
 * Hardware Abstraction Layer of the sleep timer init.
 ******************************************************************************/
void sleeptimer_hal_init_timer(void);

/*******************************************************************************
 * Hardware Abstraction Layer to get the current timer count.
 *
 * @return Value in ticks of the timer counter.
 ******************************************************************************/
uint32_t sleeptimer_hal_get_counter(void);

/*******************************************************************************
 * Hardware Abstraction Layer to get a timer comparator value.
 *
 * @return Value in ticks of the timer comparator.
 ******************************************************************************/
uint32_t sleeptimer_hal_get_compare(void);

/*******************************************************************************
 * Hardware Abstraction Layer to set a timer comparator value.
 *
 * @param value Number of ticks to set.
 ******************************************************************************/
void sleeptimer_hal_set_compare(uint32_t value);

/*******************************************************************************
 * Hardware Abstraction Layer to set a comparator value to trigger a
 * peripheral request signal to initialize.
 *
 * @param value Number of ticks to set.
 ******************************************************************************/
void sleeptimer_hal_set_compare_prs_hfxo_startup(int32_t value);

/*******************************************************************************
 * Hardware Abstraction Layer to get the timer frequency.
 ******************************************************************************/
uint32_t sleeptimer_hal_get_timer_frequency(void);

/*******************************************************************************
 * Hardware Abstraction Layer to enable timer interrupts.
 *
 * @param local_flag Internal interrupt flag.
 ******************************************************************************/
void sleeptimer_hal_enable_int(uint8_t local_flag);

/*******************************************************************************
 * Hardware Abstraction Layer to disable timer interrupts.
 *
 * @param local_flag Internal interrupt flag.
 ******************************************************************************/
void sleeptimer_hal_disable_int(uint8_t local_flag);

/*******************************************************************************
 * Hardware Abstraction Layer to set timer interrupts.
 *
 * @param local_flag Internal interrupt flag.
 ******************************************************************************/
void sleeptimer_hal_set_int(uint8_t local_flag);

/*******************************************************************************
 * Hardware Abstraction Layer to get the sleeptimer's clock accuracy.
 *
 * @return Clock accuracy in PPM.
 ******************************************************************************/
uint16_t sleeptimer_hal_get_clock_accuracy(void);

/*******************************************************************************
 * Hardware Abstraction Layer to get the capture channel value.
 *
 * @note Not supported by all peripherals Sleeptimer can use.
 *
 * @return Capture value.
 ******************************************************************************/
uint32_t sleeptimer_hal_get_capture(void);

/*******************************************************************************
 * Hardware Abstraction Layer to reset PRS signal triggered by the associated
 * peripheral.
 *
 * @note Not supported by all peripherals Sleeptimer can use.
 ******************************************************************************/
void sleeptimer_hal_reset_prs_signal(void);

/*******************************************************************************
 * Hardware Abstraction Layer to disable PRS compare and capture channel.
 *
 * @note Not supported by all peripherals Sleeptimer can use.
 ******************************************************************************/
void sleeptimer_hal_disable_prs_compare_and_capture_channel(void);

/*******************************************************************************
 * Process the timer interrupt.
 *
 * @param flags Internal interrupt flag.
 ******************************************************************************/
void process_timer_irq(uint8_t local_flag);

#ifdef __cplusplus
}
#endif

#endif /* SL_SLEEPTIMER_HAL_H */
