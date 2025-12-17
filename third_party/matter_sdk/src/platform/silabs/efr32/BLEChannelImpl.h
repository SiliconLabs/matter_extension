/***************************************************************************
 * @file BLEChannelImpl.h
 * @brief Implementation of BLE channel functionality for the Silicon Labs platform.
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
#pragma once

#include "BLEChannel.h"

namespace chip {
namespace DeviceLayer {
namespace Internal {

class BLEChannelImpl : public BLEChannel
{
public:
    CHIP_ERROR Init(void) override;
    CHIP_ERROR ConfigureAdvertising(const AdvConfigStruct & config) override;
    CHIP_ERROR StartAdvertising(void) override;
    CHIP_ERROR StopAdvertising(void) override;

    bool CanHandleEvent(uint32_t event) override;
    void ParseEvent(volatile sl_bt_msg_t * evt) override;
    void AddConnection(uint8_t connectionHandle, uint8_t bondingHandle) override;
    bool RemoveConnection(uint8_t connectionHandle) override;
    void HandleReadRequest(volatile sl_bt_msg_t * evt, ByteSpan data) override;
    void HandleWriteRequest(volatile sl_bt_msg_t * evt, MutableByteSpan data) override;

    CHIP_ERROR HandleCCCDWriteRequest(volatile sl_bt_msg_t * evt, bool & isNewSubscription) override;
    void UpdateMtu(volatile sl_bt_msg_t * evt) override;

    CHIP_ERROR GeneratAdvertisingData(uint8_t discoverMove, uint8_t connectMode, const Optional<uint16_t> & maxEvents) override;
    CHIP_ERROR SetAdvertisingParams(uint32_t intervalMin, uint32_t intervalMax, uint16_t duration,
                                    const Optional<uint16_t> & maxEvents, const Optional<uint8_t> & channelMap) override;
    CHIP_ERROR OpenConnection(bd_addr address, uint8_t addrType) override;
    CHIP_ERROR SetConnectionParams(const Optional<uint8_t> & connectionHandle, uint32_t intervalMin, uint32_t intervalMax,
                                   uint16_t latency, uint16_t timeout) override;
    CHIP_ERROR CloseConnection(void) override;
    CHIP_ERROR SetAdvHandle(uint8_t handle) override;

    CHIP_ERROR DiscoverServices() override;
    CHIP_ERROR DiscoverCharacteristics(uint32_t serviceHandle) override;
    CHIP_ERROR SetCharacteristicNotification(uint8_t characteristicHandle, uint8_t flags) override;
    CHIP_ERROR SetCharacteristicValue(uint8_t characteristicHandle, const ByteSpan & value) override;
};

} // namespace Internal
} // namespace DeviceLayer
} // namespace chip
