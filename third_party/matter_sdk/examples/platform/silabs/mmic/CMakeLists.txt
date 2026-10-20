cmake_minimum_required(VERSION 3.13)
project(mmic_host C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Default to a Debug build (with -g, no optimization) so the binary is
# immediately usable under gdb / lldb. Override with -DCMAKE_BUILD_TYPE=Release.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
endif()

if(NOT (CMAKE_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_SYSTEM_NAME STREQUAL "Darwin"))
    message(FATAL_ERROR "mmic host build only supports Linux and macOS (got ${CMAKE_SYSTEM_NAME}).")
endif()

# Transport selection.
#
# By default the host talks to the device over a UART. Pass
#   -DMMIC_USE_CPC=ON
# on the CMake command line to instead use Silicon Labs CPC (Co-Processor
# Communication) via libcpc, opening endpoint 90 on the running cpcd instance.
option(MMIC_USE_CPC "Use Silicon Labs CPC (endpoint 90) instead of UART" OFF)

option(MMIC_BUILD_TESTS "Build mmic host-side tests" ON)

find_package(Threads REQUIRED)
find_package(OpenSSL REQUIRED)

# Shared sources used by both mmic_host and the test binaries. Exposed as an
# OBJECT library so tests can reuse them without recompiling.
add_library(mmic_core OBJECT
    mmic.cpp
    chip_tool_storage.cpp
    matter_cert_issuer.cpp
)
target_include_directories(mmic_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_options(mmic_core PRIVATE -Wall -Wextra)
target_link_libraries(mmic_core PUBLIC Threads::Threads OpenSSL::Crypto)

add_executable(mmic_host host_main.cpp)
target_include_directories(mmic_host PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_options(mmic_host PRIVATE -Wall -Wextra)
target_link_libraries(mmic_host PRIVATE mmic_core)

if(MMIC_USE_CPC)
    find_path(CPC_INCLUDE_DIR NAMES sl_cpc.h)
    find_library(CPC_LIBRARY NAMES cpc)
    if(NOT CPC_INCLUDE_DIR OR NOT CPC_LIBRARY)
        message(FATAL_ERROR
            "MMIC_USE_CPC=ON but libcpc / sl_cpc.h were not found. "
            "Install the Silicon Labs CPC daemon (cpcd) development files, "
            "or point the build at them with -DCPC_INCLUDE_DIR=... "
            "-DCPC_LIBRARY=...")
    endif()
    message(STATUS "mmic_host: CPC transport enabled (endpoint 90)")
    message(STATUS "  CPC_INCLUDE_DIR = ${CPC_INCLUDE_DIR}")
    message(STATUS "  CPC_LIBRARY     = ${CPC_LIBRARY}")
    target_compile_definitions(mmic_host PRIVATE MMIC_USE_CPC=1)
    target_include_directories(mmic_host PRIVATE ${CPC_INCLUDE_DIR})
    target_link_libraries(mmic_host PRIVATE ${CPC_LIBRARY})
else()
    message(STATUS "mmic_host: UART transport enabled (default)")
endif()

# Emit full DWARF debug info and disable frame-pointer omission so backtraces
# in gdb / lldb are reliable, regardless of build type.
target_compile_options(mmic_host PRIVATE
    $<$<CONFIG:Debug>:-O0 -g3 -ggdb -fno-omit-frame-pointer>
    $<$<CONFIG:RelWithDebInfo>:-g3 -ggdb -fno-omit-frame-pointer>
)

# Ensure the linker keeps debug sections (mainly relevant on some toolchains).
target_link_options(mmic_host PRIVATE
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:RelWithDebInfo>:-g>
)

target_link_libraries(mmic_host PRIVATE Threads::Threads OpenSSL::Crypto)

if(MMIC_BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()
