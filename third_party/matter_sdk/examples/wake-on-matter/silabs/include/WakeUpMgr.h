/*
 *
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

#include <cstddef>
#include <cstdint>

#include <lib/core/CHIPError.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/Span.h>

// Maximum number of concurrent (cluster, attribute) wake-up triggers the
// manager can store. Override at build time (e.g. via GN defines) if needed.
#ifndef WAKE_UP_MGR_MAX_TRIGGERS
#define WAKE_UP_MGR_MAX_TRIGGERS 25
#endif

namespace chip {
namespace Silabs {

// How the reported attribute value is compared against a trigger's operand.
enum class WakeUpMatchMode : uint8_t
{
    Boolean = 0, // wake when (value != 0) == (operand != 0)
    Bitmask = 1, // wake when (value & operand) != 0
    Equal   = 2, // wake when value == operand
};

// Wire-format entry describing a single wake-up trigger. Packed so it can be
// forwarded as-is over the MMIC transport to a Linux host.
struct __attribute__((packed)) WakeUpTrigger
{
    ClusterId   clusterId;
    AttributeId attributeId;
    uint64_t    operand;
    uint8_t     mode; // WakeUpMatchMode value
};

class WakeUpMgr
{
public:
    static constexpr size_t kMaxTriggers = WAKE_UP_MGR_MAX_TRIGGERS;

    static WakeUpMgr & Instance();

    // Configure the wake-up GPIO(s). Safe to call more than once.
    CHIP_ERROR Init();

    // Install (or replace) a trigger for a boolean attribute. Fires when the
    // reported value's truthiness matches wakeOn.
    CHIP_ERROR SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, bool wakeOn);

    // Install (or replace) a trigger for a bitmap attribute. Fires when any bit
    // selected by mask is set in the reported value.
    CHIP_ERROR SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint8_t mask);
    CHIP_ERROR SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint16_t mask);
    CHIP_ERROR SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint32_t mask);

    // Install (or replace) a trigger for a numeric attribute. Fires when the
    // reported value equals expected exactly.
    CHIP_ERROR SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint64_t expected);

    // Install (or replace) a trigger with an explicit match mode. Intended for
    // wire-driven configuration (e.g. MMIC addWakeUp) where the caller already
    // holds the raw mode + operand pair.
    CHIP_ERROR SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, WakeUpMatchMode mode, uint64_t operand);

    // Remove the trigger installed for (clusterId, attributeId). Returns
    // CHIP_ERROR_NOT_FOUND if no matching trigger exists.
    CHIP_ERROR RemoveWakeUpTrigger(ClusterId clusterId, AttributeId attributeId);

    // True if the reported (clusterId, attributeId, value) matches any installed
    // trigger. The value is delivered as uint64_t by the subscription callback;
    // signed integers are reinterpreted (two's complement).
    bool IsWakeUpNeeded(ClusterId clusterId, AttributeId attributeId, uint64_t value) const;

    // View of the currently installed triggers.
    Span<const WakeUpTrigger> GetWakeUpTriggers() const;

private:
    WakeUpMgr() = default;
    WakeUpMgr(const WakeUpMgr &)             = delete;
    WakeUpMgr & operator=(const WakeUpMgr &) = delete;

    // Replace an existing entry with the same (cluster, attribute) or append.
    CHIP_ERROR Upsert(const WakeUpTrigger & trigger);

    WakeUpTrigger mTriggers[kMaxTriggers] = {};
    size_t mCount                         = 0;
    bool mInitialized                     = false;
};

} // namespace Silabs
} // namespace chip
