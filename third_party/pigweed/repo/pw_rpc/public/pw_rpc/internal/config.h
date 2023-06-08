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

// Configuration macros for the pw_rpc module.
#pragma once

#include <cstddef>
#include <type_traits>

#if defined(PW_RPC_CLIENT_STREAM_END_CALLBACK) && \
    PW_RPC_CLIENT_STREAM_END_CALLBACK
#pragma message(                                                \
    "Warning PW_RPC_CLIENT_STREAM_END_CALLBACK is deprecated! " \
    "Use PW_RPC_COMPLETION_REQUEST_CALLBACK instead.")
#define PW_RPC_COMPLETION_REQUEST_CALLBACK 1
#endif

#undef PW_RPC_CLIENT_STREAM_END_CALLBACK

/// pw_rpc clients may request call completion by sending
/// `CLIENT_REQUEST_COMPLETION` packet. For client streaming or bi-direction
/// RPCs, this also indicates that the client is done sending requests. While
/// this can be useful in some circumstances, it is often not necessary.
///
/// This option controls whether or not include a callback that is called when
/// the client stream requests for completion. The callback is included in all
/// ServerReader/Writer objects as a @cpp_type{pw::Function}, so may have a
/// significant cost.
///
/// This is disabled by default.
#ifndef PW_RPC_COMPLETION_REQUEST_CALLBACK
#define PW_RPC_COMPLETION_REQUEST_CALLBACK 0
#endif  // PW_RPC_COMPLETION_REQUEST_CALLBACK

/// The Nanopb-based pw_rpc implementation allocates memory to use for Nanopb
/// structs for the request and response protobufs. The template function that
/// allocates these structs rounds struct sizes up to this value so that
/// different structs can be allocated with the same function. Structs with
/// sizes larger than this value cause an extra function to be created, which
/// slightly increases code size.
///
/// Ideally, this value will be set to the size of the largest Nanopb struct
/// used as an RPC request or response. The buffer can be stack or globally
/// allocated (see @c_macro{PW_RPC_NANOPB_STRUCT_BUFFER_STACK_ALLOCATE}).
///
/// This defaults to 64 bytes.
#ifndef PW_RPC_NANOPB_STRUCT_MIN_BUFFER_SIZE
#define PW_RPC_NANOPB_STRUCT_MIN_BUFFER_SIZE 64
#endif  // PW_RPC_NANOPB_STRUCT_MIN_BUFFER_SIZE

/// Enable global synchronization for RPC calls. If this is set, a backend must
/// be configured for pw_sync:mutex.
///
/// This is enabled by default.
#ifndef PW_RPC_USE_GLOBAL_MUTEX
#define PW_RPC_USE_GLOBAL_MUTEX 1
#endif  // PW_RPC_USE_GLOBAL_MUTEX

/// pw_rpc must yield the current thread when waiting for a callback to complete
/// in a different thread. PW_RPC_YIELD_MODE determines how to yield. There are
/// three supported settings:
///
///   - @c_macro{PW_RPC_YIELD_MODE_BUSY_LOOP} - Do nothing. Release and
///     reacquire the RPC lock in a busy loop. @c_macro{PW_RPC_USE_GLOBAL_MUTEX}
///     must be 0.
///   - @c_macro{PW_RPC_YIELD_MODE_SLEEP} - Yield with 1-tick calls to
///     @cpp_func{pw::this_thread::sleep_for()}. A backend must be configured
///     for pw_thread:sleep.
///   - @c_macro{PW_RPC_YIELD_MODE_YIELD} - Yield with
///     @cpp_func{pw::this_thread::yield()}. A backend must be configured for
///     pw_thread:yield. IMPORTANT: On some platforms,
///     @cpp_func{pw::this_thread::yield()} does not yield to lower priority
///     tasks and should not be used here.
///
#ifndef PW_RPC_YIELD_MODE
#if PW_RPC_USE_GLOBAL_MUTEX == 0
#define PW_RPC_YIELD_MODE PW_RPC_YIELD_MODE_BUSY_LOOP
#else
#define PW_RPC_YIELD_MODE PW_RPC_YIELD_MODE_SLEEP
#endif  // PW_RPC_USE_GLOBAL_MUTEX == 0
#endif  // PW_RPC_YIELD_MODE

