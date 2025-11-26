/*****************************************************************************
 * @file MultiProtocolDataModelHelper.cpp
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

#include <MultiProtocolDataModelHelper.h>
#include <app/util/attribute-metadata.h>
#include <app/util/attribute-table.h>
#include <lib/support/TypeTraits.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/PlatformManager.h>
#include <protocols/interaction_model/StatusCode.h>
#include <sl-matter-attribute-storage.h>
#include <sl_component_catalog.h>
#include <zap-config.h>

namespace MultiProtocolDataModel {
#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
// Attribute map between zigbee and matter.
#if defined(GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING) && defined(SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT)

const MpClusterMetadata mpClusterMap[] = GENERATED_MULTI_PROTOCOL_CLUSTER_MAPPING;
const uint8_t mappedMpClusterCount     = (sizeof(mpClusterMap) / sizeof(sl_zigbee_matter_af_multi_protocol_cluster_metadata_t));

const MpClusterMetadata * GetMpClusterMetadata(chip::ClusterId matterClusterId)
{
    for (uint8_t i = 0; i < mappedMpClusterCount; i++)
    {
        if (mpClusterMap[i].matterClusterId == (matterClusterId & 0xFFFF) &&
            mpClusterMap[i].matterMfgClusterId == (matterClusterId >> 16))
        {
            return &mpClusterMap[i];
        }
    }
    return nullptr;
}

const MpAttributeMetadata * GetMpAttributeMetadata(const MpClusterMetadata * mpClusterMetadata, chip::AttributeId attributeId)
{
    const MpAttributeMetadata * mpAttributeMap = mpClusterMetadata->zigbeeMatterAttributeMap;
    for (uint8_t i = 0; i < mpClusterMetadata->clusterMappedAttributeCount; i++)
    {
        if (mpAttributeMap[i].matterAttributeId == (attributeId & 0xFFFF) &&
            mpAttributeMap[i].matterMfgAttributeId == (attributeId >> 16))
        {
            return &mpAttributeMap[i];
        }
    }
    return nullptr;
}

void WriteMatterAttributeValueToZigbee(chip::EndpointId endpointId, chip::ClusterId clusterId, chip::AttributeId attributeId,
                                       uint8_t * attributeValue, EmberAfAttributeType dataType)
{
    const MpClusterMetadata * mpClusterMetadata = GetMpClusterMetadata(clusterId);
    VerifyOrReturn(mpClusterMetadata != nullptr);

    const MpAttributeMetadata * mpAttributeMetadata = GetMpAttributeMetadata(mpClusterMetadata, attributeId);
    VerifyOrReturn(mpAttributeMetadata != nullptr);
    // TODO handle MFG specific attributes
    sl_zigbee_af_write_server_attribute_without_sync(endpointId, mpClusterMetadata->zigbeeClusterId,
                                                     mpAttributeMetadata->zigbeeAttributeId, attributeValue, dataType);
}

void SynchMultiProtocolAttributes(chip::EndpointId endpointId, const MpClusterMetadata * mpClusterMetadata)
{
    VerifyOrReturn(mpClusterMetadata != nullptr);
    // Go over each mapped multiprotocol attribute in the cluster
    const MpAttributeMetadata * mpAttributeMap = mpClusterMetadata->zigbeeMatterAttributeMap;
    for (uint8_t i = 0; i < mpClusterMetadata->clusterMappedAttributeCount; i++)
    {
        // Check if the mapped multiprotocol attribute is enabled on the ZB datamodel
        if (sl_zigbee_af_contains_attribute(endpointId, mpClusterMetadata->zigbeeClusterId, mpAttributeMap[i].zigbeeAttributeId,
                                            CLUSTER_MASK_SERVER, mpAttributeMap[i].zigbeeMfgAttributeId))
        {
            uint8_t attributeSize                 = sl_zigbee_af_get_data_size(mpAttributeMap[i].zigbeeAttributeType);
            uint8_t attributeValue[attributeSize] = { 0 };

            // Read the Matter attribute value and write it to Zigbee
            if (emberAfReadAttribute(endpointId, mpClusterMetadata->matterClusterId, mpAttributeMap[i].matterAttributeId,
                                     attributeValue, attributeSize) == chip::Protocols::InteractionModel::Status::Success)
            {
                sl_zigbee_af_write_server_attribute_without_sync(endpointId, mpClusterMetadata->zigbeeClusterId,
                                                                 mpAttributeMap[i].zigbeeAttributeId, attributeValue,
                                                                 mpAttributeMap[i].zigbeeAttributeType);
            }
        }
    }
}

void Initialize()
{
    // Iterate over all Zigbee endpoints
    for (uint8_t epIdx = 0; epIdx < sl_zigbee_af_endpoint_count(); epIdx++)
    {
        uint8_t endpoint = sl_zigbee_af_endpoint_from_index(epIdx);
        for (uint8_t i = 0; i < mappedMpClusterCount; i++)
        {
            const MpClusterMetadata * mpClusterMetadata = &mpClusterMap[i];
            // Check if mapped multiprotocol cluster is enabled on the endpoint
            if (sl_zigbee_af_contains_server_with_mfg_code(endpoint, mpClusterMetadata->zigbeeClusterId,
                                                           mpClusterMetadata->zigbeeMfgClusterId))
            {
                // Synchronize all enabled attributes for this endpoint and this cluster
                SynchMultiProtocolAttributes(endpoint, mpClusterMetadata);
            }
        }
    }
}

#endif // defined(GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING) && defined(SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT)
#endif // SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
} // namespace MultiProtocolDataModel

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

    chip::DeviceLayer::PlatformMgr().LockChipStack();
    chip::Protocols::InteractionModel::Status imStatus =
        emberAfWriteAttribute(matterEndpointId, matterClusterId, matterAttributeId, attributeValue, matterDataType);
    chip::DeviceLayer::PlatformMgr().UnlockChipStack();

    // For sl internal use so we return a known status type to our stack
    sl_status_t slStatus = SL_STATUS_OK;
    if (imStatus != chip::Protocols::InteractionModel::Status::Success)
    {
        ChipLogError(Zcl, "Failed to write Matter cluster %ld attribute %ld from multiprotocol update. Err:0x%02x", matterClusterId,
                     attributeId, chip::to_underlying(imStatus));
        slStatus = SL_STATUS_FAIL;
    }

    return slStatus;
}

} // namespace
