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
 *   This file implements the handler for data model callbacks.
 */

#include "AppConfig.h"

#include "AppTask.h"
#include <SensorManager.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/ConcreteAttributePath.h>
#include <lib/support/logging/CHIPLogging.h>

using namespace ::chip;
using namespace ::chip::app::Clusters;

void MatterPostAttributeChangeCallback(const chip::app::ConcreteAttributePath & attributePath, uint8_t type, uint16_t size,
                                       uint8_t * value)
{
    ClusterId clusterId     = attributePath.mClusterId;
    AttributeId attributeId = attributePath.mAttributeId;
    ChipLogProgress(Zcl, "Cluster callback: " ChipLogFormatMEI, ChipLogValueMEI(clusterId));

    switch (clusterId)
    {
    case Identify::Id:
        ChipLogProgress(Zcl, "Identify attribute ID: " ChipLogFormatMEI " Type: %u Value: %u, length %u",
                        ChipLogValueMEI(attributeId), type, *value, size);
        break;

    case OccupancySensing::Id: {
        VerifyOrReturn(attributeId == OccupancySensing::Attributes::Occupancy::Id);

        BitMask<OccupancySensing::OccupancyBitmap> state = *reinterpret_cast<BitMask<OccupancySensing::OccupancyBitmap> *>(value);

        AppEvent event                         = {};
        event.Type                             = AppEvent::kEventType_OccupancyAttributeUpdate;
        event.Handler                          = AppTask::OccupancyAttributeUpdateEvent;
        event.OccupancyEvent.occupancyDetected = state.Has(OccupancySensing::OccupancyBitmap::kOccupied);
        AppTask().PostEvent(&event);
    }
    break;

    case TemperatureMeasurement::Id:
    case RelativeHumidityMeasurement::Id: {
        VerifyOrReturn(attributeId == TemperatureMeasurement::Attributes::MeasuredValue::Id ||
                       attributeId == RelativeHumidityMeasurement::Attributes::MeasuredValue::Id);

        AppEvent event = {
            .Type    = AppEvent::kEventType_SensorAttributeUpdate,
            .Handler = AppTask::SensorAttributeUpdateEvent,
        };
        AppTask().PostEvent(&event);
    }
    break;

    default:
        // Handle default case if needed
        break;
    }
}
