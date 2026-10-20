/*
 *
 *    Copyright (c) 2020-2026 Project CHIP Authors
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
 * Bounded FIFO queue with fixed-capacity storage indexed in a circle.
 *
 * This is one data structure, not two: logical behavior is a queue (enqueue at
 * the back, dequeue from the front). `head` and `count` map that queue onto a
 * fixed `FixedBuffer` by wrapping indices modulo `Capacity`, which is the
 * usual ring-buffer indexing trick for a fixed array.
 *
 * `PushBack` / `PopFront` are the standard names for enqueue/dequeue at the
 * two ends of that FIFO. A low-level ring API might expose only head/tail
 * indices; here we expose the queue operations callers need.
 *
 * After `PopFront`, the vacated cell is assigned `Slot{}` so the slot in the
 * array is empty until reused. That is optional for some `Slot` types once
 * moved-from, but it keeps array cells in a known state and matches types whose
 * moved-from state still holds resources until reassigned or destroyed.
 *
 * `PopFront` returns `Slot` by value: the returned object is constructed from
 * the slot contents (move), then returned to the caller (NRVO or move). It is
 * not a reference into ring storage; the caller owns the returned `Slot`.
 *
 * Storage mechanics are in this header so host unit tests can cover them
 * without LwIP.
 */

#pragma once

#include <lib/support/FixedBuffer.h>

#include <cstddef>
#include <utility>

namespace chip {
namespace Inet {

template <typename Slot, size_t Capacity>
struct DeferredUdpSendRing
{
    static_assert(Capacity > 0, "DeferredUdpSendRing capacity must be > 0");

    chip::FixedBuffer<Slot, Capacity> slots{};
    size_t head  = 0;
    size_t count = 0;

    bool Empty() const { return count == 0; }
    bool IsFull() const { return count == Capacity; }
    size_t ActiveCount() const { return count; }

    // Enqueue at the logical tail (may drop oldest entry when full).
    void PushBack(Slot && slot)
    {
        if (IsFull())
        {
            slots[head] = Slot{};
            head        = (head + 1) % Capacity;
            --count;
        }
        const size_t idx = (head + count) % Capacity;
        slots[idx]       = std::move(slot);
        ++count;
    }

    // Dequeue from the logical head; returned value is owned by the caller.
    Slot PopFront()
    {
        Slot out    = std::move(slots[head]);
        slots[head] = Slot{};
        head        = (head + 1) % Capacity;
        --count;
        return out;
    }
};

template <typename Slot, size_t Capacity>
void SwapDeferredUdpSendRings(DeferredUdpSendRing<Slot, Capacity> & a, DeferredUdpSendRing<Slot, Capacity> & b)
{
    std::swap(a.head, b.head);
    std::swap(a.count, b.count);
    for (size_t i = 0; i < Capacity; ++i)
    {
        std::swap(a.slots[i], b.slots[i]);
    }
}

} // namespace Inet
} // namespace chip
