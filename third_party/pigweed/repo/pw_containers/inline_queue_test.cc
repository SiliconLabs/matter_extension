// Copyright 2020 The Pigweed Authors
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.

#include "pw_containers/inline_queue.h"

#include <algorithm>
#include <array>
#include <cstddef>

#include "gtest/gtest.h"
#include "pw_compilation_testing/negative_compilation.h"
#include "pw_containers/algorithm.h"
#include "pw_containers_private/test_helpers.h"

namespace pw::containers {
namespace {

using namespace std::literals::string_view_literals;
using test::CopyOnly;
using test::Counter;
using test::MoveOnly;

TEST(InlineQueue, Construct_Sized) {
  InlineQueue<int, 3> queue;
  EXPECT_TRUE(queue.empty());
  EXPECT_EQ(queue.size(), 0u);
  EXPECT_EQ(queue.max_size(), 3u);
}

TEST(InlineQueue, Construct_GenericSized) {
  InlineQueue<int, 3> sized_queue;
  InlineQueue<int>& queue(sized_queue);
  EXPECT_TRUE(queue.empty());
  EXPECT_EQ(queue.size(), 0u);
  EXPECT_EQ(queue.max_size(), 3u);
}

TEST(InlineQueue, Destruct_ZeroLength) {
  Counter::Reset();
  {
    InlineQueue<Counter, 0> queue;
    EXPECT_EQ(queue.size(), 0u);
  }
  EXPECT_EQ(Counter::created, 0);
  EXPECT_EQ(Counter::destroyed, 0);
}

TEST(InlineQueue, Destruct_Empty) {
  Counter::Reset();

  {
    InlineQueue<Counter, 3> queue;
    EXPECT_EQ(queue.size(), 0u);
  }
  EXPECT_EQ(Counter::created, 0);
  EXPECT_EQ(Counter::destroyed, 0);
}

TEST(InlineQueue, Destruct_MultpileEntries) {
  Counter value;
  Counter::Reset();

  { InlineQueue<Counter, 128> queue(100, value); }

  EXPECT_EQ(Counter::created, 100);
  EXPECT_EQ(Counter::destroyed, 100);
}

TEST(InlineQueue, Assign_InitializerList) {
  InlineQueue<int, 4> queue({1, 3, 5, 7});

  EXPECT_EQ(4u, queue.size());

  EXPECT_EQ(1, queue[0]);
  EXPECT_EQ(3, queue[1]);
  EXPECT_EQ(5, queue[2]);
  EXPECT_EQ(7, queue[3]);
}

TEST(InlineQueue, Access_Iterator) {
  InlineQueue<Counter, 2> queue(2);
  for (Counter& item : queue) {
    EXPECT_EQ(item.value, 0);
  }
  for (const Counter& item : queue) {
    EXPECT_EQ(item.value, 0);
  }
}

TEST(InlineQueue, Access_ConstIterator) {
  const InlineQueue<Counter, 2> queue(2);
  for (const Counter& item : queue) {
    EXPECT_EQ(item.value, 0);
  }
}

TEST(InlineQueue, Access_ZeroLength) {
  InlineQueue<Counter, 0> queue;

  EXPECT_EQ(0u, queue.size());
  EXPECT_EQ(0u, queue.max_size());
  EXPECT_TRUE(queue.empty());
  EXPECT_TRUE(queue.full());

  for (Counter& item : queue) {
    (void)item;
    FAIL();
  }
}

TEST(InlineQueue, Access_ContiguousData) {
  // Content = {}, Storage = [x, x]
  InlineQueue<int, 2> queue;

  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_EQ(first.size(), 0u);
    EXPECT_EQ(second.size(), 0u);
  }

  // Content = {1}, Storage = [1, x]
  queue.push(1);
  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_TRUE(Equal(first, std::array<int, 1>{1}));
    EXPECT_TRUE(Equal(second, std::array<int, 0>{}));
  }

