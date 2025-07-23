/***************************************************************************
 * @file SilabsTracing.h
 * @brief Instrumenting for matter operation tracing for the Silicon Labs platform.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#include "BLEChannelImpl.h"
#include <crypto/RandUtils.h>
#include <lib/support/logging/CHIPLogging.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/internal/CHIPDeviceLayerInternal.h>

namespace chip {
namespace DeviceLayer {
namespace Internal {

namespace {

inline constexpr uint8_t kAdvertisingFlagStaticRandomAddress = 1;
inline constexpr uint8_t kAttErrorCodeNoError                = 0;
inline constexpr uint8_t kAttErrorCodeInvalidHandle          = 0x01;
inline constexpr uint8_t kAttErrorApplicationError           = 0x80;
// For ble transmit, the size be smaller than  SL_BGAPI_MAX_PAYLOAD_SIZE - SL_BGAPI_MSG_HEADER_LEN : 256 - 5 = (251)
// For sl_bt_gattdb_add_uuid128_characteristic, the size must be smaller than 255 - 30, so we pick a value below those thresholds.
inline constexpr uint8_t kCharacteristicBufferSize = 220;
inline constexpr uint8_t kIndicateTimeout          = 30;

// Side Channel UUIDS
constexpr uint8_t kSideServiceUUID[16] = { 0x01, 0x00, 0x00, 0xEE, 0xFF, 0xC0, 0x00, 0x80,
                                           0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
constexpr uuid_128 kRxUUID = { .data = { 0x01, 0x00, 0x00, 0xEE, 0xFF, 0xC0, 0xAD, 0xDE, 0xEF, 0xBE, 0xAD, 0xDE, 0x00, 0xEE, 0xFF,
                                         0xC0 } };
constexpr uuid_128 kTxUUID = { .data = { 0x02, 0x00, 0x00, 0xEE, 0xFF, 0xC0, 0xAD, 0xDE, 0xEF, 0xBE, 0xAD, 0xDE, 0x00, 0xEE, 0xFF,
                                         0xC0 } };

uint8_t sRxValueBuffer[kCharacteristicBufferSize] = {};
uint8_t sTxValueBuffer[kCharacteristicBufferSize] = {};

CHIP_ERROR MapBLEError(int bleErr)
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

uint8_t MapCHIPError(CHIP_ERROR err)
{
    switch (err.AsInteger())
    {
    case CHIP_NO_ERROR.AsInteger():
        return kAttErrorCodeNoError;
    case CHIP_ERROR_INVALID_ARGUMENT.AsInteger():
        return kAttErrorCodeInvalidHandle;
    default:
        return kAttErrorApplicationError;
    }
}

} // namespace

CHIP_ERROR BLEChannelImpl::Init()
{
    uint16_t session;
    sl_status_t ret = sl_bt_gattdb_new_session(&session);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    // Add service
    ret = sl_bt_gattdb_add_service(session, sl_bt_gattdb_primary_service,
                                   0, // not advertised
                                   sizeof(kSideServiceUUID), kSideServiceUUID, &mSideServiceHandle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    // Add RX characteristic
    mSideRxChar.buffer = MutableByteSpan(sRxValueBuffer, sizeof(sRxValueBuffer));
    ret                = sl_bt_gattdb_add_uuid128_characteristic(session, mSideServiceHandle,
                                                                 SL_BT_GATTDB_CHARACTERISTIC_READ | SL_BT_GATTDB_CHARACTERISTIC_WRITE,
                                                                 0, // No security
                                                                 0, // No flags
                                                                 kRxUUID, sl_bt_gattdb_variable_length_value,
                                                                 kCharacteristicBufferSize, // Max length
                                                                 kCharacteristicBufferSize, mSideRxChar.buffer.data(), &mSideRxChar.handle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    // Add TX characteristic
    mSideTxChar.buffer = MutableByteSpan(sTxValueBuffer, sizeof(sTxValueBuffer));
    ret                = sl_bt_gattdb_add_uuid128_characteristic(session, mSideServiceHandle,
                                                                 SL_BT_GATTDB_CHARACTERISTIC_READ | SL_BT_GATTDB_CHARACTERISTIC_WRITE |
                                                                     SL_BT_GATTDB_CHARACTERISTIC_WRITE_NO_RESPONSE |
                                                                     SL_BT_GATTDB_CHARACTERISTIC_NOTIFY | SL_BT_GATTDB_CHARACTERISTIC_INDICATE,
                                                                 0, // No security
                                                                 0, // No flags
                                                                 kTxUUID, sl_bt_gattdb_variable_length_value,
                                                                 kCharacteristicBufferSize, // Max length
                                                                 kCharacteristicBufferSize, mSideTxChar.buffer.data(), &mSideTxChar.handle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    ret = sl_bt_gattdb_start_service(session, mSideServiceHandle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    ret = sl_bt_gattdb_start_characteristic(session, mSideRxChar.handle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    ret = sl_bt_gattdb_start_characteristic(session, mSideTxChar.handle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    ret = sl_bt_gattdb_commit(session);
    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::ConfigureAdvertising(const AdvConfigStruct & config)
{
    ChipLogProgress(DeviceLayer, "Configuring BLE Channel");

    sl_status_t ret;

    if (mAdvHandle == kInvalidAdvertisingHandle)
    {
        ret = sl_bt_advertiser_create_set(&mAdvHandle);
        VerifyOrReturnLogError(ret == SL_STATUS_OK, MapBLEError(ret));

        uint64_t random = Crypto::GetRandU64();
        memcpy(&mConnectionState.address, &random, sizeof(mConnectionState.address));

        // Set two MSBs to 11 to properly the address - BLE Static Device Address requirement
        mConnectionState.address.addr[5] |= 0xC0;

        ret = sl_bt_advertiser_set_random_address(mAdvHandle, sl_bt_gap_static_address, mConnectionState.address,
                                                  &mConnectionState.address);
        VerifyOrReturnLogError(ret == SL_STATUS_OK, MapBLEError(ret));

        ChipLogDetail(DeviceLayer, "BLE Static Device Address %02X:%02X:%02X:%02X:%02X:%02X", mConnectionState.address.addr[5],
                      mConnectionState.address.addr[4], mConnectionState.address.addr[3], mConnectionState.address.addr[2],
                      mConnectionState.address.addr[1], mConnectionState.address.addr[0]);
    }

    ret = sl_bt_legacy_advertiser_set_data(mAdvHandle, sl_bt_advertiser_advertising_data_packet, config.advData.size(),
                                           config.advData.data());
    VerifyOrReturnLogError(ret == SL_STATUS_OK, MapBLEError(ret));

    ret = sl_bt_legacy_advertiser_set_data(mAdvHandle, sl_bt_advertiser_scan_response_packet, config.responseData.size(),
                                           config.responseData.data());
    VerifyOrReturnLogError(ret == SL_STATUS_OK, MapBLEError(ret));

    mAdvIntervalMin     = config.intervalMin;
    mAdvIntervalMax     = config.intervalMax;
    mAdvDuration        = config.duration;
    mAdvMaxEvents       = config.maxEvents;
    mAdvConnectableMode = config.advConnectableMode;

    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEChannelImpl::StartAdvertising(void)
{
    // If already advertising, stop it, before changing values
    if (mFlags.Has(Flags::kAdvertising))
    {
        sl_bt_advertiser_stop(mAdvHandle);
    }

    sl_status_t ret;

    ret = sl_bt_advertiser_set_timing(mAdvHandle, mAdvIntervalMin, mAdvIntervalMax, mAdvDuration, mAdvMaxEvents);
    VerifyOrReturnLogError(ret == SL_STATUS_OK, MapBLEError(ret));

    ret = sl_bt_advertiser_configure(mAdvHandle, kAdvertisingFlagStaticRandomAddress);
    VerifyOrReturnLogError(ret == SL_STATUS_OK, MapBLEError(ret));

    // Start advertising
    ret = sl_bt_legacy_advertiser_start(mAdvHandle, mAdvConnectableMode);
    VerifyOrReturnLogError(ret == SL_STATUS_OK, MapBLEError(ret));

    mFlags.Set(Flags::kAdvertising);
    ChipLogProgress(DeviceLayer, "BLE Advertising started successfully");

    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEChannelImpl::StopAdvertising(void)
{
    if (mFlags.Has(Flags::kAdvertising))
    {
        sl_status_t ret = SL_STATUS_OK;

        mFlags.Clear(Flags::kAdvertising);

        ret = sl_bt_advertiser_stop(mAdvHandle);
        sl_bt_advertiser_clear_random_address(mAdvHandle);
        sl_bt_advertiser_delete_set(mAdvHandle);
        mAdvHandle = kInvalidAdvertisingHandle;
        VerifyOrReturnLogError(CHIP_NO_ERROR == MapBLEError(ret), MapBLEError(ret));
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEChannelImpl::NotifyCharacteristic(uint16_t characteristicHandle)
{
    MutableByteSpan dataSpan;
    ReturnErrorOnFailure(GetCharacteristicValue(characteristicHandle, dataSpan));
    sl_status_t ret = sl_bt_gatt_server_send_notification(mConnectionState.connectionHandle, characteristicHandle, dataSpan.size(),
                                                          dataSpan.data());
    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::IndicateCharacteristic(uint16_t characteristicHandle)
{
    MutableByteSpan dataSpan;
    ReturnErrorOnFailure(GetCharacteristicValue(characteristicHandle, dataSpan));
    sl_status_t ret = sl_bt_gatt_server_send_indication(mConnectionState.connectionHandle, characteristicHandle, dataSpan.size(),
                                                        dataSpan.data());
    return MapBLEError(ret);
}
void BLEChannelImpl::HandleIndicationTimeout(volatile sl_bt_msg_t * evt)
{
    sl_bt_evt_gatt_server_indication_timeout_t * indicationTimeout =
        (sl_bt_evt_gatt_server_indication_timeout_t *) &(evt->data.evt_gatt_server_indication_timeout);

    VerifyOrReturn(indicationTimeout->connection == mConnectionState.connectionHandle);
    ChipLogProgress(DeviceLayer, "Indication timeout for connection: %d", indicationTimeout->connection);
}
void BLEChannelImpl::HandleIndicationConfirmation(volatile sl_bt_msg_t * evt)
{
    sl_bt_evt_gatt_server_characteristic_status_t * indicationConfirmation =
        (sl_bt_evt_gatt_server_characteristic_status_t *) &(evt->data.evt_gatt_server_characteristic_status);

    VerifyOrReturn(indicationConfirmation->connection == mConnectionState.connectionHandle);
    ChipLogProgress(DeviceLayer, "Indication confirmation for connection: %d characteristic: %d",
                    indicationConfirmation->connection, indicationConfirmation->characteristic);
}

void BLEChannelImpl::AddConnection(uint8_t connectionHandle, uint8_t bondingHandle)
{
    // We currently only support one connection at a time on our side channel
    VerifyOrReturn(!mConnectionState.allocated, ChipLogError(DeviceLayer, "Connection already exists"));

    mConnectionState.connectionHandle = connectionHandle;
    mConnectionState.bondingHandle    = bondingHandle;
    mConnectionState.allocated        = 1;
    mConnectionState.subscribed       = 0;
}

bool BLEChannelImpl::RemoveConnection(uint8_t connectionHandle)
{
    VerifyOrReturnValue(mConnectionState.allocated, false);
    VerifyOrReturnValue(mConnectionState.connectionHandle == connectionHandle, false);
    memset(&mConnectionState, 0, sizeof(mConnectionState));
    return true;
}

void BLEChannelImpl::HandleReadRequest(volatile sl_bt_msg_t * evt)
{
    uint16_t sent_length;

    sl_bt_evt_gatt_server_user_read_request_t * readReq =
        (sl_bt_evt_gatt_server_user_read_request_t *) &(evt->data.evt_gatt_server_user_read_request);

    MutableByteSpan dataSpan;
    CHIP_ERROR err = GetCharacteristicValue(readReq->characteristic, dataSpan);
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "Failed to get characteristic value, err: %s", ErrorStr(err));
        sl_bt_gatt_server_send_user_read_response(readReq->connection, readReq->characteristic, MapCHIPError(err), 0, nullptr,
                                                  &sent_length);
    }
    else
    {
        ChipLogProgress(DeviceLayer, "Handling Read Request for characteristic: %d", readReq->characteristic);
        sl_status_t ret = sl_bt_gatt_server_send_user_read_response(
            readReq->connection, readReq->characteristic, kAttErrorCodeNoError, dataSpan.size(), dataSpan.data(), &sent_length);
        ChipLogProgress(DeviceLayer, "Sent %d of the %d bytes requested", sent_length, dataSpan.size());

        if (ret != SL_STATUS_OK)
        {
            ChipLogDetail(DeviceLayer, "Failed to send read response, err:%ld", ret);
        }
    }
}

void BLEChannelImpl::HandleWriteRequest(volatile sl_bt_msg_t * evt)
{
    sl_bt_evt_gatt_server_user_write_request_t * writeReq =
        (sl_bt_evt_gatt_server_user_write_request_t *) &(evt->data.evt_gatt_server_user_write_request);
    ChipLogProgress(DeviceLayer, "Handling Write Request for characteristic: %d", writeReq->characteristic);

    MutableByteSpan dataSpan;
    CHIP_ERROR err = SetCharacteristicValue(writeReq->characteristic, ByteSpan(writeReq->value.data, writeReq->value.len));
    if (err != CHIP_NO_ERROR)
    {
        ChipLogError(DeviceLayer, "Failed to set characteristic value, err: %s", ErrorStr(err));
        sl_bt_gatt_server_send_user_write_response(writeReq->connection, writeReq->characteristic, MapCHIPError(err));
        return;
    }

    ChipLogProgress(DeviceLayer, "Received Write Request for characteristic: %d, data size: %d", writeReq->characteristic,
                    writeReq->value.len);
    // Log the data received
    ChipLogByteSpan(DeviceLayer, dataSpan);

    sl_status_t ret =
        sl_bt_gatt_server_send_user_write_response(writeReq->connection, writeReq->characteristic, kAttErrorCodeNoError);
    if (ret != SL_STATUS_OK)
    {
        ChipLogDetail(DeviceLayer, "Failed to send write response, err:%ld", ret);
    }
}

bool BLEChannelImpl::CanHandleEvent(uint32_t event)
{
    // Check if the event is one that this channel can handle
    return (event == sl_bt_evt_gatt_server_indication_timeout_id);
}

CHIP_ERROR BLEChannelImpl::HandleCCCDWriteRequest(volatile sl_bt_msg_t * evt)
{
    ChipLogProgress(DeviceLayer, "Handling CCCD Write");

    sl_bt_evt_gatt_server_characteristic_status_t * CCCDWriteReq =
        (sl_bt_evt_gatt_server_characteristic_status_t *) &(evt->data.evt_gatt_server_characteristic_status);

    VerifyOrReturnLogError(mConnectionState.allocated, CHIP_ERROR_INCORRECT_STATE);
    VerifyOrReturnLogError(mConnectionState.connectionHandle == CCCDWriteReq->connection, CHIP_ERROR_INCORRECT_STATE);

    switch (CCCDWriteReq->client_config_flags)
    {
    case sl_bt_gatt_disable:
        // Handle indication/notification disable
        ChipLogProgress(DeviceLayer, "Side Channel Indication/Notification disabled for characteristic: %d",
                        CCCDWriteReq->characteristic); // Log the TX Char handle value
        break;
    case sl_bt_gatt_indication: {
        // Handle indication enable
        ChipLogProgress(DeviceLayer, "Side Channel Indication enabled for characteristic: %d", CCCDWriteReq->characteristic);
        MutableByteSpan dataSpan;
        ReturnErrorOnFailure(GetCharacteristicValue(CCCDWriteReq->characteristic, dataSpan));
        sl_status_t ret = sl_bt_gatt_server_send_indication(mConnectionState.connectionHandle, CCCDWriteReq->characteristic,
                                                            dataSpan.size(), dataSpan.data());
        return MapBLEError(ret);
    }
    case sl_bt_gatt_notification: {
        // Handle notification enable
        ChipLogProgress(DeviceLayer, "Side Channel Notification enabled for characteristic: %d", CCCDWriteReq->characteristic);
        MutableByteSpan dataSpan;
        ReturnErrorOnFailure(GetCharacteristicValue(CCCDWriteReq->characteristic, dataSpan));
        sl_status_t ret = sl_bt_gatt_server_send_notification(mConnectionState.connectionHandle, CCCDWriteReq->characteristic,
                                                              dataSpan.size(), dataSpan.data());
        return MapBLEError(ret);
    }
    default:
        // Handle unknown flags
        ChipLogError(DeviceLayer, "Unknown client config flags: %d for characteristic: %d", CCCDWriteReq->client_config_flags,
                     CCCDWriteReq->characteristic);
        return CHIP_ERROR_INVALID_ARGUMENT;
    }

    return CHIP_NO_ERROR;
}

void BLEChannelImpl::UpdateMtu(volatile sl_bt_msg_t * evt)
{
    mConnectionState.mtu = evt->data.evt_gatt_mtu_exchanged.mtu;
    ChipLogProgress(DeviceLayer, "MTU exchanged: %d", evt->data.evt_gatt_mtu_exchanged.mtu);
}

CHIP_ERROR BLEChannelImpl::GeneratAdvertisingData(uint8_t discoverMove, uint8_t connectMode, const Optional<uint16_t> & maxEvents)
{
    sl_status_t ret = sl_bt_legacy_advertiser_generate_data(mAdvHandle, discoverMove);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

    if (maxEvents.HasValue())
    {
        mAdvMaxEvents = maxEvents.Value();
        // TODO: Revisit a set timing function for the advertising handle
        ret = sl_bt_advertiser_set_timing(mAdvHandle, 160, 160, 0, mAdvMaxEvents);
        VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));
    }
    mAdvConnectableMode = connectMode;

    ret = sl_bt_legacy_advertiser_start(mAdvHandle, mAdvConnectableMode);

    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::OpenConnection(bd_addr address, uint8_t addrType)
{
    VerifyOrReturnError(addrType <= sl_bt_gap_random_nonresolvable_address, CHIP_ERROR_INVALID_ARGUMENT);
    if (mConnectionState.allocated)
    {
        // We only support one connection at a time for now
        ChipLogError(DeviceLayer, "Connection already allocated");
        return CHIP_ERROR_INCORRECT_STATE;
    }

    sl_status_t ret = sl_bt_connection_open(address, addrType, sl_bt_gap_1m_phy, &mConnectionState.connectionHandle);
    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::SetConnectionParams(const Optional<uint8_t> & connectionHandle, uint32_t intervalMin,
                                               uint32_t intervalMax, uint16_t latency, uint16_t timeout)
{
    sl_status_t ret;
    if (connectionHandle.HasValue())
    {
        ret = sl_bt_connection_set_parameters(connectionHandle.Value(), intervalMin, intervalMax, latency, timeout, 0,
                                              kDefaultConnectionEventLenght);
    }
    else
    {
        ret = sl_bt_connection_set_default_parameters(intervalMin, intervalMax, latency, timeout, 0, kDefaultConnectionEventLenght);
    }
    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::SetAdvertisingParams(uint32_t intervalMin, uint32_t intervalMax, uint16_t duration,
                                                const Optional<uint16_t> & maxEvents, const Optional<uint8_t> & channelMap)
{
    sl_status_t ret;

    mAdvIntervalMin = intervalMin;
    mAdvIntervalMax = intervalMax;
    mAdvDuration    = duration;
    mAdvMaxEvents   = maxEvents.ValueOr(0);

    if (channelMap.HasValue())
    {
        ret = sl_bt_advertiser_set_channel_map(mAdvHandle, channelMap.Value());
        VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));
    }

    ret = sl_bt_advertiser_set_timing(mAdvHandle, mAdvIntervalMin, mAdvIntervalMax, mAdvDuration, mAdvMaxEvents);
    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::CloseConnection()
{
    sl_status_t ret = sl_bt_connection_close(mConnectionState.connectionHandle);
    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::SetAdvHandle(uint8_t handle)
{
    sl_status_t ret;
    if (mAdvHandle == kInvalidAdvertisingHandle)
    {
        mAdvHandle = handle;
        ret        = sl_bt_advertiser_create_set(&mAdvHandle);
    }
    else if (handle == mAdvHandle)
    {
        return CHIP_NO_ERROR;
    }
    else
    {
        ret = sl_bt_advertiser_delete_set(mAdvHandle);
        VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));

        mAdvHandle = handle;
        ret        = sl_bt_advertiser_create_set(&mAdvHandle);
    }
    return MapBLEError(ret);
}

CHIP_ERROR BLEChannelImpl::DiscoverRemoteServices()
{
    sl_status_t ret = sl_bt_gatt_discover_primary_services(mConnectionState.connectionHandle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEChannelImpl::DiscoverRemoteCharacteristics(uint32_t serviceHandle)
{
    sl_status_t ret = sl_bt_gatt_discover_characteristics(mConnectionState.connectionHandle, serviceHandle);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEChannelImpl::SetRemoteCharacteristicNotification(uint16_t characteristicHandle, uint8_t flags)
{
    sl_status_t ret = sl_bt_gatt_set_characteristic_notification(mConnectionState.connectionHandle, characteristicHandle, flags);
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEChannelImpl::SetRemoteCharacteristicValue(uint16_t characteristicHandle, const ByteSpan & value)
{
    sl_status_t ret =
        sl_bt_gatt_write_characteristic_value(mConnectionState.connectionHandle, characteristicHandle, value.size(), value.data());
    VerifyOrReturnError(ret == SL_STATUS_OK, MapBLEError(ret));
    return CHIP_NO_ERROR;
}

// Side Channel methods
CHIP_ERROR BLEChannelImpl::GetCharacteristicValue(uint16_t charHandle, MutableByteSpan & dataSpan)
{
    if (charHandle == mSideRxChar.handle)
    {
        dataSpan = mSideRxChar.buffer;
    }
    else if (charHandle == mSideTxChar.handle)
    {
        dataSpan = mSideTxChar.buffer;
    }
    else
    {
        ChipLogError(DeviceLayer, "Unknown characteristic handle: %d", charHandle);
        return CHIP_ERROR_INVALID_ARGUMENT;
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR BLEChannelImpl::SetCharacteristicValue(uint16_t charHandle, const ByteSpan & value)
{
    if (charHandle == mSideRxChar.handle)
    {
        VerifyOrReturnError(value.size() <= kCharacteristicBufferSize, CHIP_ERROR_BUFFER_TOO_SMALL,
                            ChipLogError(DeviceLayer, "Value size exceeds RX characteristic buffer size"));

        mSideRxChar.buffer = MutableByteSpan(sRxValueBuffer, sizeof(sRxValueBuffer));
        CopySpanToMutableSpan(value, mSideRxChar.buffer);
    }
    else if (charHandle == mSideTxChar.handle)
    {
        VerifyOrReturnError(value.size() <= kCharacteristicBufferSize, CHIP_ERROR_BUFFER_TOO_SMALL,
                            ChipLogError(DeviceLayer, "Value size exceeds TX characteristic buffer size"));
        mSideTxChar.buffer = MutableByteSpan(sTxValueBuffer, sizeof(sTxValueBuffer));
        CopySpanToMutableSpan(value, mSideTxChar.buffer);
    }
    else
    {
        ChipLogError(DeviceLayer, "Unknown characteristic handle: %d", charHandle);
        return CHIP_ERROR_INVALID_ARGUMENT;
    }
    return CHIP_NO_ERROR;
}

} // namespace Internal
} // namespace DeviceLayer
} // namespace chip
