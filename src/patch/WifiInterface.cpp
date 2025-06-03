/*
 *
 *    Copyright (c) 2023 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/*
 * Modified by Flipper Devices Inc.
 * List of changes:
 *   - removed dependency on lwip
 *   - adapted for async silabs sockets
 */

/*
 * This file implements the interface to the wifi sdk
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if (SL_MATTER_GN_BUILD == 0)
#include "sl_matter_wifi_config.h"
#endif // SL_MATTER_GN_BUILD

#include "FreeRTOS.h"
#include "ble_config.h"
#include "event_groups.h"
#include "sl_status.h"
#include "sl_wifi_device.h"
#include "task.h"
#include <app/icd/server/ICDServerConfig.h>
#include <inet/IPAddress.h>
#include <lib/support/CHIPMem.h>
#include <lib/support/CHIPMemString.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/silabs/wifi/WifiInterfaceAbstraction.h>
#include <platform/silabs/wifi/wiseconnect-abstraction/WiseconnectInterfaceAbstraction.h>
#if (CHIP_DEVICE_CONFIG_ENABLE_IPV4)
#include <platform/silabs/wifi/lwip-support/dhcp_client.h>
#endif // CHIP_DEVICE_CONFIG_ENABLE_IPV4

extern "C" {
#include "sl_si91x_driver.h"
#include "sl_si91x_host_interface.h"
#include "sl_si91x_types.h"
#include "sl_wifi.h"
#include "sl_wifi_callback_framework.h"
#include "sl_wifi_constants.h"
#include "sl_wifi_types.h"
#if SL_MBEDTLS_USE_TINYCRYPT
#include "sl_si91x_constants.h"
#include "sl_si91x_trng.h"
#endif // SL_MBEDTLS_USE_TINYCRYPT

#include <sl_net.h>
#include <sl_net_constants.h>
// #include <sl_net_for_lwip.h>
#include <sl_net_wifi_types.h>
}

#if SLI_SI91X_MCU_INTERFACE
#include "rsi_wisemcu_hardware_setup.h"
#endif // SLI_SI91X_MCU_INTERFACE

#if (EXP_BOARD)
#include "rsi_bt_common_apis.h"
#include <platform/silabs/wifi/rs911x/platform/sl_board_configuration.h>
#endif

#if CHIP_CONFIG_ENABLE_ICD_SERVER
#include <app/icd/server/ICDConfigurationData.h> // nogncheck
#include <platform/silabs/wifi/icd/WifiSleepManager.h>

#if SLI_SI91X_MCU_INTERFACE
#include "rsi_rom_power_save.h"
#include "sl_gpio_board.h"
#include "sl_si91x_driver_gpio.h"
#include "sl_si91x_power_manager.h"
#endif // SLI_SI91X_MCU_INTERFACE
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER

#include <arpa/inet.h>
#include <ifaddrs.h>

// static const sl_wifi_device_configuration_t sl_wifi_config = {
//   .boot_option = LOAD_NWP_FW,
//   .mac_address = NULL,
//   .band        = SL_SI91X_WIFI_BAND_2_4GHZ,
//   .region_code = US,
//   .boot_config = { .oper_mode       = SL_SI91X_CLIENT_MODE,
//                    .coex_mode       = SL_SI91X_WLAN_ONLY_MODE,
//                    .feature_bit_map = (SL_SI91X_FEAT_AGGREGATION | SL_SI91X_FEAT_DISABLE_11AX_SUPPORT),
//                    .tcp_ip_feature_bit_map =
//                      (SL_SI91X_TCP_IP_FEAT_DHCPV4_CLIENT | SL_SI91X_TCP_IP_FEAT_DHCPV6_CLIENT
//                       | SL_SI91X_TCP_IP_FEAT_IPV6 | SL_SI91X_TCP_IP_FEAT_ICMP | SL_SI91X_TCP_IP_FEAT_EXTENSION_VALID
//                       | SL_SI91X_TCP_IP_FEAT_MDNSD),
//                    .custom_feature_bit_map     = SL_SI91X_CUSTOM_FEAT_EXTENTION_VALID,
//                    .ext_custom_feature_bit_map = (SL_SI91X_EXT_FEAT_XTAL_CLK | MEMORY_CONFIG
//                                                   | SL_SI91X_EXT_FEAT_FRONT_END_SWITCH_PINS_ULP_GPIO_4_5_0
//                                                   ),
//                    .bt_feature_bit_map         = 0,
//                    .ext_tcp_ip_feature_bit_map = SL_SI91X_CONFIG_FEAT_EXTENTION_VALID,
//                    .ble_feature_bit_map        = 0,
//                    .ble_ext_feature_bit_map    = 0,
//                    .config_feature_bit_map     = SL_SI91X_FEAT_SLEEP_GPIO_SEL_BITMAP }
// };

const sl_wifi_device_configuration_t sl_wifi_config = {
    .boot_option = LOAD_NWP_FW,
    .mac_address = NULL,
    .band = SL_SI91X_WIFI_BAND_2_4GHZ,
    .region_code = US,
    .boot_config =
        {
            .oper_mode = SL_SI91X_CLIENT_MODE,
            .coex_mode = SL_SI91X_WLAN_BLE_MODE,
            .feature_bit_map =
                (SL_SI91X_FEAT_SECURITY_OPEN | SL_SI91X_FEAT_AGGREGATION |
                 SL_SI91X_FEAT_ULP_GPIO_BASED_HANDSHAKE | SL_SI91X_FEAT_DEV_TO_HOST_ULP_GPIO_1),
            .tcp_ip_feature_bit_map =
                (SL_SI91X_TCP_IP_FEAT_DHCPV4_CLIENT | SL_SI91X_TCP_IP_FEAT_EXTENSION_VALID |
                 SL_SI91X_TCP_IP_FEAT_DNS_CLIENT | SL_SI91X_TCP_IP_FEAT_SSL |
                 SL_SI91X_TCP_IP_FEAT_DHCPV6_CLIENT | SL_SI91X_TCP_IP_FEAT_IPV6),
            .custom_feature_bit_map =
                (SL_SI91X_CUSTOM_FEAT_EXTENTION_VALID | SL_SI91X_CUSTOM_FEAT_SOC_CLK_CONFIG_120MHZ),
            .ext_custom_feature_bit_map =
                (SL_SI91X_EXT_FEAT_XTAL_CLK | MEMORY_CONFIG
#ifdef SLI_SI917
                 | SL_SI91X_EXT_FEAT_FRONT_END_SWITCH_PINS_ULP_GPIO_4_5_0
#endif
                 | SL_SI91X_EXT_FEAT_BT_CUSTOM_FEAT_ENABLE),
            .bt_feature_bit_map = (SL_SI91X_BT_RF_TYPE | SL_SI91X_ENABLE_BLE_PROTOCOL),
#ifdef RSI_PROCESS_MAX_RX_DATA
            .ext_tcp_ip_feature_bit_map =
                (SL_SI91X_CONFIG_FEAT_EXTENTION_VALID | SL_SI91X_EXT_TCP_MAX_RECV_LENGTH),
#else
            .ext_tcp_ip_feature_bit_map =
                (SL_SI91X_EXT_TCP_IP_WINDOW_DIV | SL_SI91X_CONFIG_FEAT_EXTENTION_VALID),
#endif
            //!ENABLE_BLE_PROTOCOL in bt_feature_bit_map
            .ble_feature_bit_map =
                ((SL_SI91X_BLE_MAX_NBR_PERIPHERALS(RSI_BLE_MAX_NBR_PERIPHERALS) |
                  SL_SI91X_BLE_MAX_NBR_CENTRALS(RSI_BLE_MAX_NBR_CENTRALS) |
                  SL_SI91X_BLE_MAX_NBR_ATT_SERV(RSI_BLE_MAX_NBR_ATT_SERV) |
                  SL_SI91X_BLE_MAX_NBR_ATT_REC(RSI_BLE_MAX_NBR_ATT_REC)) |
                 SL_SI91X_FEAT_BLE_CUSTOM_FEAT_EXTENTION_VALID |
                 SL_SI91X_BLE_PWR_INX(RSI_BLE_PWR_INX) |
                 SL_SI91X_BLE_PWR_SAVE_OPTIONS(RSI_BLE_PWR_SAVE_OPTIONS) |
                 SL_SI91X_916_BLE_COMPATIBLE_FEAT_ENABLE
#if RSI_BLE_GATT_ASYNC_ENABLE
                 | SL_SI91X_BLE_GATT_ASYNC_ENABLE
#endif
                 ),
            .ble_ext_feature_bit_map =
                ((SL_SI91X_BLE_NUM_CONN_EVENTS(RSI_BLE_NUM_CONN_EVENTS) |
                  SL_SI91X_BLE_NUM_REC_BYTES(RSI_BLE_NUM_REC_BYTES))
#if RSI_BLE_INDICATE_CONFIRMATION_FROM_HOST
                 | SL_SI91X_BLE_INDICATE_CONFIRMATION_FROM_HOST //indication response from app
#endif
#if RSI_BLE_MTU_EXCHANGE_FROM_HOST
                 | SL_SI91X_BLE_MTU_EXCHANGE_FROM_HOST //MTU Exchange request initiation from app
#endif
#if RSI_BLE_SET_SCAN_RESP_DATA_FROM_HOST
                 | (SL_SI91X_BLE_SET_SCAN_RESP_DATA_FROM_HOST) //Set SCAN Resp Data from app
#endif
#if RSI_BLE_DISABLE_CODED_PHY_FROM_HOST
                 | (SL_SI91X_BLE_DISABLE_CODED_PHY_FROM_HOST) //Disable Coded PHY from app
#endif
#if BLE_SIMPLE_GATT
                 | SL_SI91X_BLE_GATT_INIT
#endif
                 ),
            .config_feature_bit_map = SL_SI91X_FEAT_SLEEP_GPIO_SEL_BITMAP,
        },
    .ta_pool =
        {
            .tx_ratio_in_buffer_pool = 1,
            .rx_ratio_in_buffer_pool = 1,
            .global_ratio_in_buffer_pool = 1,
        },
};

WfxRsi_t wfx_rsi;

namespace {

#if CHIP_CONFIG_ENABLE_ICD_SERVER

constexpr uint32_t kTimeToFullBeaconReception = 5000; // 5 seconds

#if SLI_SI91X_MCU_INTERFACE
// TODO: should be removed once we are getting the press interrupt for button 0 with sleep
bool btn0_pressed = false;
#ifdef ENABLE_CHIP_SHELL
bool ps_requirement_added = false;
#endif // ENABLE_CHIP_SHELL
#endif // SLI_SI91X_MCU_INTERFACE
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER

bool hasNotifiedWifiConnectivity = false;
bool hasNotifiedIPV6             = false;
#if (CHIP_DEVICE_CONFIG_ENABLE_IPV4)
bool hasNotifiedIPV4 = false;
#endif /* CHIP_DEVICE_CONFIG_ENABLE_IPV4 */

