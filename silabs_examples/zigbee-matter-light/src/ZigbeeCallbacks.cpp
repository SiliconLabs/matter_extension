/***************************************************************************//**
 * @file ZigbeeCallbacks.cpp
 * @brief Callbacks implementation and application specific code.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
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

#include "app/framework/include/af.h"
#ifdef SL_COMPONENT_CATALOG_PRESENT
#include "sl_component_catalog.h"
#endif

#ifdef SL_CATALOG_ZIGBEE_NETWORK_TEST_PRESENT
#include "network_test_config.h"
#endif //SL_CATALOG_ZIGBEE_NETWORK_TEST_PRESENT

#if (LARGE_NETWORK_TESTING == 0)
#ifndef EZSP_HOST

#include "zigbee_sleep_config.h"
#endif

#include "network-creator.h"
#include "network-creator-security.h"
#include "find-and-bind-target.h"
#include "zll-commissioning.h"
#include "stack/include/zigbee-security-manager.h" // Install code
#include "af-security.h" // Install code
#include "network-creator-security.h" // Install code

#include "LightingManager.h"

#include "AppConfig.h"

#include "ZigbeeCallbacks.h"

static sl_zigbee_af_event_t start_zigbee_event;
static sl_zigbee_af_event_t finding_and_binding_event;
static bool pendingRestart = false;

// Must match with Matter Light endpoint
#define LIGHT_ENDPOINT 1


// Stub callbacks that are unused
extern "C" void halPrintCrashSummary(uint8_t port)
{
  (void)port;
  // unused
}
extern "C" void halPrintCrashDetails(uint8_t port)
{
  (void)port;
  // unused
}

extern "C" void halPrintCrashData(uint8_t port)
{
  (void)port;
  // unused
}

namespace Zigbee {
void RequestStart(uint8_t channel)
{

  // First 8 bits are used for Zigbee Metadata
  start_zigbee_event.data = static_cast<uint32_t>(channel << 8);
  sl_zigbee_af_event_set_active(&start_zigbee_event);
}

void RequestLeave()
{
  sl_zigbee_leave_network(SL_ZIGBEE_LEAVE_NWK_WITH_NO_OPTION);
}

uint8_t GetZigbeeChannel()
{
  return sl_zigbee_af_get_radio_channel();
}
} // Namespace zigbee

#if SL_MATTER_CMP_SECURE_ZIGBEE
sl_802154_long_addr_t reverse_eui64 = { SL_MATTER_CMP_INSTALL_CODE_EUID64 };
uint8_t code[18 ] = { SL_MATTER_CMP_INSTALL_CODE };    

extern "C" void option_install_code(void)
{
#if (defined(EMBER_AF_HAS_SECURITY_PROFILE_SE_TEST) \
  || defined(EMBER_AF_HAS_SECURITY_PROFILE_SE_FULL) \
  || defined (EMBER_AF_HAS_SECURITY_PROFILE_Z3))

  sl_zigbee_key_data_t key;
  sl_status_t status;
  uint8_t length = 18;
  
  // Convert the install code to a key.
  status = sli_zigbee_af_install_code_to_key(code, length, &key);

  if (SL_STATUS_OK != status) {
    if (SL_STATUS_INVALID_CONFIGURATION == status) {
      SILABS_LOG("ERR: Calculated CRC does not match");
    } else if (SL_STATUS_INVALID_PARAMETER == status) {
      SILABS_LOG("ERR: Install Code must be 8, 10, 14, or 18 bytes in "
                                  "length");
    } else {
      SILABS_LOG("ERR: AES-MMO hash failed: 0x%x", status);
    }
    return;
  }

  #ifndef EMBER_AF_HAS_SECURITY_PROFILE_Z3
  // Add the key to the link key table.

  status = sl_zigbee_sec_man_import_link_key(0,     // index
                                             reverse_eui64,
                                             (sl_zigbee_sec_man_key_t*) &key);
  SILABS_LOG("add link key %lu", status);
  #else
  // Add the key to the transient key table.
  // This will be used while the DUT joins.
  if (SL_STATUS_OK == status) {
    status = sl_zigbee_sec_man_import_transient_key(reverse_eui64, (sl_zigbee_sec_man_key_t*)&key);
    SILABS_LOG("Set joining link key %lu", status);
  }
  #endif

#else
  SILABS_LOG("This command only supports the Z3 or SE application profile.");
#endif

}

extern "C" void open_network_with_key()
{
  sl_zigbee_key_data_t keyData;
  sl_status_t status;

  // Convert the install code to a key.
  status = sli_zigbee_af_install_code_to_key(code, length, &key);

  if (SL_STATUS_OK != status) {
    SILABS_LOG("%s: Failed to convert install code: 0x%X",
                     SL_ZIGBEE_AF_PLUGIN_NETWORK_CREATOR_SECURITY_PLUGIN_NAME,
                     status);  
    return;
  }

  status = sl_zigbee_af_network_creator_security_open_network_with_key_pair(reverse_eui64, keyData);

  SILABS_LOG("%s: Open network: 0x%X",
                     SL_ZIGBEE_AF_PLUGIN_NETWORK_CREATOR_SECURITY_PLUGIN_NAME,
                     status);
}
#endif // SL_MATTER_CMP_SECURE_ZIGBEE

//---------------
// Event handlers
// Start a zigbee network on the given channel or re-open the joining window
// 
extern "C" void start_zigbee_event_handler(sl_zigbee_af_event_t *event)
{
  // First 8 bits are used for Zigbee Metadata
  uint8_t channel = static_cast<uint8_t>((event->data) >> 8);
  #if SL_MATTER_CMP_SECURE_ZIGBEE
  uint8_t distributedNetwork = 1;
  #else
  uint8_t distributedNetwork = 0;
  #endif // SL_MATTER_CMP_SECURE_ZIGBEE

  if (channel != 0) 
  {
    if (sl_zigbee_af_get_radio_channel() != channel)
    {
      if (sl_zigbee_af_network_state() == SL_ZIGBEE_JOINED_NETWORK)
      {
        pendingRestart = true;
        SILABS_LOG(" [ZB] Leaving Network");
        sl_zigbee_leave_network(SL_ZIGBEE_LEAVE_NWK_WITH_NO_OPTION);
        return;
      }
      sl_status_t status = sl_zigbee_af_network_creator_network_form(distributedNetwork, 0xABCD, 1, channel);
      SILABS_LOG(" [ZB] Form network start: 0x%X", status);
    }
  }
  else if (sl_zigbee_af_network_state() == SL_ZIGBEE_JOINED_NETWORK) {
    #if SL_MATTER_CMP_SECURE_ZIGBEE
    open_network_with_key();
    option_install_code();
    #else
    SILABS_LOG(" [ZB] Start_evt_handler: Permitting Join");
    sl_zigbee_af_permit_join(254, NULL);
    #endif
  } else {
    sl_status_t status = sl_zigbee_af_network_creator_network_form(distributedNetwork, 0xABCD, 1, 11);
    SILABS_LOG(" [ZB] Form network start: 0x%X", status);
  }
}

extern "C" void finding_and_binding_event_handler(sl_zigbee_af_event_t *event)
{
  if (sl_zigbee_af_network_state() == SL_ZIGBEE_JOINED_NETWORK) {
    sl_zigbee_af_event_set_inactive(&finding_and_binding_event);

    SILABS_LOG(" [ZB] Find and bind target start: 0x%X",
                                sl_zigbee_af_find_and_bind_target_start(LIGHT_ENDPOINT));
  }
}

//----------------------
// Implemented Callbacks

/** @brief Stack Status
 *
 * This function is called by the application framework from the stack status
 * handler.  This callbacks provides applications an opportunity to be notified
 * of changes to the stack status and take appropriate action. The framework
 * will always process the stack status after the callback returns.
 */
