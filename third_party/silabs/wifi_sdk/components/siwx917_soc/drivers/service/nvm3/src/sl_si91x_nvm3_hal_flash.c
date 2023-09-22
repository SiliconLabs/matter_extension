/*****************************************************************************
 * @file
 * @brief Non-Volatile Memory Wear-Leveling driver HAL implementation
 *******************************************************************************
 * # License
 * <b>Copyright 2018 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * SPDX-License-Identifier: Zlib
 *
 * The licensor of this software is Silicon Laboratories Inc.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 ******************************************************************************/

#ifdef COMMON_FLASH_EN
#include "sl_si91x_common_flash_intf.h"
#else
#include "sl_si91x_dual_flash_intf.h"
#endif
#include "si91x_device.h"
#include "nvm3.h"
#include "nvm3_hal_flash.h"
#include <stdbool.h>
#include <string.h>

/*******************************************************************************
 * @addtogroup nvm3
 * @{
 ******************************************************************************/

/*******************************************************************************
 * @addtogroup nvm3hal
 * @{
 ******************************************************************************/

/******************************************************************************
 ******************************    MACROS    **********************************
 *****************************************************************************/

#define CHECK_DATA 1 ///< Macro defining if data should be checked
/* default NVM3 page size */
#define PAGE_SIZE 4096
/* Memory-mapped: 0=not memory mapped, 1=memory mapped */
#define MEMORY_MAPPED     1
#define MEMORY_NOT_MAPPED 0
/* Device family or part number info */
#define DEVICE_NUMBER 19
/* Enable delay for flash (Qspi) operations.*/
#define CCP_FLASH_DELAY 100000
#ifdef CHIP_917B0
#define TA_M4_ADDRESS_OFFSET 0x4000000 //Difference between TA and M4 flash access address
#else
#define TA_M4_ADDRESS_OFFSET 0x4032000 //Difference between TA and M4 flash access address
#endif

/******************************************************************************
 ***************************   LOCAL VARIABLES   ******************************
 *****************************************************************************/

/******************************************************************************
 ***************************   LOCAL FUNCTIONS   ******************************
 *****************************************************************************/

/** @cond DO_NOT_INCLUDE_WITH_DOXYGEN */

/***************************************************************************/ /**
 * Check if the page is erased.
 ******************************************************************************/
static bool isErased(void *adr, size_t len)
{
  size_t i;
  size_t cnt;
  uint32_t *data = adr;
  bool status    = true;

  /* Check for if the page is erased */
  //check for data address is valid or NULL
  if (data == NULL) {
    status = false;
  } else {
    /* Caluclating the number words */
    cnt = len / sizeof(uint32_t);
    for (i = 0U; i < cnt; i++) {
      /* checking flash data after page erase */
      if (*data != 0xFFFFFFFFUL) {
        status = false;
      }
      data++;
    }
  }
  return status;
}

/***************************************************************************/ /**
 *   This function must be run at initialization, before any other functions
 *   are called. It is used to call necessary startup routines before the
 *   hardware can be accessed.
 ******************************************************************************/
static Ecode_t nvm3_halFlashOpen(nvm3_HalPtr_t nvmAdr, size_t flashSize)
{
  (void)nvmAdr;
  (void)flashSize;
  Ecode_t halSta = ECODE_NVM3_ERR_NOT_OPENED;

#if CCP_FLASH_DELAY
  /* Delay is added for flash (Qspi) operations.
   * It is added to resolve target connection lost (mcu reset) issue in SiWx917
   * SOC Device.
   */
  for (int i = 0; i < CCP_FLASH_DELAY; i++) {
    __asm__("nop;");
  }
#endif /* CCP_FLASH_DELAY */

  /* Calling this function for flash Initialize */
  if (!(rsi_flash_init())) {
    halSta = ECODE_NVM3_OK;
  }
  return halSta;
}

/***************************************************************************/ /**
 *   This function should be called at program termination.
 *   Should be done before any graceful halts.
 ******************************************************************************/
static void nvm3_halFlashClose(void)
{
  /* Calling this function for flash uninitialize */
  rsi_flash_uninitialize();
}

/***************************************************************************/ /**
 *   This function is used to retrieve information about the device properties,
 *   such as the device family, write size, whether the NVM is memory mapped or
 *   not, and finally the NVM page size.
 ******************************************************************************/
static Ecode_t nvm3_halFlashGetInfo(nvm3_HalInfo_t *halInfo)
{
  /* Hardcode with si91x */
  /* Device family or part number info */
  halInfo->deviceFamilyPartNumber = DEVICE_NUMBER;
  /* Write-size: 0=32-bit, 1=16-bit */
  halInfo->writeSize = NVM3_HAL_WRITE_SIZE_16;
  /* Memory-mapped: 0=not memory mapped, 1=memory mapped */
  halInfo->memoryMapped = MEMORY_MAPPED;
  /* The data storage page size */
  halInfo->pageSize     = PAGE_SIZE;
  halInfo->systemUnique = 0;

  return ECODE_NVM3_OK;
}

