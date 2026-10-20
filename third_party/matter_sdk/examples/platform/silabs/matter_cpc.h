/***************************************************************************//**
 * @brief RTOS interface for Matter CPC driver
 *******************************************************************************
 * # License
 * <b>Copyright 2026 Silicon Laboratories Inc. www.silabs.com</b>
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

#pragma once
// Enum of CPC states
typedef enum {
  SL_MATTER_CPC_STATE_DISCONNECTED = 0,
  SL_MATTER_CPC_STATE_CONNECTING   = 1,   // sl_cpc_listen_endpoint() called, SL_CPC_ENDPOINT_ON_CONNECT callback not yet invoked
  SL_MATTER_CPC_STATE_CONNECTED    = 2,   // SL_CPC_ENDPOINT_ON_CONNECT callback invoked
} sl_matter_cpc_state_t;

sl_status_t sl_matter_cpc_init(void);
/**
 * @brief reads byte from CPC endpoints
 *
 * @param uint8_t **  a pointer of pointer that CPC will use to store the data.
 *                    The pointer should be null as CPC stack will allocate the required space
 *                    sl_matter_cpc_free should be called afterwards to prevent memory leak.
 * @return Number of byte read or -1 in case of failure.
 */
int sl_matter_cpc_read(uint8_t **read_buf);
void sl_matter_cpc_free(void *buf);
void sl_matter_cpc_rx_done();
sl_status_t sl_matter_cpc_write(uint8_t *data, uint16_t len);
void sl_matter_cpc_wait_for_activity();
void sl_matter_cpc_on_connect(uint8_t endpoint_id, void *arg);
void sl_matter_cpc_error(uint8_t endpoint_id, void *arg);
bool sl_matter_is_cpc_connected(void);
bool sl_matter_is_cpc_waiting(void);
void sl_matter_reconnect_cpc(void);

/**
 * Callback handler invoked when a new iframe is available. Also invoked
 * from sl_matter_cpc_error following an SL_CPC_ENDPOINT_ON_ERROR notification.
 */
void sl_matter_cpc_on_transport_notify(uint8_t endpoint_id, void * arg);