extern "C" void sl_zigbee_af_stack_status_cb(sl_status_t status)
{
  if (status == SL_STATUS_NETWORK_UP) {
    sl_zigbee_af_event_set_active(&finding_and_binding_event);
  } else if (status == SL_STATUS_NETWORK_DOWN) {
    if (pendingRestart)
    {
      pendingRestart = false;
      sl_zigbee_af_event_set_active(&start_zigbee_event);
    }
  }
}

/** @brief Init
 * Application init function
 */
extern "C" void sl_zigbee_af_main_init_cb(void)
{
  sl_zigbee_af_event_init(&start_zigbee_event, start_zigbee_event_handler);
  sl_zigbee_af_event_init(&finding_and_binding_event, finding_and_binding_event_handler);
}

/** @brief Complete the network creation process.
 *
 * This callback notifies the user that the network creation process has
 * completed successfully.
 *
 * @param network The network that the network creator plugin successfully
 * formed.
 *
 * @param usedSecondaryChannels Whether or not the network creator wants to
 * form a network on the secondary channels.
 */
extern "C" void sl_zigbee_af_network_creator_complete_cb(const sl_zigbee_network_parameters_t *network,
                                              bool usedSecondaryChannels)
{
  SILABS_LOG(" [ZB] Form Network Complete: 0x%X",
                              SL_STATUS_OK);
  #if SL_MATTER_CMP_SECURE_ZIGBEE
  open_network_with_key();
  option_install_code();
  #else
  SILABS_LOG(" [ZB] af_network_creator_complete: Permitting Join");
  sl_zigbee_af_permit_join(254, NULL);
  #endif // SL_MATTER_CMP_SECURE_ZIGBEE
  
}