wfx_wifi_scan_ext_t temp_reset;

osSemaphoreId_t sScanCompleteSemaphore;
osSemaphoreId_t sScanInProgressSemaphore;
osTimerId_t sDHCPTimer;
osMessageQueueId_t sWifiEventQueue = nullptr;

sl_wifi_security_t security = SL_WIFI_SECURITY_UNKNOWN;

// TODO : Temporary work-around for wifi-init failure in 917NCP ACX module board(BRD4357A). Can be removed after
// Wiseconnect fixes region code for all ACX module boards.
#ifdef EXP_BOARD
#define REGION_CODE IGNORE_REGION
#else
#define REGION_CODE US
#endif // EXP_BOARD

// const sl_wifi_device_configuration_t config = {
//     .boot_option = LOAD_NWP_FW,
//     .mac_address = NULL,
//     .band        = SL_SI91X_WIFI_BAND_2_4GHZ,
//     .region_code = REGION_CODE,
//     .boot_config = { .oper_mode = SL_SI91X_CLIENT_MODE,
//                      .coex_mode = SL_SI91X_WLAN_BLE_MODE,
//                      .feature_bit_map =
// #ifdef SLI_SI91X_MCU_INTERFACE
//                          (SL_SI91X_FEAT_SECURITY_OPEN | SL_SI91X_FEAT_WPS_DISABLE),
// #else
//                          (SL_SI91X_FEAT_SECURITY_OPEN | SL_SI91X_FEAT_AGGREGATION),
// #endif
//                      .tcp_ip_feature_bit_map = (SL_SI91X_TCP_IP_FEAT_DHCPV4_CLIENT | SL_SI91X_TCP_IP_FEAT_DNS_CLIENT |
//                                                 SL_SI91X_TCP_IP_FEAT_SSL | SL_SI91X_TCP_IP_FEAT_BYPASS
// #ifdef ipv6_FEATURE_REQUIRED
//                                                 | SL_SI91X_TCP_IP_FEAT_DHCPV6_CLIENT | SL_SI91X_TCP_IP_FEAT_IPV6
// #endif
//                                                 | SL_SI91X_TCP_IP_FEAT_ICMP | SL_SI91X_TCP_IP_FEAT_EXTENSION_VALID),
//                      .custom_feature_bit_map     = (SL_SI91X_CUSTOM_FEAT_EXTENTION_VALID | RSI_CUSTOM_FEATURE_BIT_MAP),
//                      .ext_custom_feature_bit_map = (RSI_EXT_CUSTOM_FEATURE_BIT_MAP | (SL_SI91X_EXT_FEAT_BT_CUSTOM_FEAT_ENABLE)
// #if (defined A2DP_POWER_SAVE_ENABLE)
//                                                     | SL_SI91X_EXT_FEAT_XTAL_CLK_ENABLE(2)
// #endif
//                                                         ),
//                      .bt_feature_bit_map = (RSI_BT_FEATURE_BITMAP
// #if (RSI_BT_GATT_ON_CLASSIC)
//                                             | SL_SI91X_BT_ATT_OVER_CLASSIC_ACL /* to support att over classic acl link */
// #endif
//                                             ),
// #ifdef RSI_PROCESS_MAX_RX_DATA
//                      .ext_tcp_ip_feature_bit_map =
//                          (RSI_EXT_TCPIP_FEATURE_BITMAP | SL_SI91X_CONFIG_FEAT_EXTENTION_VALID | SL_SI91X_EXT_TCP_MAX_RECV_LENGTH),
// #else
//                      .ext_tcp_ip_feature_bit_map = (RSI_EXT_TCPIP_FEATURE_BITMAP | SL_SI91X_CONFIG_FEAT_EXTENTION_VALID),
// #endif
//                      //! ENABLE_BLE_PROTOCOL in bt_feature_bit_map
//                      .ble_feature_bit_map =
//                          ((SL_SI91X_BLE_MAX_NBR_PERIPHERALS(RSI_BLE_MAX_NBR_PERIPHERALS) |
//                            SL_SI91X_BLE_MAX_NBR_CENTRALS(RSI_BLE_MAX_NBR_CENTRALS) |
//                            SL_SI91X_BLE_MAX_NBR_ATT_SERV(RSI_BLE_MAX_NBR_ATT_SERV) |
//                            SL_SI91X_BLE_MAX_NBR_ATT_REC(RSI_BLE_MAX_NBR_ATT_REC)) |
//                           SL_SI91X_FEAT_BLE_CUSTOM_FEAT_EXTENTION_VALID | SL_SI91X_BLE_PWR_INX(RSI_BLE_PWR_INX) |
//                           SL_SI91X_BLE_PWR_SAVE_OPTIONS(RSI_BLE_PWR_SAVE_OPTIONS) | SL_SI91X_916_BLE_COMPATIBLE_FEAT_ENABLE
// #if RSI_BLE_GATT_ASYNC_ENABLE
//                           | SL_SI91X_BLE_GATT_ASYNC_ENABLE
// #endif
//                           ),

