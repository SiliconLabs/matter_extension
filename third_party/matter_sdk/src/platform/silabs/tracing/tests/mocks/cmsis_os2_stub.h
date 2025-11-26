/***************************************************************************
 * @file cmsis_os2_stub.h
 * @brief Stub header for CMSIS-OS2 API (for unit tests)
 *******************************************************************************
 * # License
 * <b>Copyright 2025 Silicon Laboratories Inc. www.silabs.com</b>
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
#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*osTimerFunc_t)(void * argument);
typedef void * osTimerId_t;

typedef enum
{
    osTimerOnce = 0,
    osTimerPeriodic
} osTimerType_t;

typedef struct
{
    const char * name;
    uint32_t attr_bits;
    void * cb_mem;
    uint32_t cb_size;
} osTimerAttr_t;

typedef enum
{
    osOK             = 0,
    osError          = -1,
    osErrorTimeout   = -2,
    osErrorResource  = -3,
    osErrorParameter = -4,
    osErrorNoMemory  = -5,
    osErrorISR       = -6
} osStatus_t;

osTimerId_t osTimerNew(osTimerFunc_t func, osTimerType_t type, void * argument, const osTimerAttr_t * attr);
uint32_t osKernelGetTickFreq(void);
osStatus_t osTimerStart(osTimerId_t timer_id, uint32_t ticks);
osStatus_t osTimerStop(osTimerId_t timer_id);
osStatus_t osTimerDelete(osTimerId_t timer_id);
osStatus_t osDelay(uint32_t ticks);

#ifdef __cplusplus
}
#endif
