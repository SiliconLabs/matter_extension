#include "sl_event_handler.h"

#include "sl_interrupt_manager.h"
#include "sl_board_init.h"
#include "sl_clock_manager.h"
#include "SEGGER_RTT.h"
#include "sl_board_control.h"
#include "sl_gpio.h"
#include "sl_iostream_rtt.h"
#include "sl_mbedtls.h"
#include "psa/crypto.h"
#include "cmsis_os2.h"
#include "sl_iostream_init_instances.h"
#include "nvm3_default.h"

void sl_platform_init(void)
{
  sl_interrupt_manager_init();
  sl_board_preinit();
  sl_clock_manager_runtime_init();
  SEGGER_RTT_Init();
  sl_board_init();
  osKernelInitialize();
  nvm3_initDefault();
}

void sl_kernel_start(void)
{
  osKernelStart();
}

void sl_driver_init(void)
{
  sl_gpio_init();
}

void sl_service_init(void)
{
  sl_board_configure_vcom();
  sl_mbedtls_init();
  psa_crypto_init();
  sl_iostream_init_instances();
}

void sl_stack_init(void)
{
}

void sl_internal_app_init(void)
{
}

void sl_iostream_init_instances(void)
{
  sl_iostream_rtt_init();
}

