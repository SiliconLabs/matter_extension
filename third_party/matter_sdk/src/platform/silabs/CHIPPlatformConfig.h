/*
 *
 *    Copyright (c) 2020-2022 Project CHIP Authors
 *    Copyright (c) 2019 Google LLC.
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

/**
 *    @file
 *          Platform-specific configuration overrides for CHIP on
 *          Silcon Labs Silabs platforms.
 */

#pragma once

#include <app/icd/server/ICDServerConfig.h>
#include <stdint.h>

#if (SL_MATTER_GN_BUILD == 0)
#if defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && (CHIP_CONFIG_ENABLE_ICD_SERVER == 1)
#include "sl_matter_icd_config.h"
#endif // defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && (CHIP_CONFIG_ENABLE_ICD_SERVER == 1)
#endif // SL_MATTER_GN_BUILD

// ==================== General Platform Adaptations ====================

#define CHIP_CONFIG_ABORT() abort()

#define CHIP_CONFIG_PERSISTED_STORAGE_KEY_TYPE uint32_t
#define CHIP_CONFIG_PERSISTED_STORAGE_ENC_MSG_CNTR_ID 1
#define CHIP_CONFIG_PERSISTED_STORAGE_MAX_KEY_LENGTH 2

#define CHIP_CONFIG_LIFETIIME_PERSISTED_COUNTER_KEY SilabsConfig::kConfigKey_LifeTimeCounter

// ==================== Security Adaptations ====================

// FIXME: Silabs set to MBED-TLS (But this is third-party repo in CHIP, not SDK)

// FIXME: Silabs currently set to CHIP (Does this use Entropy.cpp ?)

#if CHIP_HAVE_CONFIG_H
#include <crypto/CryptoBuildConfig.h>
#endif

#if (CHIP_CRYPTO_PLATFORM == 1) && !defined(SL_MBEDTLS_USE_TINYCRYPT)
#include "psa/crypto.h"

#if !defined(CHIP_CONFIG_SHA256_CONTEXT_SIZE)
#define CHIP_CONFIG_SHA256_CONTEXT_SIZE (sizeof(psa_hash_operation_t))
#endif

#if !defined(CHIP_CONFIG_SHA256_CONTEXT_ALIGN)
#define CHIP_CONFIG_SHA256_CONTEXT_ALIGN psa_hash_operation_t
#endif

#endif // (CHIP_CRYPTO_PLATFORM == 1) && !defined(SL_MBEDTLS_USE_TINYCRYPT)

// ==================== General Configuration Overrides ====================

#ifndef CHIP_CONFIG_MAX_UNSOLICITED_MESSAGE_HANDLERS
#define CHIP_CONFIG_MAX_UNSOLICITED_MESSAGE_HANDLERS 8
#endif // CHIP_CONFIG_MAX_UNSOLICITED_MESSAGE_HANDLERS

#ifndef CHIP_CONFIG_MAX_EXCHANGE_CONTEXTS
#define CHIP_CONFIG_MAX_EXCHANGE_CONTEXTS 20
#endif // CHIP_CONFIG_MAX_EXCHANGE_CONTEXTS

#ifndef CHIP_LOG_FILTERING
#define CHIP_LOG_FILTERING 0
#endif // CHIP_LOG_FILTERING

#ifndef CHIP_CONFIG_MAX_INTERFACES
#define CHIP_CONFIG_MAX_INTERFACES 4
#endif // CHIP_CONFIG_MAX_INTERFACES

#ifndef CHIP_CONFIG_MAX_LOCAL_ADDR_UDP_ENDPOINTS
#define CHIP_CONFIG_MAX_LOCAL_ADDR_UDP_ENDPOINTS 4
#endif // CHIP_CONFIG_MAX_LOCAL_ADDR_UDP_ENDPOINTS

/**
 *  @def CHIP_CONFIG_MAX_FABRICS
 *
 *  @brief
 *    Maximum number of fabrics the device can participate in.  Each fabric can
 *    provision the device with its unique operational credentials and manage
 *    its own access control lists.
 */
#ifndef CHIP_CONFIG_MAX_FABRICS
#define CHIP_CONFIG_MAX_FABRICS 5 // 4 fabrics + 1 for rotation slack
#endif

#if defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER

#ifndef CHIP_CONFIG_ICD_IDLE_MODE_DURATION_SEC
#define CHIP_CONFIG_ICD_IDLE_MODE_DURATION_SEC SL_IDLE_MODE_DURATION_S
#endif // CHIP_CONFIG_ICD_IDLE_MODE_DURATION_SEC

#ifndef CHIP_CONFIG_ICD_ACTIVE_MODE_DURATION_MS
#define CHIP_CONFIG_ICD_ACTIVE_MODE_DURATION_MS SL_ACTIVE_MODE_DURATION_MS
#endif // CHIP_CONFIG_ICD_ACTIVE_MODE_DURATION_MS

#ifndef CHIP_CONFIG_ICD_ACTIVE_MODE_THRESHOLD_MS
#define CHIP_CONFIG_ICD_ACTIVE_MODE_THRESHOLD_MS SL_ACTIVE_MODE_THRESHOLD
#endif // CHIP_CONFIG_ICD_ACTIVE_MODE_THRESHOLD_MS

#ifndef CHIP_CONFIG_ICD_CLIENTS_SUPPORTED_PER_FABRIC
#define CHIP_CONFIG_ICD_CLIENTS_SUPPORTED_PER_FABRIC SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC
#endif // CHIP_CONFIG_ICD_CLIENTS_SUPPORTED_PER_FABRIC

#ifdef SL_WIFI
#ifndef CHIP_CONFIG_ICD_OBSERVERS_POOL_SIZE
#define CHIP_CONFIG_ICD_OBSERVERS_POOL_SIZE 3
#endif // CHIP_CONFIG_ICD_OBSERVERS_POOL_SIZE
static_assert(CHIP_CONFIG_ICD_OBSERVERS_POOL_SIZE >= 3, "ICD Observers pool size must be at least 3");
#endif // SL_WIFI

#endif // defined(CHIP_CONFIG_ENABLE_ICD_SERVER) && CHIP_CONFIG_ENABLE_ICD_SERVER

/**
 * @brief CHIP_SHELL_MAX_LINE_SIZE
 *
 * @brief Platform maximum line for the Matter Shell
 */
#ifndef CHIP_SHELL_MAX_LINE_SIZE
#define CHIP_SHELL_MAX_LINE_SIZE 256
#endif // CHIP_SHELL_MAX_LINE_SIZE

// ==================== FreeRTOS Configuration Overrides ====================
#ifndef CHIP_CONFIG_FREERTOS_USE_STATIC_TASK
#define CHIP_CONFIG_FREERTOS_USE_STATIC_TASK 1
#endif

#ifndef CHIP_CONFIG_FREERTOS_USE_STATIC_QUEUE
#define CHIP_CONFIG_FREERTOS_USE_STATIC_QUEUE 1
#endif

#ifndef CHIP_SHELL_MAX_TOKENS
#define CHIP_SHELL_MAX_TOKENS 40
#endif // CHIP_SHELL_MAX_TOKENS