  // Content = {1, 2}, Storage = [1, 2]
  queue.push(2);
  EXPECT_TRUE(queue.full());
  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_TRUE(Equal(first, std::array<int, 2>{1, 2}));
    EXPECT_TRUE(Equal(second, std::array<int, 0>{}));
  }

  // Content = {2}, Storage = [x, 2]
  queue.pop();
  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_TRUE(Equal(first, std::array<int, 1>{2}));
    EXPECT_TRUE(Equal(second, std::array<int, 0>{}));
  }

  // Content = {2, 1}, Storage = [1, 2]
  queue.push(1);
  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_TRUE(Equal(first, std::array<int, 1>{2}));
    EXPECT_TRUE(Equal(second, std::array<int, 1>{1}));
  }

  // Content = {1}, Storage = [1, x]
  queue.pop();
  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_TRUE(Equal(first, std::array<int, 1>{1}));
    EXPECT_TRUE(Equal(second, std::array<int, 0>{}));
  }

  // Content = {1, 2}, Storage = [1, 2]
  queue.push(2);
  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_TRUE(Equal(first, std::array<int, 2>{1, 2}));
    EXPECT_TRUE(Equal(second, std::array<int, 0>{}));
  }
}

TEST(InlineQueue, Access_ConstContiguousData) {
  // Content = {1, 2}, Storage = [1, 2]
  const InlineQueue<int, 2> queue = {1, 2};

  {
    auto [first, second] = queue.contiguous_data();
    EXPECT_EQ(first.size(), 2u);
    EXPECT_EQ(second.size(), 0u);
  }
}

TEST(InlineQueue, Modify_Clear) {
  Counter::Reset();

  InlineQueue<Counter, 100> queue;
  queue.emplace();
  queue.emplace();
  queue.emplace();

  queue.clear();

  EXPECT_EQ(3, Counter::created);
  EXPECT_EQ(3, Counter::destroyed);
}

TEST(InlineQueue, Modify_Push_Copy) {
  Counter value(99);
  Counter::Reset();

  {
    InlineQueue<Counter, 10> queue;
    queue.push(value);

    EXPECT_EQ(queue.size(), 1u);
    EXPECT_EQ(queue.front().value, 99);
  }

  EXPECT_EQ(Counter::created, 1);
  EXPECT_EQ(Counter::destroyed, 1);
}

TEST(InlineQueue, Modify_Push_Move) {
  Counter::Reset();

  {
    Counter value(99);
    InlineQueue<Counter, 10> queue;
    queue.push(std::move(value));

    EXPECT_EQ(queue.size(), 1u);
    EXPECT_EQ(queue.front().value, 99);
    // NOLINTNEXTLINE(bugprone-use-after-move)
    EXPECT_EQ(value.value, 0);
  }

  EXPECT_EQ(Counter::created, 1);
  EXPECT_EQ(Counter::destroyed, 2);
  EXPECT_EQ(Counter::moved, 1);
}

TEST(InlineQueue, Modify_Emplace) {
  Counter::Reset();

  {
    InlineQueue<Counter, 10> queue;
    queue.emplace(314);

    EXPECT_EQ(queue.size(), 1u);
    EXPECT_EQ(queue.front().value, 314);
  }

  EXPECT_EQ(Counter::created, 1);
  EXPECT_EQ(Counter::destroyed, 1);
}

TEST(InlineQueue, Modify_Overwrite) {
  Counter::Reset();
  {
    InlineQueue<Counter, 2> queue(2);
    queue.push_overwrite(1);
    queue.emplace_overwrite(2);

    EXPECT_EQ(queue.size(), 2u);
    EXPECT_EQ(queue.front().value, 1);
    EXPECT_EQ(queue.back().value, 2);
  }
}

