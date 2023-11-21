/*
 *
 *    Copyright (c) 2022 Project CHIP Authors
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

#include "sl_si91x_button_config.h"
#include "rsi_pll.h"
#include "rsi_rom_clks.h"
#include "siwx917_utils.h"
#include "sli_siwx917_soc.h"

#define SOC_PLL_REF_FREQUENCY 32000000 /* PLL input REFERENCE clock 32MHZ */

// Note: Change this macro to required PLL frequency in hertz
#define PS4_SOC_FREQ 180000000 /* PLL out clock 180MHz */
#define SWITCH_QSPI_TO_SOC_PLL
#define ICACHE_DISABLE
#define DEBUG_DISABLE

/* QSPI clock config params */
#define INTF_PLL_500_CTRL_VALUE 0xD900
#define INTF_PLL_CLK 80000000 /* PLL out clock 80 MHz */

#define PMU_GOOD_TIME 31  /*Duration in us*/
#define XTAL_GOOD_TIME 31 /*Duration in us*/

/*Pre-fetch and regestring */
#define ICACHE2_ADDR_TRANSLATE_1_REG *(volatile uint32_t *) (0x20280000 + 0x24)
#define MISC_CFG_SRAM_REDUNDANCY_CTRL *(volatile uint32_t *) (0x46008000 + 0x18)
#define MISC_CONFIG_MISC_CTRL1 *(volatile uint32_t *) (0x46008000 + 0x44)
#define MISC_QUASI_SYNC_MODE *(volatile uint32_t *) (0x46008000 + 0x84)

void sl_button_on_change(uint8_t btn, uint8_t btnAction);

int soc_pll_config(void)
{
    int32_t status = RSI_OK;

    RSI_CLK_SocPllLockConfig(1, 1, 7);

    RSI_CLK_SocPllRefClkConfig(2);

    RSI_CLK_M4SocClkConfig(M4CLK, M4_ULPREFCLK, 0);

    /*Enable fre-fetch and register if SOC-PLL frequency is more than or equal to 120M*/
#if (PS4_SOC_FREQ >= 120000000)
    ICACHE2_ADDR_TRANSLATE_1_REG  = BIT(21);
    MISC_CFG_SRAM_REDUNDANCY_CTRL = BIT(4);
    MISC_CONFIG_MISC_CTRL1 |= BIT(4);
#if !(defined WISE_AOC_4)
    MISC_QUASI_SYNC_MODE |= BIT(6);
    MISC_QUASI_SYNC_MODE |= (BIT(6) | BIT(7));
#endif /* !WISE_AOC_4 */
#endif /* (PS4_SOC_FREQ > 120000000) */

    RSI_CLK_SetSocPllFreq(M4CLK, PS4_SOC_FREQ, SOC_PLL_REF_FREQUENCY);

    RSI_CLK_M4SocClkConfig(M4CLK, M4_SOCPLLCLK, 0);

#ifdef SWITCH_QSPI_TO_SOC_PLL
    /* program intf pll to 160Mhz */
    SPI_MEM_MAP_PLL(INTF_PLL_500_CTRL_REG9) = INTF_PLL_500_CTRL_VALUE;
    status                                  = RSI_CLK_SetIntfPllFreq(M4CLK, INTF_PLL_CLK, SOC_PLL_REF_FREQUENCY);
    if (status != RSI_OK)
    {
        SILABS_LOG("Failed to Config Interface PLL Clock, status:%d", status);
    }
    else
    {
        SILABS_LOG("Configured Interface PLL Clock to %d", INTF_PLL_CLK);
    }

    RSI_CLK_QspiClkConfig(M4CLK, QSPI_INTFPLLCLK, 0, 0, 1);
#endif /* SWITCH_QSPI_TO_SOC_PLL */

    return 0;
}

void sl_si91x_button_isr(uint8_t pin, uint8_t state)
{
    ROM_WL_rsi_m4_interrupt_isr(global_cb_p);
}

