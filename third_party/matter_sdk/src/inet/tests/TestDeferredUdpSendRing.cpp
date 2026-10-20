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
 * Unit tests for @ref chip::Inet::DeferredUdpSendRing, the FIFO backing
 * DeferredUdpSendQueueLwIP. LwIP-specific ProbeDefer/Flush behavior is not
 * covered here.
 */

#include <pw_unit_test/framework.h>

#include <inet/DeferredUdpSendRing.h>

namespace {

using namespace chip;
using namespace chip::Inet;

struct IntSlot
{
    int value = -1;
    IntSlot() = default;
    explicit IntSlot(int v) : value(v) {}
};

using Ring3 = DeferredUdpSendRing<IntSlot, 3>;

TEST(DeferredUdpSendRingTest, StartsEmpty)
{
    Ring3 r;
    EXPECT_TRUE(r.Empty());
    EXPECT_EQ(r.ActiveCount(), 0u);
    EXPECT_FALSE(r.IsFull());
}

TEST(DeferredUdpSendRingTest, PushPopSingle)
{
    Ring3 r;
    r.PushBack(IntSlot{ 42 });
    EXPECT_FALSE(r.Empty());
    EXPECT_EQ(r.ActiveCount(), 1u);
    IntSlot out = r.PopFront();
    EXPECT_EQ(out.value, 42);
    EXPECT_TRUE(r.Empty());
}

// PopFront returns a by-value Slot owned by the caller, not a view into ring
// storage; it must remain valid after later ring operations.
TEST(DeferredUdpSendRingTest, PopFrontReturnSurvivesLaterRingUse)
{
    Ring3 r;
    r.PushBack(IntSlot{ 5 });
    IntSlot first = r.PopFront();
    r.PushBack(IntSlot{ 6 });
    EXPECT_EQ(first.value, 5);
    EXPECT_EQ(r.PopFront().value, 6);
    EXPECT_TRUE(r.Empty());
}

TEST(DeferredUdpSendRingTest, FifoOrderUpToCapacity)
{
    Ring3 r;
    r.PushBack(IntSlot{ 1 });
    r.PushBack(IntSlot{ 2 });
    r.PushBack(IntSlot{ 3 });
    EXPECT_TRUE(r.IsFull());
    EXPECT_EQ(r.ActiveCount(), 3u);
    EXPECT_EQ(r.PopFront().value, 1);
    EXPECT_EQ(r.PopFront().value, 2);
    EXPECT_EQ(r.PopFront().value, 3);
    EXPECT_TRUE(r.Empty());
}

TEST(DeferredUdpSendRingTest, OverflowDropsOldest)
{
    Ring3 r;
    r.PushBack(IntSlot{ 1 });
    r.PushBack(IntSlot{ 2 });
    r.PushBack(IntSlot{ 3 });
    r.PushBack(IntSlot{ 4 });
    EXPECT_TRUE(r.IsFull());
    EXPECT_EQ(r.ActiveCount(), 3u);
    EXPECT_EQ(r.PopFront().value, 2);
    EXPECT_EQ(r.PopFront().value, 3);
    EXPECT_EQ(r.PopFront().value, 4);
    EXPECT_TRUE(r.Empty());
}

TEST(DeferredUdpSendRingTest, RepeatedOverflowKeepsFifo)
{
    Ring3 r;
    for (int i = 0; i < 10; ++i)
    {
        r.PushBack(IntSlot{ i });
    }
    EXPECT_EQ(r.ActiveCount(), 3u);
    EXPECT_EQ(r.PopFront().value, 7);
    EXPECT_EQ(r.PopFront().value, 8);
    EXPECT_EQ(r.PopFront().value, 9);
}

TEST(DeferredUdpSendRingTest, SwapExchangesRings)
{
    Ring3 a;
    Ring3 b;
    a.PushBack(IntSlot{ 1 });
    a.PushBack(IntSlot{ 2 });
    b.PushBack(IntSlot{ 9 });

    SwapDeferredUdpSendRings(a, b);

    EXPECT_EQ(a.ActiveCount(), 1u);
    EXPECT_EQ(b.ActiveCount(), 2u);
    EXPECT_EQ(a.PopFront().value, 9);
    EXPECT_EQ(b.PopFront().value, 1);
    EXPECT_EQ(b.PopFront().value, 2);
}

TEST(DeferredUdpSendRingTest, SwapEmptyWithFull)
{
    Ring3 a;
    Ring3 b;
    b.PushBack(IntSlot{ 10 });
    b.PushBack(IntSlot{ 11 });
    b.PushBack(IntSlot{ 12 });

    SwapDeferredUdpSendRings(a, b);

    EXPECT_TRUE(b.Empty());
    EXPECT_EQ(a.ActiveCount(), 3u);
    EXPECT_EQ(a.PopFront().value, 10);
    EXPECT_EQ(a.PopFront().value, 11);
    EXPECT_EQ(a.PopFront().value, 12);
    EXPECT_TRUE(a.Empty());
}

} // namespace