TEST(InlineQueue, Modify_Wrap) {
  Counter::Reset();

  {
    InlineQueue<Counter, 3> queue;
    queue.emplace(1);
    queue.emplace(2);
    queue.emplace(3);

    ASSERT_EQ(queue.size(), 3u);
    EXPECT_EQ(queue[0].value, 1);
    EXPECT_EQ(queue[1].value, 2);
    EXPECT_EQ(queue[2].value, 3);

    queue.pop();
    queue.emplace(4);

    ASSERT_EQ(queue.size(), 3u);
    EXPECT_EQ(queue[0].value, 2);
    EXPECT_EQ(queue[1].value, 3);
    EXPECT_EQ(queue[2].value, 4);
  }

  EXPECT_EQ(Counter::created, 4);
  EXPECT_EQ(Counter::destroyed, 4);
}

TEST(InlineQueue, Modify_Pop) {
  Counter::Reset();

  InlineQueue<Counter, 3> queue;
  queue.emplace(0);
  queue.pop();
  queue.emplace(0);
  queue.pop();
  queue.emplace(1);  // This wraps to the other end.
  queue.emplace(2);  // This is the first entry in storage.
  queue.emplace(3);
  // Content = {1, 2, 3}, Storage = [2, 3, 1]

  ASSERT_EQ(queue.size(), 3u);
  EXPECT_EQ(queue[0].value, 1);
  EXPECT_EQ(queue[1].value, 2);
  EXPECT_EQ(queue[2].value, 3);

  // This wraps around
  queue.pop();
  // Content = {2, 3}, Storage = [2, 3, x]

  EXPECT_EQ(queue.size(), 2u);
  EXPECT_EQ(queue[0].value, 2);
  EXPECT_EQ(queue[1].value, 3);

  queue.pop();
  // Content = {3}, Storage = [x, 3, x]
  ASSERT_EQ(queue.size(), 1u);
  EXPECT_EQ(queue[0].value, 3);

  EXPECT_EQ(Counter::created, 5);
  EXPECT_EQ(Counter::destroyed, 4);
}

TEST(InlineQueue, Generic) {
  InlineQueue<int, 10> queue({1, 2, 3, 4, 5});
  InlineQueue<int>& generic_queue(queue);

  EXPECT_EQ(generic_queue.size(), queue.size());
  EXPECT_EQ(generic_queue.max_size(), queue.max_size());

  int i = 0;
  for (int value : queue) {
    EXPECT_EQ(value, generic_queue[i]);
    i += 1;
  }

  i = 0;
  for (int value : generic_queue) {
    EXPECT_EQ(queue[i], value);
    i += 1;
  }
}

TEST(InlineQueue, ConstexprMaxSize) {
  InlineQueue<int, 10> queue;
  constexpr size_t kMaxSize = queue.max_size();
  EXPECT_EQ(queue.max_size(), kMaxSize);

  // Ensure the generic sized container does not have a constexpr max_size().
  [[maybe_unused]] InlineQueue<int>& generic_queue(queue);
#if PW_NC_TEST(InlineQueue_GenericMaxSize_NotConstexpr)
  PW_NC_EXPECT_CLANG(
      "kGenericMaxSize.* must be initialized by a constant expression");
  PW_NC_EXPECT_GCC("call to non-'constexpr' function .*InlineQueue.*max_size");
  [[maybe_unused]] constexpr size_t kGenericMaxSize = generic_queue.max_size();
#endif  // PW_NC_TEST
}

TEST(InlineQueue, StdMaxElement) {
  // Content = {1, 2, 3, 4}, Storage = [1, 2, 3, 4]
  InlineQueue<int, 4> queue = {1, 2, 3, 4};

  auto max_element_it = std::max_element(queue.begin(), queue.end());
  ASSERT_NE(max_element_it, queue.end());
  EXPECT_EQ(*max_element_it, 4);

  // Content = {2, 3, 4, 5}, Storage = [5, 2, 3, 4]
  queue.push_overwrite(5);

  max_element_it = std::max_element(queue.begin(), queue.end());
  ASSERT_NE(max_element_it, queue.end());
  EXPECT_EQ(*max_element_it, 5);

  // Content = {3, 4, 5}, Storage = [5, x, 3, 4]
  queue.pop();

  max_element_it = std::max_element(queue.begin(), queue.end());
  ASSERT_NE(max_element_it, queue.end());
  EXPECT_EQ(*max_element_it, 5);

  // Content = {}, Storage = [x, x, x, x]
  queue.clear();

  max_element_it = std::max_element(queue.begin(), queue.end());
  ASSERT_EQ(max_element_it, queue.end());
}

