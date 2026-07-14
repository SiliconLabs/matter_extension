/*
 *    Copyright (c) 2024 Project CHIP Authors
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

static constexpr uint32_t kCreds_KeyId_Default = 2; //(PSA_KEY_ID_USER_MIN + 1);

// Size of the buffer holding the CSR subject name:
//   "CN=<cn>, 1.3.6.1.4.1.37244.2.1=VVVV, 1.3.6.1.4.1.37244.2.2=PPPP\0"
//   - <cn>:       X.509 ub-common-name limit of 64 chars (RFC 5280, Appendix A.1)
//   - VVVV/PPPP:  Matter VID/PID OID values, 4 uppercase-hex chars each
//   - literals:   "CN=", ", " separators and the two OID prefixes = 59 chars
//   - NUL:        1 char
// Worst case: 64 + 59 + 1 = 124, rounded up to 128.
static constexpr size_t kSubjectNameLengthMax = 128;

class AttestationKey
{
public:
    AttestationKey(uint32_t id = 0) { mId = (id > 0) ? id : kCreds_KeyId_Default; }
    ~AttestationKey() = default;

    uint32_t GetId() { return mId; }
    CHIP_ERROR Import(const uint8_t * asn1, size_t size);
    CHIP_ERROR Export(uint8_t * asn1, size_t max, size_t & size);
    CHIP_ERROR GenerateCSR(uint16_t vid, uint16_t pid, const CharSpan & cn, MutableCharSpan & csr);
    CHIP_ERROR SignMessage(const ByteSpan & message, MutableByteSpan & out_span);

#if (defined(SLI_SI91X_MCU_INTERFACE) && SLI_SI91X_MCU_INTERFACE)
    static CHIP_ERROR Unwrap(const uint8_t * asn1, size_t size, MutableByteSpan & private_key);
    static CHIP_ERROR SignMessageWithKey(const uint8_t * private_key, const ByteSpan & message, MutableByteSpan & out_span);
#endif // SLI_SI91X_MCU_INTERFACE

protected:
    uint32_t mId = 0;
};

} // namespace Provision
} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
