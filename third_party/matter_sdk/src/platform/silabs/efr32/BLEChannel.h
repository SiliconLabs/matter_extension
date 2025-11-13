/***************************************************************************
 * @file BLEChannel.h
 * @brief Provides BLE channel abstraction for the Silicon Labs platform, including connection and advertising management.
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

#include "sl_bt_api.h"
#include "sl_bt_rtos_adaptation.h"
#include "sl_bt_stack_config.h"
#include "sl_bt_stack_init.h"
#include <lib/core/CHIPError.h>
#include <lib/core/Optional.h>
#include <lib/support/BitFlags.h>
#include <lib/support/Span.h>

namespace chip {
namespace DeviceLayer {
namespace Internal {

struct BLEConState
{
    bd_addr address;
    uint16_t mtu : 10;
    uint16_t allocated : 1;
    uint16_t subscribed : 1;
    uint16_t unused : 4;
    uint8_t connectionHandle;
    uint8_t bondingHandle;
};

struct AdvConfigStruct
{
    ByteSpan advData;
    ByteSpan responseData;
    uint32_t intervalMin;
    uint32_t intervalMax;
    uint8_t advConnectableMode;
    uint16_t duration;
    uint8_t maxEvents;
};

inline constexpr uint8_t kInvalidAdvertisingHandle      = 0xff;
inline constexpr uint16_t kDefaultConnectionEventLength = 0xffff;

class BLEChannel
{
public:
    BLEChannel()
    {
        // Initialize the connection state
        memset(&mConnectionState, 0, sizeof(mConnectionState));
        mFlags.ClearAll();
    }

    virtual ~BLEChannel() = default;

    virtual CHIP_ERROR Init(void) = 0;

    // TODO: Revisit this method and see about splitting timing vs advertising data. It is currently implemented to do everything
    /** @brief ConfigureAdvertising
     *   Configure the advertising data and parameters for the BLE channel. This function needs to be called before
     *  starting the advertising process.
     *
     *  @param AdvConfigStruct Structure holding The advertising data to be set, the scan response data to be set,
     *  the minimum and maximum advertising intervals, the duration of the advertising, and the maximum number of events.
     */
    virtual CHIP_ERROR ConfigureAdvertising(const AdvConfigStruct & config) = 0;

    /** @brief StartAdvertising
     *  Start the advertising process for the BLE channel using configured parameters. ConfigureAdvertising must be called before
     * this function.
     */
    virtual CHIP_ERROR StartAdvertising(void) = 0;
    virtual CHIP_ERROR StopAdvertising(void)  = 0;

    virtual void AddConnection(uint8_t connectionHandle, uint8_t bondingHandle)       = 0;
    virtual bool RemoveConnection(uint8_t connectionHandle)                           = 0;
    virtual void HandleReadRequest(volatile sl_bt_msg_t * evt, ByteSpan data)         = 0;
    virtual void HandleWriteRequest(volatile sl_bt_msg_t * evt, MutableByteSpan data) = 0;

    /** @brief CanHandleEvent
     *  Determine if the side channel can handle a BLE event. This only gets called if the
     *  targetted event is not supported by MATTERoBLE as the side channel supports every
     *  event that MATTERoBLE does.
     *
     * @param event uint32_t Header of sl_bt_msg_t event type
     * @return true if the event can be handled, false otherwise.
     */
    virtual bool CanHandleEvent(uint32_t event) { return false; }

    virtual void ParseEvent(volatile sl_bt_msg_t * evt) {}

    /** @brief CCCD Write Handler
     *
     *  This method handles the CCCD write request from the client. It sets the subscribed flag
     *  in the connection state and logs the subscription status. It returns a boolean indicating
     *  whether the request requires a new subscription.
     *
     * @param evt The event containing the CCCD write request.
     * @param isNewSubscription A boolean indicating whether the request requires a new subscription.
     *
     *
     * @return CHIP_ERROR_INCORRECT_STATE if a request is received when the connection is not allocated or a request is received
     *        for a different connection handle. CHIP_NO_ERROR if the request is handled successfully.
     */
    virtual CHIP_ERROR HandleCCCDWriteRequest(volatile sl_bt_msg_t * evt, bool & isNewSubscription) = 0;

    virtual void UpdateMtu(volatile sl_bt_msg_t * evt) = 0;

    // CLI methods BEGIN
    // GAP
    virtual CHIP_ERROR GeneratAdvertisingData(uint8_t discoverMove, uint8_t connectMode, const Optional<uint16_t> & maxEvents) = 0;
    virtual CHIP_ERROR SetAdvertisingParams(uint32_t intervalMin, uint32_t intervalMax, uint16_t duration,
                                            const Optional<uint16_t> & maxEvents, const Optional<uint8_t> & channelMap)        = 0;
    virtual CHIP_ERROR OpenConnection(bd_addr address, uint8_t addrType)                                                       = 0;

    /** @brief SetConnectionParams
     *
     *  If a connectionHandle is provided, this connection parameters will be updated, otherwise, the default connection
     *  parameters (in the bt stack) will be updated to the provided values
     *
     * @param connectionHandle Optional connection handle to set the parameters for.
     * @param intervalMin Minimum connection interval, caculate as Time = intervalMin x 1.25 ms = 30ms
     * @param intervalMax Maximum connection interval, caculate as Time = intervalMin x 1.25 ms = 30ms
     * @param latency Peripheral latency: how many connection intervals the peripheral can skip if it has no data to send.
     * @param timeout Supervision timeout: time that the connection is maintained although the devices can't communicate
     *
     * @return CHIP_NO_ERROR if the parameters are set successfully, sl_status_t mapped to from ble stack error to CHIP_ERROR
     * otherwise.
     */
    virtual CHIP_ERROR SetConnectionParams(const Optional<uint8_t> & connectionHandle, uint32_t intervalMin, uint32_t intervalMax,
                                           uint16_t latency, uint16_t timeout) = 0;
    virtual CHIP_ERROR CloseConnection(void)                                   = 0;

    /** @brief Set Advertising Handle
     *
     *  Our side channel currently only supports one advertising handle. This method checks if the
     *  current mAdvertisingHandle is 0xff (uninitialized) and sets it to the provided handle and
     *  create the advertising set if it is the case.
     *  If the handle is already set, it will stop the ongoing advertising, delete the set and
     *  create a new one with the provided handle.
     *
     *  TODO: Have the BLEManagerImpl set the max advertising handle by deriving it from
     *  SL_BT_CONFIG_USER_ADVERTISERS and the number of channels it has to manage.
     *
     *  @param handle The advertising handle to set as the channel's advertising handle.
     *  @return CHIP_NO_ERROR if the handle is set successfully, otherwise an error code.
     */
    virtual CHIP_ERROR SetAdvHandle(uint8_t handle) = 0;

    // GATT (All these methods need some event handling to be done in sl_bt_on_event)
    virtual CHIP_ERROR DiscoverServices()                                                           = 0;
    virtual CHIP_ERROR DiscoverCharacteristics(uint32_t serviceHandle)                              = 0;
    virtual CHIP_ERROR SetCharacteristicNotification(uint8_t characteristicHandle, uint8_t flags)   = 0;
    virtual CHIP_ERROR SetCharacteristicValue(uint8_t characteristicHandle, const ByteSpan & value) = 0;
    // CLI methods END

    // Getters
    uint8_t GetAdvHandle(void) const { return mAdvHandle; }
    uint8_t GetConnectionHandle(void) const { return mConnectionState.connectionHandle; }
    uint8_t GetBondingHandle(void) const { return mConnectionState.bondingHandle; }
    bd_addr GetRandomizedAddr(void) const { return mConnectionState.address; }
    BLEConState GetConnectionState() const { return mConnectionState; }

protected:
    enum class Flags : uint16_t
    {
        kAdvertising = 0x0001, // Todo : See about flags for connection, subscription, etc.
    };

    BLEConState mConnectionState;
    BitFlags<Flags> mFlags;

    // Advertising parameters
    // TODO: Default values should be set in a configuration file for the side channel
    uint8_t mAdvHandle           = 0xff;
    uint32_t mAdvIntervalMin     = 0;
    uint32_t mAdvIntervalMax     = 0;
    uint16_t mAdvDuration        = 0;
    uint8_t mAdvMaxEvents        = 0;
    uint8_t mAdvConnectableMode  = 0;
    uint8_t mAdvDiscoverableMode = 0;

    uint16_t mSideServiceHandle = 0;
    uint16_t mSideRxCharHandle  = 0;
    uint16_t mSideTxCharHandle  = 0;
};

} // namespace Internal
} // namespace DeviceLayer
} // namespace chip
