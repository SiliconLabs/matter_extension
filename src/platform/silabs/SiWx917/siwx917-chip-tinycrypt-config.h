/*
 *
 *    Copyright (c) 2023 Project CHIP Authors
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

#pragma once

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
/**
 * Enable FreeRTOS threading support
 */
#define MBEDTLS_FREERTOS

/**
 * Enable H Crypto and Entropy modules
 */
#define MBEDTLS_AES_C
#define MBEDTLS_ECP_C
#define MBEDTLS_ECDH_C
#define MBEDTLS_ENTROPY_C
#define MBEDTLS_SHA256_C
#define MBEDTLS_CIPHER_MODE_CTR
#define MBEDTLS_TRNG_C

#define MBEDTLS_NO_PLATFORM_ENTROPY
#define MBEDTLS_NO_DEFAULT_ENTROPY_SOURCES

#if defined(MBEDTLS_ECP_ALT) && !defined(MBEDTLS_ECP_RESTARTABLE)
typedef void mbedtls_ecp_restart_ctx;
#endif

#ifdef DIC_ENABLE
#define MBEDTLS_PKCS1_V15
#define MBEDTLS_RSA_NO_CRT
#define MBEDTLS_CIPHER_MODE_CBC
#define MBEDTLS_KEY_EXCHANGE_ECDHE_RSA_ENABLED
#define MBEDTLS_RSA_C
#define MBEDTLS_SHA1_C
#define MBEDTLS_SSL_IN_CONTENT_LEN 5120
#define MBEDTLS_SSL_OUT_CONTENT_LEN 1560
#define MBEDTLS_DEBUG_C
#define MBEDTLS_CIPHER_MODE_WITH_PADDING
#endif
#define MBEDTLS_PLATFORM_SNPRINTF_MACRO snprintf

#define MBEDTLS_AES_ROM_TABLES
#define MBEDTLS_ASN1_PARSE_C
#define MBEDTLS_ASN1_WRITE_C
#define MBEDTLS_BASE64_C
#define MBEDTLS_BIGNUM_C
#define MBEDTLS_CCM_C
#define MBEDTLS_CIPHER_C
#define MBEDTLS_CIPHER_MODE_CBC
#define MBEDTLS_CIPHER_MODE_CFB
#define MBEDTLS_CMAC_C
#define MBEDTLS_CTR_DRBG_C
#define MBEDTLS_ECDH_LEGACY_CONTEXT
#define MBEDTLS_ECDSA_C
#define MBEDTLS_ECDSA_DETERMINISTIC
#define MBEDTLS_ECJPAKE_C
#define MBEDTLS_ECP_DP_SECP256R1_ENABLED
#define MBEDTLS_ECP_NIST_OPTIM
#define MBEDTLS_ENTROPY_FORCE_SHA256
// TODO: 3R
// #define MBEDTLS_ENTROPY_HARDWARE_ALT

#define MBEDTLS_ERROR_STRERROR_DUMMY
#define MBEDTLS_HAVE_ASM
#define MBEDTLS_HKDF_C
#define MBEDTLS_HMAC_DRBG_C
#define MBEDTLS_KEY_EXCHANGE_ECDHE_ECDSA_ENABLED
#define MBEDTLS_KEY_EXCHANGE_ECJPAKE_ENABLED
#define MBEDTLS_KEY_EXCHANGE_PSK_ENABLED
#define MBEDTLS_MD_C
#define MBEDTLS_OID_C
#define MBEDTLS_PEM_PARSE_C
#define MBEDTLS_PEM_WRITE_C
#define MBEDTLS_PK_C
#define MBEDTLS_PK_PARSE_C
#define MBEDTLS_PK_WRITE_C
#define MBEDTLS_PKCS5_C
#define MBEDTLS_PLATFORM_C
#define MBEDTLS_PLATFORM_MEMORY
#define MBEDTLS_SHA256_SMALLER
#define MBEDTLS_SHA512_C
#define MBEDTLS_SSL_CLI_C
#define MBEDTLS_SSL_COOKIE_C
#define MBEDTLS_SSL_DTLS_ANTI_REPLAY
#define MBEDTLS_SSL_DTLS_HELLO_VERIFY
#define MBEDTLS_SSL_EXPORT_KEYS
#define MBEDTLS_SSL_KEEP_PEER_CERTIFICATE
#define MBEDTLS_SSL_MAX_FRAGMENT_LENGTH
#define MBEDTLS_SSL_PROTO_TLS1_2
#define MBEDTLS_SSL_PROTO_DTLS
#define MBEDTLS_SSL_SRV_C
#define MBEDTLS_SSL_TLS_C
#define MBEDTLS_X509_CREATE_C
#define MBEDTLS_X509_CSR_WRITE_C
#define MBEDTLS_X509_CRL_PARSE_C
#define MBEDTLS_X509_CRT_PARSE_C
#define MBEDTLS_X509_CSR_PARSE_C
#define MBEDTLS_X509_USE_C

#define MBEDTLS_MPI_WINDOW_SIZE 1 /**< Maximum windows size used. */
#ifdef DIC_ENABLE
#define MBEDTLS_MPI_MAX_SIZE 512 /**< Maximum number of bytes for usable MPIs. */
#else
#define MBEDTLS_MPI_MAX_SIZE 32 /**< Maximum number of bytes for usable MPIs. */
#endif
#define MBEDTLS_ECP_MAX_BITS 256        /**< Maximum bit size of groups */
#define MBEDTLS_ECP_WINDOW_SIZE 2       /**< Maximum window size used */
#define MBEDTLS_ECP_FIXED_POINT_OPTIM 0 /**< Enable fixed-point speed-up */
#define MBEDTLS_ENTROPY_MAX_SOURCES 2   /**< Maximum number of sources supported */

#if OPENTHREAD_CONFIG_COAP_SECURE_API_ENABLE
#define MBEDTLS_SSL_MAX_CONTENT_LEN 900 /**< Maxium fragment length in bytes */
#else
#ifdef DIC_ENABLE
#define MBEDTLS_SSL_MAX_CONTENT_LEN 5120 /**< Maxium fragment length in bytes */
#else
#define MBEDTLS_SSL_MAX_CONTENT_LEN 768 /**< Maxium fragment length in bytes */
#endif                                  // DIC
#endif

#define MBEDTLS_SSL_CIPHERSUITES MBEDTLS_TLS_ECJPAKE_WITH_AES_128_CCM_8

#include "mbedtls/check_config.h"