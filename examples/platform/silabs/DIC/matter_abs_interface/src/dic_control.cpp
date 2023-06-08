/**
 * @file
 * @brief Matter abstraction layer for Direct Internet Connectivity.
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

#include "efr32_utils.h"
#include "dic_control.h"
#include "dic.h"
#include <platform/CHIPDeviceLayer.h>
#include <zap-generated/gen_config.h>
#include <app-common/zap-generated/ids/Clusters.h>

#ifdef ZCL_USING_ON_OFF_CLUSTER_SERVER
#include  <app/clusters/on-off-server/on-off-server.h>
#endif //ZCL_USING_ON_OFF_CLUSTER_SERVER
 
#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
#include <app/clusters/door-lock-server/door-lock-server.h>
#endif // ZCL_USING_DOOR_LOCK_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
#include "TemperatureManager.h"
#endif //ZCL_USING_THERMOSTAT_CLUSTER_SERVER


using namespace chip;
using namespace chip::Platform;
using namespace ::chip::DeviceLayer;
using namespace chip::app::Clusters;


constexpr EndpointId kEndpointId = 1; // the clusters server could be configured on any endpoint
constexpr uint8_t kStringNotFound = 0xFF;
constexpr uint8_t kMaxCommandStrLength = 30; 

struct mqttControlCommand {
    const char* cmdString;
    union{

#ifdef ZCL_USING_ON_OFF_CLUSTER_SERVER
        CommandId cmdId;
#endif //ZCL_USING_ON_OFF_CLUSTER_SERVER

#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
        DlLockState lockState;
#endif

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
        AttributeId attributeId;
#endif //ZCL_USING_THERMOSTAT_CLUSTER_SERVER

    }action;
};

typedef struct mqttControlCommand mqttControlCommand;

#ifdef ZCL_USING_ON_OFF_CLUSTER_SERVER
using namespace chip::app::Clusters::OnOff;

// OnOff cluster exposed commands to mqtt
static constexpr mqttControlCommand OnOffMqttControlCmd[] = {
    { .cmdString = "off", .action = { .cmdId = OnOff::Commands::Off::Id } },
    { .cmdString = "on", .action = { .cmdId = OnOff::Commands::On::Id } },
    { .cmdString = "toggle", .action = { .cmdId = OnOff::Commands::Toggle::Id } },
};
#endif //ZCL_USING_ON_OFF_CLUSTER_SERVER

#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
using namespace chip::app::Clusters::DoorLock;
// Doorlock cluster exposed commands to mqtt
static constexpr mqttControlCommand DlMqttControlCmd[] = {
    { .cmdString = "unlock",  .action = { .lockState = DlLockState::kUnlocked } },
    { .cmdString = "lock", .action = { .lockState = DlLockState::kLocked } },
};
#endif // ZCL_USING_DOOR_LOCK_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
namespace ThermAttr = chip::app::Clusters::Thermostat::Attributes;
static mqttControlCommand thermostatMqttControlCmd[] = {
    { .cmdString = "SetMode", .action = { .attributeId = ThermAttr::SystemMode::Id } },
    { .cmdString = "Heating", .action = { .attributeId = ThermAttr::OccupiedHeatingSetpoint::Id } },
    { .cmdString = "Cooling", .action = { .attributeId = ThermAttr::OccupiedCoolingSetpoint::Id } },
};

#endif

// Macro to get the number of elemet of a given array
#define COUNT_OF(A) (sizeof(A) / sizeof((A)[0]))

/* 
 * This function returns the index where a exposed command is in a given
 * mqttControlCommand can be found.
 * If the command string is not found/not exposed. This function returns kStringNotFound
 */
uint8_t GetCommandStringIndex(const mqttControlCommand* ctrlCmd,uint8_t size, char* stringToMatch)
{
    for (uint8_t index = 0; index < size; index++) {
        if (strcmp(stringToMatch, ctrlCmd[index].cmdString) == 0) {
            return index;
        }
    }

    return kStringNotFound; // string not found
}

