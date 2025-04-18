/*
 *
 *    Copyright (c) 2022 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/* Includes */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef WF200_WIFI
#include "FreeRTOS.h"
#include "event_groups.h"
#include "task.h"
#if (SLI_SI91X_MCU_INTERFACE | EXP_BOARD)
#ifdef __cplusplus
extern "C" {
#endif
#include "cmsis_os2.h"
#include "sl_net.h"
#include "sl_si91x_driver.h"
#include "sl_si91x_host_interface.h"
#include "sl_si91x_types.h"
#include "sl_wifi.h"
#include "sl_wifi_callback_framework.h"
#include "sl_wifi_constants.h"
#include "sl_wifi_types.h"
#ifdef __cplusplus
}
#endif
#endif // (SLI_SI91X_MCU_INTERFACE | EXP_BOARD)
#endif // WF200_WIFI

#include <platform/silabs/wifi/WifiInterfaceAbstraction.h>
#ifdef WF200_WIFI
#include "sl_wfx.h"
#endif
/* LwIP includes. */
#include "ethernetif.h"
#include "lwip/ethip6.h"
#include "lwip/timeouts.h"
#include "netif/etharp.h"

#include <lib/support/logging/CHIPLogging.h>

StaticSemaphore_t xEthernetIfSemaBuffer;

/*****************************************************************************
 * Defines
 ******************************************************************************/
#define STATION_NETIF0 's'
#define STATION_NETIF1 't'

#define LWIP_FRAME_ALIGNMENT 60

uint32_t gOverrunCount = 0;

/*****************************************************************************
 * Variables
 ******************************************************************************/

/*****************************************************************************
 * @fn static void low_level_init(struct netif *netif)
 * @brief
 *    Initializes the hardware parameters. Called from ethernetif_init().
 *
 * @param[in] netif: the already initialized lwip network interface structure
 *
 * @return
 *    None
 ******************************************************************************/
static void low_level_init(struct netif * netif)
{
    /* set netif MAC hardware address length */
    netif->hwaddr_len = ETH_HWADDR_LEN;

    /* Set netif MAC hardware address */
    sl_wfx_mac_address_t mac_addr;

    wfx_get_wifi_mac_addr(SL_WFX_STA_INTERFACE, &mac_addr);

    netif->hwaddr[0] = mac_addr.octet[0];
    netif->hwaddr[1] = mac_addr.octet[1];
    netif->hwaddr[2] = mac_addr.octet[2];
    netif->hwaddr[3] = mac_addr.octet[3];
    netif->hwaddr[4] = mac_addr.octet[4];
    netif->hwaddr[5] = mac_addr.octet[5];

    /* Set netif maximum transfer unit */
    netif->mtu = 1500;

    /* Accept broadcast address and ARP traffic */
    netif->flags |= NETIF_FLAG_BROADCAST | NETIF_FLAG_ETHARP | NETIF_FLAG_IGMP;

#if LWIP_IPV6_MLD
    netif->flags |= NETIF_FLAG_MLD6;
#endif /* LWIP_IPV6_MLD */
}

/********************************************************************************
 * @fn  static void low_level_input(struct netif *netif, uint8_t *b, uint16_t len)
 * @brief
 * Make PBUF out of a linear buffer - that can be fed into lwip
 * @param[in]  netif: the already initialized lwip network interface structure
 * @param[in]  len: length
 * @return
 *     None
 ************************************************************************************/
