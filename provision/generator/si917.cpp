/***************************************************************************//**
 * @file
 * @brief NVM3 definition of the default data structures.
 *******************************************************************************
 * # License
 * <b>Copyright 2018 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc.  Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement.  This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#include "app.h"
extern "C" {
#include <sl_wifi_callback_framework.h>
#include <sl_wifi.h>
#include <sl_wifi_device.h>
#include <sl_net.h>
}
#include <nvm3.h>
#include <nvm3_default.h>
#include <sl_iostream_rtt.h>
#include <sl_iostream_init_instances.h>
#include <sl_net_constants.h>


static const sl_wifi_device_configuration_t _wifi_config = {
  .boot_option = LOAD_NWP_FW,
  .mac_address = NULL,
  .band        = SL_SI91X_WIFI_BAND_2_4GHZ,
  .region_code = US,
  .boot_config = { .oper_mode              = SL_SI91X_CLIENT_MODE,
                   .coex_mode              = SL_SI91X_WLAN_ONLY_MODE,
                   .feature_bit_map        = (SL_SI91X_FEAT_SECURITY_PSK | SL_SI91X_FEAT_AGGREGATION),
                   .tcp_ip_feature_bit_map = (SL_SI91X_TCP_IP_FEAT_DHCPV4_CLIENT | SL_SI91X_TCP_IP_FEAT_HTTP_CLIENT
                                              | SL_SI91X_TCP_IP_FEAT_EXTENSION_VALID | SL_SI91X_TCP_IP_FEAT_OTAF
                                              | SL_SI91X_TCP_IP_FEAT_DNS_CLIENT),
                   .custom_feature_bit_map = SL_SI91X_CUSTOM_FEAT_EXTENTION_VALID,
                   .ext_custom_feature_bit_map =
                     (SL_SI91X_EXT_FEAT_XTAL_CLK | SL_SI91X_EXT_FEAT_UART_SEL_FOR_DEBUG_PRINTS |
#ifndef SLI_SI91X_MCU_INTERFACE
                      SL_SI91X_RAM_LEVEL_NWP_ALL_MCU_ZERO
#else
                      SL_SI91X_RAM_LEVEL_NWP_MEDIUM_MCU_MEDIUM
#endif
                      ),
                   .bt_feature_bit_map = 0,
                   .ext_tcp_ip_feature_bit_map =
                     (SL_SI91X_EXT_FEAT_HTTP_OTAF_SUPPORT | SL_SI91X_EXT_TCP_IP_SSL_16K_RECORD
                      | SL_SI91X_CONFIG_FEAT_EXTENTION_VALID),
                   .ble_feature_bit_map     = 0,
                   .ble_ext_feature_bit_map = 0,
                   .config_feature_bit_map  = 0 }
};


void app_platform_init()
{
    sl_wifi_init(&_wifi_config, NULL, sl_wifi_default_event_handler);
    nvm3_open(nvm3_defaultHandle, nvm3_defaultInit);
}

void setNvm3End(uint32_t end_addr)
{
  // Unused
  (void) end_addr;
}