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

#ifndef __MATTER_AWS_CONFIG_H
#define __MATTER_AWS_CONFIG_H

#include "cmsis_os2.h"

/* Instance configuration */

#ifndef SL_MATTER_AWS_NVM_EMBED_CERT
#define SL_MATTER_AWS_NVM_EMBED_CERT (0)
#endif

/* Task Configuration */
#define MATTER_AWS_TASK_NAME "MATTER_AWS"
#define MATTER_AWS_TASK_STACK_SIZE (2 * 1024) // 2k
#define MATTER_AWS_TASK_PRIORITY (osPriorityAboveNormal)

/* Network Configuration */
#define MATTER_AWS_SERVER_HOST ""
#define MATTER_AWS_SERVER_PORT (8883)

#define MATTER_AWS_KEEP_ALIVE (0)

/* MQTT Client Configuration */
#define MATTER_AWS_CLIENT_ID "SL_MATTER_AWS_CLIENT"
#define MATTER_AWS_CLIENT_USER NULL
#define MATTER_AWS_CLIENT_PASS NULL

#define MQTT_QOS_0 (0)
#define MQTT_SUBSCRIBE_TOPIC "command"

/* MQTT Client Certification Configuration */
#define MATTER_AWS_CA_CERT_LENGTH (800)
#define MATTER_AWS_DEV_CERT_LENGTH (1400)
#define MATTER_AWS_DEV_KEY_LENGTH (500)
#define MATTER_AWS_HOSTNAME_LENGTH (55)
#define MATTER_AWS_CLIENTID_LENGTH (30)

#ifdef SL_MATTER_ENABLE_AWS_OTA_FEAT
#define AWS_OTA_TASK_STACK_SIZE (1024)
#define AWS_OTA_TASK_PRIORITY (1)
#endif // SL_MATTER_ENABLE_AWS_OTA_FEAT

#define ZCL_USING_ON_OFF_CLUSTER_SERVER

#endif // __MATTER_AWS_CONFIG_H
