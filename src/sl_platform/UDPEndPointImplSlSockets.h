/*
 *
 *    Copyright (c) 2020-2021 Project CHIP Authors
 *    Copyright (c) 2018 Google LLC
 *    Copyright (c) 2013-2017 Nest Labs, Inc.
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

/*
 * Modified by Flipper Devices Inc.
 * Original file: UDPEndPointImplSockets.h
 * List of changes:
 *   - class name: UDPEndPointImplSockets -> UDPEndPointImplSlSockets
 * 
 * To any C++ developers looking at the parts of code that were clearly written
 * by a C developer: I am sorry.
 */

/**
 * This file declares an implementation of Inet::UDPEndPoint using SiLabs async sockets.
 */

#pragma once

#include <inet/EndPointStateSockets.h>
#include <inet/UDPEndPoint.h>
#include <sl_si91x_socket_types.h>
#include <furi.h>

#define MAX_UDP_ENDPOINTS 16

namespace chip {
namespace Inet {

typedef struct {
    sl_si91x_socket_metadata_t metadata;
    uint32_t data_length;
    uint8_t* data_buffer; // immediately follows this class in memory, same allocation
} SocketInboundEvent;

class UDPEndPointImplSlSockets : public UDPEndPoint, public EndPointStateSockets
{
public:
    UDPEndPointImplSlSockets(EndPointManager<UDPEndPoint> & endPointManager) :
        UDPEndPoint(endPointManager), mBoundIntfId(InterfaceId::Null())
    {}

    // UDPEndPoint overrides.
    CHIP_ERROR SetMulticastLoopback(IPVersion aIPVersion, bool aLoopback) override;
    InterfaceId GetBoundInterface() const override;
    uint16_t GetBoundPort() const override;
    void Free() override;

private:
    // UDPEndPoint overrides.
#if INET_CONFIG_ENABLE_IPV4
    CHIP_ERROR IPv4JoinLeaveMulticastGroupImpl(InterfaceId aInterfaceId, const IPAddress & aAddress, bool join) override;
#endif // INET_CONFIG_ENABLE_IPV4
    CHIP_ERROR IPv6JoinLeaveMulticastGroupImpl(InterfaceId aInterfaceId, const IPAddress & aAddress, bool join) override;
    CHIP_ERROR BindImpl(IPAddressType addressType, const IPAddress & address, uint16_t port, InterfaceId interfaceId) override;
    CHIP_ERROR BindInterfaceImpl(IPAddressType addressType, InterfaceId interfaceId) override;
    CHIP_ERROR ListenImpl() override;
    CHIP_ERROR SendMsgImpl(const IPPacketInfo * pktInfo, chip::System::PacketBufferHandle && msg) override;
    void CloseImpl() override;

    CHIP_ERROR GetSocket(IPAddressType addressType);
    void HandlePendingIO(SocketInboundEvent* event);

    InterfaceId mBoundIntfId;
    uint16_t mBoundPort;

#if CHIP_SYSTEM_CONFIG_USE_PLATFORM_MULTICAST_API
public:
    enum class MulticastOperation
    {
        kJoin,
        kLeave
    };

    using MulticastGroupHandler = CHIP_ERROR (*)(InterfaceId, const IPAddress &, MulticastOperation operation);

    static void SetMulticastGroupHandler(MulticastGroupHandler handler) { sMulticastGroupHandler = handler; }

private:
    static MulticastGroupHandler sMulticastGroupHandler;
#endif // CHIP_SYSTEM_CONFIG_USE_PLATFORM_MULTICAST_API

private:
    typedef struct {
        uint32_t socket;
        UDPEndPointImplSlSockets* endpoint;
    } SocketEndpointAssociation;

    class SocketEndpointMap {
    public:
        SocketEndpointMap();
        ~SocketEndpointMap();
        void associate(uint32_t socket, UDPEndPointImplSlSockets* endpoint);
        void deassociate(uint32_t socket);
        UDPEndPointImplSlSockets* get_endpoint(uint32_t socket);
    private:
        FuriMutex* mutex;
        SocketEndpointAssociation associations[MAX_UDP_ENDPOINTS];
    };

    static SocketEndpointMap map;

    static void async_socket_callback(uint32_t socket, uint8_t *buffer, uint32_t length, const sl_si91x_socket_metadata_t *firmware_socket_response);
};

using UDPEndPointImpl = UDPEndPointImplSlSockets;

} // namespace Inet
} // namespace chip