void IRQ021_Handler(void)
{
    // TODO: Replace with rsi_delay once that is fixed
    for (int i = 0; i < 10000; i++)
        __asm__("nop;");
    /* clear NPSS GPIO interrupt*/
    RSI_NPSSGPIO_ClrIntr(NPSS_GPIO_0_INTR);
    RSI_NPSSGPIO_ClrIntr(NPSS_GPIO_2_INTR);
    // if the btn is not pressed setting the state to 1
    if (RSI_NPSSGPIO_GetPin(NPSS_GPIO_2) && (!btn1))
    {
        btn1 = 1;
        sl_button_on_change(1, 0);
    }
    // geting the state of the gpio 2 pin and checking if the btn is already pressed or not
    if (!RSI_NPSSGPIO_GetPin(NPSS_GPIO_2) && btn1)
    {
        btn1 = 0;
        sl_button_on_change(1, 1);
    }
    if (RSI_NPSSGPIO_GetPin(NPSS_GPIO_0) && (!btn0))
    {
        btn0 = 1;
        sl_button_on_change(0, 0);
    }
    if (!RSI_NPSSGPIO_GetPin(NPSS_GPIO_0) && btn0)
    {
        btn0 = 0;
        sl_button_on_change(0, 1);
    }
}

/*==============================================*/
/**
 * @fn           void rsi_raise_pkt_pending_interrupt_to_ta()
 * @brief        This function raises the packet pending interrupt to TA
 * @param[in]    none
 * @param[out]   none
 * @return       none
 * @section description
 * This function raises the packet pending interrupt to TA
 *
 *
 */
void rsi_m4_ta_interrupt_init(void)
{
    //! Unmask the interrupt
    unmask_ta_interrupt(TX_PKT_TRANSFER_DONE_INTERRUPT | RX_PKT_TRANSFER_DONE_INTERRUPT);

    P2P_STATUS_REG |= M4_is_active;

    *(volatile uint32_t *) 0xE000E108 = 0x00000400;

#ifdef RSI_WITH_OS
    //! Set P2P Intr priority
    NVIC_SetPriority(TASS_P2P_IRQn, TASS_P2P_INTR_PRI);
#endif

    return;
}

void mask_ta_interrupt(uint32_t interrupt_no)
{
#ifdef ROM_WIRELESS
    ROMAPI_WL->mask_ta_interrupt(interrupt_no);
#else
    api_wl->mask_ta_interrupt(interrupt_no);
#endif
}

void unmask_ta_interrupt(uint32_t interrupt_no)
{
#ifdef ROM_WIRELESS
    ROMAPI_WL->unmask_ta_interrupt(interrupt_no);
#else
    api_wl->unmask_ta_interrupt(interrupt_no);
#endif
}

int rsi_submit_rx_pkt(void)
{
#ifdef ROM_WIRELESS
    return ROMAPI_WL->rsi_submit_rx_pkt(global_cb_p);
#else
    return api_wl->rsi_submit_rx_pkt(global_cb_p);
#endif
}

/*====================================================*/
/**
 * @fn          int16_t rsi_frame_read(uint8_t *pkt_buffer)
 * @brief This  function is used to read the response from module.
 * @param[in]   uint8_t *pkt_buffer, pointer to the buffer to which packet has to read
 *              which is used to store the response from the module
 * @param[out]  none
 * @return      errCode
 *              -1 = SPI busy / Timeout
 *              -2 = SPI Failure
 *              0  = SUCCESS
 * @section description
 * This is a common function to read response for all the command and data from Wi-Fi module.
 */

rsi_pkt_t * rsi_frame_read(void)
{
#ifdef ROM_WIRELESS
    return ROMAPI_WL->rsi_frame_read(global_cb_p);
#else
    return api_wl->rsi_frame_read(global_cb_p);
#endif
}

