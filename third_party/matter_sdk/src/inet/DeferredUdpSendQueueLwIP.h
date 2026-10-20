/*
 *
 *    Copyright (c) 2020-2026 Project CHIP Authors
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
 * Outbound UDP send deferral for LwIP (bounded FIFO, fixed storage).
 * Keeps queue mechanics out of UDPEndPointImplLwIP.cpp.
 */

#pragma once

#include <inet/InetConfig.h>

#if SL_INET_CONFIG_UDP_LWIP_QUEUE_UNTIL_NETIF_READY

#include <lib/core/CHIPError.h>
#include <system/SystemPacketBuffer.h>

namespace chip {
namespace Inet {

struct IPPacketInfo;
class UDPEndPointImplLwIP;

class DeferredUdpSendQueueLwIP
{
public:
    /**
     * If the netif is not ready for this destination, set outShouldDefer true so the send should be
     * queued. Returns a mapped CHIP error if the TCPIP thread bridge fails.
     */
    static CHIP_ERROR ProbeDefer(const IPPacketInfo & pktInfo, bool & outShouldDefer);

    static CHIP_ERROR Enqueue(UDPEndPointImplLwIP * self, const IPPacketInfo * pktInfo, System::PacketBufferHandle && msg);

    static void PurgeForEndpoint(UDPEndPointImplLwIP * self);

    static void Flush();
};

} // namespace Inet
} // namespace chip

#endif // SL_INET_CONFIG_UDP_LWIP_QUEUE_UNTIL_NETIF_READY
