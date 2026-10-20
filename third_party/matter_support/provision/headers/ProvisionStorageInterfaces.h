/*
 *    Copyright (c) 2026 Project CHIP Authors
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

#include <lib/core/CHIPError.h>
#include <lib/support/Span.h>
#include <stddef.h>
#include <stdint.h>

namespace chip {
namespace DeviceLayer {
namespace Silabs {
namespace Provision {
/**
 * Read-only access to persisted provisioning/factory data.
 *
 * This is the minimum storage capability required by consumers that only
 * retrieve factory data, such as a normal Matter application.
 */
struct IProvisionStorageReader
{
    virtual ~IProvisionStorageReader()                                                   = default;
    virtual CHIP_ERROR GetSerialNumber(char * value, size_t max)                         = 0;
    virtual CHIP_ERROR GetVendorId(uint16_t & value)                                     = 0;
    virtual CHIP_ERROR GetVendorName(char * value, size_t max)                           = 0;
    virtual CHIP_ERROR GetProductId(uint16_t & value)                                    = 0;
    virtual CHIP_ERROR GetProductName(char * value, size_t max)                          = 0;
    virtual CHIP_ERROR GetProductLabel(char * value, size_t max)                         = 0;
    virtual CHIP_ERROR GetProductURL(char * value, size_t max)                           = 0;
    virtual CHIP_ERROR GetPartNumber(char * value, size_t max)                           = 0;
    virtual CHIP_ERROR GetHardwareVersion(uint16_t & value)                              = 0;
    virtual CHIP_ERROR GetHardwareVersionString(char * value, size_t max)                = 0;
    virtual CHIP_ERROR GetManufacturingDate(uint8_t * value, size_t max, size_t & size)  = 0;
    virtual CHIP_ERROR GetPersistentUniqueId(uint8_t * value, size_t max, size_t & size) = 0;
    virtual CHIP_ERROR GetSetupDiscriminator(uint16_t & value)                           = 0;
    virtual CHIP_ERROR GetSpake2pIterationCount(uint32_t & value)                        = 0;
    virtual CHIP_ERROR GetSpake2pSalt(char * value, size_t max, size_t & size)           = 0;
    virtual CHIP_ERROR GetSpake2pVerifier(char * value, size_t max, size_t & size)       = 0;
    virtual CHIP_ERROR GetSetupPayload(uint8_t * value, size_t max, size_t & size)       = 0;
    virtual CHIP_ERROR GetFirmwareInformation(MutableByteSpan & value)                   = 0;
    virtual CHIP_ERROR GetCertificationDeclaration(MutableByteSpan & value)              = 0;
    virtual CHIP_ERROR GetProductAttestationIntermediateCert(MutableByteSpan & value)    = 0;
    virtual CHIP_ERROR GetDeviceAttestationCert(MutableByteSpan & value)                 = 0;
    virtual CHIP_ERROR GetProvisionVersion(char * value, size_t max, size_t & size)      = 0;
    virtual CHIP_ERROR GetTestEventTriggerKey(MutableByteSpan & value) = 0;
    virtual CHIP_ERROR GetOtaTlvEncryptionKeyId(uint32_t & value)      = 0;
    virtual CHIP_ERROR DecryptUsingOtaTlvEncryptionKey(MutableByteSpan & block, uint32_t & ivOffset) = 0;
};

/**
 * Optional write/provisioning capability.
 *
 * Read-only consumers do not need to provide this capability. The capability
 * also owns provisioning-specific lifecycle controls used by GFW.
 */
struct IProvisionStorageWriter
{

    virtual ~IProvisionStorageWriter()                                           = default;
    virtual CHIP_ERROR SetSerialNumber(const char * value, size_t len)           = 0;
    virtual CHIP_ERROR SetVendorId(uint16_t value)                               = 0;
    virtual CHIP_ERROR SetVendorName(const char * value, size_t len)             = 0;
    virtual CHIP_ERROR SetProductId(uint16_t value)                              = 0;
    virtual CHIP_ERROR SetProductName(const char * value, size_t len)            = 0;
    virtual CHIP_ERROR SetProductLabel(const char * value, size_t len)           = 0;
    virtual CHIP_ERROR SetProductURL(const char * value, size_t len)             = 0;
    virtual CHIP_ERROR SetPartNumber(const char * value, size_t len)             = 0;
    virtual CHIP_ERROR SetHardwareVersion(uint16_t value)                        = 0;
    virtual CHIP_ERROR SetHardwareVersionString(const char * value, size_t len)  = 0;
    virtual CHIP_ERROR SetManufacturingDate(const char * value, size_t len)      = 0;
    virtual CHIP_ERROR SetPersistentUniqueId(const uint8_t * value, size_t size) = 0;

    virtual CHIP_ERROR SetSetupDiscriminator(uint16_t value)               = 0;
    virtual CHIP_ERROR SetSpake2pIterationCount(uint32_t value)            = 0;
    virtual CHIP_ERROR SetSpake2pSalt(const char * value, size_t size)     = 0;
    virtual CHIP_ERROR SetSpake2pVerifier(const char * value, size_t size) = 0;
    virtual CHIP_ERROR SetSetupPayload(const uint8_t * value, size_t size) = 0;

    virtual CHIP_ERROR SetFirmwareInformation(const ByteSpan & value)                = 0;
    virtual CHIP_ERROR SetCertificationDeclaration(const ByteSpan & value)           = 0;
    virtual CHIP_ERROR SetProductAttestationIntermediateCert(const ByteSpan & value) = 0;
    virtual CHIP_ERROR SetDeviceAttestationCert(const ByteSpan & value)              = 0;
    virtual CHIP_ERROR SetProvisionVersion(const char * value, size_t len)           = 0;
    virtual CHIP_ERROR SetTestEventTriggerKey(const ByteSpan & value) = 0;
    virtual CHIP_ERROR SetOtaTlvEncryptionKey(const ByteSpan & value) = 0;

    // Provisioning/platform lifecycle controls. These are only required by
    // consumers that enable provisioning writes, such as GFW.
    virtual CHIP_ERROR Initialize(uint32_t flash_addr = 0, uint32_t flash_size = 0) = 0;
    virtual CHIP_ERROR GetFlashPageSize(uint32_t & size)
    {
        (void) size;
        return CHIP_ERROR_NOT_IMPLEMENTED;
    }
    virtual CHIP_ERROR SetCredentialsBaseAddress(uint32_t addr)                     = 0;
    virtual CHIP_ERROR GetCredentialsBaseAddress(uint32_t & addr)                   = 0;
    virtual CHIP_ERROR SetProvisionRequest(bool value)                              = 0;
    virtual CHIP_ERROR GetProvisionRequest(bool & value)                            = 0;

    virtual CHIP_ERROR Commit() = 0;
};

} // namespace Provision
} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
