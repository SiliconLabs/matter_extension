/**
 * @file
 * @brief Matter abstraction layer for AWS
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

#ifndef __MATTER_AWS_H
#define __MATTER_AWS_H

#include <stdint.h>

#include "MatterAwsConfig.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "mqtt.h"
typedef enum
{
    MATTER_AWS_OK = 0,
    MATTER_AWS_ERR_INVAL,
    MATTER_AWS_ERR_MEM,
    MATTER_AWS_ERR_FAIL,
    MATTER_AWS_ERR_CONN,
    MATTER_AWS_ERR_PUBLISH,
} matterAws_err_t;

typedef struct
{
    uint8_t * dataP;
    uint16_t dataLen;
} matterAws_buff_t;

typedef void (*matterAws_subscribe_cb)(void);

matterAws_err_t MatterAwsInit(matterAws_subscribe_cb subs_cb);

matterAws_err_t MatterAwsMqttSubscribe(mqtt_client_t * client, mqtt_incoming_publish_cb_t publish_cb,
                                       mqtt_incoming_data_cb_t data_cb, const char * topic, uint8_t qos);

matterAws_err_t MatterAwsSendMsg(const char * subject, const char * content);

#ifdef SL_MATTER_ENABLE_AWS_OTA_FEAT

typedef void (*callback_t)(const char * sub_topic, uint16_t top_len, const void * pload, uint16_t pLoadLength);
struct sub_cb_info
{
    char * sub_topic;
    callback_t cb;
};

int MatterAwsInitStatus(void);

matterAws_err_t MatterAwsOtaPublish(const char * const topic, const char * message, uint32_t message_len, uint8_t qos);

matterAws_err_t MatterAwsOtaUnsubscribe(const char * topic);

matterAws_err_t MatterAwsOtaSubscribe(const char * topic, uint8_t qos, callback_t subscribe_cb);

matterAws_err_t MatterAwsOtaProcess();

matterAws_err_t MatterAwsOtaClose();
#endif // SL_MATTER_ENABLE_AWS_OTA_FEAT

#ifdef __cplusplus
}
#endif
#endif //__MATTER_AWS_H
