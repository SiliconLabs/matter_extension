#include "sl_event_handler.h"

#include "rsi_nvic_priorities_config.h"
#include "sl_si91x_clock_manager.h"
#include "sli_siwx917_soc.h"
#include "rsi_board.h"
#include "rsi_debug.h"
#if SL_ICD_ENABLED
#include "sl_si91x_power_manager.h"
#include "sl_si91x_power_manager_init.h"
#endif // SL_ICD_ENABLED
#include "sl_si91x_button_instances.h"
#include "sl_si91x_led_instances.h"
#include "sl_ulp_timer_instances.h"
#include "sl_iostream_rtt.h"
#include "sl_mbedtls.h"
#include "sl_iostream_init_instances.h"
#include "cmsis_os2.h"
#include "sl_iostream_handles.h"

void sli_driver_permanent_allocation(void)
{
}

void sli_service_permanent_allocation(void)
{
}

void sli_stack_permanent_allocation(void)
{
}

void sli_internal_permanent_allocation(void)
{
}

void sl_platform_init(void)
{
  sl_si91x_device_init_nvic();
  sl_si91x_clock_manager_init();
  sli_si91x_platform_init();
  RSI_Board_Init();
  DEBUGINIT();
}

void sli_internal_init_early(void)
{
}

void sl_kernel_start(void)
{
  osKernelStart();
}

void sl_driver_init(void)
{
  button_init_instances();
  led_init_instances();
}

void sl_service_init(void)
{
#if SL_ICD_ENABLED
  sl_si91x_power_manager_init();
  sli_si91x_power_manager_configure_ram_and_peripheral();
#endif // SL_ICD_ENABLED
  sl_mbedtls_init();
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
  sl_iostream_set_console_instance();
}