namespace dic {
    namespace control {
/*
 * This function received data from dic mqtt. The data received is expected to be a 
 * string matching exposed cluster commands.
 * 
 * *** This function has no return for proof of concept sake,
 *     but error codes should be returned as many thing could happen here ***
 */
void dic_incoming_data_cb(void* arg, const char* topic, const uint8_t* data, uint16_t len, uint8_t flags)
{
    const struct mqtt_connect_client_info_t* client_info = (const struct mqtt_connect_client_info_t*)arg;
    (void)client_info;

    if (data == nullptr) {
        return;
    }

    uint8_t cmdIndex = kStringNotFound;
    char cmd[kMaxCommandStrLength] = { 0 };
    VerifyOrReturn(kMaxCommandStrLength > len);
        CopyString(cmd, len+1,(const char*) data);
    std::string cmdString(cmd);
    char *_cmd = strtok(const_cast<char *>(cmdString.c_str()), "/");
    char *value = strtok(NULL, "/");
    int32_t _value = 0;
    if (value != NULL)
    {
    _value = std::stoi(value);
    }
    SILABS_LOG("_value=%d",_value);

#ifdef ZCL_USING_ON_OFF_CLUSTER_SERVER
    cmdIndex = GetCommandStringIndex(OnOffMqttControlCmd,COUNT_OF(OnOffMqttControlCmd),_cmd);
    if (cmdIndex != kStringNotFound) {
        chip::DeviceLayer::PlatformMgr().LockChipStack();
        OnOffServer::Instance().setOnOffValue(kEndpointId, OnOffMqttControlCmd[cmdIndex].action.cmdId, false);
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();
        return;
    }
#endif // ZCL_USING_ON_OFF_CLUSTER_SERVER

#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
    cmdIndex = GetCommandStringIndex(DlMqttControlCmd, COUNT_OF(DlMqttControlCmd), _cmd);
    if (cmdIndex != kStringNotFound) {
        chip::DeviceLayer::PlatformMgr().LockChipStack();
        DoorLockServer::Instance().SetLockState(kEndpointId, DlMqttControlCmd[cmdIndex].action.lockState, OperationSourceEnum::kUnspecified);
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();
        return;
    }
#endif // ZCL_USING_DOOR_LOCK_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
    cmdIndex = GetCommandStringIndex(thermostatMqttControlCmd, COUNT_OF(thermostatMqttControlCmd), _cmd);
    if (cmdIndex != kStringNotFound) {
        chip::DeviceLayer::PlatformMgr().LockChipStack();
        if (thermostatMqttControlCmd[cmdIndex].action.attributeId == ThermAttr::SystemMode::Id)
        {
            Thermostat::Attributes::SystemMode::Set(kEndpointId, _value);
        }
        else if(thermostatMqttControlCmd[cmdIndex].action.attributeId == ThermAttr::OccupiedHeatingSetpoint::Id)
        {
            Thermostat::Attributes::OccupiedHeatingSetpoint::Set(kEndpointId, _value);
        }
        else if (thermostatMqttControlCmd[cmdIndex].action.attributeId == ThermAttr::OccupiedCoolingSetpoint::Id)
        {
            Thermostat::Attributes::OccupiedCoolingSetpoint::Set(kEndpointId, _value);
        }
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();
        return;
    }

#endif // ZCL_USING_THERMOSTAT_CLUSTER_SERVER

    if (cmdIndex == kStringNotFound) {
        SILABS_LOG("Command %s not found", cmd);
    }
}

void SubscribeMQTT(intptr_t context){
    dic_mqtt_subscribe(dic_incoming_data_cb, MQTT_SUBSCRIBE_TOPIC, 0);
}

void subscribeCB(void){
     chip::DeviceLayer::PlatformMgr().ScheduleWork(SubscribeMQTT, reinterpret_cast<intptr_t>(nullptr));
}
    } //control
} //dic