//                      .ble_ext_feature_bit_map = ((SL_SI91X_BLE_NUM_CONN_EVENTS(RSI_BLE_NUM_CONN_EVENTS) |
//                                                   SL_SI91X_BLE_NUM_REC_BYTES(RSI_BLE_NUM_REC_BYTES))
// #if RSI_BLE_INDICATE_CONFIRMATION_FROM_HOST
//                                                  | SL_SI91X_BLE_INDICATE_CONFIRMATION_FROM_HOST // indication response from app
// #endif
// #if RSI_BLE_MTU_EXCHANGE_FROM_HOST
//                                                  | SL_SI91X_BLE_MTU_EXCHANGE_FROM_HOST // MTU Exchange request initiation from app
// #endif
// #if RSI_BLE_SET_SCAN_RESP_DATA_FROM_HOST
//                                                  | (SL_SI91X_BLE_SET_SCAN_RESP_DATA_FROM_HOST) // Set SCAN Resp Data from app
// #endif
// #if RSI_BLE_DISABLE_CODED_PHY_FROM_HOST
//                                                  | (SL_SI91X_BLE_DISABLE_CODED_PHY_FROM_HOST) // Disable Coded PHY from app
// #endif
// #if BLE_SIMPLE_GATT
//                                                  | SL_SI91X_BLE_GATT_INIT
// #endif
//                                                  ),
//                      .config_feature_bit_map = (SL_SI91X_FEAT_SLEEP_GPIO_SEL_BITMAP | RSI_CONFIG_FEATURE_BITMAP) }
// };

// static const sl_wifi_device_configuration_t config = {
//   .boot_option = LOAD_NWP_FW,
//   .mac_address = NULL,
//   .band        = SL_SI91X_WIFI_BAND_2_4GHZ,
//   .region_code = REGION_CODE,
//   .boot_config = { .oper_mode              = SL_SI91X_CLIENT_MODE,
//                    .coex_mode              = SL_SI91X_WLAN_ONLY_MODE,
//                    .feature_bit_map        = SL_SI91X_FEAT_SECURITY_OPEN | SL_SI91X_FEAT_AGGREGATION,
//                    .tcp_ip_feature_bit_map = (SL_SI91X_TCP_IP_FEAT_DHCPV4_CLIENT | SL_SI91X_TCP_IP_FEAT_DNS_CLIENT
//                                               | SL_SI91X_TCP_IP_FEAT_SSL | SL_SI91X_TCP_IP_FEAT_BYPASS
//                                               | SL_SI91X_TCP_IP_FEAT_ICMP | SL_SI91X_TCP_IP_FEAT_EXTENSION_VALID
//                                               | SL_SI91X_TCP_IP_FEAT_DHCPV6_CLIENT | SL_SI91X_TCP_IP_FEAT_IPV6),
//                    .custom_feature_bit_map = (SL_SI91X_CUSTOM_FEAT_EXTENTION_VALID),
//                    .ext_custom_feature_bit_map = 0,
//                    .bt_feature_bit_map         = 0,
//                    .ext_tcp_ip_feature_bit_map = SL_SI91X_CONFIG_FEAT_EXTENTION_VALID,
//                    .ble_feature_bit_map        = 0,
//                    .ble_ext_feature_bit_map    = 0,
//                    .config_feature_bit_map     = SL_SI91X_FEAT_SLEEP_GPIO_SEL_BITMAP }
// };

constexpr int8_t kAdvScanThreshold           = -40;
constexpr uint8_t kAdvRssiToleranceThreshold = 5;
constexpr uint8_t kAdvActiveScanDuration     = 15;
constexpr uint8_t kAdvPassiveScanDuration    = 20;
constexpr uint8_t kAdvMultiProbe             = 1;
constexpr uint8_t kAdvEnableInstantbgScan    = 1;
constexpr uint8_t kAdvScanPeriodicity        = 10;

