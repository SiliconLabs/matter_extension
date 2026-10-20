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

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <cmsis_os2.h>
#include "sl_cmsis_os2_common.h"
#include "sl_component_catalog.h"
#include "sl_core.h"
#include "sl_status.h"
#include "sli_cpc.h"
#include "matter_cpc.h"

#include <lib/support/CodeUtils.h>

static osSemaphoreId_t matter_cpc_signal_semaphore;
static sl_matter_cpc_state_t cpc_state = SL_MATTER_CPC_STATE_DISCONNECTED;
static sl_cpc_endpoint_handle_t endpoint_handle;

void sl_matter_cpc_on_transport_notify(uint8_t endpoint_id, void * arg)
{
  (void)endpoint_id;
  (void)arg;

  osSemaphoreRelease(matter_cpc_signal_semaphore);
}

void sl_matter_cpc_wait_for_activity()
{
  osSemaphoreAcquire(matter_cpc_signal_semaphore, osWaitForever);
}

sl_status_t sl_matter_cpc_init(void)
{
#ifdef SL_CATALOG_MATTER_NCP_PRESENT // Temp fix for 26q4 dev
  sl_status_t status = SL_STATUS_OK;

  status = sli_cpc_init_service_endpoint(&endpoint_handle, SL_CPC_ENDPOINT_MATTER, 0);
  VerifyOrReturnError(status == SL_STATUS_OK, status);

  status = sl_cpc_set_endpoint_option(&endpoint_handle, SL_CPC_ENDPOINT_ON_IFRAME_RECEIVE, (void *)sl_matter_cpc_on_transport_notify);
  VerifyOrReturnError(status == SL_STATUS_OK, status);
  status = sl_cpc_set_endpoint_option(&endpoint_handle, SL_CPC_ENDPOINT_ON_CONNECT, (void*)sl_matter_cpc_on_connect);
  VerifyOrReturnError(status == SL_STATUS_OK, status);
  status = sl_cpc_set_endpoint_option(&endpoint_handle, SL_CPC_ENDPOINT_ON_ERROR, (void*)sl_matter_cpc_error);
  VerifyOrReturnError(status == SL_STATUS_OK, status);

  if (matter_cpc_signal_semaphore == NULL) {
    matter_cpc_signal_semaphore = osSemaphoreNew(1, 0, NULL);
    status = (matter_cpc_signal_semaphore != NULL) ? SL_STATUS_OK : SL_STATUS_FAIL;
  }

  return status;
#else
  return SL_STATUS_OK;
#endif
}

void sl_matter_cpc_on_connect(uint8_t endpoint_id, void *arg)
{
  (void)endpoint_id;
  (void)arg;

  cpc_state = SL_MATTER_CPC_STATE_CONNECTED;
}

void sl_matter_cpc_error(uint8_t endpoint_id, void *arg)
{
  (void)endpoint_id;
  (void)arg;
  sl_status_t status;

  cpc_state = SL_MATTER_CPC_STATE_DISCONNECTED;
  status = sl_cpc_terminate_endpoint(&endpoint_handle, 0);
  VerifyOrDie(status == SL_STATUS_OK);
  sl_matter_cpc_on_transport_notify(0, NULL);
}

int sl_matter_cpc_read(uint8_t **read_buf)
{
  if (read_buf == NULL) {
    return -1;
  }

  void *   data        = NULL;
  uint16_t data_length = 0;

  // Non-blocking: callers are expected to gate this with sl_matter_cpc_wait_for_new_data().
  sl_status_t status = sl_cpc_read(&endpoint_handle, &data, &data_length, 0, SL_CPC_FLAG_NO_BLOCK);

  if (status == SL_STATUS_EMPTY) {
    *read_buf = NULL;
    return 0;
  }
  if (status != SL_STATUS_OK) {
    *read_buf = NULL;
    return -1;
  }

  *read_buf = (uint8_t *) data;
  return (int) data_length;
}

sl_status_t sl_matter_cpc_write(uint8_t *data, uint16_t len)
{
  return sl_cpc_write(&endpoint_handle, data, len, 0, NULL);
}

void sl_matter_cpc_free(void *buf)
{
  sl_cpc_free_rx_buffer((void *) buf);
}

bool sl_matter_is_cpc_waiting(void)
{
  return (cpc_state == SL_MATTER_CPC_STATE_CONNECTING);
}

bool sl_matter_is_cpc_connected(void)
{
  return (cpc_state == SL_MATTER_CPC_STATE_CONNECTED);
}

void sl_matter_reconnect_cpc(void)
{
  switch (cpc_state) {
    case SL_MATTER_CPC_STATE_DISCONNECTED:
      sl_cpc_listen_endpoint(&endpoint_handle, SL_CPC_FLAG_NO_BLOCK);
      cpc_state = SL_MATTER_CPC_STATE_CONNECTING;
      break;

    case SL_MATTER_CPC_STATE_CONNECTING:
    case SL_MATTER_CPC_STATE_CONNECTED:
      // Nothing to do
      break;

    default:
      VerifyOrDie(false);
  }
}
