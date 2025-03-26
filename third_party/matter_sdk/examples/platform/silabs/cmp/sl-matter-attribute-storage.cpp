/*****************************************************************************
 * @file sl-matter-attribute-storage.cpp
 * @brief Link zigbee datamodel attribute changes to Matter attribute storage.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc.
 *www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon
 *Laboratories Inc. Your use of this software is
 *governed by the terms of Silicon Labs Master
 *Software License Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement.
 *This software is distributed to you in Source Code
 *format and is governed by the sections of the MSLA
 *applicable to Source Code.
 *
 ******************************************************************************/

#include <app/util/attribute-metadata.h>
#include <app/util/attribute-table.h>
#include <lib/support/TypeTraits.h>
#include <lib/support/logging/CHIPLogging.h>
#include <protocols/interaction_model/StatusCode.h>
#include <sl-matter-attribute-storage.h>
#include <sl_component_catalog.h>

namespace {
// This is called from simplicity_sdk/protocol/zigbee/app/framework/util/attribute-storage.c on ZB attribute write
// when GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING and SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT are defined.
extern "C" sl_status_t sli_matter_af_write_attribute(uint16_t endpointId, uint32_t clusterId, uint32_t attributeId,
                                                     uint8_t * attributeValue, uint8_t type)
{
    // All type shall be directly applicable. We expect compilation error if type changes.
    chip::EndpointId matterEndpointId   = endpointId;
    chip::ClusterId matterClusterId     = clusterId;
    chip::AttributeId matterAttributeId = attributeId;
    EmberAfAttributeType matterDataType = type;

    chip::Protocols::InteractionModel::Status imStatus =
        emberAfWriteAttribute(matterEndpointId, matterClusterId, matterAttributeId, attributeValue, matterDataType);

    // For sl internal use so we return a known status type to our stack
    sl_status_t slStatus = SL_STATUS_OK;
    if (imStatus != chip::Protocols::InteractionModel::Status::Success)
    {
        ChipLogError(Zcl, "Failed to write Matter attribute from multiprotocol update. Err:0x%02x", chip::to_underlying(imStatus));
        slStatus = SL_STATUS_FAIL;
    }

    return slStatus;
}
} // namespace