static void low_level_input(struct netif * netif, uint8_t * b, uint16_t len)
{
    struct pbuf *p, *q;
    uint32_t bufferoffset;

    if (len <= 0)
    {
        return;
    }
    if (len < LWIP_FRAME_ALIGNMENT)
    { /* 60 : LWIP frame alignment */
        len = LWIP_FRAME_ALIGNMENT;
    }

    /* Drop packets originated from the same interface and is not destined for the said interface */
    const uint8_t * src_mac = b + netif->hwaddr_len;
    const uint8_t * dst_mac = b;

    if (!(ip6_addr_ispreferred(netif_ip6_addr_state(netif, 0))) && (memcmp(netif->hwaddr, src_mac, netif->hwaddr_len) == 0) &&
        (memcmp(netif->hwaddr, dst_mac, netif->hwaddr_len) != 0))
    {
#ifdef WIFI_DEBUG_ENABLED
        ChipLogProgress(DeviceLayer,
                        "lwip_input: DROP, [%02x:%02x:%02x:%02x:%02x:%02x]<-[%02x:%02x:%02x:%02x:%02x:%02x] type=%02x%02x",

                        dst_mac[0], dst_mac[1], dst_mac[2], dst_mac[3], dst_mac[4], dst_mac[5],

                        src_mac[0], src_mac[1], src_mac[2], src_mac[3], src_mac[4], src_mac[5],

                        b[12], b[13]);
#endif
        return;
    }

    /* We allocate a pbuf chain of pbufs from the Lwip buffer pool
     * and copy the data to the pbuf chain
     */
    if ((p = pbuf_alloc(PBUF_RAW, len, PBUF_POOL)) != NULL)
    {
        for (q = p, bufferoffset = 0; q != NULL; q = q->next)
        {
            memcpy((uint8_t *) q->payload, (uint8_t *) b + bufferoffset, q->len);
            bufferoffset += q->len;
        }
#ifdef WIFI_DEBUG_ENABLED
        ChipLogProgress(DeviceLayer,
                        "lwip_input: ACCEPT %ld, [%02x:%02x:%02x:%02x:%02x:%02x]<-[%02x:%02x:%02x:%02x:%02x:%02x] type=%02x%02x",
                        bufferoffset,

                        dst_mac[0], dst_mac[1], dst_mac[2], dst_mac[3], dst_mac[4], dst_mac[5],

                        src_mac[0], src_mac[1], src_mac[2], src_mac[3], src_mac[4], src_mac[5],

                        b[12], b[13]);
#endif

        if (netif->input(p, netif) != ERR_OK)
        {
            gOverrunCount++;
            ChipLogProgress(DeviceLayer, "overrun count entering when fail to alloc value %ld", gOverrunCount);
            pbuf_free(p);
        }
    }
    else
    {
        gOverrunCount++;
        ChipLogProgress(DeviceLayer, "overrun count entering when fail to alloc value %ld", gOverrunCount);
    }
}

/*****************************************************************************
 *  @fn  static err_t low_level_output(struct netif *netif, struct pbuf *p)
 *  @brief
 *    This function should does the actual transmission of the packet(s).
 *    The packet is contained in the pbuf that is passed to the function.
 *    This pbuf might be chained.
 *
 * @param[in] netif: the lwip network interface structure
 *
 * @param[in] p: the packet to send
 *
 * @return
 *    ERR_OK if successful
 ******************************************************************************/
#ifdef WF200_WIFI
static err_t low_level_output(struct netif * netif, struct pbuf * p)
{
    struct pbuf * q;
    sl_wfx_send_frame_req_t * tx_buffer;
    uint8_t * buffer;
    uint32_t framelength, asize;
    uint32_t bufferoffset;
    uint32_t padding;
    sl_status_t result;

    for (q = p, framelength = 0; q != NULL; q = q->next)
    {
        framelength += q->len;
    }
    if (framelength < LWIP_FRAME_ALIGNMENT)
    { /* 60 : Frame alignment for LWIP */
        padding = LWIP_FRAME_ALIGNMENT - framelength;
    }
    else
    {
        padding = 0;
    }

    /* choose padding of 64 */
    asize = SL_WFX_ROUND_UP(framelength + padding, 64) + sizeof(sl_wfx_send_frame_req_t);
    // 12 is size of other data in buffer struct, user shouldn't have to care about this?
    if (sl_wfx_host_allocate_buffer((void **) &tx_buffer, SL_WFX_TX_FRAME_BUFFER, asize) != SL_STATUS_OK)
    {
        ChipLogProgress(DeviceLayer, "*ERR*EN-Out: No mem frame len=%ld", framelength);
        gOverrunCount++;
        ChipLogProgress(DeviceLayer, "overrun count exiting when faied to alloc value %ld", gOverrunCount);
        return ERR_MEM;
    }
    buffer = tx_buffer->body.packet_data;
    /* copy frame from pbufs to driver buffers */
    for (q = p, bufferoffset = 0; q != NULL; q = q->next)
    {
        /* Get bytes in current lwIP buffer */
        memcpy((uint8_t *) ((uint8_t *) buffer + bufferoffset), (uint8_t *) ((uint8_t *) q->payload), q->len);
        bufferoffset += q->len;
    }
    /* No requirement to do this - but we should for security */
    if (padding)
    {
        memset(buffer + bufferoffset, 0, padding);
        framelength += padding;
    }
    /* transmit */
    int i  = 0;
    result = SL_STATUS_FAIL;

#ifdef WIFI_DEBUG_ENABLED
    ChipLogProgress(DeviceLayer, "WF200: Out %d", (int) framelength);
#endif

    /* send the generated frame over Wifi network */
    while ((result != SL_STATUS_OK) && (i++ < 10))
    {
        result = sl_wfx_send_ethernet_frame(tx_buffer, framelength, SL_WFX_STA_INTERFACE, 0 /* priority */);
    }
    sl_wfx_host_free_buffer(tx_buffer, SL_WFX_TX_FRAME_BUFFER);

    if (result != SL_STATUS_OK)
    {
        ChipLogProgress(DeviceLayer, "*ERR*Send enet %d", (int) framelength);
        return ERR_IF;
    }
    return ERR_OK;
}

