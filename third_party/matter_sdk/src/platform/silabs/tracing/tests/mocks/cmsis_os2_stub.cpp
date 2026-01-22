/***************************************************************************
 * @file cmsis_os2_stub.cpp
 * @brief Stub implementation for CMSIS-OS2 API (for unit tests)
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

#include "cmsis_os2_stub.h"

// Minimal stub implementations for unit tests
// These functions do nothing but return success

osTimerId_t osTimerNew(osTimerFunc_t func, osTimerType_t type, void * argument, const osTimerAttr_t * attr)
{
    // Return a non-null pointer to simulate successful timer creation
    static int dummy_timer = 1;
    return &dummy_timer;
}

uint32_t osKernelGetTickFreq(void)
{
    return 1024;
}

osStatus_t osTimerStart(osTimerId_t timer_id, uint32_t ticks)
{
    return osOK;
}

osStatus_t osTimerStop(osTimerId_t timer_id)
{
    return osOK;
}

osStatus_t osTimerDelete(osTimerId_t timer_id)
{
    return osOK;
}

osStatus_t osDelay(uint32_t ticks)
{
    return osOK;
}