TEST(InlineQueue, StdMaxElementConst) {
  // Content = {1, 2, 3, 4}, Storage = [1, 2, 3, 4]
  InlineQueue<int, 4> queue = {1, 2, 3, 4};

  auto max_element_it = std::max_element(queue.cbegin(), queue.cend());
  ASSERT_NE(max_element_it, queue.cend());
  EXPECT_EQ(*max_element_it, 4);

  // Content = {2, 3, 4, 5}, Storage = [5, 2, 3, 4]
  queue.push_overwrite(5);

  max_element_it = std::max_element(queue.cbegin(), queue.cend());
  ASSERT_NE(max_element_it, queue.cend());
  EXPECT_EQ(*max_element_it, 5);

  // Content = {3, 4, 5}, Storage = [5, x, 3, 4]
  queue.pop();

  max_element_it = std::max_element(queue.cbegin(), queue.cend());
  ASSERT_NE(max_element_it, queue.cend());
  EXPECT_EQ(*max_element_it, 5);

  // Content = {}, Storage = [x, x, x, x]
  queue.clear();

  max_element_it = std::max_element(queue.cbegin(), queue.cend());
  ASSERT_EQ(max_element_it, queue.cend());
}

// Test that InlineQueue<T> is trivially destructible when its type is.
static_assert(std::is_trivially_destructible_v<InlineQueue<int>>);
static_assert(std::is_trivially_destructible_v<InlineQueue<int, 4>>);

static_assert(std::is_trivially_destructible_v<MoveOnly>);
static_assert(std::is_trivially_destructible_v<InlineQueue<MoveOnly>>);
static_assert(std::is_trivially_destructible_v<InlineQueue<MoveOnly, 1>>);

static_assert(std::is_trivially_destructible_v<CopyOnly>);
static_assert(std::is_trivially_destructible_v<InlineQueue<CopyOnly>>);
static_assert(std::is_trivially_destructible_v<InlineQueue<CopyOnly, 99>>);

static_assert(!std::is_trivially_destructible_v<Counter>);
static_assert(!std::is_trivially_destructible_v<InlineQueue<Counter>>);
static_assert(!std::is_trivially_destructible_v<InlineQueue<Counter, 99>>);

// Tests that InlineQueue<T> does not have any extra padding.
static_assert(sizeof(InlineQueue<uint8_t, 1>) ==
              sizeof(InlineQueue<uint8_t>::size_type) * 4 +
                  std::max(sizeof(InlineQueue<uint8_t>::size_type),
                           sizeof(uint8_t)));
static_assert(sizeof(InlineQueue<uint8_t, 2>) ==
              sizeof(InlineQueue<uint8_t>::size_type) * 4 +
                  2 * sizeof(uint8_t));
static_assert(sizeof(InlineQueue<uint16_t, 1>) ==
              sizeof(InlineQueue<uint16_t>::size_type) * 4 + sizeof(uint16_t));
static_assert(sizeof(InlineQueue<uint32_t, 1>) ==
              sizeof(InlineQueue<uint32_t>::size_type) * 4 + sizeof(uint32_t));
static_assert(sizeof(InlineQueue<uint64_t, 1>) ==
              sizeof(InlineQueue<uint64_t>::size_type) * 4 + sizeof(uint64_t));

// Test that InlineQueue<T> is copy assignable
static_assert(std::is_copy_assignable_v<InlineQueue<int>::iterator>);
static_assert(std::is_copy_assignable_v<InlineQueue<int, 4>::iterator>);

}  // namespace
}  // namespace pw::containers