// TODO: Confirm that this value works for size and timing
constexpr uint8_t kWfxQueueSize = 10;

// TODO: Figure out why we actually need this, we are already handling failure and retries somewhere else.
constexpr uint16_t kWifiScanTimeoutTicks = 10000;

sl_status_t sl_wifi_siwx917_init(void)
{
    sl_status_t status = SL_STATUS_OK;

#ifdef SLI_SI91X_MCU_INTERFACE
    // SoC Configurations
    uint8_t xtal_enable = 1;
    status              = sl_si91x_m4_ta_secure_handshake(SL_SI91X_ENABLE_XTAL, 1, &xtal_enable, 0, nullptr);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_si91x_m4_ta_secure_handshake failed: 0x%lx", static_cast<uint32_t>(status)));

#if CHIP_CONFIG_ENABLE_ICD_SERVER
#ifdef ENABLE_CHIP_SHELL
    // While using the matter shell with a Low Power Build, GPIO 1 is used to check the UULP PIN 1 status
    // since UART doesn't act as a wakeup source in the UULP mode.

    // Configuring the NPS GPIO 1
    RSI_NPSSGPIO_SetPinMux(RTE_UULP_GPIO_1_PIN, 0);

    // Configure the NPSS GPIO direction to input
    RSI_NPSSGPIO_SetDir(RTE_UULP_GPIO_1_PIN, 1);

    // Enable the REN
    RSI_NPSSGPIO_InputBufferEn(RTE_UULP_GPIO_1_PIN, 1);
#endif // ENABLE_CHIP_SHELL
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER
#endif // SLI_SI91X_MCU_INTERFACE

    sl_wifi_firmware_version_t version = { 0 };
    status                             = sl_wifi_get_firmware_version(&version);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_wifi_get_firmware_version failed: 0x%lx", static_cast<uint32_t>(status)));

    ChipLogDetail(DeviceLayer, "Firmware version is: %x%x.%d.%d.%d.%d.%d.%d", version.chip_id, version.rom_id, version.major,
                  version.minor, version.security_version, version.patch_num, version.customer_id, version.build_num);

    status = sl_wifi_get_mac_address(SL_WIFI_CLIENT_INTERFACE, (sl_mac_address_t *) &wfx_rsi.sta_mac.octet[0]);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_wifi_get_mac_address failed: 0x%lx", static_cast<uint32_t>(status)));

#ifdef SL_MBEDTLS_USE_TINYCRYPT
    constexpr uint32_t trngKey[TRNG_KEY_SIZE] = { 0x16157E2B, 0xA6D2AE28, 0x8815F7AB, 0x3C4FCF09 };

    // To check the Entropy of TRNG and verify TRNG functioning.
    status = sl_si91x_trng_entropy();
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_si91x_trng_entropy failed: 0x%lx", static_cast<uint32_t>(status)));

    // Initiate and program the key required for TRNG hardware engine
    status = sl_si91x_trng_program_key((uint32_t *) trngKey, TRNG_KEY_SIZE);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_si91x_trng_program_key failed: 0x%lx", static_cast<uint32_t>(status)));
#endif // SL_MBEDTLS_USE_TINYCRYPT

    wfx_rsi.dev_state.Set(WifiState::kStationInit);
    return status;
}

sl_status_t ScanCallback(sl_wifi_event_t event, sl_wifi_scan_result_t * scan_result, uint32_t result_length, void * arg)
{
    sl_status_t status = SL_STATUS_OK;
    if (SL_WIFI_CHECK_IF_EVENT_FAILED(event))
    {
        if (scan_result != nullptr)
        {
            status = *reinterpret_cast<sl_status_t *>(scan_result);
            ChipLogError(DeviceLayer, "ScanCallback: failed: 0x%lx", static_cast<uint32_t>(status));
        }

#if WIFI_ENABLE_SECURITY_WPA3_TRANSITION
        security = SL_WIFI_WPA3;
#else
        security = SL_WIFI_WPA_WPA2_MIXED;
#endif /* WIFI_ENABLE_SECURITY_WPA3_TRANSITION */
    }
    else
    {
        security        = static_cast<sl_wifi_security_t>(scan_result->scan_info[0].security_mode);
        wfx_rsi.ap_chan = scan_result->scan_info[0].rf_channel;
        memcpy(&wfx_rsi.ap_mac.octet, scan_result->scan_info[0].bssid, BSSID_LEN);
    }

    osSemaphoreRelease(sScanCompleteSemaphore);
    return status;
}

sl_status_t InitiateScan()
{
    sl_status_t status = SL_STATUS_OK;

    sl_wifi_ssid_t ssid = { 0 };

    // TODO: this changes will be reverted back after the Silabs WiFi SDK team fix the scan API
    sl_wifi_scan_configuration_t wifi_scan_configuration = default_wifi_scan_configuration;

    ssid.length = wfx_rsi.sec.ssid_length;

    // TODO: workaround because the string management with the null termination is flawed
    chip::Platform::CopyString((char *) &ssid.value[0], ssid.length + 1, wfx_rsi.sec.ssid);
    sl_wifi_set_scan_callback(ScanCallback, NULL);

    osSemaphoreAcquire(sScanInProgressSemaphore, osWaitForever);

    // This is an odd success code?
    status = sl_wifi_start_scan(SL_WIFI_CLIENT_2_4GHZ_INTERFACE, &ssid, &wifi_scan_configuration);
    if (status == SL_STATUS_IN_PROGRESS)
    {
        osSemaphoreAcquire(sScanCompleteSemaphore, kWifiScanTimeoutTicks);
        status = SL_STATUS_OK;
    }

    osSemaphoreRelease(sScanInProgressSemaphore);

    return status;
}

