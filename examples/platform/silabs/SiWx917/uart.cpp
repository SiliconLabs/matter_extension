/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
 *    All rights reserved.
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
#include "AppConfig.h"
#include "USART.h"
#include "matter_shell.h"
#include "rsi_rom_egpio.h"
#include "silabs_utils.h"
#include "sl_si91x_usart.h"
#include "cmsis_os2.h"
#include <sl_cmsis_os2_common.h>
#ifdef __cplusplus
extern "C" {
#endif
#include "assert.h"
#include "rsi_board.h"
#include "rsi_debug.h"
#include "uart.h"
#include <stddef.h>
#include <string.h>

#define USART_BAUDRATE 115200 // Baud rate <9600-7372800>
#define UART_CONSOLE_ERR -1   // Negative value in case of UART Console action failed. Triggers a failure for PW_RPC

// uart transmit
#if SILABS_LOG_OUT_UART
#if CHIP_CONFIG_ENABLE_ICD_SERVER
#include "syscalls.h"
#endif // CHIP_CONFIG_ENABLE_ICD_SERVER
#define UART_MAX_QUEUE_SIZE 125
#else
#define UART_MAX_QUEUE_SIZE 25
#endif

#ifdef CHIP_CONFIG_LOG_MESSAGE_MAX_SIZE
#define UART_TX_MAX_BUF_LEN (CHIP_CONFIG_LOG_MESSAGE_MAX_SIZE + 2) // \r\n
#else
#define UART_TX_MAX_BUF_LEN (258)
#endif

sl_usart_handle_t usart_handle;

static constexpr uint32_t kUartTxCompleteFlag = 1;
static osThreadId_t sUartTaskHandle;
constexpr uint32_t kUartTaskSize = 512;
static uint8_t uartStack[kUartTaskSize];
static osThread_t sUartTaskControlBlock;
constexpr osThreadAttr_t kUartTaskAttr = { .name       = "UART",
                                           .attr_bits  = osThreadDetached,
                                           .cb_mem     = &sUartTaskControlBlock,
                                           .cb_size    = osThreadCbSize,
                                           .stack_mem  = uartStack,
                                           .stack_size = kUartTaskSize,
                                           .priority   = osPriorityRealtime };

typedef struct
{
    uint8_t data[UART_TX_MAX_BUF_LEN];
    uint16_t length = 0;
} UartTxStruct_t;

static osMessageQueueId_t sUartTxQueue;
static osMessageQueue_t sUartTxQueueStruct;
uint8_t sUartTxQueueBuffer[UART_MAX_QUEUE_SIZE * sizeof(UartTxStruct_t)];
constexpr osMessageQueueAttr_t kUartTxQueueAttr = { .cb_mem  = &sUartTxQueueStruct,
                                                    .cb_size = osMessageQueueCbSize,
                                                    .mq_mem  = sUartTxQueueBuffer,
                                                    .mq_size = sizeof(sUartTxQueueBuffer) };


void callback_event(uint32_t event);
static void uartSendBytes(uint8_t * buffer, uint16_t nbOfBytes);

/*******************************************************************************
 * Callback function triggered on data Transfer and reception
 ******************************************************************************/
void callback_event(uint32_t event)
{
    switch (event)
    {
    case SL_USART_EVENT_SEND_COMPLETE:
        osThreadFlagsSet(sUartTaskHandle, kUartTxCompleteFlag);
        break;
    case SL_USART_EVENT_RECEIVE_COMPLETE:
#ifdef ENABLE_CHIP_SHELL
        chip::NotifyShellProcess();
#endif
    case SL_USART_EVENT_TRANSFER_COMPLETE:
        break;
    }
}

void uartConsoleInit(void)
{
    if (sUartTaskHandle != NULL)
    {
        // Init was already done
        return;
    }

    sUartTxQueue    = osMessageQueueNew(UART_MAX_QUEUE_SIZE, sizeof(UartTxStruct_t), &kUartTxQueueAttr);
    sUartTaskHandle = osThreadNew(uartMainLoop, nullptr, &kUartTaskAttr);

    assert(sUartTaskHandle);
    assert(sUartTxQueue);

#if !(SILABS_LOG_OUT_UART && CHIP_CONFIG_ENABLE_ICD_SERVER)
    // if UART is used for logging, UART is already initialized as a part of sl_event_handler.c
    int32_t status = 0;
    sl_si91x_usart_control_config_t usart_config;
    usart_config.baudrate      = USART_BAUDRATE;
    usart_config.mode          = SL_USART_MODE_ASYNCHRONOUS;
    usart_config.parity        = SL_USART_NO_PARITY;
    usart_config.stopbits      = SL_USART_STOP_BITS_1;
    usart_config.hwflowcontrol = SL_USART_FLOW_CONTROL_NONE;
    usart_config.databits      = SL_USART_DATA_BITS_8;
    usart_config.misc_control  = SL_USART_MISC_CONTROL_NONE;
    usart_config.usart_module  = ULPUART;
    usart_config.config_enable = ENABLE;
    usart_config.synch_mode    = DISABLE;
    sl_si91x_usart_control_config_t get_config;

    // Initialize the UART
    status = sl_si91x_usart_init((usart_peripheral_t) usart_config.usart_module, &usart_handle);
    if (status != SL_STATUS_OK)
    {
        SILABS_LOG("sl_si91x_usart_initialize: Error Code : %lu \n", status);
    }

    // Configure the USART configurations
    status = sl_si91x_usart_set_configuration(usart_handle, &usart_config);
    if (status != SL_STATUS_OK)
    {
        SILABS_LOG("sl_si91x_usart_set_configuration: Error Code : %lu \n", status);
    }

    // Register user callback function
    status = sl_si91x_usart_multiple_instance_register_event_callback((usart_peripheral_t) usart_config.usart_module, callback_event);
    if (status != SL_STATUS_OK)
    {
        SILABS_LOG("sl_si91x_usart_register_event_callback: Error Code : %lu \n", status);
    }
#endif // !SILABS_LOG_OUT_UART
}

/*
 *   @brief Read the data available from the console Uart
 *   @param Buffer that contains the data to write, number bytes to write.
 *   @return Amount of bytes written or ERROR (-1)
 */
int16_t uartConsoleWrite(const char * Buf, uint16_t BufLength)
{
    if (Buf == NULL || BufLength < 1 || BufLength > UART_TX_MAX_BUF_LEN)
    {
        return UART_CONSOLE_ERR;
    }

    UartTxStruct_t workBuffer;
    memcpy(workBuffer.data, Buf, BufLength);
    workBuffer.length = BufLength;

    if (osMessageQueuePut(sUartTxQueue, &workBuffer, osPriorityNormal, 0) == osOK)
    {
        return BufLength;
    }

    return UART_CONSOLE_ERR;
}

/**
 * @brief Write Logs to the Uart. Appends a return character
 *
 * @param log pointer to the logs
 * @param length number of bytes to write
 * @return int16_t Amount of bytes written or ERROR (-1)
 */
int16_t uartLogWrite(const char * log, uint16_t length)
{
    if (log == NULL || length < 1 || (length + 2) > UART_TX_MAX_BUF_LEN)
    {
        return UART_CONSOLE_ERR;
    }

    UartTxStruct_t workBuffer;
    memcpy(workBuffer.data, log, length);
    memcpy(workBuffer.data + length, "\r\n", 2);
    workBuffer.length = length + 2;

    if (osMessageQueuePut(sUartTxQueue, &workBuffer, osPriorityNormal, 0) == osOK)
    {
        return length;
    }

    return UART_CONSOLE_ERR;
}

/*
 *   @brief Read the data available from the console Uart
 *   @param Buffer for the data to be read, number bytes to read.
 *   @return Amount of bytes that was read from the rx fifo or ERROR (-1)
 */
int16_t uartConsoleRead(char * Buf, uint16_t NbBytesToRead)
{
    int32_t status = 0;
    if (Buf == NULL || NbBytesToRead < 1)
    {
        return UART_CONSOLE_ERR;
    }

    status = sl_si91x_usart_receive_data(usart_handle, Buf, NbBytesToRead);
    if (status != SL_STATUS_OK)
    {
        return status;
    }
    return NbBytesToRead;
}

void uartMainLoop(void * args)
{
    UartTxStruct_t workBuffer;

    while (1)
    {

        osStatus_t eventReceived = osMessageQueueGet(sUartTxQueue, &workBuffer, nullptr, osWaitForever);
        while (eventReceived == osOK)
        {
            uartSendBytes(workBuffer.data, workBuffer.length);
            eventReceived = osMessageQueueGet(sUartTxQueue, &workBuffer, nullptr, 0);
        }
    }
}

/**
 * @brief Send Bytes to UART. This blocks the UART task.
 *
 * @param buffer pointer to the buffer containing the data
 * @param nbOfBytes number of bytes to send
 */
void uartSendBytes(uint8_t * buffer, uint16_t nbOfBytes)
{
#if SILABS_LOG_OUT_UART && CHIP_CONFIG_ENABLE_ICD_SERVER
    _write(0, (char *) buffer, nbOfBytes);
#else
    sl_si91x_usart_send_data(usart_handle, buffer, nbOfBytes);
    osThreadFlagsWait(kUartTxCompleteFlag, osFlagsWaitAny, osWaitForever);
#endif // SILABS_LOG_OUT_UART
}

#ifdef __cplusplus
}
#endif
