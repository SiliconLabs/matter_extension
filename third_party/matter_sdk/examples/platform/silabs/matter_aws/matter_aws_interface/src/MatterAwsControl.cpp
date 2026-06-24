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

#include "silabs_utils.h"
#include <platform/CHIPDeviceLayer.h>

#include "MatterAws.h"
#include "MatterAwsControl.h"

#ifdef SL_MATTER_ENABLE_AWS_OTA_FEAT
extern "C" {
extern void aws_ota_init(void);
}
#endif

#ifdef ZCL_USING_ON_OFF_CLUSTER_SERVER
#include <app/clusters/on-off-server/on-off-server.h>
#endif // ZCL_USING_ON_OFF_CLUSTER_SERVER

#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
#include <app/clusters/door-lock-server/door-lock-server.h>
#endif // ZCL_USING_DOOR_LOCK_CLUSTER_SERVER

#ifdef ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER
#include <app/clusters/window-covering-server/window-covering-server.h>
#endif // ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
#include <app/clusters/thermostat-server/ThermostatCluster.h>
#endif // ZCL_USING_THERMOSTAT_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
#define DECIMAL (10)
#define MSG_SIZE (5)

namespace ThermAttr = chip::app::Clusters::Thermostat::Attributes;
#endif // ZCL_USING_THERMOSTAT_CLUSTER_SERVER

using namespace chip;
using namespace chip::Platform;
using namespace ::chip::DeviceLayer;
using namespace chip::app::Clusters;

constexpr EndpointId kEndpointId       = 1; // the clusters server could be configured on any endpoint
constexpr uint8_t kStringNotFound      = 0xFF;
constexpr uint8_t kMaxCommandStrLength = 30;

