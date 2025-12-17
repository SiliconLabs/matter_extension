/*
 *
 *    Copyright (c) 2020-2021 Project CHIP Authors
 *    Copyright (c) 2019 Nest Labs, Inc.
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
 *    @file
 *          Provides an implementation of the BLEManager singleton object
 *          for the Silicon Labs EFR32 platforms.
 */

/* this file behaves like a config.h, comes first */
#include <platform/internal/CHIPDeviceLayerInternal.h>
#if CHIP_DEVICE_CONFIG_ENABLE_CHIPOBLE

#if defined(SL_COMPONENT_CATALOG_PRESENT)
#include "sl_component_catalog.h"
#endif

#include "sl_component_catalog.h"

#include <platform/internal/BLEManager.h>

#if SL_USE_INTERNAL_BLE_SIDE_CHANNEL
#include <platform/silabs/efr32/BLEChannelImpl.h>
#endif // SL_USE_INTERNAL_BLE_SIDE_CHANNEL

#include "FreeRTOS.h"
#include "rail.h"
extern "C" {
#include "sl_bluetooth.h"
}
#include "sl_bt_api.h"
#include "sl_bt_stack_config.h"
#include "sl_bt_stack_init.h"
#include "timers.h"
#include <ble/Ble.h>
#include <crypto/RandUtils.h>
#include <cstring>
#include <lib/support/CodeUtils.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/CommissionableDataProvider.h>
#include <platform/DeviceInstanceInfoProvider.h>
#include <sl_bt_rtos_adaptation.h>

#if CHIP_ENABLE_ADDITIONAL_DATA_ADVERTISING
#include <setup_payload/AdditionalDataPayloadGenerator.h>
#endif

#include <headers/ProvisionChannel.h>
#include <headers/ProvisionManager.h>

using namespace ::chip;
using namespace ::chip::Ble;

