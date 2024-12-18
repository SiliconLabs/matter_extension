/***************************************************************************//**
 * @file
 * @brief Configuration file for Zigbee Matter APP.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
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

// <<< Use Configuration Wizard in Context Menu >>>

#ifndef SL_CMP_CONFIG_H
#define SL_CMP_CONFIG_H

/*******************************************************************************
 ******************************   DEFINES   ************************************
 ******************************************************************************/

// Default behaviour of the CMP app is concurrent multiprotocol
#if ! defined(SL_MATTER_ZIGBEE_CMP) && ! defined(SL_MATTER_ZIGBEE_SEQUENTIAL)
#define SL_MATTER_ZIGBEE_SEQUENTIAL       
#endif

// <h>CMP App Configuration

// <o SL_MATTER_CMP_SECURE_ZIGBEE> Enable Install code for Zigbee.
// <i> Default: 0
// <i> Change the commissioning behaviour of Zigbee to use Install code
#define SL_MATTER_CMP_SECURE_ZIGBEE         0

// <o SL_MATTER_CMP_INSTALL_CODE> Default install code
// <i> Default: //7251C5A8F97E5526644ED771689DEA78 + crc: 7491
// <i> Install code for secure commisioning with Zigbee
#define SL_MATTER_CMP_INSTALL_CODE          0x72, 0x51, 0xC5, 0xA8, 0xF9, 0x7E, 0x55, 0x26, 0x64, 0x4E, 0xD7, 0x71, 0x68, 0x9D, 0xEA, 0x78, 0x74, 0x91

// <o SL_MATTER_CMP_INSTALL_CODE_EUID64> EUID of the device to pair with
// <i> Default: wildcard euid64
// <i> This need to be in reverse order, e.g. 3425B4FFFEA959E0 ==> 0xE0, 0x59, 0xA9, 0xFE, 0xFF, 0xb4, 0x25, 0x34
// <i> including the arguments.
#define SL_MATTER_CMP_INSTALL_CODE_EUID64 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF           



#endif // SL_CMP_CONFIG_H

// <<< end of configuration section >>>