/*****************************************************************************
 * @fn   void sl_wfx_host_received_frame_callback(sl_wfx_received_ind_t *rx_buffer)
 * @brief
 *    This function implements the wf200 received frame callback.
 *    Called from the context of the bus_task (not ISR)
 *
 * @param[in] rx_buffer: the ethernet frame received by the wf200
 *
 * @return
 *    None
 ******************************************************************************/
void sl_wfx_host_received_frame_callback(sl_wfx_received_ind_t * rx_buffer)
{
    struct netif * netif;

    /* Check packet interface to send to AP or STA interface */
    if ((rx_buffer->header.info & SL_WFX_MSG_INFO_INTERFACE_MASK) == (SL_WFX_STA_INTERFACE << SL_WFX_MSG_INFO_INTERFACE_OFFSET))
    {

        /* Send received frame to station interface */
        if ((netif = wfx_get_netif(SL_WFX_STA_INTERFACE)) != NULL)
        {
            uint8_t * buffer;
            uint16_t len;

            len    = rx_buffer->body.frame_length;
            buffer = (uint8_t *) &(rx_buffer->body.frame[rx_buffer->body.frame_padding]);

#ifdef WIFI_DEBUG_ENABLED
            ChipLogProgress(DeviceLayer, "WF200: In %d", (int) len);
#endif

            low_level_input(netif, buffer, len);
        }
        else
        {
#ifdef WIFI_DEBUG_ENABLED
            ChipLogProgress(DeviceLayer, "WF200: NO-INTF");
#endif
        }
    }
    else
    {
#ifdef WIFI_DEBUG_ENABLED
        ChipLogProgress(DeviceLayer, "WF200: Invalid frame IN");
#endif
    }
}

#else /* For RS911x - using LWIP */
static SemaphoreHandle_t ethout_sem;
/*****************************************************************************
 *  @fn  static err_t low_level_output(struct netif *netif, struct pbuf *p)
 *  @brief
 *    This function is called from LWIP task when LWIP stack
 *    has some data to be forwarded over WiFi Network
 *
 * @param[in] netif: lwip network interface
 *
 * @param[in] p: the packet to send
 *
 * @return
 *    ERR_OK if successful
 ******************************************************************************/
static err_t low_level_output(struct netif * netif, struct pbuf * p)
{
#if (SLI_SI91X_MCU_INTERFACE | EXP_BOARD)
    UNUSED_PARAMETER(netif);
    sl_status_t status;
    status = sl_wifi_send_raw_data_frame(SL_WIFI_CLIENT_INTERFACE, (uint8_t *) p->payload, p->len);
    if (status != SL_STATUS_OK)
    {
        return ERR_IF;
    }
    return ERR_OK;
#else
    void * packet;
    struct pbuf * q;
    uint16_t framelength = 0;
    uint16_t datalength  = 0;
    int32_t status       = 0;
#ifdef WIFI_DEBUG_ENABLED
    ChipLogProgress(DeviceLayer, "LWIP : low_level_output");
#endif
    if (xSemaphoreTake(ethout_sem, portMAX_DELAY) != pdTRUE)
    {
        return ERR_IF;
    }
    /* Calculate total packet size */
    for (q = p, framelength = 0; q != NULL; q = q->next)
    {
        framelength += q->len;
    }
    if (framelength < LWIP_FRAME_ALIGNMENT)
    {
        framelength = LWIP_FRAME_ALIGNMENT;
    }
#ifdef WIFI_DEBUG_ENABLED
    ChipLogProgress(DeviceLayer, "EN-RSI: Output");
#endif
    if ((netif->flags & (NETIF_FLAG_LINK_UP | NETIF_FLAG_UP)) != (NETIF_FLAG_LINK_UP | NETIF_FLAG_UP))
    {
        ChipLogError(DeviceLayer, "EN-RSI:NOT UP");
        xSemaphoreGive(ethout_sem);
        return ERR_IF;
    }
    packet = wfx_rsi_alloc_pkt();
    if (!packet)
    {
        ChipLogError(DeviceLayer, "EN-RSI:No buf");
        xSemaphoreGive(ethout_sem);
        return ERR_IF;
    }

#ifdef WIFI_DEBUG_ENABLED
    uint8_t * b = (uint8_t *) p->payload;
    ChipLogProgress(DeviceLayer, "EN-RSI: Out [%02x:%02x:%02x:%02x:%02x:%02x][%02x:%02x:%02x:%02x:%02x:%02x]type=%02x%02x", b[0],
                    b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], b[11], b[12], b[13]);
