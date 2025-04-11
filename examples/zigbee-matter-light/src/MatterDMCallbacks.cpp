/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/**
 * @file
 *   This file implements the handler for data model messages.
 */

#include "AppConfig.h"
#include "LightingManager.h"

#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/ConcreteAttributePath.h>
#include <lib/support/logging/CHIPLogging.h>

#include "sl_component_catalog.h"

using namespace ::chip;
using namespace ::chip::app::Clusters;

#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
namespace {
#include "app/framework/include/af-storage.h"
#include "app/framework/include/af.h"
#include <zap-config.h>
// Attribute map between zigbee and matter.
#if defined(GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING) && defined(SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT)
constexpr sl_zigbee_matter_af_multi_protocol_attribute_metadata_t mpAttributeMap[] = GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING;

constexpr size_t mpMappedAttributeCount =
    (sizeof(mpAttributeMap) / sizeof(sl_zigbee_matter_af_multi_protocol_attribute_metadata_t));

// SL-TEMP Until GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING is reworked to optimize parsing time
inline bool isMultiProtocolMappedMatterCluster(chip::ClusterId clusterId)
{
    return (clusterId == OnOff::Id || clusterId == LevelControl::Id || clusterId == ColorControl::Id);
}

/**
 * @brief Writes an attribute value to the Zigbee attribute storage.
 *
 * This function translates Matter attribute parameters to Zigbee attribute parameters, using our multiprotocol
 * attribute map and uses the Zigbee API to perform the write operation.
 *
 * @param endpointId The Matter endpoint identifier.
 * @param clusterId The Matter cluster identifier.
 * @param attributeId The Matter attribute identifier.
 * @param attributeValue Pointer to the attribute value to be written.
 * @param dataType The data type of the attribute.
 */
void sli_matter_af_write_to_zb_attribute(chip::EndpointId endpointId, chip::ClusterId clusterId, chip::AttributeId attributeId,
                                         uint8_t * attributeValue, EmberAfAttributeType dataType)
{
    for (uint8_t i = 0; i < mpMappedAttributeCount; i++)
    {
        if (mpAttributeMap[i].matterClusterId == (clusterId & 0xFFFF) &&
            mpAttributeMap[i].matterMfgClusterId == (clusterId >> 16) &&
            mpAttributeMap[i].matterAttributeId == (attributeId & 0xFFFF) &&
            mpAttributeMap[i].matterMfgAttributeId == (attributeId >> 16))
        {
            // TODO handle MFG specific attributes
            sl_zigbee_af_write_server_attribute(endpointId, mpAttributeMap[i].zigbeeClusterId, mpAttributeMap[i].zigbeeAttributeId,
                                                attributeValue, dataType);
            break;
        }
    }
}
#endif // defined(GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING) && defined(SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT)
} // namespace
#endif // SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT

void MatterPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value)
{
    [[maybe_unused]] EndpointId endpointId = attributePath.mEndpointId;
    ClusterId clusterId                    = attributePath.mClusterId;
    AttributeId attributeId                = attributePath.mAttributeId;
    ChipLogProgress(Zcl, "Cluster callback: " ChipLogFormatMEI, ChipLogValueMEI(clusterId));

    if (clusterId == OnOff::Id && attributeId == OnOff::Attributes::OnOff::Id)
    {
        LightMgr().InitiateAction(AppEvent::kEventType_Light, *value ? LightingManager::ON_ACTION : LightingManager::OFF_ACTION);
    }
    else if (clusterId == LevelControl::Id)
    {
        ChipLogProgress(Zcl, "Level Control attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u",
                        ChipLogValueMEI(attributeId), type, *value, size);
    }
    else if (clusterId == ColorControl::Id)
    {
        ChipLogProgress(Zcl, "Color Control attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u",
                        ChipLogValueMEI(attributeId), type, *value, size);
    }
    else if (clusterId == Identify::Id)
    {
        ChipLogProgress(Zcl, "Identify attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u",
                        ChipLogValueMEI(attributeId), type, *value, size);
    }

#if defined(GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING) && defined(SL_CATALOG_MULTIPROTOCOL_ZIGBEE_MATTER_COMMON_PRESENT)
    // SL-TEMP Until GENERATED_MULTI_PROTOCOL_ATTRIBUTE_MAPPING is reworked to optimize parsing time.
    // At boot, the attributes are already sync, no need to write them to Zigbee until init is done.
    if (LightMgr().IsInitialized() && isMultiProtocolMappedMatterCluster(clusterId))
    {
        sli_matter_af_write_to_zb_attribute(endpointId, clusterId, attributeId, value, type);
    }
#endif
}