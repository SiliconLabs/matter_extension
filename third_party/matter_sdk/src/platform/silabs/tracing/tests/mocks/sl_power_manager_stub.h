/***************************************************************************
 * @file sl_power_manager_stub.h
 * @brief Stub header for Silicon Labs Power Manager API (for unit tests)
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

#include <cstddef>
#include <stdint.h>

// Default values for tracing config constants if not defined by build system
#ifndef SL_TRACING_ENERGY_TRACES_MAX
#define SL_TRACING_ENERGY_TRACES_MAX 100
#endif
#ifndef SL_TRACING_ENERGY_TRACES_SECONDS
#define SL_TRACING_ENERGY_TRACES_SECONDS 10
#endif

#ifdef __cplusplus
extern "C" {
#endif

// Power transition events
#define SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM0 (1 << 0)
#define SL_POWER_MANAGER_EVENT_TRANSITION_LEAVING_EM0 (1 << 1)
#define SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM1 (1 << 2)
#define SL_POWER_MANAGER_EVENT_TRANSITION_LEAVING_EM1 (1 << 3)
#define SL_POWER_MANAGER_EVENT_TRANSITION_ENTERING_EM2 (1 << 4)
#define SL_POWER_MANAGER_EVENT_TRANSITION_LEAVING_EM2 (1 << 5)

// Energy modes
typedef enum
{
    SL_POWER_MANAGER_EM0 = 0, ///< Run Mode (Energy Mode 0)
    SL_POWER_MANAGER_EM1,     ///< Sleep Mode (Energy Mode 1)
    SL_POWER_MANAGER_EM2,     ///< Deep Sleep Mode (Energy Mode 2)
    SL_POWER_MANAGER_EM3,     ///< Stop Mode (Energy Mode 3)
    SL_POWER_MANAGER_EM4,     ///< Shutoff Mode (Energy Mode 4)
} sl_power_manager_em_t;

typedef uint32_t sl_power_manager_em_transition_event_t;

typedef void (*sl_power_manager_em_transition_on_event_t)(sl_power_manager_em_t from, sl_power_manager_em_t to);

typedef struct
{
    const sl_power_manager_em_transition_event_t event_mask;
    const sl_power_manager_em_transition_on_event_t on_event;
} sl_power_manager_em_transition_event_info_t;

typedef struct
{
    void * node;
    const sl_power_manager_em_transition_event_info_t * info;
} sl_power_manager_em_transition_event_handle_t;

void sl_power_manager_init(void);
void sl_power_manager_subscribe_em_transition_event(void * handle, void * info);
void sl_power_manager_unsubscribe_em_transition_event(void * handle);

#ifdef __cplusplus
}
#endif
