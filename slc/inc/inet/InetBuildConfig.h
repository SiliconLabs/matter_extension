#ifndef INET_INETBUILDCONFIG_H_
#define INET_INETBUILDCONFIG_H_

// TODO: enable IPv4 and TCP if using wifi
#define INET_CONFIG_TEST                    0
#define INET_CONFIG_ENABLE_UDP_ENDPOINT     1
#define HAVE_LWIP_RAW_BIND_NETIF            1
#define INET_PROJECT_CONFIG_INCLUDE         <CHIPProjectConfig.h>
#define INET_PLATFORM_CONFIG_INCLUDE        <platform/silabs/InetPlatformConfig.h>
#define INET_CONFIG_ENABLE_IPV4             0
#define INET_CONFIG_ENABLE_TCP_ENDPOINT     0
#ifndef SL_WIFI
#define INET_TCP_END_POINT_IMPL_CONFIG_FILE <inet/TCPEndPointImplOpenThread.h>
#define INET_UDP_END_POINT_IMPL_CONFIG_FILE <inet/UDPEndPointImplOpenThread.h>
#else
#if SL_WIFI_USE_SOCKETS
#define INET_TCP_END_POINT_IMPL_CONFIG_FILE <inet/TCPEndPointImplSockets.h>
#define INET_UDP_END_POINT_IMPL_CONFIG_FILE <inet/UDPEndPointImplSockets.h>
#else
#define INET_TCP_END_POINT_IMPL_CONFIG_FILE <inet/TCPEndPointImplLwIP.h>
#define INET_UDP_END_POINT_IMPL_CONFIG_FILE <inet/UDPEndPointImplLwIP.h>
#endif // SL_WIFI_USE_SOCKETS
#endif  // SL_WIFI
#endif  // INET_INETBUILDCONFIG_H_
