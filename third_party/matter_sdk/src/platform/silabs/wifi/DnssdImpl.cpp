#include <lib/dnssd/platform/Dnssd.h>
#include <lib/support/CHIPMem.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/logging/CHIPLogging.h>

extern "C" {
#include "sl_mdns.h"
#include "sl_wifi.h"
}

using namespace ::chip::DeviceLayer;

namespace chip {
namespace Dnssd {

namespace {
// Global mDNS instance
sl_mdns_t sMdnsInstance;
constexpr size_t sServiceNameSize  = 80;
constexpr size_t sInstanceNameSize = 150;
constexpr size_t sttlValue         = 120;

bool IsSupportedProtocol(DnssdServiceProtocol protocol)
{
    return (protocol == DnssdServiceProtocol::kDnssdProtocolUdp) || (protocol == DnssdServiceProtocol::kDnssdProtocolTcp);
}

} // namespace

CHIP_ERROR ChipDnssdInit(DnssdAsyncReturnCallback initCallback, DnssdAsyncReturnCallback errorCallback, void * context)
{
    sl_mac_address_t mac_addr;
    char macString[20]; // 12 hex digits + ".local." + null terminator
    sl_status_t status = sl_wifi_get_mac_address(SL_WIFI_CLIENT_INTERFACE, &mac_addr);
    VerifyOrReturnError(status == SL_STATUS_OK, CHIP_ERROR_INTERNAL);

    snprintf(macString, sizeof(macString), "%02X%02X%02X%02X%02X%02X.local.", mac_addr.octet[0], mac_addr.octet[1],
             mac_addr.octet[2], mac_addr.octet[3], mac_addr.octet[4], mac_addr.octet[5]);

    sl_mdns_configuration_t config = { .protocol = SL_MDNS_PROTO_UDP, .type = SL_IPV6_VERSION };
    strcpy(config.host_name, macString);
    status = sl_mdns_init(&sMdnsInstance, &config, nullptr);
    VerifyOrReturnError(status == SL_STATUS_OK, CHIP_ERROR_INTERNAL);
    if (status != SL_STATUS_OK)
    {
        ChipLogError(DeviceLayer, "Failed to initialize mDNS: 0x%lx", status);
        if (errorCallback)
        {
            errorCallback(context, CHIP_ERROR_INTERNAL);
        }
        return CHIP_ERROR_INTERNAL;
    }
    status = sl_mdns_add_interface(&sMdnsInstance, SL_NET_WIFI_CLIENT_INTERFACE);
    VerifyOrReturnError(status == SL_STATUS_OK, CHIP_ERROR_INTERNAL);

    if (initCallback)
    {
        initCallback(context, CHIP_NO_ERROR);
    }

    return CHIP_NO_ERROR;
}

void ChipDnssdShutdown()
{
    sl_status_t status = sl_mdns_deinit(&sMdnsInstance);
    VerifyOrReturn(status == SL_STATUS_OK);
}

const char * GetProtocolString(DnssdServiceProtocol protocol)
{
    return protocol == DnssdServiceProtocol::kDnssdProtocolTcp ? "_tcp" : "_udp";
}

CHIP_ERROR ChipDnssdPublishService(const DnssdService * service, DnssdPublishCallback callback, void * context)
{
    VerifyOrReturnError(service != nullptr, CHIP_ERROR_INVALID_ARGUMENT);
    VerifyOrReturnError(callback != nullptr, CHIP_ERROR_INVALID_ARGUMENT);
    VerifyOrReturnError(IsSupportedProtocol(service->mProtocol), CHIP_ERROR_INVALID_ARGUMENT);

    sl_mdns_service_t mdnsService = {};
    std::string serviceMessage;

    char service_type[sServiceNameSize];
    // last . is needed as suggested from the network stack team
    // for the mdns discovery instead of avahi only
    snprintf(service_type, sizeof(service_type), "%s.%s.local.", service->mType, GetProtocolString(service->mProtocol));

    char instance_name[sInstanceNameSize];
    snprintf(instance_name, sizeof(instance_name), "%s.%s.%s.local.", service->mName, service->mType,
             GetProtocolString(service->mProtocol));

    mdnsService.instance_name = strdup(instance_name); // Duplicate the string to ensure memory safety
    mdnsService.service_type  = strdup(service_type);  // Duplicate the string to ensure memory safety
    mdnsService.port          = service->mPort;
    mdnsService.ttl           = sttlValue; // Default TTL; adjust as needed
    for (size_t i = 0; i < service->mTextEntrySize; i++)
    {
        if (service->mTextEntries[i].mKey && service->mTextEntries[i].mData)
        {
            serviceMessage += std::string(service->mTextEntries[i].mKey) + "=" +
                std::string(reinterpret_cast<const char *>(service->mTextEntries[i].mData)) + " ";
        }
    }
    mdnsService.service_message = strdup(serviceMessage.c_str()); // Duplicate the string to ensure memory safety

    sl_status_t status = sl_mdns_register_service(&sMdnsInstance, SL_NET_WIFI_CLIENT_INTERFACE, &mdnsService);

    // free allocated memory
    free(const_cast<char *>(mdnsService.instance_name));
    free(const_cast<char *>(mdnsService.service_type));
    free(const_cast<char *>(mdnsService.service_message));
    return ((status == SL_STATUS_OK) ? CHIP_NO_ERROR : CHIP_ERROR_INTERNAL);
}

CHIP_ERROR ChipDnssdRemoveServices()
{
    // Currently, `sl_mdns_unregister_service` is not supported.
    // As a workaround, we can deinitialize and reinitialize the mDNS instance to remove all services.
    sl_mdns_deinit(&sMdnsInstance);

    // Reinitialize the mDNS instance
    ChipDnssdInit(nullptr, nullptr, nullptr);

    return CHIP_NO_ERROR;
}

CHIP_ERROR ChipDnssdFinalizeServiceUpdate()
{
    // No explicit finalize function. Assume updates are applied immediately.
    return CHIP_NO_ERROR;
}

CHIP_ERROR ChipDnssdBrowse(const char * type, DnssdServiceProtocol protocol, chip::Inet::IPAddressType addressType,
                           chip::Inet::InterfaceId interface, DnssdBrowseCallback callback, void * context,
                           intptr_t * browseIdentifier)
{
    // Currently, `sl_mdns_discover_service` is not supported.
    // Return an error indicating that browsing is not implemented.
    ChipLogError(DeviceLayer, "Browsing services is not implemented");
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR ChipDnssdStopBrowse(intptr_t browseIdentifier)
{
    // Currently, stopping a browse operation is not supported.
    // Return an error indicating that stopping browse is not implemented.
    ChipLogError(DeviceLayer, "Stopping browse is not implemented");
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR ChipDnssdResolve(DnssdService * service, chip::Inet::InterfaceId interface, DnssdResolveCallback callback,
                            void * context)
{
    // Currently, `sl_mdns_discover_service` is not supported.
    // Return an error indicating that resolving is not implemented.
    ChipLogError(DeviceLayer, "Resolving services is not implemented");
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

void ChipDnssdResolveNoLongerNeeded(const char * instanceName)
{
    // No explicit function to handle this. Assume no action is needed.
}

CHIP_ERROR ChipDnssdReconfirmRecord(const char * hostname, chip::Inet::IPAddress address, chip::Inet::InterfaceId interface)
{
    // Currently, `sl_mdns.c` does not support reconfirming records.
    // Return an error indicating that reconfirming is not implemented.
    ChipLogError(DeviceLayer, "Reconfirming records is not implemented");
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

} // namespace Dnssd
} // namespace chip
