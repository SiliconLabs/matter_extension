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

#include "WakeUpMgr.h"

#include <lib/support/CodeUtils.h>

#include <em_device.h>
#include "sl_gpio.h"

namespace chip {
namespace Silabs {

namespace {

WakeUpTrigger MakeTrigger(ClusterId clusterId, AttributeId attributeId, uint64_t operand, WakeUpMatchMode mode)
{
    WakeUpTrigger t{};
    t.clusterId   = clusterId;
    t.attributeId = attributeId;
    t.operand     = operand;
    t.mode        = static_cast<uint8_t>(mode);
    return t;
}

} // namespace

WakeUpMgr & WakeUpMgr::Instance()
{
    static WakeUpMgr sInstance;
    return sInstance;
}

CHIP_ERROR WakeUpMgr::Init()
{
    if (mInitialized)
    {
        return CHIP_NO_ERROR;
    }

    /*
        Place relevant Init Here.
        e.g. Preconfigure Wake uo triggers
    */

    mInitialized = true;
    return CHIP_NO_ERROR;
}

CHIP_ERROR WakeUpMgr::SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, bool wakeOn)
{
    return Upsert(MakeTrigger(clusterId, attributeId, wakeOn ? 1u : 0u, WakeUpMatchMode::Boolean));
}

CHIP_ERROR WakeUpMgr::SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint8_t mask)
{
    return Upsert(MakeTrigger(clusterId, attributeId, mask, WakeUpMatchMode::Bitmask));
}

CHIP_ERROR WakeUpMgr::SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint16_t mask)
{
    return Upsert(MakeTrigger(clusterId, attributeId, mask, WakeUpMatchMode::Bitmask));
}

CHIP_ERROR WakeUpMgr::SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint32_t mask)
{
    return Upsert(MakeTrigger(clusterId, attributeId, mask, WakeUpMatchMode::Bitmask));
}

CHIP_ERROR WakeUpMgr::SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, uint64_t expected)
{
    return Upsert(MakeTrigger(clusterId, attributeId, expected, WakeUpMatchMode::Equal));
}

CHIP_ERROR WakeUpMgr::SetWakeUpTrigger(ClusterId clusterId, AttributeId attributeId, WakeUpMatchMode mode, uint64_t operand)
{
    VerifyOrReturnError(mode == WakeUpMatchMode::Boolean || mode == WakeUpMatchMode::Bitmask || mode == WakeUpMatchMode::Equal,
                        CHIP_ERROR_INVALID_ARGUMENT);
    return Upsert(MakeTrigger(clusterId, attributeId, operand, mode));
}

CHIP_ERROR WakeUpMgr::RemoveWakeUpTrigger(ClusterId clusterId, AttributeId attributeId)
{
    for (size_t i = 0; i < mCount; ++i)
    {
        if (mTriggers[i].clusterId == clusterId && mTriggers[i].attributeId == attributeId)
        {
            // Compact by moving the tail down one slot.
            for (size_t j = i + 1; j < mCount; ++j)
            {
                mTriggers[j - 1] = mTriggers[j];
            }
            --mCount;
            mTriggers[mCount] = WakeUpTrigger{};
            return CHIP_NO_ERROR;
        }
    }
    return CHIP_ERROR_NOT_FOUND;
}

bool WakeUpMgr::IsWakeUpNeeded(ClusterId clusterId, AttributeId attributeId, uint64_t value) const
{
    for (size_t i = 0; i < mCount; ++i)
    {
        const WakeUpTrigger & t = mTriggers[i];
        if (t.clusterId != clusterId || t.attributeId != attributeId)
        {
            continue;
        }
        switch (static_cast<WakeUpMatchMode>(t.mode))
        {
        case WakeUpMatchMode::Boolean:
            if ((value != 0) == (t.operand != 0))
            {
                return true;
            }
            break;
        case WakeUpMatchMode::Bitmask:
            if ((value & t.operand) != 0)
            {
                return true;
            }
            break;
        case WakeUpMatchMode::Equal:
            if (value == t.operand)
            {
                return true;
            }
            break;
        }
    }
    return false;
}

Span<const WakeUpTrigger> WakeUpMgr::GetWakeUpTriggers() const
{
    return Span<const WakeUpTrigger>(mTriggers, mCount);
}

CHIP_ERROR WakeUpMgr::Upsert(const WakeUpTrigger & trigger)
{
    for (size_t i = 0; i < mCount; ++i)
    {
        if (mTriggers[i].clusterId == trigger.clusterId && mTriggers[i].attributeId == trigger.attributeId)
        {
            mTriggers[i] = trigger;
            return CHIP_NO_ERROR;
        }
    }
    VerifyOrReturnError(mCount < kMaxTriggers, CHIP_ERROR_NO_MEMORY);
    mTriggers[mCount++] = trigger;
    return CHIP_NO_ERROR;
}

} // namespace Silabs
} // namespace chip