sl_status_t SetWifiConfigurations()
{
    sl_status_t status = SL_STATUS_OK;

#if CHIP_CONFIG_ENABLE_ICD_SERVER
    // [sl-only] Set the listen interval to the slow polling interval during association
    sl_wifi_listen_interval_t sleep_interval = { .listen_interval =
                                                     chip::ICDConfigurationData::GetInstance().GetSlowPollingInterval().count() };
    status                                   = sl_wifi_set_listen_interval(SL_WIFI_CLIENT_INTERFACE, sleep_interval);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_wifi_set_listen_interval failed: 0x%lx", status));

    sl_wifi_advanced_client_configuration_t client_config = { .max_retry_attempts = 5 };
    status = sl_wifi_set_advanced_client_configuration(SL_WIFI_CLIENT_INTERFACE, &client_config);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_wifi_set_advanced_client_configuration failed: 0x%lx", status));

    // [sl-only] Required configuration for listen interval changes at runtime
    status = sl_si91x_set_join_configuration(
        SL_WIFI_CLIENT_INTERFACE, (SL_SI91X_JOIN_FEAT_LISTEN_INTERVAL_VALID | SL_SI91X_JOIN_FEAT_PS_CMD_LISTEN_INTERVAL_VALID));
    VerifyOrReturnError(status == SL_STATUS_OK, status);
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER

    if (wfx_rsi.sec.passkey_length != 0)
    {
        status = sl_net_set_credential(SL_NET_DEFAULT_WIFI_CLIENT_CREDENTIAL_ID, SL_NET_WIFI_PSK, &wfx_rsi.sec.passkey[0],
                                       wfx_rsi.sec.passkey_length);
        // status = sl_net_set_credential(SL_NET_DEFAULT_WIFI_CLIENT_CREDENTIAL_ID, SL_NET_WIFI_PSK, "susamogus", 9);
        VerifyOrReturnError(status == SL_STATUS_OK, status,
                            ChipLogError(DeviceLayer, "sl_net_set_credential failed: 0x%lx", status));
    }

    sl_net_wifi_client_profile_t profile = {
        .config = {
            .ssid = {
                //static cast because the types dont match
                .length = static_cast<uint8_t>(wfx_rsi.sec.ssid_length),
                // .length = 4,
            },
            .channel = {
                .channel = SL_WIFI_AUTO_CHANNEL,
                .band = SL_WIFI_AUTO_BAND,
                .bandwidth = SL_WIFI_AUTO_BANDWIDTH
            },
            .bssid = {{0}},
            .bss_type = SL_WIFI_BSS_TYPE_INFRASTRUCTURE,
            // .security = security,
            .security = SL_WIFI_WPA_WPA2_MIXED,
            .encryption = SL_WIFI_DEFAULT_ENCRYPTION,
            .client_options = SL_WIFI_JOIN_WITH_SCAN,
            // .client_options = SL_WIFI_NO_JOIN_OPTION,
            .credential_id = SL_NET_DEFAULT_WIFI_CLIENT_CREDENTIAL_ID,
        },
        .ip = {
            .mode = SL_IP_MANAGEMENT_DHCP,
            // .mode = SL_IP_MANAGEMENT_LINK_LOCAL,
            .type = SL_IPV6,
            .host_name = "busybar",
            .ip = {{{0}}},
        }
    };
    // TODO: memcpy for now since the types dont match
    memcpy((char *) &profile.config.ssid.value, wfx_rsi.sec.ssid, wfx_rsi.sec.ssid_length);
    // memcpy(profile.config.ssid.value, "psi3", 4);

    status = sl_net_set_profile((sl_net_interface_t) SL_NET_WIFI_CLIENT_INTERFACE, SL_NET_DEFAULT_WIFI_CLIENT_PROFILE_ID, &profile);
    VerifyOrReturnError(status == SL_STATUS_OK, status, ChipLogError(DeviceLayer, "sl_net_set_profile failed: 0x%lx", status));

    return status;
}

/**
 * @brief Callback function for the SL_WIFI_JOIN_EVENTS group
 *
 * This callback handler will be invoked when any event within join event group occurs, providing the event details and any
 * associated data The callback doesn't get called when we join a network using the sl net APIs
 *
 * @note In case of failure, the 'result' parameter will be of type sl_status_t, and the 'resultLenght' parameter should be ignored
 *
 * @param[in] event sl_wifi_event_t that triggered the callback
 * @param[in] result Pointer to the response data received
 * @param[in] result_length Length of the data received in bytes
 * @param[in] arg Optional user provided argument
 *
 * @return sl_status_t Returns the status of the operation
 */
sl_status_t JoinCallback(sl_wifi_event_t event, char * result, uint32_t resultLenght, void * arg)
{
    sl_status_t status = SL_STATUS_OK;
    wfx_rsi.dev_state.Clear(WifiState::kStationConnecting);
    if (SL_WIFI_CHECK_IF_EVENT_FAILED(event))
    {
        status = *reinterpret_cast<sl_status_t *>(result);
        ChipLogError(DeviceLayer, "JoinCallback: failed: 0x%lx", static_cast<uint32_t>(status));
        wfx_rsi.dev_state.Clear(WifiState::kStationConnected);
        wfx_retry_connection(++wfx_rsi.join_retries);
        return status;
    }

    /*
     * Join was complete - Do the DHCP
     */
    ChipLogDetail(DeviceLayer, "JoinCallback: success");
    memset(&temp_reset, 0, sizeof(temp_reset));

    WifiEvent wifievent = WifiEvent::kStationConnect;
    sl_matter_wifi_post_event(wifievent);
    wfx_rsi.join_retries = 0;
    return status;
}
sl_status_t JoinWifiNetwork(void)
{
    VerifyOrReturnError(!wfx_rsi.dev_state.HasAny(WifiState::kStationConnecting, WifiState::kStationConnected),
                        SL_STATUS_IN_PROGRESS);
    sl_status_t status = SL_STATUS_OK;

    // Start Join Network
    wfx_rsi.dev_state.Set(WifiState::kStationConnecting);

    status = SetWifiConfigurations();
    VerifyOrReturnError(status == SL_STATUS_OK, status, ChipLogError(DeviceLayer, "Failure to set the Wifi Configurations!"));

    status = sl_wifi_set_join_callback(JoinCallback, nullptr);
    VerifyOrReturnError(status == SL_STATUS_OK, status);

    status = sl_net_up((sl_net_interface_t) SL_NET_WIFI_CLIENT_INTERFACE, SL_NET_DEFAULT_WIFI_CLIENT_PROFILE_ID);

    if (status == SL_STATUS_OK)
    {
#if CHIP_CONFIG_ENABLE_ICD_SERVER
        // Remove High performance request that might have been added during the connect/retry process
        chip::DeviceLayer::Silabs::WifiSleepManager::GetInstance().RemoveHighPerformanceRequest();
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER
        WifiEvent event = WifiEvent::kStationConnect;
        sl_matter_wifi_post_event(event);
        return status;
    }

    // failure only happens when the firmware returns an error
    ChipLogError(DeviceLayer, "sl_net_up failed: 0x%lx", static_cast<uint32_t>(status));

    wfx_rsi.dev_state.Clear(WifiState::kStationConnecting).Clear(WifiState::kStationConnected);

    ChipLogProgress(DeviceLayer, "Connection retry attempt %d", wfx_rsi.join_retries);
    wfx_retry_connection(++wfx_rsi.join_retries);

    return status;
}

} // namespace

