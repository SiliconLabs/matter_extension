/*
 *    Copyright (c) 2026 Project CHIP Authors
 *    All rights reserved.
 */
#pragma once

#include <lib/core/CHIPError.h>
#include <lib/support/Span.h>
#include <stdint.h>

namespace chip {
namespace DeviceLayer {
namespace Silabs {
namespace Provision {

/** Platform credential operations required by Provision Core. */
struct IProvisionCrypto
{
    virtual ~IProvisionCrypto() = default;

    virtual CHIP_ERROR GenerateRandom(MutableByteSpan & output)                 = 0;
    virtual CHIP_ERROR Hash256(const ByteSpan & input, MutableByteSpan & output) = 0;
    virtual CHIP_ERROR ImportDeviceAttestationKey(const ByteSpan & key)                                    = 0;
    virtual CHIP_ERROR GenerateDeviceAttestationCSR(uint16_t vid, uint16_t pid, const CharSpan & commonName,
                                                    MutableCharSpan & csr)                                 = 0;
    virtual CHIP_ERROR SignWithDeviceAttestationKey(const ByteSpan & message, MutableByteSpan & signature) = 0;
};

} // namespace Provision
} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