struct mqttControlCommand
{
    const char * cmdString;
    union
    {

#ifdef ZCL_USING_ON_OFF_CLUSTER_SERVER
        CommandId cmdId;
#endif // ZCL_USING_ON_OFF_CLUSTER_SERVER

#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
        DlLockState lockState;
#endif // ZCL_USING_DOOR_LOCK_CLUSTER_SERVER

#ifdef ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER
        void (*setPosition)(EndpointId,
                            chip::app::Clusters::WindowCovering::NPercent100ths); // Function pointer to set the position
#endif                                                                            // ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
        void (*setAttribute)(EndpointId, int32_t); // Function pointer to set the attribute
#endif                                             // ZCL_USING_THERMOSTAT_CLUSTER_SERVER

    } action;
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
#endif // ZCL_USING_ON_OFF_CLUSTER_SERVER

#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
using namespace chip::app::Clusters::DoorLock;
// Doorlock cluster exposed commands to mqtt
static constexpr mqttControlCommand DlMqttControlCmd[] = {
    { .cmdString = "unlock", .action = { .lockState = DlLockState::kUnlocked } },
    { .cmdString = "lock", .action = { .lockState = DlLockState::kLocked } },
};
#endif // ZCL_USING_DOOR_LOCK_CLUSTER_SERVER

#ifdef ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER
using namespace chip::app::Clusters::WindowCovering;
static mqttControlCommand WindowMqttControlCmd[] = {
    { .cmdString = "Lift",
      .action    = { .setPosition =
                         [](EndpointId endpoint, chip::app::Clusters::WindowCovering::NPercent100ths value) {
                          LiftPositionSet(endpoint, value);
                      } } },
    { .cmdString = "Tilt",
      .action    = { .setPosition =
                         [](EndpointId endpoint, chip::app::Clusters::WindowCovering::NPercent100ths value) {
                          TiltPositionSet(endpoint, value);
                      } } },
};
#endif // ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
namespace ThermAttr                                  = chip::app::Clusters::Thermostat::Attributes;
static mqttControlCommand thermostatMqttControlCmd[] = {
    { .cmdString = "SetMode",
      .action    = { .setAttribute =
                         [](EndpointId endpoint, int32_t value) {
                          Thermostat::Attributes::SystemMode::Set(endpoint, static_cast<Thermostat::SystemModeEnum>(value));
                      } } },
    { .cmdString = "Heating",
      .action    = { .setAttribute = [](EndpointId endpoint,
                                     int32_t value) { Thermostat::Attributes::OccupiedHeatingSetpoint::Set(endpoint, value); } } },
    { .cmdString = "Cooling",
      .action    = { .setAttribute = [](EndpointId endpoint,
                                     int32_t value) { Thermostat::Attributes::OccupiedCoolingSetpoint::Set(endpoint, value); } } },
};
#endif // ZCL_USING_THERMOSTAT_CLUSTER_SERVER

// Macro to get the number of elemet of a given array
#define COUNT_OF(A) (sizeof(A) / sizeof((A)[0]))

/*
 * This function returns the index where a exposed command is in a given
 * mqttControlCommand can be found.
 * If the command string is not found/not exposed. This function returns kStringNotFound
 */
uint8_t GetCommandStringIndex(const mqttControlCommand * ctrlCmd, uint8_t size, char * stringToMatch)
{
    for (uint8_t index = 0; index < size; index++)
    {
        if (strcmp(stringToMatch, ctrlCmd[index].cmdString) == 0)
        {
            return index;
        }
    }

    return kStringNotFound; // string not found
}

namespace matterAws {
namespace control {
/*
 * This function received data from matterAws mqtt. The data received is expected to be a
 * string matching exposed cluster commands.
 *
 * *** This function has no return for proof of concept sake,
 *     but error codes should be returned as many thing could happen here ***
 */

#ifdef SL_MATTER_ENABLE_AWS_OTA_FEAT
void aws_ota_init_task(void * parameters)
{
    (void) parameters;
    aws_ota_init();
}
#endif

void MatterAwsIncomingDataCb(void * arg, const char * topic, uint16_t topic_len, const uint8_t * data, uint16_t len, uint8_t flags)
{
    const struct mqtt_connect_client_info_t * client_info = (const struct mqtt_connect_client_info_t *) arg;
    (void) client_info;

    if (data == nullptr)
    {
        return;
    }

    uint8_t cmdIndex               = kStringNotFound;
    char cmd[kMaxCommandStrLength] = { 0 };
    VerifyOrReturn(kMaxCommandStrLength > len);
    CopyString(cmd, len + 1, (const char *) data);
    std::string cmdString(cmd);
    char * _cmd                     = strtok(const_cast<char *>(cmdString.c_str()), "/");
    char * value                    = strtok(NULL, "/");
    [[maybe_unused]] int32_t _value = 0;
    if (value != NULL)
    {
        _value = std::stoi(value);
    }
    ChipLogDetail(AppServer, "[MATTER_AWS] _value: %ld", _value);

#ifdef SL_MATTER_ENABLE_AWS_OTA_FEAT
    if (strcmp(cmd, "ota") == 0)
    {
        static TaskHandle_t AWS_OTA = NULL;
        if (AWS_OTA == NULL)
        {
            if ((pdPASS !=
                 xTaskCreate(aws_ota_init_task, "AWS_OTA", AWS_OTA_TASK_STACK_SIZE, NULL, AWS_OTA_TASK_PRIORITY, &AWS_OTA)) ||
                !AWS_OTA)
            {
                ChipLogError(AppServer, "[MATTER_AWS] failed to create AWS OTA task");
                return;
            }
            ChipLogError(AppServer, "[MATTER_AWS] Task creation successfull for AWS OTA thread");
        }
        return;
    }
#endif

#ifdef ZCL_USING_ON_OFF_CLUSTER_SERVER
    cmdIndex = GetCommandStringIndex(OnOffMqttControlCmd, COUNT_OF(OnOffMqttControlCmd), _cmd);
    if (cmdIndex != kStringNotFound)
    {
        chip::DeviceLayer::PlatformMgr().LockChipStack();
        OnOffServer::Instance().setOnOffValue(kEndpointId, OnOffMqttControlCmd[cmdIndex].action.cmdId, false);
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();
        return;
    }
#endif // ZCL_USING_ON_OFF_CLUSTER_SERVER

#ifdef ZCL_USING_DOOR_LOCK_CLUSTER_SERVER
    cmdIndex = GetCommandStringIndex(DlMqttControlCmd, COUNT_OF(DlMqttControlCmd), _cmd);
    if (cmdIndex != kStringNotFound)
    {
        OperationErrorEnum err = OperationErrorEnum::kUnspecified;
        const chip::app::DataModel::Nullable<chip::FabricIndex> fabricIdx = chip::app::DataModel::NullNullable;
        const chip::app::DataModel::Nullable<chip::NodeId> nodeId         = chip::app::DataModel::NullNullable;
        const chip::Optional<chip::ByteSpan> pinCode                      = chip::NullOptional;
        const bool wantLock = (DlMqttControlCmd[cmdIndex].action.lockState == DlLockState::kLocked);

        chip::DeviceLayer::PlatformMgr().LockChipStack();
        const bool success = wantLock
            ? emberAfPluginDoorLockOnDoorLockCommand(kEndpointId, fabricIdx, nodeId, pinCode, err)
                                      : emberAfPluginDoorLockOnDoorUnlockCommand(kEndpointId, fabricIdx, nodeId, pinCode, err);
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();

        if (!success)
        {
            ChipLogError(AppServer, "[MATTER_AWS] door lock command failed, err=%u", to_underlying(err));
        }
        return;
    }
#endif // ZCL_USING_DOOR_LOCK_CLUSTER_SERVER

#ifdef ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER
    cmdIndex = GetCommandStringIndex(WindowMqttControlCmd, COUNT_OF(WindowMqttControlCmd), _cmd);
    if (cmdIndex != kStringNotFound)
    {
        chip::DeviceLayer::PlatformMgr().LockChipStack();
        WindowMqttControlCmd[cmdIndex].action.setPosition(kEndpointId,
                                                          (chip::app::Clusters::WindowCovering::NPercent100ths) _value);
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();
        return;
    }
#endif // ZCL_USING_WINDOW_COVERING_CLUSTER_SERVER

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
    cmdIndex = GetCommandStringIndex(thermostatMqttControlCmd, COUNT_OF(thermostatMqttControlCmd), _cmd);
    if (cmdIndex != kStringNotFound)
    {
        chip::DeviceLayer::PlatformMgr().LockChipStack();
        thermostatMqttControlCmd[cmdIndex].action.setAttribute(kEndpointId, _value);
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();
        return;
    }

#endif // ZCL_USING_THERMOSTAT_CLUSTER_SERVER

    if (cmdIndex == kStringNotFound)
    {
        ChipLogError(AppServer, "[MATTER_AWS] command %s not found", cmd);
    }
}

void SubscribeMQTT(intptr_t context)
{
    MatterAwsMqttSubscribe(NULL, NULL, MatterAwsIncomingDataCb, MQTT_SUBSCRIBE_TOPIC, MQTT_QOS_0);
}

void subscribeCB(void)
{
    CHIP_ERROR err = chip::DeviceLayer::PlatformMgr().ScheduleWork(SubscribeMQTT, reinterpret_cast<intptr_t>(nullptr));
    VerifyOrReturn(CHIP_NO_ERROR == err, ChipLogError(AppServer, "[MATTER_AWS] failed to schedule work: %s", err.AsString()));
}

#ifdef ZCL_USING_THERMOSTAT_CLUSTER_SERVER
void AttributeHandler(EndpointId endpointId, AttributeId attributeId)
{
    chip::app::DataModel::Nullable<int16_t> currentTempRaw;
    int16_t coolingSetpointRaw            = 0;
    int16_t heatingSetpointRaw            = 0;
    Thermostat::SystemModeEnum systemMode = Thermostat::SystemModeEnum::kOff;
    char buffer[MSG_SIZE];

    switch (attributeId)
    {
    case ThermAttr::LocalTemperature::Id: {
        ThermAttr::LocalTemperature::Get(endpointId, currentTempRaw);
        const int16_t tempCenti = currentTempRaw.IsNull() ? 0 : currentTempRaw.Value();
        itoa(tempCenti / 100, buffer, DECIMAL);
        MatterAwsSendMsg("thermostat/LocalTemperature/Temp", buffer);
    }
    break;

    case ThermAttr::OccupiedCoolingSetpoint::Id: {
        ThermAttr::OccupiedCoolingSetpoint::Get(endpointId, &coolingSetpointRaw);
        itoa(coolingSetpointRaw / 100, buffer, DECIMAL);
        MatterAwsSendMsg("thermostat/OccupiedCoolingSetpoint/coolingTemp", buffer);
    }
    break;

    case ThermAttr::OccupiedHeatingSetpoint::Id: {
        ThermAttr::OccupiedHeatingSetpoint::Get(endpointId, &heatingSetpointRaw);
        itoa(heatingSetpointRaw / 100, buffer, DECIMAL);
        MatterAwsSendMsg("thermostat/OccupiedHeatingSetpoint/heatingTemp", buffer);
    }
    break;

    case ThermAttr::SystemMode::Id: {
        const char * modeStr;
        ThermAttr::SystemMode::Get(endpointId, &systemMode);
        ThermAttr::LocalTemperature::Get(endpointId, currentTempRaw);
        switch (systemMode)
        {
        case Thermostat::SystemModeEnum::kOff:
            modeStr = "OFF";
            break;
        case Thermostat::SystemModeEnum::kAuto:
            modeStr = "HEAT&COOL";
            break;
        case Thermostat::SystemModeEnum::kCool:
            modeStr = "COOL";
            break;
        case Thermostat::SystemModeEnum::kHeat:
            modeStr = "HEAT";
            break;
        default:
            modeStr = "INVALID MODE";
            break;
        }
        const int16_t tempCenti = currentTempRaw.IsNull() ? 0 : currentTempRaw.Value();
        itoa(tempCenti / 100, buffer, DECIMAL);
        MatterAwsSendMsg("thermostat/systemMode", modeStr);
        MatterAwsSendMsg("thermostat/currentTemp", buffer);
    }
    break;

    default: {
        ChipLogError(AppServer, "[MATTER_AWS] unhandled thermostat attributeId: %lx", attributeId);
        return;
    }
    break;
    }
}
#endif // ZCL_USING_THERMOSTAT_CLUSTER_SERVER
} // namespace control
} // namespace matterAws
