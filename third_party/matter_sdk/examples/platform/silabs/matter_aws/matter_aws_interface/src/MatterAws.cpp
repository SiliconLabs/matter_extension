/**
 * @file
 * @brief Matter abstraction layer for AWS.
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc.
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

#include <stdbool.h>
#include <string.h>

#include "FreeRTOS.h"
#include "event_groups.h"
#include "task.h"

#include "silabs_utils.h"
#include <lib/core/CHIPError.h>
#include <lib/support/logging/CHIPLogging.h>

#include "MatterAws.h"
#include "MatterAwsConfig.h"
#include "MatterAwsNvmCert.h"

#ifdef __cplusplus
extern "C" {
#endif

#include "MQTT_transport.h"
#include "mqtt.h"

#ifdef __cplusplus
}
#endif

static TaskHandle_t matterAwsTask         = nullptr;
static EventGroupHandle_t matterAwsEvents = nullptr;

mqtt_client_t * mqtt_client    = nullptr;
MQTT_Transport_t * transport   = nullptr;
matterAws_subscribe_cb gSubsCB = NULL;
static mqtt_transport_intf_t trans;

static bool init_complete;

static void MatterAwsMqttSubscribeCb(void * arg, mqtt_err_t err)
{
    const struct mqtt_connect_client_info_t * client_info = (const struct mqtt_connect_client_info_t *) arg;
    (void) client_info;
    ChipLogProgress(AppServer, "[MATTER_AWS] MQTT sub request callback: %d", (int) err);
}

matterAws_err_t MatterAwsMqttSubscribe(mqtt_client_t * client, mqtt_incoming_publish_cb_t publish_cb,
                                       mqtt_incoming_data_cb_t data_cb, const char * topic, uint8_t qos)
{
    mqtt_set_inpub_callback(mqtt_client, publish_cb, data_cb, NULL);
    int mret = mqtt_subscribe(mqtt_client, topic, qos, MatterAwsMqttSubscribeCb, NULL);
    if (mret != ERR_OK)
    {
        ChipLogError(AppServer, "[MATTER_AWS] MQTT subscribe failed: %d", mret);
        return MATTER_AWS_ERR_FAIL;
    }
    return MATTER_AWS_OK;
}

static void MatterAwsMqttConnCb(mqtt_client_t * client, void * arg, mqtt_connection_status_t status)
{
    (void) client;
    (void) arg;

    ChipLogProgress(AppServer, "[MATTER_AWS] MQTT connection status: %u", status);
    if (status != MQTT_CONNECT_ACCEPTED)
    {
        /* Signal the task to exit cleanly - the task will handle the event and set its local endLoop flag */
        VerifyOrReturn(matterAwsTask != nullptr && matterAwsEvents != nullptr,
                       ChipLogError(AppServer, "[MATTER_AWS] Task or events not initialized in MQTT callback"));
        xEventGroupSetBits(matterAwsEvents, SIGNAL_TRANSINTF_CONN_CLOSE);
        return;
    }
    if (gSubsCB != NULL)
        gSubsCB(); // Subscribe callback
}

void MatterAwsTcpConnectCb(err_t err)
{
    ChipLogProgress(AppServer, "[MATTER_AWS] connection callback started");
    if (err == ERR_OK)
    {
        struct mqtt_connect_client_info_t connect_info;
        mqtt_err_t mret;
        /* Connect to MQTT broker/cloud */
        memset(&connect_info, 0, sizeof(connect_info));

        char clientID[MATTER_AWS_CLIENTID_LENGTH] = { 0 };
        size_t length                             = 0;

        VerifyOrExit(MatterAwsGetClientId(clientID, MATTER_AWS_CLIENTID_LENGTH, &length) == CHIP_NO_ERROR,
                     ChipLogError(AppServer, "[MATTER_AWS] failed to fetch client ID"));

        connect_info.client_id = clientID;
#if MATTER_AWS_CLIENT_USER
        connect_info.client_user = MATTER_AWS_CLIENT_USER;
#endif // MATTER_AWS_CLIENT_USER
#if MATTER_AWS_CLIENT_PASS
        connect_info.client_pass = MATTER_AWS_CLIENT_PASS;
#endif // MATTER_AWS_CLIENT_PASS
        connect_info.keep_alive = MATTER_AWS_KEEP_ALIVE;

        mret = mqtt_client_connect(mqtt_client, (void *) &trans, MatterAwsMqttConnCb, NULL, &connect_info);
        if (mret != ERR_OK)
        {
            ChipLogError(AppServer, "[MATTER_AWS] MQTT connection failed: %d", mret);
            init_complete = false;
            goto exit;
        }
        init_complete = true;
        return;
    }
    init_complete = false;
exit:
    /* Instead of deleting the task from callback context (which causes hardfault),
     * signal the task to exit and let it clean up itself. The callback is called
     * from TCP/IP thread context, and deleting a task from another task's context
     * can corrupt FreeRTOS internal structures. */
    VerifyOrReturn(matterAwsTask != nullptr && matterAwsEvents != nullptr,
                   ChipLogError(AppServer, "[MATTER_AWS] Task or events not initialized in TCP callback"));
    /* Signal the task to wake up and exit cleanly - task will set its local endLoop flag */
    xEventGroupSetBits(matterAwsEvents, SIGNAL_TRANSINTF_CONN_CLOSE);
    return;
}

