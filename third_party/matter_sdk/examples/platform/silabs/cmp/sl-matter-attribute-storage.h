/*******************************************************************************
 * @file sl-matter-attribute-storage.h
 * @brief Link zigbee datamodel attribute changes to Matter attribute storage.
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

#ifndef SL_MATTER_ATTRIBUTE_STORAGE
#define SL_MATTER_ATTRIBUTE_STORAGE

#include <sl_status.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Writes an attribute value to the Matter attribute storage.
 *
 *  *** This is a Silabs internal api. ***
 *
 * It exposes the Matter API that writes to the Matter attribute storage to our zigbee datamodel stack,
 * implemented in C, for multiprotocol usecases, without exposing matter datamodel elements
 *
 * This function expect that either the used Zigbee cluster/attributes maps 1 to 1 to the matter counter part
 * or that the caller translated the Zigbee attribute parameters to Matter attribute parameters.
 *
 * The function ultimaly uses those fields in the Matter API to perform the attribute write operation.
 *
 * @param endpointId Linked ZB/Matter endpoint identifier.
 * @param clusterId Linked ZB/Matter cluster identifier.
 * @param attributeId Linked ZB/Matter attribute identifier.
 * @param attributeValue Pointer to the attribute value to be written.
 * @param type The data type of the attribute. Shall match Matters' EmberAfAttributeType
 * @return sl_status_t Status of the write operation, SL_STATUS_OK if successful, otherwise SL_STATUS_FAIL.
 */
sl_status_t sli_matter_af_write_attribute(uint16_t endpointId, uint32_t clusterId, uint32_t attributeId, uint8_t * attributeValue,
                                          uint8_t type);

#ifdef __cplusplus
}
#endif

#endif // SL_MATTER_ATTRIBUTE_STORAGE