#endif
    /* Generate the packet */
    for (q = p, datalength = 0; q != NULL; q = q->next)
    {
        wfx_rsi_pkt_add_data(packet, (uint8_t *) (q->payload), (uint16_t) q->len, datalength);
        datalength += q->len;
    }
    if (datalength < LWIP_FRAME_ALIGNMENT)
    {
        /* Add junk data to the end for frame alignment if framelength is less than 60 */
        wfx_rsi_pkt_add_data(packet, (uint8_t *) (p->payload), LWIP_FRAME_ALIGNMENT - datalength, datalength);
    }
#ifdef WIFI_DEBUG_ENABLED
    ChipLogProgress(DeviceLayer, "EN-RSI: Sending %d", framelength);
#endif

    /* forward the generated packet to RSI to
     * send the data over wifi network
     */
    status = wfx_rsi_send_data(packet, datalength);
    if (status != 0)
    {
        ChipLogError(DeviceLayer, "wfx_rsi_send_data failed: %ld", status);
        xSemaphoreGive(ethout_sem);
        return ERR_IF;
    }

#ifdef WIFI_DEBUG_ENABLED
    ChipLogProgress(DeviceLayer, "EN-RSI:Xmit %d", framelength);
#endif
    xSemaphoreGive(ethout_sem);

    return ERR_OK;
#endif // RS9116
}

#if (SLI_SI91X_MCU_INTERFACE | EXP_BOARD)
/*****************************************************************************
 *  @fn  void sl_si91x_host_process_data_frame(uint8_t *buf, int len)
 *  @brief
 *    host received frame cb
 *
 * @param[in] buf: buffer
 *
 * @param[in] len: length
 *
 * @return
 *    None
 ******************************************************************************/
sl_status_t sl_si91x_host_process_data_frame(sl_wifi_interface_t interface, sl_wifi_buffer_t * buffer)
{
    void * packet;
    struct netif * ifp;
    sl_si91x_packet_t * rsi_pkt;
    packet  = sl_si91x_host_get_buffer_data(buffer, 0, NULL);
    rsi_pkt = (sl_si91x_packet_t *) packet;
    /* get the network interface for STATION interface,
     * and forward the received frame buffer to LWIP
     */
    if ((ifp = wfx_get_netif(SL_WFX_STA_INTERFACE)) != (struct netif *) 0)
    {
        low_level_input(ifp, rsi_pkt->data, rsi_pkt->length);
    }
    return SL_STATUS_OK;
}
#else

/*****************************************************************************
 *  @fn  void wfx_host_received_sta_frame_cb(uint8_t *buf, int len)
 *  @brief
 *    host received frame cb
 *
        @@ -409,17 +430,21 @@ static err_t low_level_output(struct netif * netif, struct pbuf * p)
 * @return
 *    None
 ******************************************************************************/
void wfx_host_received_sta_frame_cb(uint8_t * buf, int len)
{
    struct netif * ifp;

    /* get the network interface for STATION interface,
     * and forward the received frame buffer to LWIP
     */
    if ((ifp = wfx_get_netif(SL_WFX_STA_INTERFACE)) != (struct netif *) 0)
    {
        low_level_input(ifp, buf, len);
    }
}
#endif

#endif /* RS911x - with LWIP */

/*****************************************************************************
 *  @fn  err_t sta_ethernetif_init(struct netif *netif)
 *  @brief
 *    sta ethernet if initialization
 *
 * @param[in] netif: the lwip network interface structure
 *
 * @return
 *    ERR_OK if successful
 ******************************************************************************/
err_t sta_ethernetif_init(struct netif * netif)
{
    LWIP_ASSERT("netif != NULL", (netif != NULL));

    /* Set the netif name to identify the interface */
    netif->name[0] = STATION_NETIF0;
    netif->name[1] = STATION_NETIF1;

#if LWIP_IPV4 && LWIP_ARP
    netif->output = etharp_output;
#endif /* #if LWIP_IPV4 && LWIP_ARP */
#if LWIP_IPV6 && LWIP_ETHERNET
    netif->output_ip6 = ethip6_output;
#endif /* LWIP_IPV6 && LWIP_ETHERNET */
    netif->linkoutput = low_level_output;

    /* initialize the hardware */
    low_level_init(netif);
#ifndef WF200_WIFI
    /* Need single output only */
    ethout_sem = xSemaphoreCreateBinaryStatic(&xEthernetIfSemaBuffer);
    xSemaphoreGive(ethout_sem);
#endif
    return ERR_OK;
}