static void MatterAwsTaskFn(void * args)
{
    /* Local flag to control the task loop - reset each time the task starts */
    bool endLoop = false;

    /* get MQTT client handle */
    err_t ret;
    gSubsCB                                     = reinterpret_cast<void (*)()>(args);
    mqtt_client                                 = mqtt_client_new();
    char ca_cert_buf[MATTER_AWS_CA_CERT_LENGTH] = { 0 };
    char cert_buf[MATTER_AWS_DEV_CERT_LENGTH]   = { 0 };
    char key_buf[MATTER_AWS_DEV_KEY_LENGTH]     = { 0 };
    char hostname[MATTER_AWS_HOSTNAME_LENGTH]   = { 0 };
    size_t ca_cert_length                       = 0;
    size_t cert_length                          = 0;
    size_t key_length                           = 0;
    size_t hostname_length                      = 0;

    VerifyOrExit(mqtt_client != NULL, ChipLogError(AppServer, "[MATTER_AWS] failed to create mqtt client"));

    /* Get transport handle*/
    memset(&trans, 0x00, sizeof(mqtt_transport_intf_t));
    transport = MQTT_Transport_Init(&trans, mqtt_client, matterAwsEvents);
    VerifyOrExit(transport != NULL, ChipLogError(AppServer, "[MATTER_AWS] failed to configure mqtt client"));

    VerifyOrExit(MatterAwsGetHostname(hostname, MATTER_AWS_HOSTNAME_LENGTH, &hostname_length) == CHIP_NO_ERROR,
                 ChipLogError(AppServer, "[MATTER_AWS] failed to fetch hostname"));
    VerifyOrExit(MatterAwsGetCACertificate(ca_cert_buf, MATTER_AWS_CA_CERT_LENGTH, &ca_cert_length) == CHIP_NO_ERROR,
                 ChipLogError(AppServer, "[MATTER_AWS] failed to fetch CA certificate"));
    VerifyOrExit(MatterAwsGetDeviceCertificate(cert_buf, MATTER_AWS_DEV_CERT_LENGTH, &cert_length) == CHIP_NO_ERROR,
                 ChipLogError(AppServer, "[MATTER_AWS] failed to fetch device certificate"));
    VerifyOrExit(MatterAwsGetDevicePrivKey(key_buf, MATTER_AWS_DEV_KEY_LENGTH, &key_length) == CHIP_NO_ERROR,
                 ChipLogError(AppServer, "[MATTER_AWS] failed to fetch device key"));

    /* set SSL configuration for TLS transport connection */
    if (ca_cert_length > 1 && cert_length > 1 && key_length > 1)
    {
        ret = MQTT_Transport_SSLConfigure(transport, (const u8_t *) ca_cert_buf, ca_cert_length, (const u8_t *) key_buf, key_length,
                                          NULL, 0, (const u8_t *) cert_buf, cert_length);

        VerifyOrExit(ERR_OK == ret, ChipLogError(AppServer, "[MATTER_AWS] failed to configure SSL to mqtt transport"));
    }

    ret = MQTT_Transport_Connect(transport, hostname, hostname_length, MATTER_AWS_SERVER_PORT, MatterAwsTcpConnectCb);
    VerifyOrExit(ERR_OK == ret, ChipLogError(AppServer, "[MATTER_AWS] transport connection failed: %d", ret));

    while (!endLoop)
    {
        EventBits_t event;
        event = xEventGroupWaitBits(matterAwsEvents,
                                    SIGNAL_TRANSINTF_RX | SIGNAL_TRANSINTF_TX_ACK | SIGNAL_TRANSINTF_CONN_CLOSE |
                                        SIGNAL_TRANSINTF_MBEDTLS_RX,
                                    1, 0, portMAX_DELAY);
        if (event & SIGNAL_TRANSINTF_CONN_CLOSE)
        {
            mqtt_close(mqtt_client, MQTT_CONNECT_DISCONNECTED);
            endLoop = true;
        }
        else
        {
            if (event & SIGNAL_TRANSINTF_RX)
                mqtt_process(mqtt_client, SIGNAL_TRANSINTF_TX);
            else if (event & SIGNAL_TRANSINTF_TX_ACK)
                mqtt_process(mqtt_client, SIGNAL_TRANSINTF_TX_ACK);
            if (event & SIGNAL_TRANSINTF_MBEDTLS_RX)
                transport_process_mbedtls_rx(transport);
        }
    }
    init_complete = false;

exit:
    /* Clean up resources before task deletion.
     * Save handle and nullify pointers atomically to prevent race with callbacks. */
    if (matterAwsTask != nullptr)
    {
        vEventGroupDelete(matterAwsEvents);
        matterAwsEvents = nullptr;
        matterAwsTask   = nullptr;
    }
    /* Delete the current task - use NULL to delete self */
    vTaskDelete(NULL);
    /* This line should never be reached */
    return;
}

