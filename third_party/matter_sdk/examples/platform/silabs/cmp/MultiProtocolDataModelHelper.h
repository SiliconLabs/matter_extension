/*****************************************************************************
 * @file MultiProtocolDataModelHelper.h
 * @brief Helpers to Link Matter and Zigbee data models.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon
 * Laboratories Inc. Your use of this software is
 * governed by the terms of Silicon Labs Master
 * Software License Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement.
 * This software is distributed to you in Source Code
 * format and is governed by the sections of the MSLA
 * applicable to Source Code.
 *
 ******************************************************************************/
#pragma once

#include <app/util/af-types.h>
#include <stdint.h>

#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
#include "app/framework/include/af-storage.h"
#include "app/framework/include/af.h"
#endif

namespace MultiProtocolDataModel {
#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
// Attribute map between zigbee and matter.
#if defined(GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING) && defined(SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT)
//  typedefs to make the naming smaller
typedef sl_zigbee_matter_af_multi_protocol_cluster_metadata_t MpClusterMetadata;
typedef sl_zigbee_matter_af_multi_protocol_attribute_metadata_t MpAttributeMetadata;

/**
 * @brief Find the cluster metadata mapping for a given Matter cluster ID.
 *
 * @param matterClusterId The Matter cluster ID (may include manufacturer bits).
 * @return Pointer to the cluster metadata if found, otherwise nullptr.
 */
const MpClusterMetadata * GetMpClusterMetadata(chip::ClusterId matterClusterId);

/**
 * @brief Find the attribute metadata mapping for a given Matter attribute ID within a cluster.
 *
 * @param mpClusterMetadata Pointer to the cluster metadata.
 * @param attributeId       Matter attribute ID (may include manufacturer bits).
 * @return Pointer to the attribute metadata if found, otherwise nullptr.
 */
const MpAttributeMetadata * GetMpAttributeMetadata(const MpClusterMetadata * mpClusterMetadata, chip::AttributeId attributeId);

/**
 * @brief Write a value to the mapped Zigbee attribute for a given Matter attribute.
 *
 * @param endpointId      Matter endpoint ID.
 * @param clusterId       Matter cluster ID (may include manufacturer bits).
 * @param attributeId     Matter attribute ID (may include manufacturer bits).
 * @param attributeValue  Pointer to the value to write.
 * @param dataType        Attribute data type.
 */
void WriteMatterAttributeValueToZigbee(chip::EndpointId endpointId, chip::ClusterId clusterId, chip::AttributeId attributeId,
                                       uint8_t * attributeValue, EmberAfAttributeType dataType);

/**
 * @brief Synch the MultiProtocol clusters's attributes from a given endpoint.
 *
 * Synchronizes attribute values from Matter to Zigbee at initialization.
 *
 * @param endpointId        Matter endpoint ID.
 * @param mpClusterMetadata The Multiprotocol Cluster Metadata for the cluster to synch.
 */
void SynchMultiProtocolAttributes(chip::EndpointId endpointId, const MpClusterMetadata * mpClusterMetadata);

/**
 * @brief Initialize MultiProtocol Datamodel.
 */
void Initialize();

#endif // defined(GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING) && defined(SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT)
#endif // SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
} // namespace MultiProtocolDataModel