namespace chip {
namespace DeviceLayer {
namespace Internal {

namespace {

#define CHIP_ADV_DATA_TYPE_FLAGS 0x01
#define CHIP_ADV_DATA_TYPE_UUID 0x03
#define CHIP_ADV_DATA_TYPE_NAME 0x09
#define CHIP_ADV_DATA_TYPE_SERVICE_DATA 0x16

#define CHIP_ADV_DATA_FLAGS 0x06

#define CHIP_ADV_DATA 0
#define CHIP_ADV_SCAN_RESPONSE_DATA 1
#define CHIP_ADV_SHORT_UUID_LEN 2

#define MAX_RESPONSE_DATA_LEN 31
#define MAX_ADV_DATA_LEN 31

// Timer Frequency used.
#define TIMER_CLK_FREQ ((uint32_t) 32768)
// Convert msec to timer ticks.
#define TIMER_MS_2_TIMERTICK(ms) ((TIMER_CLK_FREQ * ms) / 1000)
#define TIMER_S_2_TIMERTICK(s) (TIMER_CLK_FREQ * s)

#define BLE_MAX_BUFFER_SIZE (3076)
#define BLE_MAX_ADVERTISERS (1)
#define BLE_CONFIG_MAX_PERIODIC_ADVERTISING_SYNC (0)
#define BLE_CONFIG_MAX_SOFTWARE_TIMERS (4)
#define BLE_CONFIG_MIN_TX_POWER (-30)
#define BLE_CONFIG_MAX_TX_POWER (80)
#define BLE_CONFIG_RF_PATH_GAIN_TX (0)
#define BLE_CONFIG_RF_PATH_GAIN_RX (0)

// Default Connection  parameters
#define BLE_CONFIG_MIN_INTERVAL (16) // Time = Value x 1.25 ms = 20ms
#define BLE_CONFIG_MAX_INTERVAL (80) // Time = Value x 1.25 ms = 100ms
#define BLE_CONFIG_LATENCY (0)
#define BLE_CONFIG_TIMEOUT (100)          // Time = Value x 10 ms = 1s
#define BLE_CONFIG_MIN_CE_LENGTH (0)      // Leave to min value
#define BLE_CONFIG_MAX_CE_LENGTH (0xFFFF) // Leave to max value

#define BLE_CONFIG_MIN_INTERVAL_SC (32)   // Time = Value * 0.625 ms = 20ms
#define BLE_CONFIG_MAX_INTERVAL_SC (8000) // Time = Value * 0.625 ms = 5s

osTimerId_t sbleAdvTimeoutTimer; // SW timer

const uint8_t UUID_CHIPoBLEService[]      = { 0xFB, 0x34, 0x9B, 0x5F, 0x80, 0x00, 0x00, 0x80,
                                              0x00, 0x10, 0x00, 0x00, 0xF6, 0xFF, 0x00, 0x00 };
const uint8_t ShortUUID_CHIPoBLEService[] = { 0xF6, 0xFF };

bd_addr randomizedAddr = { 0 };

bool isMATTERoBLECharacteristic(uint16_t characteristic)
{
    return (gattdb_CHIPoBLEChar_Rx == characteristic || gattdb_CHIPoBLEChar_Tx == characteristic ||
            gattdb_CHIPoBLEChar_C3 == characteristic);
}

#if SL_USE_INTERNAL_BLE_SIDE_CHANNEL
BLEChannelImpl sBleSideChannel;
#endif // SL_USE_INTERNAL_BLE_SIDE_CHANNEL

} // namespace

BLEManagerImpl BLEManagerImpl::sInstance;

CHIP_ERROR BLEManagerImpl::_Init()
{
    // Initialize the CHIP BleLayer.
    ReturnErrorOnFailure(BleLayer::Init(this, this, &DeviceLayer::SystemLayer()));

    // This line hasn't changed but since the BLEConState definition has moved to
    // BLEChannel.h, the compiler seems to think that the memset is not valid
    // since the size of the struct is not known here.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmemset-elt-size"
    memset(mBleConnections, 0, sizeof(mBleConnections));
#pragma GCC diagnostic pop
    memset(mIndConfId, kUnusedIndex, sizeof(mIndConfId));
    mServiceMode = ConnectivityManager::kCHIPoBLEServiceMode_Enabled;

    // SW timer for BLE timeouts and interval change.
    sbleAdvTimeoutTimer = osTimerNew(BleAdvTimeoutHandler, osTimerOnce, NULL, NULL);

    mFlags.ClearAll().Set(Flags::kAdvertisingEnabled, CHIP_DEVICE_CONFIG_CHIPOBLE_ENABLE_ADVERTISING_AUTOSTART);
    mFlags.Set(Flags::kFastAdvertisingEnabled, true);

    // Check that an address was not already configured at boot.
    // This covers the init-shutdown-init case to comply with the BLE address change at boot only requirement
    bd_addr temp = { 0 };
    if (memcmp(&randomizedAddr, &temp, sizeof(bd_addr)) == 0)
    {
        // Since a random address is not configured, configure one
        uint64_t random = Crypto::GetRandU64();
        // Copy random value to address. We don't care of the ordering since it's a random value.
        memcpy(&randomizedAddr, &random, sizeof(randomizedAddr));

        // Set two MSBs to 11 to properly the address - BLE Static Device Address requirement
        randomizedAddr.addr[5] |= 0xC0;
    }

#if SL_USE_INTERNAL_BLE_SIDE_CHANNEL
    ReturnErrorOnFailure(sBleSideChannel.Init());
    BLEMgrImpl().InjectSideChannel(&sBleSideChannel);
    BLEMgrImpl().SideChannelConfigureAdvertisingDefaultData();
#endif

    PlatformMgr().ScheduleWork(DriveBLEState, 0);
    return CHIP_NO_ERROR;
}

uint16_t BLEManagerImpl::_NumConnections(void)
{
    uint16_t numCons = 0;
    for (uint16_t i = 0; i < kMaxConnections; i++)
    {
        if (mBleConnections[i].allocated)
        {
            numCons++;
        }
    }

    return numCons;
}

CHIP_ERROR BLEManagerImpl::_SetAdvertisingEnabled(bool val)
{
    CHIP_ERROR err = CHIP_NO_ERROR;

    VerifyOrExit(mServiceMode != ConnectivityManager::kCHIPoBLEServiceMode_NotSupported, err = CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE);

    if (mFlags.Has(Flags::kAdvertisingEnabled) != val)
    {
        mFlags.Set(Flags::kAdvertisingEnabled, val);
        PlatformMgr().ScheduleWork(DriveBLEState, 0);
    }

exit:
    return err;
}

CHIP_ERROR BLEManagerImpl::_SetAdvertisingMode(BLEAdvertisingMode mode)
{
    switch (mode)
    {
    case BLEAdvertisingMode::kFastAdvertising:
        mFlags.Set(Flags::kFastAdvertisingEnabled, true);
        break;
    case BLEAdvertisingMode::kSlowAdvertising:
        mFlags.Set(Flags::kFastAdvertisingEnabled, false);
        break;
    default:
        return CHIP_ERROR_INVALID_ARGUMENT;
    }
    mFlags.Set(Flags::kRestartAdvertising);
    PlatformMgr().ScheduleWork(DriveBLEState, 0);
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEManagerImpl::_GetDeviceName(char * buf, size_t bufSize)
{
    if (strlen(mDeviceName) >= bufSize)
    {
        return CHIP_ERROR_BUFFER_TOO_SMALL;
    }
    strcpy(buf, mDeviceName);
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEManagerImpl::_SetDeviceName(const char * deviceName)
{
    if (mServiceMode == ConnectivityManager::kCHIPoBLEServiceMode_NotSupported)
    {
        return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
    }
    if (deviceName != NULL && deviceName[0] != 0)
    {
        if (strlen(deviceName) >= kMaxDeviceNameLength)
        {
            return CHIP_ERROR_INVALID_ARGUMENT;
        }
        strcpy(mDeviceName, deviceName);
        mFlags.Set(Flags::kDeviceNameSet);
        mFlags.Set(Flags::kRestartAdvertising);
        ChipLogProgress(DeviceLayer, "Setting device name to : \"%s\"", mDeviceName);
    }
    else
    {
        mDeviceName[0] = 0;
    }
    PlatformMgr().ScheduleWork(DriveBLEState, 0);
    return CHIP_NO_ERROR;
}

void BLEManagerImpl::_OnPlatformEvent(const ChipDeviceEvent * event)
{
    switch (event->Type)
    {
    case DeviceEventType::kCHIPoBLESubscribe: {
        ChipDeviceEvent connEstEvent;

        ChipLogProgress(DeviceLayer, "_OnPlatformEvent kCHIPoBLESubscribe");
        HandleSubscribeReceived(event->CHIPoBLESubscribe.ConId, &CHIP_BLE_SVC_ID, &Ble::CHIP_BLE_CHAR_2_UUID);
        connEstEvent.Type = DeviceEventType::kCHIPoBLEConnectionEstablished;
        PlatformMgr().PostEventOrDie(&connEstEvent);
    }
    break;

    case DeviceEventType::kCHIPoBLEUnsubscribe: {
        ChipLogProgress(DeviceLayer, "_OnPlatformEvent kCHIPoBLEUnsubscribe");
        HandleUnsubscribeReceived(event->CHIPoBLEUnsubscribe.ConId, &CHIP_BLE_SVC_ID, &Ble::CHIP_BLE_CHAR_2_UUID);
    }
    break;

    case DeviceEventType::kCHIPoBLEWriteReceived: {
        ChipLogProgress(DeviceLayer, "_OnPlatformEvent kCHIPoBLEWriteReceived");
        HandleWriteReceived(event->CHIPoBLEWriteReceived.ConId, &CHIP_BLE_SVC_ID, &Ble::CHIP_BLE_CHAR_1_UUID,
                            PacketBufferHandle::Adopt(event->CHIPoBLEWriteReceived.Data));
    }
    break;

    case DeviceEventType::kCHIPoBLEConnectionError: {
        ChipLogProgress(DeviceLayer, "_OnPlatformEvent kCHIPoBLEConnectionError");
        HandleConnectionError(event->CHIPoBLEConnectionError.ConId, event->CHIPoBLEConnectionError.Reason);
    }
    break;

    case DeviceEventType::kCHIPoBLEIndicateConfirm: {
        ChipLogProgress(DeviceLayer, "_OnPlatformEvent kCHIPoBLEIndicateConfirm");
        HandleIndicationConfirmation(event->CHIPoBLEIndicateConfirm.ConId, &CHIP_BLE_SVC_ID, &Ble::CHIP_BLE_CHAR_2_UUID);
    }
    break;

    default:
        ChipLogProgress(DeviceLayer, "_OnPlatformEvent default:  event->Type = %d", event->Type);
        break;
    }
}

CHIP_ERROR BLEManagerImpl::SubscribeCharacteristic(BLE_CONNECTION_OBJECT conId, const ChipBleUUID * svcId,
                                                   const ChipBleUUID * charId)
{
    ChipLogProgress(DeviceLayer, "BLEManagerImpl::SubscribeCharacteristic() not supported");
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR BLEManagerImpl::UnsubscribeCharacteristic(BLE_CONNECTION_OBJECT conId, const ChipBleUUID * svcId,
                                                     const ChipBleUUID * charId)
{
    ChipLogProgress(DeviceLayer, "BLEManagerImpl::UnsubscribeCharacteristic() not supported");
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR BLEManagerImpl::CloseConnection(BLE_CONNECTION_OBJECT conId)
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    sl_status_t ret;

    ChipLogProgress(DeviceLayer, "Closing BLE GATT connection (con %u)", conId);

    ret = sl_bt_connection_close(conId);
    err = MapBLEError(ret);

    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "sl_bt_connection_close() failed: %" CHIP_ERROR_FORMAT, err.Format());
    }

    return err;
}

uint16_t BLEManagerImpl::GetMTU(BLE_CONNECTION_OBJECT conId) const
{
    BLEConState * conState = const_cast<BLEManagerImpl *>(this)->GetConnectionState(conId);
    return (conState != NULL) ? conState->mtu : 0;
}

CHIP_ERROR BLEManagerImpl::SendIndication(BLE_CONNECTION_OBJECT conId, const ChipBleUUID * svcId, const ChipBleUUID * charId,
                                          PacketBufferHandle data)
{
    CHIP_ERROR err         = CHIP_NO_ERROR;
    BLEConState * conState = GetConnectionState(conId);
    sl_status_t ret;
    uint16_t cId        = (UUIDsMatch(&Ble::CHIP_BLE_CHAR_1_UUID, charId) ? gattdb_CHIPoBLEChar_Rx : gattdb_CHIPoBLEChar_Tx);
    uint8_t timerHandle = GetTimerHandle(conId, true);

    VerifyOrExit(((conState != NULL) && (conState->subscribed != 0)), err = CHIP_ERROR_INVALID_ARGUMENT);
    VerifyOrExit(timerHandle != kMaxConnections, err = CHIP_ERROR_NO_MEMORY);

    // start timer for light indication confirmation. Long delay for spake2 indication
    sl_bt_system_set_lazy_soft_timer(TIMER_S_2_TIMERTICK(6), 0, timerHandle, true);

    ret = sl_bt_gatt_server_send_indication(conId, cId, (data->DataLength()), data->Start());
    err = MapBLEError(ret);

exit:
    return err;
}

CHIP_ERROR BLEManagerImpl::SendWriteRequest(BLE_CONNECTION_OBJECT conId, const ChipBleUUID * svcId, const ChipBleUUID * charId,
                                            PacketBufferHandle pBuf)
{
    ChipLogProgress(DeviceLayer, "BLEManagerImpl::SendWriteRequest() not supported");
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

void BLEManagerImpl::NotifyChipConnectionClosed(BLE_CONNECTION_OBJECT conId)
{
    CloseConnection(conId);
}

CHIP_ERROR BLEManagerImpl::MapBLEError(int bleErr)
{
    switch (bleErr)
    {
    case SL_STATUS_OK:
        return CHIP_NO_ERROR;
    case SL_STATUS_BT_ATT_INVALID_ATT_LENGTH:
        return CHIP_ERROR_INVALID_STRING_LENGTH;
    case SL_STATUS_INVALID_PARAMETER:
        return CHIP_ERROR_INVALID_ARGUMENT;
    case SL_STATUS_INVALID_STATE:
        return CHIP_ERROR_INCORRECT_STATE;
    case SL_STATUS_NOT_SUPPORTED:
        return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
    default:
        return CHIP_ERROR(ChipError::Range::kPlatform, bleErr + CHIP_DEVICE_CONFIG_SILABS_BLE_ERROR_MIN);
    }
}

void BLEManagerImpl::DriveBLEState(void)
{
    CHIP_ERROR err = CHIP_NO_ERROR;

    // Check if BLE stack is initialized
    VerifyOrExit(mFlags.Has(Flags::kSiLabsBLEStackInitialize), /* */);

    // Start advertising if needed...
    if (mServiceMode == ConnectivityManager::kCHIPoBLEServiceMode_Enabled && mFlags.Has(Flags::kAdvertisingEnabled) &&
        NumConnections() < kMaxConnections)
    {
        // Start/re-start advertising if not already started, or if there is a pending change
        // to the advertising configuration.
        if (!mFlags.Has(Flags::kAdvertising) || mFlags.Has(Flags::kRestartAdvertising))
        {
            err = StartAdvertising();
            SuccessOrExit(err);
        }
    }

    // Otherwise, stop advertising if it is enabled.
    else if (mFlags.Has(Flags::kAdvertising))
    {
        err = StopAdvertising();
        SuccessOrExit(err);
    }

exit:
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "Disabling CHIPoBLE service due to error: %" CHIP_ERROR_FORMAT, err.Format());
        mServiceMode = ConnectivityManager::kCHIPoBLEServiceMode_Disabled;
    }
}

CHIP_ERROR BLEManagerImpl::ConfigureAdvertisingData(void)
{
    sl_status_t ret;
    ChipBLEDeviceIdentificationInfo mDeviceIdInfo;
    CHIP_ERROR err;
    uint8_t responseData[MAX_RESPONSE_DATA_LEN];
    uint8_t advData[MAX_ADV_DATA_LEN];
    uint32_t index              = 0;
    uint32_t mDeviceNameLength  = 0;
    uint8_t mDeviceIdInfoLength = 0;

    VerifyOrExit((kMaxDeviceNameLength + 1) < UINT8_MAX, err = CHIP_ERROR_INVALID_ARGUMENT);

    memset(responseData, 0, MAX_RESPONSE_DATA_LEN);
    memset(advData, 0, MAX_ADV_DATA_LEN);

    err = ConfigurationMgr().GetBLEDeviceIdentificationInfo(mDeviceIdInfo);
    SuccessOrExit(err);

    if (!mFlags.Has(Flags::kDeviceNameSet))
    {
        uint16_t discriminator;
        SuccessOrExit(err = GetCommissionableDataProvider()->GetSetupDiscriminator(discriminator));

        snprintf(mDeviceName, sizeof(mDeviceName), "%s%04u", CHIP_DEVICE_CONFIG_BLE_DEVICE_NAME_PREFIX, discriminator);

        mDeviceName[kMaxDeviceNameLength] = 0;
        mDeviceNameLength                 = strlen(mDeviceName);

        VerifyOrExit(mDeviceNameLength < kMaxDeviceNameLength, err = CHIP_ERROR_INVALID_ARGUMENT);
    }

    mDeviceNameLength = strlen(mDeviceName); // Device Name length + length field
    VerifyOrExit(mDeviceNameLength < kMaxDeviceNameLength, err = CHIP_ERROR_INVALID_ARGUMENT);
    static_assert((kUUIDTlvSize + kDeviceNameTlvSize) <= MAX_RESPONSE_DATA_LEN, "Scan Response buffer is too small");

    mDeviceIdInfoLength = sizeof(mDeviceIdInfo); // Servicedatalen + length+ UUID (Short)
    static_assert(sizeof(mDeviceIdInfo) + CHIP_ADV_SHORT_UUID_LEN + 1 <= UINT8_MAX, "Our length won't fit in a uint8_t");
    static_assert(2 + CHIP_ADV_SHORT_UUID_LEN + sizeof(mDeviceIdInfo) + 1 <= MAX_ADV_DATA_LEN, "Our buffer is not big enough");

    index            = 0;
    advData[index++] = 0x02;                                                                    // length
    advData[index++] = CHIP_ADV_DATA_TYPE_FLAGS;                                                // AD type : flags
    advData[index++] = CHIP_ADV_DATA_FLAGS;                                                     // AD value
    advData[index++] = static_cast<uint8_t>(mDeviceIdInfoLength + CHIP_ADV_SHORT_UUID_LEN + 1); // AD length
    advData[index++] = CHIP_ADV_DATA_TYPE_SERVICE_DATA;                                         // AD type : Service Data
    advData[index++] = ShortUUID_CHIPoBLEService[0];                                            // AD value
    advData[index++] = ShortUUID_CHIPoBLEService[1];

#if CHIP_DEVICE_CONFIG_EXT_ADVERTISING
    // Check for extended advertisement interval and redact VID/PID if past the initial period.
    if (mFlags.Has(Flags::kExtAdvertisingEnabled))
    {
        mDeviceIdInfo.SetVendorId(0);
        mDeviceIdInfo.SetProductId(0);
        mDeviceIdInfo.SetExtendedAnnouncementFlag(true);
    }
#endif

    memcpy(&advData[index], (void *) &mDeviceIdInfo, mDeviceIdInfoLength); // AD value
    index += mDeviceIdInfoLength;

#if CHIP_ENABLE_ADDITIONAL_DATA_ADVERTISING
    ReturnErrorOnFailure(EncodeAdditionalDataTlv());
#endif

    if (mAdvertisingSetHandle == kInvalidAdvertisingHandle)
    {
        ret = sl_bt_advertiser_create_set(&mAdvertisingSetHandle);
        VerifyOrExit(ret == SL_STATUS_OK, {
            err = MapBLEError(ret);
            ChipLogError(DeviceLayer, "sl_bt_advertiser_create_set() failed: %" CHIP_ERROR_FORMAT, err.Format());
        });

        ret = sl_bt_advertiser_set_random_address(mAdvertisingSetHandle, sl_bt_gap_static_address, randomizedAddr, &randomizedAddr);
        VerifyOrExit(ret == SL_STATUS_OK, {
            err = MapBLEError(ret);
            ChipLogError(DeviceLayer, "sl_bt_advertiser_set_random_address() failed: %" CHIP_ERROR_FORMAT, err.Format());
        });
        ChipLogDetail(DeviceLayer, "BLE Static Device Address %02X:%02X:%02X:%02X:%02X:%02X", randomizedAddr.addr[5],
                      randomizedAddr.addr[4], randomizedAddr.addr[3], randomizedAddr.addr[2], randomizedAddr.addr[1],
                      randomizedAddr.addr[0]);
    }

    ret = sl_bt_legacy_advertiser_set_data(mAdvertisingSetHandle, sl_bt_advertiser_advertising_data_packet, index,
                                           (uint8_t *) advData);

    VerifyOrExit(ret == SL_STATUS_OK, {
        err = MapBLEError(ret);
        ChipLogError(DeviceLayer, "sl_bt_legacy_advertiser_set_data() - Advertising Data failed: %" CHIP_ERROR_FORMAT,
                     err.Format());
    });

    index = 0;

    responseData[index++] = CHIP_ADV_SHORT_UUID_LEN + 1;  // AD length
    responseData[index++] = CHIP_ADV_DATA_TYPE_UUID;      // AD type : uuid
    responseData[index++] = ShortUUID_CHIPoBLEService[0]; // AD value
    responseData[index++] = ShortUUID_CHIPoBLEService[1];

    responseData[index++] = static_cast<uint8_t>(mDeviceNameLength + 1); // length
    responseData[index++] = CHIP_ADV_DATA_TYPE_NAME;                     // AD type : name
    memcpy(&responseData[index], mDeviceName, mDeviceNameLength);        // AD value
    index += mDeviceNameLength;

    ret = sl_bt_legacy_advertiser_set_data(mAdvertisingSetHandle, sl_bt_advertiser_scan_response_packet, index,
                                           (uint8_t *) responseData);

    VerifyOrExit(ret == SL_STATUS_OK, {
        err = MapBLEError(ret);
        ChipLogError(DeviceLayer, "sl_bt_legacy_advertiser_set_data() - Scan Response failed: %" CHIP_ERROR_FORMAT, err.Format());
    });

    err = MapBLEError(ret);

exit:
    return err;
}

CHIP_ERROR BLEManagerImpl::StartAdvertising(void)
{
    CHIP_ERROR err          = CHIP_NO_ERROR;
    sl_status_t ret         = SL_STATUS_OK;
    uint32_t interval_min   = 0;
    uint32_t interval_max   = 0;
    bool postAdvChangeEvent = false;
    uint8_t connectableAdv =
        (NumConnections() < kMaxConnections) ? sl_bt_advertiser_connectable_scannable : sl_bt_advertiser_scannable_non_connectable;

    // If already advertising, stop it, before changing values
    if (mFlags.Has(Flags::kAdvertising))
    {
        sl_bt_advertiser_stop(mAdvertisingSetHandle);
    }
    else
    {
        ChipLogDetail(DeviceLayer, "Start BLE advertisement");
        postAdvChangeEvent = true;
    }

    err = ConfigureAdvertisingData();
    SuccessOrExit(err);

    mFlags.Clear(Flags::kRestartAdvertising);

    if (mFlags.Has(Flags::kFastAdvertisingEnabled))
    {
        interval_min = CHIP_DEVICE_CONFIG_BLE_FAST_ADVERTISING_INTERVAL_MIN;
        interval_max = CHIP_DEVICE_CONFIG_BLE_FAST_ADVERTISING_INTERVAL_MAX;
    }
    else
    {
#if CHIP_DEVICE_CONFIG_EXT_ADVERTISING
        if (!mFlags.Has(Flags::kExtAdvertisingEnabled))
        {
            interval_min = CHIP_DEVICE_CONFIG_BLE_SLOW_ADVERTISING_INTERVAL_MIN;
            interval_max = CHIP_DEVICE_CONFIG_BLE_SLOW_ADVERTISING_INTERVAL_MAX;
        }
        else
        {
            interval_min = CHIP_DEVICE_CONFIG_BLE_EXT_ADVERTISING_INTERVAL_MIN;
            interval_max = CHIP_DEVICE_CONFIG_BLE_EXT_ADVERTISING_INTERVAL_MAX;
        }
#else
        interval_min = CHIP_DEVICE_CONFIG_BLE_SLOW_ADVERTISING_INTERVAL_MIN;
        interval_max = CHIP_DEVICE_CONFIG_BLE_SLOW_ADVERTISING_INTERVAL_MAX;
#endif
    }

    ChipLogProgress(DeviceLayer, "Starting advertising with interval_min=%u, intverval_max=%u (units of 625us)",
                    static_cast<unsigned>(interval_min), static_cast<unsigned>(interval_max));
    ret = sl_bt_advertiser_set_timing(mAdvertisingSetHandle, interval_min, interval_max, 0, 0);
    err = MapBLEError(ret);
    SuccessOrExit(err);

    sl_bt_advertiser_configure(mAdvertisingSetHandle, 1);

    ret = sl_bt_legacy_advertiser_start(mAdvertisingSetHandle, connectableAdv);
    err = MapBLEError(ret);
    SuccessOrExit(err);

    if (mFlags.Has(Flags::kFastAdvertisingEnabled))
    {
        StartBleAdvTimeoutTimer(CHIP_DEVICE_CONFIG_BLE_ADVERTISING_INTERVAL_CHANGE_TIME);
    }
    mFlags.Set(Flags::kAdvertising);

    if (postAdvChangeEvent)
    {
        // Post CHIPoBLEAdvertisingChange event.
        ChipDeviceEvent advChange;
        advChange.Type                             = DeviceEventType::kCHIPoBLEAdvertisingChange;
        advChange.CHIPoBLEAdvertisingChange.Result = kActivity_Started;

        ReturnErrorOnFailure(PlatformMgr().PostEvent(&advChange));
    }

exit:
    return err;
}

CHIP_ERROR BLEManagerImpl::StopAdvertising(void)
{
    CHIP_ERROR err = CHIP_NO_ERROR;

    if (mFlags.Has(Flags::kAdvertising))
    {
        sl_status_t ret = SL_STATUS_OK;

        mFlags.Clear(Flags::kAdvertising).Clear(Flags::kRestartAdvertising);
        mFlags.Set(Flags::kFastAdvertisingEnabled, true);

        ret = sl_bt_advertiser_stop(mAdvertisingSetHandle);
        sl_bt_advertiser_clear_random_address(mAdvertisingSetHandle);

        sl_bt_advertiser_delete_set(mAdvertisingSetHandle);
        mAdvertisingSetHandle = kInvalidAdvertisingHandle;
        err                   = MapBLEError(ret);
        VerifyOrReturnError(err == CHIP_NO_ERROR, err);

        CancelBleAdvTimeoutTimer();

        // Post CHIPoBLEAdvertisingChange event.
        ChipDeviceEvent advChange;
        advChange.Type                             = DeviceEventType::kCHIPoBLEAdvertisingChange;
        advChange.CHIPoBLEAdvertisingChange.Result = kActivity_Stopped;
        err                                        = PlatformMgr().PostEvent(&advChange);
    }

    return err;
}
#if SL_BLE_SIDE_CHANNEL_ENABLED
#if SL_USE_INTERNAL_BLE_SIDE_CHANNEL
CHIP_ERROR BLEManagerImpl::SideChannelConfigureAdvertisingDefaultData(void)
{
    VerifyOrReturnError(mBleSideChannel != nullptr, CHIP_ERROR_INCORRECT_STATE);

    uint8_t advData[MAX_ADV_DATA_LEN];
    uint32_t index = 0;

    // Flags
    advData[index++] = 2;                        // Length
    advData[index++] = CHIP_ADV_DATA_TYPE_FLAGS; // Flags AD Type
    advData[index++] = 0x06;                     // LE General Discoverable Mode, BR/EDR not supported

    // Service UUID
    advData[index++] = 3;                       // Length
    advData[index++] = CHIP_ADV_DATA_TYPE_UUID; // 16-bit UUID
    advData[index++] = 0x34;                    // UUID 0x1234 (little endian)
    advData[index++] = 0x12;
    ByteSpan advDataSpan(advData, index);

    uint8_t responseData[MAX_RESPONSE_DATA_LEN];
    index = 0;

    const char * sideChannelName = "Si-Channel";
    size_t sideChannelNameLen    = strlen(sideChannelName);

    responseData[index++] = static_cast<uint8_t>(sideChannelNameLen + 1);
    responseData[index++] = 0x09; // Complete Local Name
    memcpy(&responseData[index], sideChannelName, sideChannelNameLen);
    index += sideChannelNameLen;
    ByteSpan responseDataSpan(responseData, index);

    AdvConfigStruct config = { advDataSpan,
                               responseDataSpan,
                               BLE_CONFIG_MIN_INTERVAL_SC,
                               BLE_CONFIG_MAX_INTERVAL_SC,
                               sl_bt_advertiser_connectable_scannable,
                               0,
                               0 };
    return mBleSideChannel->ConfigureAdvertising(config);
}
#endif // SL_USE_INTERNAL_BLE_SIDE_CHANNEL

CHIP_ERROR BLEManagerImpl::InjectSideChannel(BLEChannel * channel)
{
    VerifyOrReturnError(nullptr != channel, CHIP_ERROR_INVALID_ARGUMENT);
    mBleSideChannel = channel;
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEManagerImpl::SideChannelConfigureAdvertising(ByteSpan advData, ByteSpan responseData, uint32_t intervalMin,
                                                           uint32_t intervalMax, uint16_t duration, uint8_t maxEvents)
{
    VerifyOrReturnError(mBleSideChannel != nullptr, CHIP_ERROR_INCORRECT_STATE);
    AdvConfigStruct config = { advData,  responseData, intervalMin, intervalMax, sl_bt_advertiser_connectable_scannable,
                               duration, maxEvents };
    return mBleSideChannel->ConfigureAdvertising(config);
}

CHIP_ERROR BLEManagerImpl::SideChannelStartAdvertising(void)
{
    VerifyOrReturnError(mBleSideChannel != nullptr, CHIP_ERROR_INCORRECT_STATE);
    return mBleSideChannel->StartAdvertising();
}

CHIP_ERROR BLEManagerImpl::SideChannelStopAdvertising(void)
{
    VerifyOrReturnError(mBleSideChannel != nullptr, CHIP_ERROR_INCORRECT_STATE);
    return mBleSideChannel->StopAdvertising();
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleReadEvent(volatile sl_bt_msg_t * evt)
{
    EventFilter eventFilter = EventFilter::UnprocessedEvent;
    if (GetConnectionState(evt->data.evt_gatt_server_user_read_request.connection) ||
        isMATTERoBLECharacteristic(evt->data.evt_gatt_server_user_read_request.characteristic))
    {
        eventFilter = EventFilter::MatterReservedEvent;
        // Sends invalid handle if the user attemps to read a value other than C3 on CHIPoBLE
        // or if the user attempts to read a CHIPoBLE characteristic on the side channel
        sl_bt_gatt_server_send_user_read_response(evt->data.evt_gatt_server_user_read_request.connection,
                                                  evt->data.evt_gatt_server_user_read_request.characteristic, 0x01, 0, 0, nullptr);
    }

    return eventFilter;
}
#endif // SL_BLE_SIDE_CHANNEL_ENABLED

BLEManagerImpl::EventFilter BLEManagerImpl::UpdateMtu(volatile sl_bt_msg_t * evt)
{
    BLEConState * bleConnState = GetConnectionState(evt->data.evt_gatt_mtu_exchanged.connection);
    VerifyOrReturnValue(bleConnState != nullptr, EventFilter::UnprocessedEvent);
    // bleConnState->MTU is a 10-bit field inside a uint16_t.  We're
    // assigning to it from a uint16_t, and compilers warn about
    // possibly not fitting.  There's no way to suppress that warning
    // via explicit cast; we have to disable the warning around the
    // assignment.
    //
    // TODO: https://github.com/project-chip/connectedhomeip/issues/2569
    // tracks making this safe with a check or explaining why no check
    // is needed.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wconversion"
    bleConnState->mtu = evt->data.evt_gatt_mtu_exchanged.mtu;
#pragma GCC diagnostic pop

    return EventFilter::MatterReservedEvent;
}

void BLEManagerImpl::HandleBootEvent(void)
{
    mFlags.Set(Flags::kSiLabsBLEStackInitialize);
    PlatformMgr().ScheduleWork(DriveBLEState, 0);
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleConnectEvent(volatile sl_bt_msg_t * evt)
{
    EventFilter eventFilter                  = EventFilter::UnprocessedEvent;
    sl_bt_evt_connection_opened_t * conn_evt = (sl_bt_evt_connection_opened_t *) &(evt->data);

    if (conn_evt->advertiser == mAdvertisingSetHandle)
    {
        eventFilter = EventFilter::MatterReservedEvent;
        ChipLogProgress(DeviceLayer, "Connect Event for CHIPoBLE on handle : %d", conn_evt->connection);

        AddConnection(conn_evt->connection, conn_evt->bonding);
        PlatformMgr().ScheduleWork(DriveBLEState, 0);
    }

    return eventFilter;
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleConnectParams(volatile sl_bt_msg_t * evt)
{
    EventFilter eventFilter                           = EventFilter::UnprocessedEvent;
    sl_bt_evt_connection_parameters_t * con_param_evt = (sl_bt_evt_connection_parameters_t *) &(evt->data);

    // If the connection belongs to the CHIPoBLE service
    if (nullptr != GetConnectionState(con_param_evt->connection, false))
    {
        eventFilter = EventFilter::MatterReservedEvent;
        ChipLogProgress(DeviceLayer, "Connection Parameters Event for handle : %d", con_param_evt->connection);
        ChipLogProgress(DeviceLayer, "Connection parameter ID received - i:%d, l:%d, t:%d, sm:%d", con_param_evt->interval,
                        con_param_evt->latency, con_param_evt->timeout, con_param_evt->security_mode);

        uint16_t desiredTimeout = con_param_evt->timeout < BLE_CONFIG_TIMEOUT ? BLE_CONFIG_TIMEOUT : con_param_evt->timeout;

        // For better stability, renegotiate the connection parameters if the received ones from the central are outside
        // of our defined constraints
        if (desiredTimeout != con_param_evt->timeout || con_param_evt->interval < BLE_CONFIG_MIN_INTERVAL ||
            con_param_evt->interval > BLE_CONFIG_MAX_INTERVAL)
        {
            ChipLogProgress(DeviceLayer, "Renegotiate BLE connection parameters to minInterval:%d, maxInterval:%d, timeout:%d",
                            BLE_CONFIG_MIN_INTERVAL, BLE_CONFIG_MAX_INTERVAL, desiredTimeout);
            sl_bt_connection_set_parameters(con_param_evt->connection, BLE_CONFIG_MIN_INTERVAL, BLE_CONFIG_MAX_INTERVAL,
                                            BLE_CONFIG_LATENCY, desiredTimeout, BLE_CONFIG_MIN_CE_LENGTH, BLE_CONFIG_MAX_CE_LENGTH);
        }

        PlatformMgr().ScheduleWork(DriveBLEState, 0);
    }
    return eventFilter;
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleConnectionCloseEvent(volatile sl_bt_msg_t * evt)
{
    EventFilter eventFilter                  = EventFilter::UnprocessedEvent;
    sl_bt_evt_connection_closed_t * conn_evt = (sl_bt_evt_connection_closed_t *) &(evt->data);

    if (nullptr != GetConnectionState(conn_evt->connection, false))
    {
        eventFilter = EventFilter::MatterReservedEvent;
        ChipLogProgress(DeviceLayer, "Disconnect Event for CHIPoBLE on handle : %d", conn_evt->connection);
        if (RemoveConnection(conn_evt->connection))
        {
            ChipDeviceEvent event;
            event.Type                          = DeviceEventType::kCHIPoBLEConnectionError;
            event.CHIPoBLEConnectionError.ConId = conn_evt->connection;

            switch (conn_evt->reason)
            {
            case SL_STATUS_BT_CTRL_REMOTE_USER_TERMINATED:
            case SL_STATUS_BT_CTRL_REMOTE_DEVICE_TERMINATED_CONNECTION_DUE_TO_LOW_RESOURCES:
            case SL_STATUS_BT_CTRL_REMOTE_POWERING_OFF:
                event.CHIPoBLEConnectionError.Reason = BLE_ERROR_REMOTE_DEVICE_DISCONNECTED;
                break;

            case SL_STATUS_BT_CTRL_CONNECTION_TERMINATED_BY_LOCAL_HOST:
                event.CHIPoBLEConnectionError.Reason = BLE_ERROR_APP_CLOSED_CONNECTION;
                break;

            default:
                event.CHIPoBLEConnectionError.Reason = BLE_ERROR_CHIPOBLE_PROTOCOL_ABORT;
                break;
            }

            ChipLogProgress(DeviceLayer, "BLE GATT connection closed (con %u, reason %u)", conn_evt->connection, conn_evt->reason);

            PlatformMgr().PostEventOrDie(&event);

            // Arrange to re-enable connectable advertising in case it was disabled due to the
            // maximum connection limit being reached.
            mFlags.Set(Flags::kRestartAdvertising);
            mFlags.Set(Flags::kFastAdvertisingEnabled);
        }

        PlatformMgr().ScheduleWork(DriveBLEState, 0);
    }
    return eventFilter;
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleWriteEvent(volatile sl_bt_msg_t * evt)
{
    EventFilter eventFilter = EventFilter::UnprocessedEvent;
    if (GetConnectionState(evt->data.evt_gatt_server_user_write_request.connection))
    {
        eventFilter        = EventFilter::MatterReservedEvent;
        uint16_t attribute = evt->data.evt_gatt_server_user_write_request.characteristic;
        bool do_provision  = chip::DeviceLayer::Silabs::Provision::Manager::GetInstance().IsProvisionRequired();
        ChipLogProgress(DeviceLayer, "Char Write Req, char : %d", attribute);

        if (gattdb_CHIPoBLEChar_Rx == attribute)
        {
            if (do_provision)
            {
                chip::DeviceLayer::Silabs::Provision::Channel::Update(attribute);
                chip::DeviceLayer::Silabs::Provision::Manager::GetInstance().Step();
            }
            else
            {
                HandleRXCharWrite(evt);
            }
        }
    }
    else if (isMATTERoBLECharacteristic(evt->data.evt_gatt_server_user_write_request.characteristic))
    {
        // Prevent to write CHIPoBLE Characteristics from other connections
        // This will fail if the characteristic has the WRITE_NO_RESPONSE property
        eventFilter = EventFilter::MatterReservedEvent;
        sl_bt_gatt_server_send_user_write_response(evt->data.evt_gatt_server_user_write_request.connection,
                                                   evt->data.evt_gatt_server_user_write_request.characteristic, 0x01);
    }

    return eventFilter;
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleTXCharCCCDWrite(volatile sl_bt_msg_t * evt)
{
    CHIP_ERROR err          = CHIP_NO_ERROR;
    EventFilter eventFilter = EventFilter::UnprocessedEvent;

    if (isMATTERoBLECharacteristic(evt->data.evt_gatt_server_user_write_request.characteristic))
    {
        eventFilter                = EventFilter::MatterReservedEvent;
        BLEConState * bleConnState = GetConnectionState(evt->data.evt_gatt_server_user_write_request.connection);

        // Silent fail when bleConnState == nullptr.
        // We don't own the connection but it is trying to write a MatterOBle Characteristic
        VerifyOrReturnValue(bleConnState != nullptr, eventFilter);

        if ((evt->data.evt_gatt_server_characteristic_status.characteristic == gattdb_CHIPoBLEChar_Tx) &&
            (evt->data.evt_gatt_server_characteristic_status.status_flags == sl_bt_gatt_server_client_config))
        {
            bool isIndicationEnabled = false;
            ChipDeviceEvent event;
            // Determine if the client is enabling or disabling notification/indication.
            isIndicationEnabled = (evt->data.evt_gatt_server_characteristic_status.client_config_flags == sl_bt_gatt_indication);

            ChipLogProgress(DeviceLayer, "HandleTXcharCCCDWrite - Config Flags value : %d",
                            evt->data.evt_gatt_server_characteristic_status.client_config_flags);
            ChipLogProgress(DeviceLayer, "CHIPoBLE %s received", isIndicationEnabled ? "subscribe" : "unsubscribe");

            if (isIndicationEnabled)
            {
                // If indications are not already enabled for the connection...
                if (!bleConnState->subscribed)
                {
                    bleConnState->subscribed = 1;
                    // Post an event to the CHIP queue to process either a CHIPoBLE Subscribe or Unsubscribe based on
                    // whether the client is enabling or disabling indications.
                    {
                        event.Type                    = DeviceEventType::kCHIPoBLESubscribe;
                        event.CHIPoBLESubscribe.ConId = evt->data.evt_gatt_server_user_write_request.connection;
                        err                           = PlatformMgr().PostEvent(&event);
                    }
                }
            }
            else
            {
                bleConnState->subscribed      = 0;
                event.Type                    = DeviceEventType::kCHIPoBLEUnsubscribe;
                event.CHIPoBLESubscribe.ConId = evt->data.evt_gatt_server_user_write_request.connection;
                err                           = PlatformMgr().PostEvent(&event);
            }
        }
    }

    LogErrorOnFailure(err);
    return eventFilter;
}

void BLEManagerImpl::HandleRXCharWrite(volatile sl_bt_msg_t * evt)
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    System::PacketBufferHandle buf;
    uint16_t writeLen = evt->data.evt_gatt_server_user_write_request.value.len;
    uint8_t * data    = (uint8_t *) evt->data.evt_gatt_server_user_write_request.value.data;

    // Copy the data to a packet buffer.
    buf = System::PacketBufferHandle::NewWithData(data, writeLen, 0, 0);
    VerifyOrExit(!buf.IsNull(), err = CHIP_ERROR_NO_MEMORY);

    ChipLogDetail(DeviceLayer, "Write request/command received for CHIPoBLE RX characteristic (con %u, len %u)",
                  evt->data.evt_gatt_server_user_write_request.connection, buf->DataLength());

    // Post an event to the CHIP queue to deliver the data into the CHIP stack.
    {
        ChipDeviceEvent event;
        event.Type                        = DeviceEventType::kCHIPoBLEWriteReceived;
        event.CHIPoBLEWriteReceived.ConId = evt->data.evt_gatt_server_user_write_request.connection;
        event.CHIPoBLEWriteReceived.Data  = std::move(buf).UnsafeRelease();
        err                               = PlatformMgr().PostEvent(&event);
    }

exit:
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "HandleRXCharWrite() failed: %" CHIP_ERROR_FORMAT, err.Format());
    }
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleTxConfirmationEvent(BLE_CONNECTION_OBJECT conId)
{
    VerifyOrReturnValue(GetConnectionState(conId), EventFilter::UnprocessedEvent);

    ChipDeviceEvent event;
    uint8_t timerHandle = sInstance.GetTimerHandle(conId, false);

    ChipLogProgress(DeviceLayer, "Tx Confirmation received");

    // stop indication confirmation timer
    if (timerHandle < kMaxConnections)
    {
        ChipLogProgress(DeviceLayer, " stop soft timer");
        sl_bt_system_set_lazy_soft_timer(0, 0, timerHandle, false);
    }

    event.Type                          = DeviceEventType::kCHIPoBLEIndicateConfirm;
    event.CHIPoBLEIndicateConfirm.ConId = conId;
    PlatformMgr().PostEventOrDie(&event);
    return EventFilter::MatterReservedEvent;
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleSoftTimerEvent(volatile sl_bt_msg_t * evt)
{
    // BLE Manager starts soft timers with timer handles less than kMaxConnections
    // If we receive a callback for unknown timer handle ignore this.
    VerifyOrReturnValue(evt->data.evt_system_soft_timer.handle < kMaxConnections, EventFilter::UnprocessedEvent);

    ChipLogProgress(DeviceLayer, "BLEManagerImpl::HandleSoftTimerEvent CHIPOBLE_PROTOCOL_ABORT");
    ChipDeviceEvent event;
    event.Type                                                   = DeviceEventType::kCHIPoBLEConnectionError;
    event.CHIPoBLEConnectionError.ConId                          = mIndConfId[evt->data.evt_system_soft_timer.handle];
    sInstance.mIndConfId[evt->data.evt_system_soft_timer.handle] = kUnusedIndex;
    event.CHIPoBLEConnectionError.Reason                         = BLE_ERROR_CHIPOBLE_PROTOCOL_ABORT;
    PlatformMgr().PostEventOrDie(&event);
    return EventFilter::MatterReservedEvent;
}

bool BLEManagerImpl::RemoveConnection(uint8_t connectionHandle)
{
    BLEConState * bleConnState = GetConnectionState(connectionHandle, true);
    bool status                = false;

    if (bleConnState != NULL)
    {
        memset(bleConnState, 0, sizeof(BLEConState));
        status = true;
    }

    return status;
}

void BLEManagerImpl::AddConnection(uint8_t connectionHandle, uint8_t bondingHandle)
{
    BLEConState * bleConnState = GetConnectionState(connectionHandle, true);

    if (bleConnState != NULL)
    {
        memset(bleConnState, 0, sizeof(BLEConState));
        bleConnState->allocated        = 1;
        bleConnState->connectionHandle = connectionHandle;
        bleConnState->bondingHandle    = bondingHandle;
    }
}

BLEConState * BLEManagerImpl::GetConnectionState(uint8_t connectionHandle, bool allocate)
{
    uint8_t freeIndex = kMaxConnections;

    for (uint8_t i = 0; i < kMaxConnections; i++)
    {
        if (mBleConnections[i].allocated == 1)
        {
            if (mBleConnections[i].connectionHandle == connectionHandle)
            {
                return &mBleConnections[i];
            }
        }

        else if (i < freeIndex)
        {
            freeIndex = i;
        }
    }

    if (allocate)
    {
        if (freeIndex < kMaxConnections)
        {
            return &mBleConnections[freeIndex];
        }

        ChipLogError(DeviceLayer, "Failed to allocate BLEConState");
    }

    return NULL;
}

#if CHIP_ENABLE_ADDITIONAL_DATA_ADVERTISING
CHIP_ERROR BLEManagerImpl::EncodeAdditionalDataTlv()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    BitFlags<AdditionalDataFields> additionalDataFields;
    AdditionalDataPayloadGeneratorParams additionalDataPayloadParams;

#if CHIP_ENABLE_ROTATING_DEVICE_ID && defined(CHIP_DEVICE_CONFIG_ROTATING_DEVICE_ID_UNIQUE_ID)
    uint8_t rotatingDeviceIdUniqueId[ConfigurationManager::kRotatingDeviceIDUniqueIDLength] = {};
    MutableByteSpan rotatingDeviceIdUniqueIdSpan(rotatingDeviceIdUniqueId);

    err = DeviceLayer::GetDeviceInstanceInfoProvider()->GetRotatingDeviceIdUniqueId(rotatingDeviceIdUniqueIdSpan);

    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(DeviceLayer, "Failed to GetRotatingDeviceIdUniqueId"));

    err = ConfigurationMgr().GetLifetimeCounter(additionalDataPayloadParams.rotatingDeviceIdLifetimeCounter);

    VerifyOrReturnError(err == CHIP_NO_ERROR, err, ChipLogError(DeviceLayer, "Failed to GetLifetimeCounter"));

    additionalDataPayloadParams.rotatingDeviceIdUniqueId = rotatingDeviceIdUniqueIdSpan;
    additionalDataFields.Set(AdditionalDataFields::RotatingDeviceId);
#endif /* CHIP_ENABLE_ROTATING_DEVICE_ID && defined(CHIP_DEVICE_CONFIG_ROTATING_DEVICE_ID_UNIQUE_ID) */

    err = AdditionalDataPayloadGenerator().generateAdditionalDataPayload(
        additionalDataPayloadParams, sInstance.c3AdditionalDataBufferHandle, additionalDataFields);

    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "Failed to generate TLV encoded Additional Data: %" CHIP_ERROR_FORMAT, err.Format());
    }
    return err;
}

BLEManagerImpl::EventFilter BLEManagerImpl::HandleC3ReadRequest(volatile sl_bt_msg_t * evt)
{
    EventFilter eventFilter = EventFilter::UnprocessedEvent;
    sl_bt_evt_gatt_server_user_read_request_t * readReq =
        (sl_bt_evt_gatt_server_user_read_request_t *) &(evt->data.evt_gatt_server_user_read_request);
    if (readReq->characteristic == gattdb_CHIPoBLEChar_C3)
    {
        eventFilter = EventFilter::MatterReservedEvent;

        ChipLogDetail(DeviceLayer, "Read request received for CHIPoBLEChar_C3 - opcode:%d", readReq->att_opcode);
        sl_status_t ret = sl_bt_gatt_server_send_user_read_response(readReq->connection, readReq->characteristic, 0,
                                                                    sInstance.c3AdditionalDataBufferHandle->DataLength(),
                                                                    sInstance.c3AdditionalDataBufferHandle->Start(), nullptr);

        if (ret != SL_STATUS_OK)
        {
            ChipLogError(DeviceLayer, "Failed to send read response, err:%ld", ret);
        }
    }
    return eventFilter;
}
#endif // CHIP_ENABLE_ADDITIONAL_DATA_ADVERTISING

uint8_t BLEManagerImpl::GetTimerHandle(uint8_t connectionHandle, bool allocate)
{
    uint8_t freeIndex = kMaxConnections;

    for (uint8_t i = 0; i < kMaxConnections; i++)
    {
        if (mIndConfId[i] == connectionHandle)
        {
            return i;
        }
        else if (allocate)
        {
            if (i < freeIndex)
            {
                freeIndex = i;
            }
        }
    }

    if (freeIndex < kMaxConnections)
    {
        mIndConfId[freeIndex] = connectionHandle;
    }
    else
    {
        ChipLogError(DeviceLayer, "Failed to Save Conn Handle for indication");
    }

    return freeIndex;
}

void BLEManagerImpl::BleAdvTimeoutHandler(void * arg)
{
    if (BLEMgrImpl().mFlags.Has(Flags::kFastAdvertisingEnabled))
    {
        ChipLogDetail(DeviceLayer, "bleAdv Timeout : Start slow advertisement");
        BLEMgrImpl().mFlags.Set(Flags::kAdvertising);
        BLEMgr().SetAdvertisingMode(BLEAdvertisingMode::kSlowAdvertising);
#if CHIP_DEVICE_CONFIG_EXT_ADVERTISING
        BLEMgrImpl().mFlags.Clear(Flags::kExtAdvertisingEnabled);
        BLEMgrImpl().StartBleAdvTimeoutTimer(CHIP_DEVICE_CONFIG_BLE_EXT_ADVERTISING_INTERVAL_CHANGE_TIME_MS);
#endif
    }
#if CHIP_DEVICE_CONFIG_EXT_ADVERTISING
    else
    {
        ChipLogDetail(DeviceLayer, "bleAdv Timeout : Start extended advertisement");
        BLEMgrImpl().mFlags.Set(Flags::kAdvertising);
        BLEMgrImpl().mFlags.Set(Flags::kExtAdvertisingEnabled);
        BLEMgr().SetAdvertisingMode(BLEAdvertisingMode::kSlowAdvertising);
    }
#endif
}

void BLEManagerImpl::CancelBleAdvTimeoutTimer(void)
{
    if (osTimerStop(sbleAdvTimeoutTimer) != osOK)
    {
        ChipLogError(DeviceLayer, "Failed to stop BledAdv timeout timer");
    }
}

void BLEManagerImpl::StartBleAdvTimeoutTimer(uint32_t aTimeoutInMs)
{
    if (osTimerStart(sbleAdvTimeoutTimer, pdMS_TO_TICKS(aTimeoutInMs)) != osOK)
    {
        ChipLogError(DeviceLayer, "Failed to start BledAdv timeout timer");
    }
}

void BLEManagerImpl::DriveBLEState(intptr_t arg)
{
    sInstance.DriveBLEState();
}

bool BLEManagerImpl::CanHandleEvent(uint32_t event)
{
    return (event == sl_bt_evt_system_boot_id || event == sl_bt_evt_connection_opened_id ||
            event == sl_bt_evt_connection_parameters_id || event == sl_bt_evt_connection_phy_status_id ||
            event == sl_bt_evt_connection_data_length_id || event == sl_bt_evt_connection_closed_id ||
            event == sl_bt_evt_gatt_server_attribute_value_id || event == sl_bt_evt_gatt_mtu_exchanged_id ||
            event == sl_bt_evt_gatt_server_characteristic_status_id || event == sl_bt_evt_system_soft_timer_id ||
            event == sl_bt_evt_gatt_server_user_read_request_id || event == sl_bt_evt_connection_remote_used_features_id);
}

BLEManagerImpl::EventFilter BLEManagerImpl::ParseEvent(volatile sl_bt_msg_t * evt)
{
    EventFilter eventFilter = EventFilter::UnprocessedEvent;
    VerifyOrReturnValue(CanHandleEvent(SL_BT_MSG_ID(evt->header)), eventFilter);
    // As this is running in a separate thread, and we determined this is a matter related event,
    // we need to block CHIP from operating, until the events are handled.
    // Todo: Move inside the MatteroBLE channel once created and verify if lock is necessary for other channels
    // Ideally at this level we just want to pick the channel and the each channel can have its own switch case
    chip::DeviceLayer::PlatformMgr().LockChipStack();

    switch (SL_BT_MSG_ID(evt->header))
    {
    case sl_bt_evt_system_boot_id: {
        ChipLogProgress(DeviceLayer, "Bluetooth stack booted: v%d.%d.%d-b%d", evt->data.evt_system_boot.major,
                        evt->data.evt_system_boot.minor, evt->data.evt_system_boot.patch, evt->data.evt_system_boot.build);
        HandleBootEvent();

        RAIL_Version_t railVer;
        RAIL_GetVersion(&railVer, true);
        ChipLogProgress(DeviceLayer, "RAIL version:, v%d.%d.%d-b%d", railVer.major, railVer.minor, railVer.rev, railVer.build);
        sl_bt_connection_set_default_parameters(BLE_CONFIG_MIN_INTERVAL, BLE_CONFIG_MAX_INTERVAL, BLE_CONFIG_LATENCY,
                                                BLE_CONFIG_TIMEOUT, BLE_CONFIG_MIN_CE_LENGTH, BLE_CONFIG_MAX_CE_LENGTH);

        eventFilter = EventFilter::SharableEvent;
    }
    break;

    case sl_bt_evt_connection_opened_id: {
        eventFilter = HandleConnectEvent(evt);
    }
    break;
    case sl_bt_evt_connection_parameters_id: {
        eventFilter = HandleConnectParams(evt);
    }
    break;
    case sl_bt_evt_connection_phy_status_id: {
        eventFilter = GetConnectionState(evt->data.evt_connection_phy_status.connection) ? EventFilter::MatterReservedEvent
                                                                                         : EventFilter::UnprocessedEvent;
        if (eventFilter == EventFilter::MatterReservedEvent)
        {
            ChipLogProgress(DeviceLayer, "Connection phy status ID received - phy:%d", evt->data.evt_connection_phy_status.phy);
        }
    }
    break;
    case sl_bt_evt_connection_data_length_id: {
        eventFilter = GetConnectionState(evt->data.evt_connection_data_length.connection) ? EventFilter::MatterReservedEvent
                                                                                          : EventFilter::UnprocessedEvent;
        if (eventFilter == EventFilter::MatterReservedEvent)
        {
            ChipLogProgress(DeviceLayer, "Connection data length ID received - txL:%d, txT:%d, rxL:%d, rxL:%d",
                            evt->data.evt_connection_data_length.tx_data_len, evt->data.evt_connection_data_length.tx_time_us,
                            evt->data.evt_connection_data_length.rx_data_len, evt->data.evt_connection_data_length.rx_time_us);
        }
    }
    break;
    case sl_bt_evt_connection_closed_id: {
        eventFilter = HandleConnectionCloseEvent(evt);
    }
    break;

    /* This event indicates that a remote GATT client is attempting to write a value of an
     * attribute in to the local GATT database, where the attribute was defined in the GATT
     * XML firmware configuration file to have type="user".  */
    case sl_bt_evt_gatt_server_attribute_value_id: {
        eventFilter = HandleWriteEvent(evt);
    }
    break;

    case sl_bt_evt_gatt_mtu_exchanged_id: {
        eventFilter = UpdateMtu(evt);
    }
    break;

    // confirmation of indication received from remote GATT client
    case sl_bt_evt_gatt_server_characteristic_status_id: {
        sl_bt_gatt_server_characteristic_status_flag_t StatusFlags;

        StatusFlags = (sl_bt_gatt_server_characteristic_status_flag_t) evt->data.evt_gatt_server_characteristic_status.status_flags;

        if (sl_bt_gatt_server_confirmation == StatusFlags)
        {
            eventFilter = HandleTxConfirmationEvent(evt->data.evt_gatt_server_characteristic_status.connection);
        }
        else
        {
            eventFilter = HandleTXCharCCCDWrite(evt);
        }
    }
    break;

    /* Software Timer event */
    case sl_bt_evt_system_soft_timer_id: {
        eventFilter = HandleSoftTimerEvent(evt);
    }
    break;

    case sl_bt_evt_gatt_server_user_read_request_id: {
        ChipLogProgress(DeviceLayer, "GATT server user_read_request");
#if CHIP_ENABLE_ADDITIONAL_DATA_ADVERTISING
        eventFilter = HandleC3ReadRequest(evt);
#endif // CHIP_ENABLE_ADDITIONAL_DATA_ADVERTISING
    }
    break;

    case sl_bt_evt_connection_remote_used_features_id: {
        eventFilter = GetConnectionState(evt->data.evt_connection_remote_used_features.connection)
            ? EventFilter::MatterReservedEvent
            : EventFilter::UnprocessedEvent;
    }
    break;

    default: {
        ChipLogProgress(DeviceLayer, "evt_UNKNOWN id = %08" PRIx32, SL_BT_MSG_ID(evt->header));
        break;
    }
    }

    // Unlock the stack
    chip::DeviceLayer::PlatformMgr().UnlockChipStack();
    return eventFilter;
}

} // namespace Internal
} // namespace DeviceLayer
} // namespace chip
#ifdef SL_CATALOG_MATTER_BLE_DMP_TEST_PRESENT
extern "C" void zigbee_bt_on_event(volatile sl_bt_msg_t * evt);
#endif // SL_CATALOG_MATTER_BLE_DMP_TEST_PRESENT

// TODO: Move this to matter_bl_event.cpp and update gn and slc build files
extern "C" void sl_bt_on_event(sl_bt_msg_t * evt)
{
    [[maybe_unused]] chip::DeviceLayer::Internal::BLEManagerImpl::EventFilter eventFilter;
    eventFilter = chip::DeviceLayer::Internal::BLEMgrImpl().ParseEvent(evt);

#if SL_BLE_SIDE_CHANNEL_ENABLED
    if (chip::DeviceLayer::Internal::BLEMgrImpl().GetSideChannel() != nullptr &&
        eventFilter != chip::DeviceLayer::Internal::BLEManagerImpl::EventFilter::MatterReservedEvent)
    {
        // The side channel may process events directly.
        chip::DeviceLayer::Internal::BLEMgrImpl().GetSideChannel()->ParseEvent(evt);
    }
#endif

#ifdef SL_CATALOG_MATTER_BLE_DMP_TEST_PRESENT
    zigbee_bt_on_event(evt);
#endif // SL_CATALOG_MATTER_BLE_DMP_TEST_PRESENT
}

#endif // CHIP_DEVICE_CONFIG_ENABLE_CHIPOBLE