void MatterAwsPubRespCb(void * arg, mqtt_err_t err)
{
    (void) arg;
    ChipLogProgress(AppServer, "[MATTER_AWS] publish data %s", err != MQTT_ERR_OK ? "failed!" : "successful!");
}

matterAws_err_t MatterAwsInit(matterAws_subscribe_cb subs_cb)
{
    VerifyOrReturnError(matterAwsTask == nullptr, MATTER_AWS_OK);

    /* Create events group used to receive events from transport layer*/
    matterAwsEvents = xEventGroupCreate();
    if (!matterAwsEvents)
    {
        ChipLogError(AppServer, "[MATTER_AWS] failed to create event groups");
        return MATTER_AWS_ERR_FAIL;
    }

    if ((pdPASS !=
         xTaskCreate(MatterAwsTaskFn, MATTER_AWS_TASK_NAME, MATTER_AWS_TASK_STACK_SIZE, (void *) subs_cb, MATTER_AWS_TASK_PRIORITY,
                     &matterAwsTask)) ||
        !matterAwsTask)
    {
        ChipLogError(AppServer, "[MATTER_AWS] failed to create task");
        vEventGroupDelete(matterAwsEvents);
        return MATTER_AWS_ERR_MEM;
    }

    /* TODO: Register data and pub callback and subscribe if cloud to app messages are expected*/
    return MATTER_AWS_OK;
}

matterAws_err_t MatterAwsSendMsg(const char * subject, const char * content)
{
    if (subject == nullptr || content == nullptr)
    {
        ChipLogError(AppServer, "[MATTER_AWS] invalid subject/content");
        return MATTER_AWS_ERR_INVAL;
    }
    if (!init_complete)
    {
        ChipLogError(AppServer, "[MATTER_AWS] invalid state");
        return MATTER_AWS_ERR_CONN;
    }
    matterAws_buff_t buffValue;
    buffValue.dataP   = (uint8_t *) content;
    buffValue.dataLen = strlen(content);
    if (MQTT_ERR_OK !=
        mqtt_publish(mqtt_client, subject, buffValue.dataP, buffValue.dataLen, MQTT_QOS_0, 0, MatterAwsPubRespCb, NULL))
    {
        ChipLogError(AppServer, "[MATTER_AWS] failed to publish");
        return MATTER_AWS_ERR_PUBLISH;
    }
    return MATTER_AWS_OK;
}

#ifdef SL_MATTER_ENABLE_AWS_OTA_FEAT