/// @def PW_RPC_YIELD_MODE_BUSY_LOOP
/// @def PW_RPC_YIELD_MODE_SLEEP
/// @def PW_RPC_YIELD_MODE_YIELD
///
/// Supported configuration values for @c_macro{PW_RPC_YIELD_MODE}.
#define PW_RPC_YIELD_MODE_BUSY_LOOP 100
#define PW_RPC_YIELD_MODE_SLEEP 101
#define PW_RPC_YIELD_MODE_YIELD 102

/// If `PW_RPC_YIELD_MODE == PW_RPC_YIELD_MODE_SLEEP`,
/// `PW_RPC_YIELD_SLEEP_DURATION` sets how long to sleep during each iteration
/// of the yield loop. The value must be a constant expression that converts to
/// a @cpp_type{pw::chrono::SystemClock::duration}.
#ifndef PW_RPC_YIELD_SLEEP_DURATION

// When building for a desktop operating system, use a 1ms sleep by default.
// 1-tick duration sleeps can result in spurious timeouts.
#if defined(_WIN32) || defined(__APPLE__) || \
    defined(__linux__) && !defined(__ZEPHYR__)
#define PW_RPC_YIELD_SLEEP_DURATION std::chrono::milliseconds(1)
#else
#define PW_RPC_YIELD_SLEEP_DURATION pw::chrono::SystemClock::duration(1)
#endif  // defined(_WIN32) || defined(__APPLE__) || defined(__linux__)
        // && !defined(__ZEPHYR__)

#endif  // PW_RPC_YIELD_SLEEP_DURATION

// PW_RPC_YIELD_SLEEP_DURATION is not needed for non-sleep yield modes.
#if PW_RPC_YIELD_MODE != PW_RPC_YIELD_MODE_SLEEP
#undef PW_RPC_YIELD_SLEEP_DURATION
#endif  // PW_RPC_YIELD_MODE != PW_RPC_YIELD_MODE_SLEEP

/// pw_rpc call objects wait for their callbacks to complete before they are
/// moved or destoyed. Deadlocks occur if a callback:
///
///   - attempts to destroy its call object,
///   - attempts to move its call object while the call is still active, or
///   - never returns.
///
/// If `PW_RPC_CALLBACK_TIMEOUT_TICKS` is greater than 0, then `PW_CRASH` is
/// invoked if a thread waits for an RPC callback to complete for more than the
/// specified tick count.
///
/// A "tick" in this context is one iteration of a loop that yields releases the
/// RPC lock and yields the thread according to @c_macro{PW_RPC_YIELD_MODE}. By
/// default, the thread yields with a 1-tick call to
/// @cpp_func{pw::this_thread::sleep_for()}.
#ifndef PW_RPC_CALLBACK_TIMEOUT_TICKS
#define PW_RPC_CALLBACK_TIMEOUT_TICKS 10000
#endif  // PW_RPC_CALLBACK_TIMEOUT_TICKS

/// Whether pw_rpc should use dynamic memory allocation internally. If enabled,
/// pw_rpc dynamically allocates channels and its encoding buffer. RPC users may
/// use dynamic allocation independently of this option (e.g. to allocate pw_rpc
/// call objects).
///
/// The semantics for allocating and initializing channels change depending on
/// this option. If dynamic allocation is disabled, pw_rpc endpoints (servers or
/// clients) use an externally-allocated, fixed-size array of channels.  That
/// array must include unassigned channels or existing channels must be closed
/// to add new channels.
///
/// If dynamic allocation is enabled, an span of channels may be passed to the
/// endpoint at construction, but these channels are only used to initialize its
/// internal channels container. External channel objects are NOT used by the
/// endpoint and cannot be updated if dynamic allocation is enabled. No
/// unassigned channels should be passed to the endpoint; they will be ignored.
/// Any number of channels may be added to the endpoint, without closing
/// existing channels, but adding channels will use more memory.
#ifndef PW_RPC_DYNAMIC_ALLOCATION
#define PW_RPC_DYNAMIC_ALLOCATION 0
#endif  // PW_RPC_DYNAMIC_ALLOCATION

#if defined(PW_RPC_DYNAMIC_CONTAINER) || \
    defined(PW_RPC_DYNAMIC_CONTAINER_INCLUDE)
static_assert(
    PW_RPC_DYNAMIC_ALLOCATION == 1,
    "PW_RPC_DYNAMIC_ALLOCATION is disabled, so PW_RPC_DYNAMIC_CONTAINER and "
    "PW_RPC_DYNAMIC_CONTAINER_INCLUDE have no effect and should not be set.");