/*====================================================*/
/**
 * @fn          int16_t rsi_frame_write(rsi_frame_desc_t *uFrameDscFrame,uint8_t *payloadparam,uint16_t size_param)
 * @brief       Common function for all the commands.
 * @param[in]   uFrameDsc uFrameDscFrame, frame descriptor
 * @param[in]   uint8_t *payloadparam, pointer to the command payload parameter structure
 * @param[in]   uint16_t size_param, size of the payload for the command
 * @return      errCode
 *              -1 = SPI busy / Timeout
 *              -2 = SPI Failure
 *              0  = SUCCESS
 * @section description
 * This is a common function used to process a command to the Wi-Fi module.
 */

int16_t rsi_frame_write(rsi_frame_desc_t * uFrameDscFrame, uint8_t * payloadparam, uint16_t size_param)
{
#ifdef ROM_WIRELESS
    return ROMAPI_WL->rsi_frame_write(global_cb_p, uFrameDscFrame, payloadparam, size_param);
#else
    return api_wl->rsi_frame_write(global_cb_p, uFrameDscFrame, payloadparam, size_param);
#endif
}
/*==============================================*/
/**
 * @fn           void rsi_update_tx_dma_desc(uint8 skip_dma_valid)
 * @brief        This function updates the TX DMA descriptor address
 * @param[in]    skip_dma_valid
 * @param[out]   none
 * @return       none
 * @section description
 * This function updates the TX DMA descriptor address
 *
 *
 */

void rsi_update_tx_dma_desc(uint8_t skip_dma_valid)
{
    if (!skip_dma_valid)
    {
#ifdef COMMON_FLASH_EN
        if (!(M4_ULP_SLP_STATUS_REG & MCU_ULP_WAKEUP))
#endif
        {
            while (M4_TX_DMA_DESC_REG & DMA_DESC_REG_VALID)
                ;
        }
    }
    M4_TX_DMA_DESC_REG = (uint32_t) &tx_desc;
}

/*==============================================*/
/**
 * @fn           void rsi_update_rx_dma_desc()
 * @brief        This function updates the RX DMA descriptor address
 * @param[in]    none
 * @param[out]   none
 * @return       none
 * @section description
 * This function updates the RX DMA descriptor address
 *
 *
 */
void rsi_update_rx_dma_desc(void)
{
    M4_RX_DMA_DESC_REG = (uint32_t) &rx_desc;
}

/*==============================================*/
/**
 * @fn           void rsi_config_m4_dma_desc_on_reset()
 * @brief        This function updates the RX DMA and TX DMA descriptor address after reset
 * @param[in]    none
 * @param[out]   none
 * @return       none
 * @section description
 * This function updates the RX DMA  and TX DMA descriptor address
 *
 *
 */
void rsi_config_m4_dma_desc_on_reset(void)
{
    //! Wait for TA to go to sleep
    while (P2P_STATUS_REG & TA_is_active)
        ;
    //! Wait for TA to wakeup and should be in bootloader
    while (!(P2P_STATUS_REG & TA_is_active))
        ;
    //! UPdate M4 TX and RX dma descriptors
    M4_TX_DMA_DESC_REG = (uint32_t) &tx_desc;
    M4_RX_DMA_DESC_REG = (uint32_t) &rx_desc;
}

/*==================================================*/
/**
 * @fn          int16_t rsi_device_interrupt_status(uint8_t *int_status)
 * @brief       Returns the value of the Interrupt register
 * @param[in]   status
 * @param[out]  buffer full status reg value
 * @return      errorcode
 *               0 = Success
 *              -2 = Reg read failure
 */
int16_t rsi_device_interrupt_status(uint8_t * int_status)
{

    //! Check for TA active .If it is not active Buffer full status is not valid,
    //! SO return fail from here
    if (!(P2P_STATUS_REG & TA_is_active))
    {
        return RSI_FAIL;
    }
    //! copy buffer full status reg value
    *int_status = (uint8_t) HOST_INTR_STATUS_REG;

    return RSI_SUCCESS;
}