struct sub_cb_info sub_info;

int MatterAwsInitStatus()
{
    if (init_complete)
    {
        return 1;
    }
    else
        return 0;
}

static void MatterAwsOtaMqttIncomingDataCb(void * arg, const char * topic, u16_t topic_len, const u8_t * data, u16_t len,
                                           u8_t flags)
{
    const struct mqtt_connect_client_info_t * client_info = (const struct mqtt_connect_client_info_t *) arg;
    (void) client_info;
    u8_t buff[1500] = { 0 };
    memcpy(buff, data, LWIP_MIN(len, sizeof(buff)));
    ChipLogProgress(AppServer, "[MATTER_AWS] incoming_data_callback: len(%u), flags(%u), topic_len(%d)", len, flags, topic_len);
    sub_info.cb(topic, topic_len, (char *) buff, len);
}
static void MatterAwsOtaMqttIncomingPublishCb(void * arg, const char * topic, u32_t tot_len)
{
    const struct mqtt_connect_client_info_t * client_info = (const struct mqtt_connect_client_info_t *) arg;
    (void) client_info;

    ChipLogProgress(AppServer, "[MATTER_AWS] incoming_publish_cb: topic (%s), len (%d)", topic, (int) tot_len);
}

matterAws_err_t MatterAwsOtaPublish(const char * const topic, const char * message, uint32_t message_len, uint8_t qos)
{
    if (!init_complete)
    {
        ChipLogError(AppServer, "[MATTER_AWS] invalid state");
        return MATTER_AWS_ERR_FAIL;
    }
    if (MQTT_ERR_OK != mqtt_publish(mqtt_client, topic, message, message_len, qos, 0, MatterAwsPubRespCb, NULL))
    {
        ChipLogError(AppServer, "[MATTER_AWS] failed to publish");
        return MATTER_AWS_ERR_FAIL;
    }
    else
    {
        ChipLogError(AppServer, "[MATTER_AWS] mqtt_publish->message: %s, topic: %s", message, topic);
    }
    return MATTER_AWS_OK;
}

matterAws_err_t MatterAwsOtaUnsubscribe(const char * topic)
{
    if (!init_complete)
    {
        ChipLogError(AppServer, "[MATTER_AWS] invalid state");
        return MATTER_AWS_ERR_FAIL;
    }

    if (MQTT_ERR_OK != mqtt_unsubscribe(mqtt_client, topic, MatterAwsMqttSubscribeCb, NULL))
    {
        ChipLogError(AppServer, "[MATTER_AWS] failed to unsubscribe");
        return MATTER_AWS_ERR_FAIL;
    }
    return MATTER_AWS_OK;
}

matterAws_err_t MatterAwsOtaSubscribe(const char * topic, uint8_t qos, callback_t subscribe_cb)
{
    if (!init_complete)
    {
        ChipLogError(AppServer, "[MATTER_AWS] invalid state");
        return MATTER_AWS_ERR_FAIL;
    }

    sub_info.sub_topic = (char *) topic;
    sub_info.cb        = subscribe_cb;
    if (MATTER_AWS_OK !=
        MatterAwsMqttSubscribe(mqtt_client, MatterAwsOtaMqttIncomingPublishCb, MatterAwsOtaMqttIncomingDataCb, topic, qos))
    {
        ChipLogError(AppServer, "[MATTER_AWS] failed to subscribe");
        return MATTER_AWS_ERR_FAIL;
    }
    return MATTER_AWS_OK;
}

matterAws_err_t MatterAwsOtaProcess()
{
    if (!init_complete)
    {
        ChipLogError(AppServer, "[MATTER_AWS] invalid state");
        return MATTER_AWS_ERR_FAIL;
    }
    mqtt_process(mqtt_client, 0);

    return MATTER_AWS_OK;
}

matterAws_err_t MatterAwsOtaClose()
{
    if (!init_complete)
    {
        ChipLogError(AppServer, "[MATTER_AWS] invalid state");
        return MATTER_AWS_ERR_FAIL;
    }

    mqtt_close(mqtt_client, MQTT_CONNECT_DISCONNECTED);

    return MATTER_AWS_OK;
}
#endif // SL_MATTER_ENABLE_AWS_OTA_FEAT