void NotifyConnectivity(void);

static sl_status_t sl_matter_wifi_event_handler(sl_net_event_t event, sl_status_t status, void *data, uint32_t data_length) {
    ChipLogDetail(DeviceLayer, "net event=0x%x status=0x%lx data=%p data_len=%u", event, status, data, data_length);

    if(event == SL_NET_IP_ADDRESS_CHANGE_EVENT && status == SL_STATUS_OK && !hasNotifiedIPV6) {
        char addrStr[chip::Inet::IPAddress::kMaxStringLength] = { 0 };
        
        struct ifaddrs* ifaddrs;
        if(getifaddrs(&ifaddrs) >= 0) {
            struct ifaddrs* address = ifaddrs;
            while(address && address->ifa_addr) {
                inet_ntop(address->ifa_addr->sa_family, address->ifa_addr->sa_data, addrStr, sizeof(addrStr));
                ChipLogProgress(DeviceLayer, "IP: %s", addrStr);
                address = address->ifa_next;
            }
            freeifaddrs(ifaddrs);
        } else {
            ChipLogError(DeviceLayer, "getifaddrs failed");
        }
        
        wfx_ipv6_notify(GET_IPV6_SUCCESS);
        hasNotifiedIPV6 = true;
        NotifyConnectivity();
    }

    return SL_STATUS_OK;
}

/**
 * @brief Wifi initialization called from app main
 *
 * @return sl_status_t Returns underlying Wi-Fi initialization error
 */
sl_status_t sl_matter_wifi_platform_init(void)
{
    sl_status_t status = SL_STATUS_OK;

    status = sl_net_init((sl_net_interface_t) SL_NET_WIFI_CLIENT_INTERFACE, &sl_wifi_config, nullptr, sl_matter_wifi_event_handler);
    VerifyOrReturnError(status == SL_STATUS_OK, status, ChipLogError(DeviceLayer, "sl_net_init failed: %lx", status));

    // Create Sempaphore for scan completion
    sScanCompleteSemaphore = osSemaphoreNew(1, 0, nullptr);
    VerifyOrReturnError(sScanCompleteSemaphore != nullptr, SL_STATUS_ALLOCATION_FAILED);

    // Create Semaphore for scan in-progress protection
    sScanInProgressSemaphore = osSemaphoreNew(1, 1, nullptr);
    VerifyOrReturnError(sScanCompleteSemaphore != nullptr, SL_STATUS_ALLOCATION_FAILED);

    // Create the message queue
    sWifiEventQueue = osMessageQueueNew(kWfxQueueSize, sizeof(WifiEvent), nullptr);
    VerifyOrReturnError(sWifiEventQueue != nullptr, SL_STATUS_ALLOCATION_FAILED);

    return status;
}

/******************************************************************
 * @fn   int32_t wfx_rsi_get_ap_info(wfx_wifi_scan_result_t *ap)
 * @brief
 *       Getting the AP details
 * @param[in] ap: access point
 * @return
 *        status
 *********************************************************************/
int32_t wfx_rsi_get_ap_info(wfx_wifi_scan_result_t * ap)
{
    sl_status_t status = SL_STATUS_OK;
    int32_t rssi       = 0;
    ap->ssid_length    = wfx_rsi.sec.ssid_length;
    ap->security       = wfx_rsi.sec.security;
    ap->chan           = wfx_rsi.ap_chan;
    chip::Platform::CopyString(ap->ssid, ap->ssid_length, wfx_rsi.sec.ssid);
    memcpy(&ap->bssid[0], &wfx_rsi.ap_mac.octet[0], BSSID_LEN);
    sl_wifi_get_signal_strength(SL_WIFI_CLIENT_INTERFACE, &rssi);
    ap->rssi = rssi;
    return status;
}

/******************************************************************
 * @fn   int32_t wfx_rsi_get_ap_ext(wfx_wifi_scan_ext_t *extra_info)
 * @brief
 *       Getting the AP extra details
 * @param[in] extra info: access point extra information
 * @return
 *        status
 *********************************************************************/
int32_t wfx_rsi_get_ap_ext(wfx_wifi_scan_ext_t * extra_info)
{
    sl_status_t status        = SL_STATUS_OK;
    sl_wifi_statistics_t test = { 0 };
    status                    = sl_wifi_get_statistics(SL_WIFI_CLIENT_INTERFACE, &test);
    VERIFY_STATUS_AND_RETURN(status);
    extra_info->beacon_lost_count = test.beacon_lost_count - temp_reset.beacon_lost_count;
    extra_info->beacon_rx_count   = test.beacon_rx_count - temp_reset.beacon_rx_count;
    extra_info->mcast_rx_count    = test.mcast_rx_count - temp_reset.mcast_rx_count;
    extra_info->mcast_tx_count    = test.mcast_tx_count - temp_reset.mcast_tx_count;
    extra_info->ucast_rx_count    = test.ucast_rx_count - temp_reset.ucast_rx_count;
    extra_info->ucast_tx_count    = test.ucast_tx_count - temp_reset.ucast_tx_count;
    extra_info->overrun_count     = test.overrun_count - temp_reset.overrun_count;
    return status;
}

/******************************************************************
 * @fn   int32_t wfx_rsi_reset_count(void)
 * @brief
 *       Getting the driver reset count
 * @param[in] None
 * @return
 *        status
 *********************************************************************/
int32_t wfx_rsi_reset_count(void)
{
    sl_wifi_statistics_t test = { 0 };
    sl_status_t status        = SL_STATUS_OK;
    status                    = sl_wifi_get_statistics(SL_WIFI_CLIENT_INTERFACE, &test);
    VERIFY_STATUS_AND_RETURN(status);
    temp_reset.beacon_lost_count = test.beacon_lost_count;
    temp_reset.beacon_rx_count   = test.beacon_rx_count;
    temp_reset.mcast_rx_count    = test.mcast_rx_count;
    temp_reset.mcast_tx_count    = test.mcast_tx_count;
    temp_reset.ucast_rx_count    = test.ucast_rx_count;
    temp_reset.ucast_tx_count    = test.ucast_tx_count;
    temp_reset.overrun_count     = test.overrun_count;
    return status;
}

/******************************************************************
 * @fn   sl_wifi_platform_disconnect(void)
 * @brief
 *       Getting the driver disconnect status
 * @param[in] None
 * @return
 *        status
 *********************************************************************/