#endif  // PW_RPC_DYNAMIC_CONTAINER || PW_RPC_DYNAMIC_CONTAINER_INCLUDE

/// If @c_macro{PW_RPC_DYNAMIC_ALLOCATION} is enabled, this macro must expand to
/// a container capable of storing objects of the provided type. This container
/// will be used internally by pw_rpc to allocate the channels list and encoding
/// buffer. Defaults to `std::vector<type>`, but may be set to any type that
/// supports the following `std::vector` operations:
///
///   - Default construction
///   - `emplace_back()`
///   - `pop_back()`
///   - `back()`
///   - `resize()`
///   - `clear()`
///   - Range-based for loop iteration (`begin()`, `end()`)
///
#ifndef PW_RPC_DYNAMIC_CONTAINER
#define PW_RPC_DYNAMIC_CONTAINER(type) std::vector<type>
#endif  // PW_RPC_DYNAMIC_CONTAINER

/// If @c_macro{PW_RPC_DYNAMIC_ALLOCATION} is enabled, this header file is
/// included in files that use @c_macro{PW_RPC_DYNAMIC_CONTAINER}. Defaults to
/// `<vector>`, but may be set in conjunction with
/// @c_macro{PW_RPC_DYNAMIC_CONTAINER} to use a different container type for
/// dynamic allocations in pw_rpc.
#ifndef PW_RPC_DYNAMIC_CONTAINER_INCLUDE
#define PW_RPC_DYNAMIC_CONTAINER_INCLUDE <vector>
#endif  // PW_RPC_DYNAMIC_CONTAINER_INCLUDE

/// Size of the global RPC packet encoding buffer in bytes. If dynamic
/// allocation is enabled, this value is only used for test helpers that
/// allocate RPC encoding buffers.
#ifndef PW_RPC_ENCODING_BUFFER_SIZE_BYTES
#define PW_RPC_ENCODING_BUFFER_SIZE_BYTES 512
#endif  // PW_RPC_ENCODING_BUFFER_SIZE_BYTES

/// The log level to use for this module. Logs below this level are omitted.
#ifndef PW_RPC_CONFIG_LOG_LEVEL
#define PW_RPC_CONFIG_LOG_LEVEL PW_LOG_LEVEL_INFO
#endif  // PW_RPC_CONFIG_LOG_LEVEL

/// The log module name to use for this module.
#ifndef PW_RPC_CONFIG_LOG_MODULE_NAME
#define PW_RPC_CONFIG_LOG_MODULE_NAME "PW_RPC"
#endif  // PW_RPC_CONFIG_LOG_MODULE_NAME

namespace pw::rpc::cfg {

template <typename...>
constexpr std::bool_constant<PW_RPC_COMPLETION_REQUEST_CALLBACK>
    kClientStreamEndCallbackEnabled;

template <typename...>
constexpr std::bool_constant<PW_RPC_DYNAMIC_ALLOCATION>
    kDynamicAllocationEnabled;

inline constexpr size_t kNanopbStructMinBufferSize =
    PW_RPC_NANOPB_STRUCT_MIN_BUFFER_SIZE;

inline constexpr size_t kEncodingBufferSizeBytes =
    PW_RPC_ENCODING_BUFFER_SIZE_BYTES;

#undef PW_RPC_NANOPB_STRUCT_MIN_BUFFER_SIZE
#undef PW_RPC_ENCODING_BUFFER_SIZE_BYTES

}  // namespace pw::rpc::cfg

/// This option determines whether to allocate the Nanopb structs on the stack
/// or in a global variable. Globally allocated structs are NOT thread safe, but
/// work fine when the RPC server's ProcessPacket function is only called from
/// one thread.
#ifndef PW_RPC_NANOPB_STRUCT_BUFFER_STACK_ALLOCATE
#define PW_RPC_NANOPB_STRUCT_BUFFER_STACK_ALLOCATE 1
#endif  // PW_RPC_NANOPB_STRUCT_BUFFER_STACK_ALLOCATE

/// @private Internal macro for declaring the Nanopb struct; do not use.
#if PW_RPC_NANOPB_STRUCT_BUFFER_STACK_ALLOCATE
#define _PW_RPC_NANOPB_STRUCT_STORAGE_CLASS
#else
#define _PW_RPC_NANOPB_STRUCT_STORAGE_CLASS static
#endif  // PW_RPC_NANOPB_STRUCT_BUFFER_STACK_ALLOCATE

#undef PW_RPC_NANOPB_STRUCT_BUFFER_STACK_ALLOCATE
