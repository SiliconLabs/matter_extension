/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
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
 *          Provides an implementation of the DiagnosticDataProvider object
 *          for Silabs platform.
 */

#include <platform/internal/CHIPDeviceLayerInternal.h>

#include <platform/DiagnosticDataProvider.h>
#include <platform/silabs/DiagnosticDataProviderImpl.h>
#if CHIP_DEVICE_CONFIG_ENABLE_THREAD
#include <platform/OpenThread/GenericThreadStackManagerImpl_OpenThread.h>
#endif
#include "FreeRTOS.h"
#include "sl_memory_manager.h"
#include <inet/InetInterface.h>
#include <lib/support/CHIPMemString.h>

using namespace ::chip::app::Clusters::GeneralDiagnostics;

namespace chip {
namespace DeviceLayer {

DiagnosticDataProviderImpl & DiagnosticDataProviderImpl::GetDefaultInstance()
{
    static DiagnosticDataProviderImpl sInstance;
    return sInstance;
}

// Software Diagnostics Getters
/*
 * The following Heap stats are compiled values done by the sl_memory_manager.
 * It keeps track of the number of calls to allocate and free memory as well as the
 * number of free bytes remaining, but says nothing about fragmentation.
 */
CHIP_ERROR DiagnosticDataProviderImpl::GetCurrentHeapFree(uint64_t & currentHeapFree)
{
#if (defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
#else
    size_t freeHeapSize             = sl_memory_get_free_heap_size();
    currentHeapFree                 = static_cast<uint64_t>(freeHeapSize);
#endif //(defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetCurrentHeapUsed(uint64_t & currentHeapUsed)
{
#if (defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
#else
    size_t heapUsed                 = sl_memory_get_used_heap_size();
    currentHeapUsed                 = static_cast<uint64_t>(heapUsed);
#endif //(defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetCurrentHeapHighWatermark(uint64_t & currentHeapHighWatermark)
{
#if (defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
#else
    size_t HighestHeapUsageRecorded = sl_memory_get_heap_high_watermark();
    currentHeapHighWatermark        = static_cast<uint64_t>(HighestHeapUsageRecorded);
#endif //(defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::ResetWatermarks()
{
#if (defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
#else
    // If implemented, the server SHALL set the value of the CurrentHeapHighWatermark attribute to the
    // value of the CurrentHeapUsed.
    sl_memory_reset_heap_high_watermark();
#endif //(defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE == 1)
    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetThreadMetrics(ThreadMetrics ** threadMetricsOut)
{
    /* Obtain all available task information */
    TaskStatus_t * taskStatusArray;
    ThreadMetrics * head = nullptr;
    uint32_t arraySize, x, dummy;

    arraySize = uxTaskGetNumberOfTasks();

    taskStatusArray = static_cast<TaskStatus_t *>(chip::Platform::MemoryCalloc(arraySize, sizeof(TaskStatus_t)));

    if (taskStatusArray != NULL)
    {
        /* Generate raw status information about each task. */
        arraySize = uxTaskGetSystemState(taskStatusArray, arraySize, &dummy);
        /* For each populated position in the taskStatusArray array,
           format the raw data as human readable ASCII data. */

        for (x = 0; x < arraySize; x++)
        {
            ThreadMetrics * thread = new ThreadMetrics();
            if (thread)
            {
                Platform::CopyString(thread->NameBuf, taskStatusArray[x].pcTaskName);
                thread->name.Emplace(CharSpan::fromCharString(thread->NameBuf));
                thread->id = taskStatusArray[x].xTaskNumber;
                thread->stackFreeMinimum.Emplace(taskStatusArray[x].usStackHighWaterMark);

                /* Unsupported metrics */
                // thread->stackSize
                // thread->stackFreeCurrent

                thread->Next = head;
                head         = thread;
            }
        }

        *threadMetricsOut = head;
        /* The array is no longer needed, free the memory it consumes. */
        chip::Platform::MemoryFree(taskStatusArray);
    }

    return CHIP_NO_ERROR;
}

void DiagnosticDataProviderImpl::ReleaseThreadMetrics(ThreadMetrics * threadMetrics)
{
    while (threadMetrics)
    {
        ThreadMetrics * del = threadMetrics;
        threadMetrics       = threadMetrics->Next;
        delete del;
    }
}

// General Diagnostics Getters

CHIP_ERROR DiagnosticDataProviderImpl::GetRebootCount(uint16_t & rebootCount)
{
    uint32_t count = 0;
    CHIP_ERROR err = ConfigurationMgr().GetRebootCount(count);

    if (err == CHIP_NO_ERROR)
    {
        VerifyOrReturnError(count <= UINT16_MAX, CHIP_ERROR_INVALID_INTEGER_VALUE);
        rebootCount = static_cast<uint16_t>(count);
    }

    return err;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetBootReason(BootReasonType & bootReason)
{
    uint32_t reason = 0;
    CHIP_ERROR err  = ConfigurationMgr().GetBootReason(reason);

    if (err == CHIP_NO_ERROR)
    {
        VerifyOrReturnError(reason <= UINT8_MAX, CHIP_ERROR_INVALID_INTEGER_VALUE);
        bootReason = static_cast<BootReasonType>(reason);
    }

    return err;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetUpTime(uint64_t & upTime)
{
    System::Clock::Timestamp currentTime = System::SystemClock().GetMonotonicTimestamp();
    System::Clock::Timestamp startTime   = PlatformMgrImpl().GetStartTime();

    if (currentTime >= startTime)
    {
        upTime = std::chrono::duration_cast<System::Clock::Seconds64>(currentTime - startTime).count();
        return CHIP_NO_ERROR;
    }

    return CHIP_ERROR_INVALID_TIME;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetTotalOperationalHours(uint32_t & totalOperationalHours)
{
    return ConfigurationMgr().GetTotalOperationalHours(totalOperationalHours);
}

CHIP_ERROR DiagnosticDataProviderImpl::GetActiveHardwareFaults(GeneralFaults<kMaxHardwareFaults> & hardwareFaults)
{
#if CHIP_CONFIG_TEST
    ReturnErrorOnFailure(hardwareFaults.add(to_underlying(HardwareFaultEnum::kRadio)));
    ReturnErrorOnFailure(hardwareFaults.add(to_underlying(HardwareFaultEnum::kSensor)));
    ReturnErrorOnFailure(hardwareFaults.add(to_underlying(HardwareFaultEnum::kPowerSource)));
    ReturnErrorOnFailure(hardwareFaults.add(to_underlying(HardwareFaultEnum::kUserInterfaceFault)));
#endif

    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetActiveRadioFaults(GeneralFaults<kMaxRadioFaults> & radioFaults)
{
#if CHIP_CONFIG_TEST
    ReturnErrorOnFailure(radioFaults.add(to_underlying(RadioFaultEnum::kThreadFault)));
    ReturnErrorOnFailure(radioFaults.add(to_underlying(RadioFaultEnum::kBLEFault)));
#endif

    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetActiveNetworkFaults(GeneralFaults<kMaxNetworkFaults> & networkFaults)
{
#if CHIP_CONFIG_TEST
    ReturnErrorOnFailure(networkFaults.add(to_underlying(NetworkFaultEnum::kHardwareFailure)));
    ReturnErrorOnFailure(networkFaults.add(to_underlying(NetworkFaultEnum::kNetworkJammed)));
    ReturnErrorOnFailure(networkFaults.add(to_underlying(NetworkFaultEnum::kConnectionFailed)));
#endif

    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetNetworkInterfaces(NetworkInterface ** netifpp)
{
    NetworkInterface * ifp = new NetworkInterface();

#if CHIP_DEVICE_CONFIG_ENABLE_THREAD
    const char * threadNetworkName = otThreadGetNetworkName(ThreadStackMgrImpl().OTInstance());
    ifp->name                      = Span<const char>(threadNetworkName, strlen(threadNetworkName));
    ifp->type                      = InterfaceTypeEnum::kThread;
    ifp->isOperational             = ThreadStackMgrImpl().IsThreadAttached();
    ifp->offPremiseServicesReachableIPv4.SetNull();
    ifp->offPremiseServicesReachableIPv6.SetNull();

    ThreadStackMgrImpl().GetPrimary802154MACAddress(ifp->MacAddress);
    ifp->hardwareAddress = ByteSpan(ifp->MacAddress, kMaxHardwareAddrSize);

    // The Thread implementation has only 1 interface and is IPv6-only
    Inet::InterfaceAddressIterator interfaceAddressIterator;
    uint8_t ipv6AddressesCount = 0;
    while (interfaceAddressIterator.HasCurrent() && ipv6AddressesCount < kMaxIPv6AddrCount)
    {
        Inet::IPAddress ipv6Address;
        if (interfaceAddressIterator.GetAddress(ipv6Address) == CHIP_NO_ERROR)
        {
            memcpy(ifp->Ipv6AddressesBuffer[ipv6AddressesCount], ipv6Address.Addr, kMaxIPv6AddrSize);
            ifp->Ipv6AddressSpans[ipv6AddressesCount] = ByteSpan(ifp->Ipv6AddressesBuffer[ipv6AddressesCount]);
            ipv6AddressesCount++;
        }
        interfaceAddressIterator.Next();
    }

    ifp->IPv6Addresses = app::DataModel::List<ByteSpan>(ifp->Ipv6AddressSpans, ipv6AddressesCount);

    *netifpp = ifp;
#else // CHIP_SYSTEM_CONFIG_USE_LWIP || CHIP_SYSTEM_CONFIG_USE_SOCKETS
    NetworkInterface * head = NULL;
    for (Inet::InterfaceIterator interfaceIterator; interfaceIterator.HasCurrent(); interfaceIterator.Next())
    {
        interfaceIterator.GetInterfaceName(ifp->Name, Inet::InterfaceId::kMaxIfNameLength);
        ifp->name          = CharSpan::fromCharString(ifp->Name);
        ifp->isOperational = true;
        Inet::InterfaceType interfaceType;
        CHIP_ERROR err = interfaceIterator.GetInterfaceType(interfaceType);
        if (err == CHIP_NO_ERROR || err == CHIP_ERROR_NOT_IMPLEMENTED)
        {
            switch (interfaceType)
            {
            case Inet::InterfaceType::Unknown:
                ifp->type = app::Clusters::GeneralDiagnostics::InterfaceTypeEnum::kUnspecified;
                break;
            case Inet::InterfaceType::WiFi:
                ifp->type = app::Clusters::GeneralDiagnostics::InterfaceTypeEnum::kWiFi;
                break;
            case Inet::InterfaceType::Ethernet:
                ifp->type = app::Clusters::GeneralDiagnostics::InterfaceTypeEnum::kEthernet;
                break;
            case Inet::InterfaceType::Thread:
                ifp->type = app::Clusters::GeneralDiagnostics::InterfaceTypeEnum::kThread;
                break;
            case Inet::InterfaceType::Cellular:
                ifp->type = app::Clusters::GeneralDiagnostics::InterfaceTypeEnum::kCellular;
                break;
            default:
                ifp->type = app::Clusters::GeneralDiagnostics::InterfaceTypeEnum::kWiFi;
                break;
            }
        }
        else
        {
            ChipLogError(DeviceLayer, "Failed to get interface type");
        }

        ifp->offPremiseServicesReachableIPv4.SetNull();
        ifp->offPremiseServicesReachableIPv6.SetNull();

        uint8_t addressSize;
        if (interfaceIterator.GetHardwareAddress(ifp->MacAddress, addressSize, sizeof(ifp->MacAddress)) != CHIP_NO_ERROR)
        {
            ChipLogError(DeviceLayer, "Failed to get network hardware address");
        }
        else
        {
            ifp->hardwareAddress = ByteSpan(ifp->MacAddress, addressSize);
        }

        // Assuming IPv6-only support
        Inet::InterfaceAddressIterator interfaceAddressIterator;
        uint8_t ipv6AddressesCount = 0;
        while (interfaceAddressIterator.HasCurrent() && ipv6AddressesCount < kMaxIPv6AddrCount)
        {
            if (interfaceAddressIterator.GetInterfaceId() == interfaceIterator.GetInterfaceId())
            {
                chip::Inet::IPAddress ipv6Address;
                if (interfaceAddressIterator.GetAddress(ipv6Address) == CHIP_NO_ERROR)
                {
                    memcpy(ifp->Ipv6AddressesBuffer[ipv6AddressesCount], ipv6Address.Addr, kMaxIPv6AddrSize);
                    ifp->Ipv6AddressSpans[ipv6AddressesCount] = ByteSpan(ifp->Ipv6AddressesBuffer[ipv6AddressesCount]);
                    ipv6AddressesCount++;
                }
            }
            interfaceAddressIterator.Next();
        }

        ifp->IPv6Addresses = chip::app::DataModel::List<chip::ByteSpan>(ifp->Ipv6AddressSpans, ipv6AddressesCount);
        head               = ifp;
    }
    *netifpp = head;
#endif

    return CHIP_NO_ERROR;
}

void DiagnosticDataProviderImpl::ReleaseNetworkInterfaces(NetworkInterface * netifp)
{
    while (netifp)
    {
        NetworkInterface * del = netifp;
        netifp                 = netifp->Next;
        delete del;
    }
}

#if SL_WIFI
CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiBssId(MutableByteSpan & BssId)
{
    constexpr size_t bssIdSize = 6;
    VerifyOrReturnError(BssId.size() >= bssIdSize, CHIP_ERROR_BUFFER_TOO_SMALL);

    wfx_wifi_scan_result_t ap;
    int32_t err = wfx_get_ap_info(&ap);
    if (err == 0)
    {
        memcpy(BssId.data(), ap.bssid, bssIdSize);
        BssId.reduce_size(bssIdSize);
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiSecurityType(app::Clusters::WiFiNetworkDiagnostics::SecurityTypeEnum & securityType)
{
    using app::Clusters::WiFiNetworkDiagnostics::SecurityTypeEnum;

    wfx_wifi_scan_result_t ap;
    int32_t err = wfx_get_ap_info(&ap);
    if (err == 0)
    {
        // TODO: Is this actually right?  Do the wfx_wifi_scan_result_t values
        // match the Matter spec ones?
        securityType = static_cast<SecurityTypeEnum>(ap.security);
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiVersion(app::Clusters::WiFiNetworkDiagnostics::WiFiVersionEnum & wifiVersion)
{
    wifiVersion = app::Clusters::WiFiNetworkDiagnostics::WiFiVersionEnum::kN;
    return CHIP_NO_ERROR;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiChannelNumber(uint16_t & channelNumber)
{
    wfx_wifi_scan_result_t ap;
    int32_t err = wfx_get_ap_info(&ap);
    if (err == 0)
    {
        channelNumber = ap.chan;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiRssi(int8_t & rssi)
{
    wfx_wifi_scan_result_t ap;
    int32_t err = wfx_get_ap_info(&ap);
    if (err == 0)
    {
        rssi = ap.rssi;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiBeaconLostCount(uint32_t & beaconLostCount)
{
    wfx_wifi_scan_ext_t extra_info;
    int32_t err = wfx_get_ap_ext(&extra_info);
    if (err == 0)
    {
        beaconLostCount = extra_info.beacon_lost_count;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiCurrentMaxRate(uint64_t & currentMaxRate)
{
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiPacketMulticastRxCount(uint32_t & packetMulticastRxCount)
{
    wfx_wifi_scan_ext_t extra_info;
    int32_t err = wfx_get_ap_ext(&extra_info);
    if (err == 0)
    {
        packetMulticastRxCount = extra_info.mcast_rx_count;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiPacketMulticastTxCount(uint32_t & packetMulticastTxCount)
{
    wfx_wifi_scan_ext_t extra_info;
    int32_t err = wfx_get_ap_ext(&extra_info);
    if (err == 0)
    {
        packetMulticastTxCount = extra_info.mcast_tx_count;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiPacketUnicastRxCount(uint32_t & packetUnicastRxCount)
{
    wfx_wifi_scan_ext_t extra_info;
    int32_t err = wfx_get_ap_ext(&extra_info);
    if (err == 0)
    {
        packetUnicastRxCount = extra_info.ucast_rx_count;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiPacketUnicastTxCount(uint32_t & packetUnicastTxCount)
{
    wfx_wifi_scan_ext_t extra_info;
    int32_t err = wfx_get_ap_ext(&extra_info);
    if (err == 0)
    {
        packetUnicastTxCount = extra_info.ucast_tx_count;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiOverrunCount(uint64_t & overrunCount)
{
    wfx_wifi_scan_ext_t extra_info;
    int32_t err = wfx_get_ap_ext(&extra_info);
    if (err == 0)
    {
        overrunCount = extra_info.overrun_count;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::GetWiFiBeaconRxCount(uint32_t & beaconRxCount)
{
    wfx_wifi_scan_ext_t extra_info;
    int32_t err = wfx_get_ap_ext(&extra_info);
    if (err == 0)
    {
        beaconRxCount = extra_info.beacon_rx_count;
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}

CHIP_ERROR DiagnosticDataProviderImpl::ResetWiFiNetworkDiagnosticsCounts()
{
    int32_t err = wfx_reset_counts();
    if (err == 0)
    {
        return CHIP_NO_ERROR;
    }
    return CHIP_ERROR_UNSUPPORTED_CHIP_FEATURE;
}
#endif // SL_WIFI

DiagnosticDataProvider & GetDiagnosticDataProviderImpl()
{
    return DiagnosticDataProviderImpl::GetDefaultInstance();
}

} // namespace DeviceLayer
} // namespace chip
