/***************************************************************************/ /**
 * @file
 * @brief Memory LCD interface
 *******************************************************************************
 * # License
 * <b>Copyright 2023 Silicon Laboratories Inc. www.silabs.com</b>
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

#ifndef SL_MEMLCD_H
#define SL_MEMLCD_H

#include "sl_status.h"
#include <stdbool.h>
#include <stdint.h>
#include "rsi_timers.h"
#include "sl_status.h"
#include "rsi_pll.h"
#include "base_types.h"

#if !defined(MEMLCD_CUSTOM_DRIVER)

#include "sl_memlcd_spi.h"

#endif

#ifdef __cplusplus
extern "C" {
#endif

#define SL_MEMLCD_COLOR_MODE_MONOCHROME 1
#define SL_MEMLCD_COLOR_MODE_RGB_3BIT   2

/***************************************************************************/ /**
 * @addtogroup memlcd MEMLCD - Memory LCD
 * @brief Memory LCD interface.
 *  
 * The memory LCD interface is built to use SPI communication either with usart 
 * or eusart. Configurations for three standard display are already supported 
 * (lpm013m126a, ls013b7dh03 and ls013b7dh06), but the @ref sl_memlcd_t 
 * structure can also be configured with a custom LCD's specifications.
 * To implement a fully custom memory LCD interface, see @ref memlcd_custom.
 *
 * @{
 ******************************************************************************/

/**
 * General memory LCD data structure.
 */
typedef struct sl_memlcd_t {
  unsigned short width;  ///< Display pixel width
  unsigned short height; ///< Display pixel height
  uint8_t bpp;           ///< Bits per pixel
  uint8_t color_mode;    ///< Color mode
  int spi_freq;          ///< SPI clock frequency
  uint8_t extcomin_freq; ///< Extcomin pin toggle frequency
  uint8_t setup_us;      ///< SPI CS setup time
  uint8_t hold_us;       ///< SPI CS hold time
  void *custom_data;     ///< Custom LCD's data
} sl_memlcd_t;

/// @brief Enumeration to represent ulp-timer instances
///

/**************************************************************************/ /**
 * @brief
 *   Generates a delay in micro seconds.
 *
 * @param[in] time_us
 *   Required micro second delay.
 *
 * @return
 *   none.
 *****************************************************************************/
static void delay_us(uint16_t time_us);

/**************************************************************************/ /**
 * @brief
 *   Configure the memory LCD device.
 *
 * @details
 *   This function must be called to configure the memory LCD device
 *   before starting to use the memory LCD.
 *
 * @param[in] device
 *   Display device pointer.
 *
 * @return
 *   status code of the operation.
 *****************************************************************************/
sl_status_t sl_memlcd_configure(struct sl_memlcd_t *device);

/**************************************************************************/ /**
 * @brief
 *   Enable or disable the display.
 *
 * @details
 *   This function enables or disables the display. Disabling the display does
 *   not make it lose its data. Note that this function will not control the
 *   DISP pin on the display. This pin is usually controlled by board specific
 *   code.
 *
 * @param[in] device
 *   Display device pointer.
 *
 * @param[in] on
 *   Set this parameter to 'true' to enable the display. Set to 'false' in
 *   order to disable the display.
 *
 * @return
 *   status code of the operation.
 *****************************************************************************/
sl_status_t sl_memlcd_power_on(const struct sl_memlcd_t *device, bool on);

/**************************************************************************/ /**
 * @brief
 *   Clear the display.
 *
 * @param[in] device
 *   Memory LCD display device.
 *
 * @return
 *   SL_STATUS_OK if there are no errors.
 *****************************************************************************/
sl_status_t sl_memlcd_clear(const struct sl_memlcd_t *device);

/**************************************************************************/ /**
 * @brief
 *   Draw a number of rows to the memory LCD display.
 *
 * @param[in] device
 *   Memory LCD display device.
 *
 * @param[in] data
 *   Pointer to the pixel matrix buffer to draw. The format of the buffer
 *   depends on the color mode of the memory LCD display.
 *
 * @param[in] row_start
 *   Start row on the display where to start drawing. First row is 0.
 *
 * @param[in] row_count
 *   Number of rows to draw.
 *
 * @return
 *   SL_STATUS_OK if there are no errors.
 *****************************************************************************/
sl_status_t sl_memlcd_draw(const struct sl_memlcd_t *device,
                           const void *data,
                           unsigned int row_start,
                           unsigned int row_count);

/**************************************************************************/ /**
 * @brief
 *   Refresh the display device.
 *
 * @details
 *   This function can be used when, for instance, the clock configuration was
 *   changed to re-initialize the SPI clock rate.
 *
 * @param[in] device
 *   Display device pointer.
 *
 * @return
 *   status code of the operation.
 *****************************************************************************/
sl_status_t sl_memlcd_refresh(const struct sl_memlcd_t *device);

/**************************************************************************/ /**
 * @brief
 *   Get a handle to the memory LCD.
 *
 * @return
 *   Pointer to a memory LCD structure or NULL if no memory LCD is initialized
 *   yet.
 *****************************************************************************/
const sl_memlcd_t *sl_memlcd_get(void);

/** @} (end group memlcd) */

/***************************************************************************/ /**
 * @addtogroup memlcd MEMLCD - Memory LCD
 * @{
 * 
 * @n @section memlcd_custom Custom Memory LCD
 *
 * The custom memory LCD is a module allowing the implementation of a LCD 
 * driver that can't use the already designed interface. To achieve this, 
 * conditions must be met.
 * 
 * The LCD driver and the communication need to be implemented manually.
 * However, some functions must be implemented and the @ref sl_memlcd_t
 * structure must be initialized for the GLIB library to work properly. 
 * The functions to implement are @ref sl_memlcd_init, @ref sl_memlcd_power_on,
 * @ref sl_memlcd_draw and @ref sl_memlcd_get and they must follow the same
 * declaration as shown in the documentation. 
 * 
 * In the @ref sl_memlcd_init function, it is important to initialize a 
 * @ref sl_memlcd_t type variable and fill in the "height" and "width" fields 
 * with the real specifications of the LCD display. This same variable must be
 * accessible from the @ref sl_memlcd_get function as the GLIB library will 
 * fetch the height and width of the display.
 * 
 * The @ref sl_memlcd_t structure contains a "custom_data" field to store any
 * custom structure needed for the implementation of the driver.
 * 
 ******************************************************************************/

#ifdef __cplusplus
}
#endif

/** @} (end group memlcd) */

#endif