/** @brief Post Attribute Change
 *
 * This function is called by the application framework after it changes an
 * attribute value. The value passed into this callback is the value to which
 * the attribute was set by the framework.
 */
extern "C" void sl_zigbee_af_post_attribute_change_cb(uint8_t endpoint,
                                           sl_zigbee_af_cluster_id_t clusterId,
                                           sl_zigbee_af_attribute_id_t attributeId,
                                           uint8_t mask,
                                           uint16_t manufacturerCode,
                                           uint8_t type,
                                           uint8_t size,
                                           uint8_t* value)
{
  if (clusterId == ZCL_ON_OFF_CLUSTER_ID
      && attributeId == ZCL_ON_OFF_ATTRIBUTE_ID
      && mask == CLUSTER_MASK_SERVER) {
    bool onOff;
    if (sl_zigbee_af_read_server_attribute(endpoint,
                                           ZCL_ON_OFF_CLUSTER_ID,
                                           ZCL_ON_OFF_ATTRIBUTE_ID,
                                           (uint8_t *)&onOff,
                                           sizeof(onOff))
        == SL_ZIGBEE_ZCL_STATUS_SUCCESS) {
      // TODO : Glue Layer between Zigbee and Matter here
      // JIRA : MATTER-3019
      LightingManager::Action_t action;
      int32_t actor;
      action = (onOff) ? LightingManager::ON_ACTION : LightingManager::OFF_ACTION;
      actor  = AppEvent::kEventType_Button;
      if (LightMgr().IsLightOn() != onOff)
      {
        // Zigbee State doesn't Match the current light status
        // Zigbee probably is the source of truth : update cluster
        LightMgr().InitiateAction(actor, action);
      }
    }
  }
}

/** @brief On/off Cluster Server Post Init
 *
 * Following resolution of the On/Off state at startup for this endpoint, perform any
 * additional initialization needed; e.g., synchronize hardware state.
 *
 * @param endpoint Endpoint that is being initialized
 */
extern "C" void sl_zigbee_af_on_off_cluster_server_post_init_cb(uint8_t endpoint)
{
  // At startup, trigger a read of the attribute and possibly a toggle of the
  // LED to make sure they are always in sync.
  sl_zigbee_af_post_attribute_change_cb(endpoint,
                                        ZCL_ON_OFF_CLUSTER_ID,
                                        ZCL_ON_OFF_ATTRIBUTE_ID,
                                        CLUSTER_MASK_SERVER,
                                        0,
                                        0,
                                        0,
                                        NULL);
}

/** @brief
 *
 * Application framework equivalent of ::sl_zigbee_radio_needs_calibrating_handler
 */
extern "C" void sl_zigbee_af_radio_needs_calibrating_cb(void)
{
  #ifndef EZSP_HOST
  sl_mac_calibrate_current_channel();
  #endif
}

#endif //#if (LARGE_NETWORK_TESTING == 0)

extern "C" void zb_ble_dmp_print_ble_connections(void)
{
  (void)index;
}