/***************************************************************************/ /**
 *   This function is used to control the access to the NVM. It can be either
 *   read, write, or none.
 ******************************************************************************/
static void nvm3_halFlashAccess(nvm3_HalNvmAccessCode_t access)
{
  (void)access;
}

/***************************************************************************/ /**
 *   This function is used to read data from the NVM. It will be a
 *   blocking call, since the thread asking for data to be read cannot continue
 *   without the data.
 ******************************************************************************/
static Ecode_t nvm3_halFlashReadWords(nvm3_HalPtr_t nvmAdr, void *dst, size_t wordCnt)
{
  uint32_t *pSrc      = (uint32_t *)nvmAdr;
  unsigned char *pDst = dst;
  Ecode_t halSta      = ECODE_NVM3_OK;
  /* Calling this function for flash read */
  halSta = rsi_flash_read(pSrc, pDst, wordCnt, 0);
  return halSta;
}

/***************************************************************************/ /**
 *   This function is used to write data to the NVM. This is a blocking
 *   function.
 ******************************************************************************/
static Ecode_t nvm3_halFlashWriteWords(nvm3_HalPtr_t nvmAdr, void const *src, size_t wordCnt)
{
  const uint32_t *pSrc = src;
  uint32_t *pDst       = (uint32_t *)nvmAdr;
  Ecode_t halSta       = ECODE_NVM3_ERR_WRITE_FAILED;
  size_t byteCnt;

  byteCnt = wordCnt * sizeof(uint32_t);
  //check for pDst and pSrc address is valid or NULL
  if ((pDst == NULL) || (pSrc == NULL)) {
    halSta = ECODE_NVM3_ERR_WRITE_FAILED;
  } else {
    /* Calling this function for flash write */
    if (!(rsi_flash_write(pDst, (unsigned char *)pSrc, byteCnt))) {
      halSta = ECODE_NVM3_OK;
    }
  }

  /* Check if the data  written */
#if CHECK_DATA
#ifdef DUAL_FLASH_EN
  uint32_t data = (uint32_t)nvmAdr;
#else
  uint32_t data = (uint32_t)nvmAdr - TA_M4_ADDRESS_OFFSET;
#endif
  if (halSta == ECODE_NVM3_OK) {
    if (memcmp((uint32_t *)data, pSrc, byteCnt) != 0) {
      halSta = ECODE_NVM3_ERR_WRITE_FAILED;
    }
  }
#endif
  return halSta;
}

/***************************************************************************/ /**
 *   This function is used to erase an NVM page.
 ******************************************************************************/
static Ecode_t nvm3_halFlashPageErase(nvm3_HalPtr_t nvmAdr)
{
  Ecode_t halSta = ECODE_NVM3_ERR_ERASE_FAILED;

  //check for NVM3 address is valid or NULL
  if (nvmAdr == NULL) {
    halSta = ECODE_NVM3_ERR_ERASE_FAILED;
  } else {
    /* Calling this function for flash erase */
    if (!(rsi_flash_erase_sector((uint32_t *)nvmAdr))) {
      halSta = ECODE_NVM3_OK;
    }
  }

  /* Check if the page is erased */
#if CHECK_DATA
  if (halSta == ECODE_NVM3_OK) {
#ifdef DUAL_FLASH_EN
    if (!isErased((nvmAdr), PAGE_SIZE)) {
#else
    if (!isErased((nvmAdr - TA_M4_ADDRESS_OFFSET), PAGE_SIZE)) {
#endif
      halSta = ECODE_NVM3_ERR_ERASE_FAILED;
    }
  }
#endif
  return halSta;
}

/*******************************************************************************
 ***************************   GLOBAL VARIABLES   ******************************
 ******************************************************************************/

const nvm3_HalHandle_t nvm3_halFlashHandle = {
  .open       = nvm3_halFlashOpen,       ///< Set the open function
  .close      = nvm3_halFlashClose,      ///< Set the close function
  .getInfo    = nvm3_halFlashGetInfo,    ///< Set the get-info function
  .access     = nvm3_halFlashAccess,     ///< Set the access function
  .pageErase  = nvm3_halFlashPageErase,  ///< Set the page-erase function
  .readWords  = nvm3_halFlashReadWords,  ///< Set the read-words function
  .writeWords = nvm3_halFlashWriteWords, ///< Set the write-words function
};

/** @} (end addtogroup nvm3hal) */
/** @} (end addtogroup nvm3) */
