/**
 * @file
 * @brief Matter abstraction layer for Direct Internet Connectivity.
 *******************************************************************************
 * # License
 * <b>Copyright 2023 Silicon Laboratories Inc.
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
#ifndef __MATTER_AWS_CONTROL_H
#define __MATTER_AWS_CONTROL_H

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/ids/Attributes.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <zap-generated/gen_config.h>

#include "MatterAwsConfig.h"

using namespace chip;
using namespace ::chip::DeviceLayer;

namespace matterAws {
namespace control {
void MatterAwsIncomingDataCb(void * arg, const char * topic, const uint8_t * data, uint16_t len, uint8_t flags);

void SubscribeMQTT(intptr_t context);

void subscribeCB(void);

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
void AttributeHandler(EndpointId endpointId, AttributeId attributeId);
#endif // ZCL_USING_THERMOSTAT_CLUSTER_SERVER

} // namespace control
} // namespace matterAws
#endif //__MATTER_AWS_CONTROL_H
