
/**
 * @file
 * @brief Matter abstraction layer for Direct Internet Connectivity.
 *******************************************************************************
 * # License
 * <b>Copyright 2023 Silicon Laboratories Inc.
 *www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon
 *Laboratories Inc. Your use of this software is
 *governed by the terms of Silicon Labs Master
 *Software License Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement.
 *This software is distributed to you in Source Code
 *format and is governed by the sections of the MSLA
 *applicable to Source Code.
 *
 ******************************************************************************/

#ifndef _MATTER_AWS_NVM_CERT_H

#include <lib/core/CHIPError.h>

CHIP_ERROR MatterAwsGetCACertificate(char * buf, size_t buf_len, size_t * bufSize);

CHIP_ERROR MatterAwsGetDeviceCertificate(char * buf, size_t buf_len, size_t * bufSize);

CHIP_ERROR MatterAwsGetDevicePrivKey(char * buf, size_t buf_len, size_t * bufSize);

CHIP_ERROR MatterAwsGetHostname(char * buf, size_t buf_len, size_t * bufSize);

CHIP_ERROR MatterAwsGetClientId(char * buf, size_t buf_len, size_t * bufSize);

#endif //_MATTER_AWS_NVM_CERT_H