int32_t sl_wifi_platform_disconnect(void)
{
    return sl_net_down((sl_net_interface_t) SL_NET_WIFI_CLIENT_INTERFACE);
}

sl_status_t show_scan_results(sl_wifi_scan_result_t * scan_result)
{
    SL_WIFI_ARGS_CHECK_NULL_POINTER(scan_result);
    VerifyOrReturnError(wfx_rsi.scan_cb != nullptr, SL_STATUS_INVALID_HANDLE);

    wfx_wifi_scan_result_t cur_scan_result;
    for (int idx = 0; idx < (int) scan_result->scan_count; idx++)
    {
        memset(&cur_scan_result, 0, sizeof(cur_scan_result));

        cur_scan_result.ssid_length = strnlen((char *) scan_result->scan_info[idx].ssid,
                                              chip::min<size_t>(sizeof(scan_result->scan_info[idx].ssid), WFX_MAX_SSID_LENGTH));
        // cur_scan_result.ssid is of size WFX_MAX_SSID_LENGTH+1, we are safe with the cur_scan_result.ssid_length calculated above
        chip::Platform::CopyString(cur_scan_result.ssid, cur_scan_result.ssid_length + 1,
                                   (char *) scan_result->scan_info[idx].ssid); // +1 for null termination

        // if user has provided ssid, then check if the current scan result ssid matches the user provided ssid
        if (wfx_rsi.scan_ssid != nullptr && 
            (strlen(wfx_rsi.scan_ssid) != strlen(cur_scan_result.ssid) || 
             strncmp(wfx_rsi.scan_ssid, cur_scan_result.ssid, strlen(wfx_rsi.scan_ssid)) != 0))
        {
            continue;
        }
        cur_scan_result.security = static_cast<wfx_sec_t>(scan_result->scan_info[idx].security_mode);
        cur_scan_result.rssi     = (-1) * scan_result->scan_info[idx].rssi_val;
        memcpy(cur_scan_result.bssid, scan_result->scan_info[idx].bssid, BSSID_LEN);
        wfx_rsi.scan_cb(&cur_scan_result);

        // if user has not provided the ssid, then call the callback for each scan result
        if (wfx_rsi.scan_ssid == nullptr)
        {
            continue;
        }
        break;
    }

    // cleanup and return
    wfx_rsi.dev_state.Clear(WifiState::kScanStarted);
    wfx_rsi.scan_cb((wfx_wifi_scan_result_t *) 0);
    wfx_rsi.scan_cb = nullptr;
    if (wfx_rsi.scan_ssid)
    {
        chip::Platform::MemoryFree(wfx_rsi.scan_ssid);
        wfx_rsi.scan_ssid = nullptr;
    }
    return SL_STATUS_OK;
}

sl_status_t bg_scan_callback_handler(sl_wifi_event_t event, sl_wifi_scan_result_t * result, uint32_t result_length, void * arg)
{
    show_scan_results(result); // To do Check error
    osSemaphoreRelease(sScanCompleteSemaphore);
    return SL_STATUS_OK;
}

/// NotifyConnectivity
/// @brief Notify the application about the connectivity status if it has not been notified yet.
///        Helper function for HandleDHCPPolling.
void NotifyConnectivity(void)
{
    VerifyOrReturn(!hasNotifiedWifiConnectivity);
    wfx_connected_notify(CONNECTION_STATUS_SUCCESS, &wfx_rsi.ap_mac);
    hasNotifiedWifiConnectivity = true;
}

void sl_matter_wifi_post_event(WifiEvent event)
{
    sl_status_t status = osMessageQueuePut(sWifiEventQueue, &event, 0, 0);

    if (status != osOK)
    {
        ChipLogError(DeviceLayer, "sl_matter_wifi_post_event: failed to post event with status: %ld", status);
        // TODO: Handle error, requeue event depending on queue size or notify relevant task,
        // Chipdie, etc.
    }
}

void ProcessEvent(WifiEvent event)
{
    // Process event
    switch (event)
    {
    case WifiEvent::kStationConnect:
        ChipLogDetail(DeviceLayer, "WifiEvent::kStationConnect");
        wfx_rsi.dev_state.Set(WifiState::kStationConnected);
        hasNotifiedIPV6 = false;
        break;

    case WifiEvent::kStationDisconnect: {
        ChipLogDetail(DeviceLayer, "WifiEvent::kStationDisconnect");
        // TODO: This event is not being posted anywhere, seems to be a dead code or we are missing something

        wfx_rsi.dev_state.Clear(WifiState::kStationReady)
            .Clear(WifiState::kStationConnecting)
            .Clear(WifiState::kStationConnected)
            .Clear(WifiState::kStationDhcpDone);

        /* TODO: Implement disconnect notify */
        hasNotifiedIPV6 = false;
#if (CHIP_DEVICE_CONFIG_ENABLE_IPV4)
        wfx_ip_changed_notify(0); // for IPV4
        wfx_ip_changed_notify(IP_STATUS_FAIL);
#endif /* CHIP_DEVICE_CONFIG_ENABLE_IPV4 */
        wfx_ipv6_notify(GET_IPV6_FAIL);
    }
    break;

    case WifiEvent::kAPStart:
        // TODO: Currently unimplemented
        break;

    case WifiEvent::kScan:
        ChipLogDetail(DeviceLayer, "WifiEvent::kScan");

#ifdef SL_WFX_CONFIG_SCAN
        if (!(wfx_rsi.dev_state.Has(WifiState::kScanStarted)))
        {
            ChipLogDetail(DeviceLayer, "WifiEvent::kScan");
            sl_wifi_scan_configuration_t wifi_scan_configuration;
            memset(&wifi_scan_configuration, 0, sizeof(wifi_scan_configuration));

            // TODO: Add scan logic
            sl_wifi_advanced_scan_configuration_t advanced_scan_configuration = { 0 };
            int32_t status;
            advanced_scan_configuration.active_channel_time  = kAdvActiveScanDuration;
            advanced_scan_configuration.passive_channel_time = kAdvPassiveScanDuration;
            advanced_scan_configuration.trigger_level        = kAdvScanThreshold;
            advanced_scan_configuration.trigger_level_change = kAdvRssiToleranceThreshold;
            advanced_scan_configuration.enable_multi_probe   = kAdvMultiProbe;
            advanced_scan_configuration.enable_instant_scan  = kAdvEnableInstantbgScan;
            status = sl_wifi_set_advanced_scan_configuration(&advanced_scan_configuration);
            if (SL_STATUS_OK != status)
            {
                // TODO: Seems like Chipdie should be called here, the device should be initialized here
                ChipLogError(DeviceLayer, "sl_wifi_set_advanced_scan_configuration failed: 0x%lx", static_cast<uint32_t>(status));
                return;
            }

            if (wfx_rsi.dev_state.Has(WifiState::kStationConnected))
            {
                /* Terminate with end of scan which is no ap sent back */
                wifi_scan_configuration.type                   = SL_WIFI_SCAN_TYPE_ADV_SCAN;
                wifi_scan_configuration.periodic_scan_interval = kAdvScanPeriodicity;
            }
            else
            {
                wifi_scan_configuration = default_wifi_scan_configuration;
            }
            sl_wifi_set_scan_callback(bg_scan_callback_handler, nullptr);
            wfx_rsi.dev_state.Set(WifiState::kScanStarted);

            osSemaphoreAcquire(sScanInProgressSemaphore, osWaitForever);
            status = sl_wifi_start_scan(SL_WIFI_CLIENT_2_4GHZ_INTERFACE, nullptr, &wifi_scan_configuration);
            if (SL_STATUS_IN_PROGRESS == status)
            {
                osSemaphoreAcquire(sScanCompleteSemaphore, kWifiScanTimeoutTicks);
            }

            osSemaphoreRelease(sScanInProgressSemaphore);
        }
#endif /* SL_WFX_CONFIG_SCAN */
        break;

    case WifiEvent::kStationStartJoin:
        ChipLogDetail(DeviceLayer, "WifiEvent::kStationStartJoin");

// To avoid IOP issues, it is recommended to enable high-performance mode before joining the network.
// TODO: Remove this once the IOP issue related to power save mode switching is fixed in the Wi-Fi SDK.
#if CHIP_CONFIG_ENABLE_ICD_SERVER
        chip::DeviceLayer::Silabs::WifiSleepManager::GetInstance().RequestHighPerformance();
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER
        InitiateScan();
        JoinWifiNetwork();
        break;

    default:
        break;
    }
}

