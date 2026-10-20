/*
 *    Copyright (c) 2026 Project CHIP Authors
 *    All rights reserved.
 */
#pragma once

#include <lib/core/CHIPError.h>
#include <stddef.h>
#include <stdint.h>

namespace chip {
namespace DeviceLayer {
namespace Silabs {
namespace Provision {

/** Optional byte channel used by the proprietary provisioning protocol. */
struct IProvisionChannel
{
    virtual ~IProvisionChannel() = default;

    virtual CHIP_ERROR Init()                                                          = 0;
    virtual CHIP_ERROR Read(uint8_t * buffer, size_t bufferLength, size_t & bytesRead) = 0;
    virtual CHIP_ERROR Write(const uint8_t * buffer, size_t bufferLength)              = 0;
    virtual CHIP_ERROR OnDataAvailable()                                               = 0;
};

} // namespace Provision
} // namespace Silabs
} // namespace DeviceLayer
} // namespace chip
