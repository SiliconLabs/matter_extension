/***************************************************************************
 * @file sl_power_manager_stub.cpp
 * @brief Stub implementation for Silicon Labs Power Manager API (for unit tests)
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

#include "sl_power_manager_stub.h"

// Minimal stub implementations for unit tests
// These functions do nothing but simulate successful execution

void sl_power_manager_init(void)
{
    // No-op for unit tests
}

void sl_power_manager_subscribe_em_transition_event(void * handle, void * info)
{
    // No-op for unit tests
}

void sl_power_manager_unsubscribe_em_transition_event(void * handle)
{
    // No-op for unit tests
}