/*********************************************************************************
 * @fn  void sl_matter_wifi_task(void *arg)
 * @brief
 * The main WLAN task - started by wfx_wifi_start() that interfaces with RSI.
 * The rest of RSI stuff come in call-backs.
 * The initialization has been already done.
 * @param[in] arg:
 * @return
 *       None
 **********************************************************************************/
/* ARGSUSED */
void sl_matter_wifi_task(void * arg)
{
    (void) arg;
    WifiEvent event;
    sl_status_t status = SL_STATUS_OK;

    status = sl_wifi_siwx917_init();
    VerifyOrReturn(
        status == SL_STATUS_OK,
        ChipLogError(DeviceLayer, "sl_matter_wifi_task: sl_wifi_siwx917_init failed: 0x%lx", static_cast<uint32_t>(status)));

    sl_matter_wifi_task_started();

    ChipLogDetail(DeviceLayer, "sl_matter_wifi_task: starting event loop");
    for (;;)
    {
        if (osMessageQueueGet(sWifiEventQueue, &event, nullptr, osWaitForever) == osOK)
        {
            ProcessEvent(event);
        }
        else
        {
            ChipLogError(DeviceLayer, "sl_matter_wifi_task: get event failed: 0x%lx", static_cast<uint32_t>(status));
        }
    }
}

#if CHIP_DEVICE_CONFIG_ENABLE_IPV4
/********************************************************************************************
 * @fn   void wfx_dhcp_got_ipv4(uint32_t ip)
 * @brief
 *        Acquire the new ip address
 * @param[in] ip: internet protocol
 * @return
 *        None
 **********************************************************************************************/
void wfx_dhcp_got_ipv4(uint32_t ip)
{
    /*
     * Acquire the new IP address
     */
    wfx_rsi.ip4_addr[0] = (ip) &0xFF;
    wfx_rsi.ip4_addr[1] = (ip >> 8) & 0xFF;
    wfx_rsi.ip4_addr[2] = (ip >> 16) & 0xFF;
    wfx_rsi.ip4_addr[3] = (ip >> 24) & 0xFF;
    ChipLogDetail(DeviceLayer, "DHCP OK: IP=%d.%d.%d.%d", wfx_rsi.ip4_addr[0], wfx_rsi.ip4_addr[1], wfx_rsi.ip4_addr[2],
                  wfx_rsi.ip4_addr[3]);
    /* Notify the Connectivity Manager - via the app */
    wfx_rsi.dev_state.Set(WifiState::kStationDhcpDone).Set(WifiState::kStationReady);
    wfx_ip_changed_notify(IP_STATUS_SUCCESS);
}
#endif /* CHIP_DEVICE_CONFIG_ENABLE_IPV4 */

#if CHIP_CONFIG_ENABLE_ICD_SERVER
sl_status_t ConfigurePowerSave(rsi_power_save_profile_mode_t sl_si91x_ble_state, sl_si91x_performance_profile_t sl_si91x_wifi_state,
                               uint32_t listenInterval)
{
    int32_t error = rsi_bt_power_save_profile(sl_si91x_ble_state, RSI_MAX_PSP);
    VerifyOrReturnError(error == RSI_SUCCESS, SL_STATUS_FAIL,
                        ChipLogError(DeviceLayer, "rsi_bt_power_save_profile failed: %ld", error));

    sl_wifi_performance_profile_t wifi_profile = { .profile = sl_si91x_wifi_state,
                                                   // TODO: Performance profile fails if not alligned with DTIM
                                                   .dtim_aligned_type = SL_SI91X_ALIGN_WITH_DTIM_BEACON,
                                                   // TODO: Different types need to be fixe in the Wi-Fi SDK
                                                   .listen_interval = static_cast<uint16_t>(listenInterval) };

    sl_status_t status = sl_wifi_set_performance_profile(&wifi_profile);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_wifi_set_performance_profile failed: 0x%lx", status));

    return status;
}

sl_status_t ConfigureBroadcastFilter(bool enableBroadcastFilter)
{
    sl_status_t status = SL_STATUS_OK;

    uint16_t beaconDropThreshold = (enableBroadcastFilter) ? kTimeToFullBeaconReception : 0;
    uint8_t filterBcastInTim     = (enableBroadcastFilter) ? 1 : 0;

    status = sl_wifi_filter_broadcast(beaconDropThreshold, filterBcastInTim, 1 /* valid till next update*/);
    VerifyOrReturnError(status == SL_STATUS_OK, status,
                        ChipLogError(DeviceLayer, "sl_wifi_filter_broadcast failed: 0x%lx", static_cast<uint32_t>(status)));

    return status;
}
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER
