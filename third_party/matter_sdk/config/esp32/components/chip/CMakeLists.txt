#
#   Copyright (c) 2021 Project CHIP Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

# The compile flags written args.gn come from chip.c and chip.cpp.
# Any build specifications (include dirs, compile flags, definitions, etc)
# that is set in the component will be reflected in
# the output args.gn. By default, all components inherit build-level
# specifications stored as idf-build-properties as done in
# tools/cmake/build.cmake.
#
# Adding REQUIRES/PRIV_REQUIRES will also propagate the
# appropriate build specifications from the required component.
idf_build_get_property(idf_path IDF_PATH)

if(NOT CHIP_ROOT)
    get_filename_component(CHIP_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../../../.. REALPATH)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/ota-image.cmake)

set(CHIP_REQUIRE_COMPONENTS esp_eth freertos lwip bt mbedtls fatfs app_update console openthread nvs_flash spi_flash)

set(CHIP_DATA_MODEL_INTERFACE "disabled" CACHE STRING "Data model interface option to use: enabled or disabled")

if(NOT "${IDF_TARGET}" STREQUAL "esp32h2")
    list(APPEND CHIP_REQUIRE_COMPONENTS mdns)
endif()

if (NOT CMAKE_BUILD_EARLY_EXPANSION)
    if (CONFIG_COMPILER_OPTIMIZATION_ASSERTIONS_DISABLE)
        set(is_debug FALSE)
    else()
        set(is_debug TRUE)
    endif()
endif()

idf_component_register(SRCS chip.c chip.cpp
                       PRIV_REQUIRES ${CHIP_REQUIRE_COMPONENTS})

# Prepare initial args file (lacking compile flags)
# This will be saved as args.gn.in
set(chip_gn_args "import(\"//args.gni\")\n")

macro(chip_gn_arg_append arg val)
    string(APPEND chip_gn_args "${arg} = ${val}\n")
endmacro()

macro(chip_gn_arg_bool arg boolean)
    if (${boolean})
        string(APPEND chip_gn_args "${arg} = true\n")
    else()
        string(APPEND chip_gn_args "${arg} = false\n")
    endif()
endmacro()

if ("${CHIP_DATA_MODEL_INTERFACE}" STREQUAL "enabled")
    chip_gn_arg_append("chip_use_data_model_interface" "\"enabled\"")
else()
    chip_gn_arg_append("chip_use_data_model_interface" "\"disabled\"")
endif()

# ESP-IDF lets user set software version string by two ways:
# 1. Project's CMakeLists.txt file and 2. Config option
# It depends on CONFIG_APP_PROJECT_VER_FROM_CONFIG option
# So, below makes the same provision for software version number
if (CONFIG_APP_PROJECT_VER_FROM_CONFIG)
    chip_gn_arg_append("chip_config_software_version_number" ${CONFIG_DEVICE_SOFTWARE_VERSION_NUMBER})
elseif (DEFINED PROJECT_VER_NUMBER)
    chip_gn_arg_append("chip_config_software_version_number" ${PROJECT_VER_NUMBER})
else()
    chip_gn_arg_append("chip_config_software_version_number" 0)
endif()

chip_gn_arg_append("esp32_ar"              "\"${CMAKE_AR}\"")
chip_gn_arg_append("esp32_cc"              "\"${CMAKE_C_COMPILER}\"")
chip_gn_arg_append("esp32_cxx"             "\"${CMAKE_CXX_COMPILER}\"")
chip_gn_arg_append("esp32_cpu"             "\"esp32\"")
chip_gn_arg_bool("is_debug"                ${is_debug})

if (CONFIG_CHIP_CONFIG_IM_PRETTY_PRINT)
    chip_gn_arg_bool("enable_im_pretty_print" "true")
endif()

# Config the chip log level by IDF menuconfig
if (CONFIG_CHIP_LOG_DEFAULT_LEVEL GREATER_EQUAL 1)
    chip_gn_arg_bool  ("chip_error_logging" "true")
else()
    chip_gn_arg_bool  ("chip_error_logging" "false")
endif()

if (CONFIG_CHIP_LOG_DEFAULT_LEVEL GREATER_EQUAL 3)
    chip_gn_arg_bool  ("chip_progress_logging" "true")
else()
    chip_gn_arg_bool  ("chip_progress_logging" "false")
endif()

if (CONFIG_CHIP_LOG_DEFAULT_LEVEL GREATER_EQUAL 4)
    chip_gn_arg_bool  ("chip_detail_logging" "true")
else()
    chip_gn_arg_bool  ("chip_detail_logging" "false")
endif()

if (CONFIG_CHIP_LOG_DEFAULT_LEVEL GREATER_EQUAL 5)
    chip_gn_arg_bool  ("chip_automation_logging" "true")
else()
    chip_gn_arg_bool  ("chip_automation_logging" "false")
endif()

if(CONFIG_ENABLE_CHIPOBLE)
chip_gn_arg_append("chip_config_network_layer_ble"           "true")
else()
chip_gn_arg_append("chip_config_network_layer_ble"           "false")
endif()

if(CONFIG_DISABLE_IPV4)
    if(NOT CONFIG_LWIP_IPV4)
        chip_gn_arg_append("chip_inet_config_enable_ipv4"        "false")
    else()
	message(FATAL_ERROR "Please also disable config option CONFIG_LWIP_IPV4")
    endif()
endif()

if(CONFIG_DISABLE_READ_CLIENT)
    chip_gn_arg_append("chip_enable_read_client"             "false")
endif()

if(CHIP_CODEGEN_PREGEN_DIR)
    chip_gn_arg_append("chip_code_pre_generated_directory"  "\"${CHIP_CODEGEN_PREGEN_DIR}\"")
endif()

if(CONFIG_ENABLE_ICD_SERVER)
    chip_gn_arg_append("chip_enable_icd_server"               "true")
    if(CONFIG_ICD_REPORT_ON_ACTIVE_MODE)
        chip_gn_arg_append("chip_icd_report_on_active_mode"               "true")
    endif()
    if(CONFIG_ENABLE_ICD_LIT)
        chip_gn_arg_append("chip_enable_icd_lit"               "true")
        if(CONFIG_ENABLE_ICD_CIP)
            chip_gn_arg_append("chip_enable_icd_checkin"               "true")
        else()
            chip_gn_arg_append("chip_enable_icd_checkin"               "false")
        endif()
        if(CONFIG_ENABLE_ICD_USER_ACTIVE_MODE_TRIGGER)
            chip_gn_arg_append("chip_enable_icd_user_active_mode_trigger"               "true")
        else()
            chip_gn_arg_append("chip_enable_icd_user_active_mode_trigger"               "false")
        endif()
    endif()
endif()

if(CONFIG_ENABLE_PW_RPC)
    string(APPEND chip_gn_args "import(\"//build_overrides/pigweed.gni\")\n")
    chip_gn_arg_append("remove_default_configs"             "[\"//third_party/connectedhomeip/third_party/pigweed/repo/pw_build:toolchain_cpp_standard\"]")
    chip_gn_arg_append("chip_build_pw_rpc_lib"              "true")
    chip_gn_arg_append("pw_log_BACKEND"                     "\"//third_party/connectedhomeip/third_party/pigweed/repo/pw_log_basic\"")
    chip_gn_arg_append("pw_assert_BACKEND"                  "\"//third_party/connectedhomeip/third_party/pigweed/repo/pw_assert_log:check_backend\"")
    chip_gn_arg_append("pw_sys_io_BACKEND"                  "\"//third_party/connectedhomeip/examples/platform/esp32/pw_sys_io:pw_sys_io_esp32\"")
    chip_gn_arg_append("dir_pw_third_party_nanopb"          "\"//third_party/connectedhomeip/third_party/nanopb/repo\"")
    chip_gn_arg_append("pw_build_LINK_DEPS"                 "[\"\$dir_pw_assert:impl\", \"\$dir_pw_log:impl\"]")
    chip_gn_arg_append("pw_rpc_CONFIG"                      "\"//third_party/connectedhomeip/third_party/pigweed/repo/pw_rpc:disable_global_mutex\"")
endif()

if (CONFIG_BUILD_CHIP_TESTS)
    chip_gn_arg_bool("chip_build_tests"     "true")
endif()

if (CONFIG_IM_PRETTY_PRINT)
    chip_gn_arg_bool("enable_im_pretty_print"	"true")
endif()

if (NOT CONFIG_USE_MINIMAL_MDNS)
    chip_gn_arg_append("chip_mdns"                          "\"platform\"")
else()
    chip_gn_arg_append("chip_mdns"                          "\"minimal\"")
endif()

if (CONFIG_ENABLE_CHIP_SHELL)
    chip_gn_arg_append("chip_build_libshell"                "true")
endif()

if (CONFIG_ENABLE_CHIP_CONTROLLER_BUILD)
    chip_gn_arg_append("chip_build_controller"              "true")
endif()

if (CONFIG_ENABLE_WIFI_STATION OR CONFIG_ENABLE_WIFI_AP)
    chip_gn_arg_append("chip_enable_wifi"                       "true")
else()
    chip_gn_arg_append("chip_enable_wifi"                       "false")
endif()

if (CONFIG_ENABLE_CHIPOBLE)
    chip_gn_arg_append("chip_enable_chipoble"                "true")
endif()

if ((CONFIG_BT_ENABLED) AND (CONFIG_ENABLE_CHIPOBLE))
	if (CONFIG_BT_NIMBLE_ENABLED)
          chip_gn_arg_append("chip_bt_nimble_enabled"                "true")
        else()
          chip_gn_arg_append("chip_bt_bluedroid_enabled"                "true")
        endif()
endif()

if (CONFIG_ENABLE_PERSIST_SUBSCRIPTIONS)
    chip_gn_arg_append("chip_persist_subscriptions"                 "true")
else()
    chip_gn_arg_append("chip_persist_subscriptions"                 "false")
endif()

if (CONFIG_ENABLE_ESP32_BLE_CONTROLLER)
    chip_gn_arg_append("chip_enable_ble_controller"             "true")
endif()

if (CONFIG_ENABLE_ETHERNET_TELEMETRY)
    chip_gn_arg_append("chip_enable_ethernet"                   "true")
endif()

if (CONFIG_ENABLE_MATTER_OVER_THREAD)
    chip_gn_arg_append("chip_enable_openthread"                 "true")
    if (CONFIG_THREAD_NETWORK_COMMISSIONING_DRIVER)
        chip_gn_arg_append("chip_device_config_thread_network_endpoint_id" ${CONFIG_THREAD_NETWORK_ENDPOINT_ID})
    endif()
else()
    chip_gn_arg_append("chip_enable_openthread"                 "false")
endif()

if (CONFIG_OPENTHREAD_FTD)
    chip_gn_arg_append("chip_openthread_ftd"                    "true")
else()
    chip_gn_arg_append("chip_openthread_ftd"                    "false")
endif()

if (CONFIG_OPENTHREAD_BORDER_ROUTER)
    chip_gn_arg_append("chip_openthread_border_router"       "true")
else()
    chip_gn_arg_append("chip_openthread_border_router"       "false")
endif()

if (CONFIG_ENABLE_OTA_REQUESTOR)
    chip_gn_arg_append("chip_enable_ota_requestor"                 "true")
endif()

if (CONFIG_ENABLE_ACCESS_RESTRICTIONS)
    chip_gn_arg_append("chip_enable_access_restrictions"                 "true")
endif()

if (CONFIG_ENABLE_ROTATING_DEVICE_ID)
    chip_gn_arg_append("chip_enable_additional_data_advertising"   "true")
    chip_gn_arg_append("chip_enable_rotating_device_id"            "true")
endif()

if (CONFIG_ENABLE_ROUTE_HOOK)
    chip_gn_arg_append("chip_enable_route_hook"   "true")
endif()

if (CONFIG_CHIP_ENABLE_EXTERNAL_PLATFORM)
    chip_gn_arg_append("chip_device_platform"   "\"external\"")
    if (CONFIG_ENABLE_CHIP_SHELL)
        chip_gn_arg_append("chip_shell_platform"    "\"esp32\"")
    endif()
    chip_gn_arg_append("chip_platform_target"   "\"//${CONFIG_CHIP_EXTERNAL_PLATFORM_DIR}\"")
    chip_gn_arg_append("chip_external_platform_include_dir" "\"//${CONFIG_CHIP_EXTERNAL_PLATFORM_INCLUDE_DIR}\"")
endif()

# Set up CHIP project configuration file

if (CONFIG_CHIP_PROJECT_CONFIG)
    get_filename_component(CHIP_PROJECT_CONFIG
        ${CONFIG_CHIP_PROJECT_CONFIG}
        REALPATH
        BASE_DIR ${CMAKE_SOURCE_DIR}
    )
    set(CHIP_PROJECT_CONFIG "<${CHIP_PROJECT_CONFIG}>")
else()
    set(CHIP_PROJECT_CONFIG "")
endif()

if (CHIP_PROJECT_CONFIG)
    chip_gn_arg_append("chip_project_config_include" "\"${CHIP_PROJECT_CONFIG}\"")
    chip_gn_arg_append("chip_system_project_config_include" "\"${CHIP_PROJECT_CONFIG}\"")
endif()

if (CONFIG_ENABLE_ESP32_FACTORY_DATA_PROVIDER)
    chip_gn_arg_append("chip_use_transitional_commissionable_data_provider" "false")
    chip_gn_arg_append("chip_use_factory_data_provider"                     "true")
endif()

if (CONFIG_ENABLE_ESP32_DEVICE_INFO_PROVIDER)
    chip_gn_arg_append("chip_use_device_info_provider"                     "true")
endif()

if (CONFIG_SEC_CERT_DAC_PROVIDER)
    chip_gn_arg_append("chip_use_secure_cert_dac_provider"                 "true")
endif()

if (CONFIG_ENABLE_ESP_INSIGHTS_TRACE)
  chip_gn_arg_bool("matter_enable_tracing_support"  "true")
  chip_gn_arg_append("matter_trace_config" "\"${CHIP_ROOT}/src/tracing/esp32_trace:esp32_trace_tracing\"")
endif()

if (CONFIG_ENABLE_ESP_INSIGHTS_SYSTEM_STATS)
     chip_gn_arg_append("matter_enable_esp_insights_system_stats"            "true")
endif()

if (CONFIG_USE_ESP32_ECDSA_PERIPHERAL)
    chip_gn_arg_append("chip_use_esp32_ecdsa_peripheral" "true")
endif()

if (CONFIG_ENABLE_ESP_INSIGHTS_TRACE)
   target_include_directories(${COMPONENT_LIB} INTERFACE "${CHIP_ROOT}/src/tracing/esp32_trace/include")
endif()

set(args_gn_input "${CMAKE_CURRENT_BINARY_DIR}/args.gn.in")
file(GENERATE OUTPUT "${args_gn_input}" CONTENT "${chip_gn_args}")

# This generates the final args.in file to be fed to
# CHIP build using GN build system. The necessary compile_commands.json
# and args.gn.in input file should exist by the time this is invoked,
# since these requirements ar generated at the parent project's
# GENERATE phase.
idf_build_get_property(idf_ver IDF_VER)
set(filter_out "-DHAVE_CONFIG_H" "-DIDF_VER=\\\"${idf_ver}\\\"" )

# CMake adds config include dir relative to build directory.
# Make sure full path is given to CHIP build.
list(APPEND filter_out "-Iconfig")
idf_build_get_property(config_dir CONFIG_DIR)
target_compile_options(${COMPONENT_LIB} PRIVATE "-I${config_dir}")

if(filter_out)
    set(filter_arg "--filter-out=${filter_out}")
endif()

set(args_gn "${CMAKE_CURRENT_BINARY_DIR}/args.gn")
add_custom_command(OUTPUT "${args_gn}"
                   COMMAND ${python} 
                           ${CMAKE_CURRENT_LIST_DIR}/create_args_gn.py 
                           "${CMAKE_BINARY_DIR}"
                           "${idf_path}"
                           "${CMAKE_CURRENT_LIST_DIR}/chip.c"
                           "${CMAKE_CURRENT_LIST_DIR}/chip.cpp"
                           "${args_gn_input}"
                           "${args_gn}"
                           "${filter_arg}"
                   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                   DEPENDS "${CMAKE_BINARY_DIR}/compile_commands.json"
                   VERBATIM)

add_custom_target(args_gn DEPENDS "${args_gn}")

# CHIP build as an external project.
find_program(GN_EXECUTABLE gn)
if (${GN_EXECUTABLE} STREQUAL GN_EXECUTABLE-NOTFOUND)
    message(FATAL_ERROR "The 'gn' command was not found. Make sure you have GN installed."
                        "Or have followed necessary build preparations stated in BUILDING.md.")
endif()

set(GN_ROOT_TARGET ${CHIP_ROOT}/config/esp32)

set(chip_libraries "${CMAKE_CURRENT_BINARY_DIR}/lib/libCHIP.a")

if(CONFIG_ENABLE_PW_RPC)
  list(APPEND chip_libraries "${CMAKE_CURRENT_BINARY_DIR}/lib/libPwRpc.a")
endif()

if (CONFIG_ENABLE_ESP_INSIGHTS_TRACE)
  list(APPEND chip_libraries "${CMAKE_CURRENT_BINARY_DIR}/lib/libEsp32TracingBackend.a")
endif()

# When using the pregenerated files, there is a edge case where an error appears for
# undeclared argument chip_code_pre_generated_directory. To get around with it we are
# disabling the --fail-on-unused-args flag.
# For more, see: https://github.com/project-chip/connectedhomeip/issues/27636
if (CHIP_CODEGEN_PREGEN_DIR)
    set(GN_CONFIGURE_COMMAND ${GN_EXECUTABLE} --root=${GN_ROOT_TARGET} gen --check ${CMAKE_CURRENT_BINARY_DIR})
else ()
    set(GN_CONFIGURE_COMMAND ${GN_EXECUTABLE} --root=${GN_ROOT_TARGET} gen --check --fail-on-unused-args ${CMAKE_CURRENT_BINARY_DIR})
endif ()

externalproject_add(
    chip_gn
    SOURCE_DIR              ${CHIP_ROOT}
    BINARY_DIR              ${CMAKE_CURRENT_BINARY_DIR}
    CONFIGURE_COMMAND       ${GN_CONFIGURE_COMMAND}
    BUILD_COMMAND           ninja "esp32"
    INSTALL_COMMAND         ""
    BUILD_BYPRODUCTS        ${chip_libraries}
    DEPENDS                 args_gn
    BUILD_ALWAYS            1
)

idf_component_get_property(freertos_dir freertos COMPONENT_DIR)

# ESP-IDF components usually need 'freertos/<header.h>', while
# CHIP might include do 'header.h'.
# In IDF V5.0, this path has been moved to
# '${freertos_component}/FreeRTOS-Kernel/include/freertos'
target_include_directories(${COMPONENT_LIB} PRIVATE
    "${freertos_dir}/include/freertos"
    "${freertos_dir}/FreeRTOS-Kernel/include/freertos")

target_include_directories(${COMPONENT_LIB} INTERFACE
    "${CHIP_ROOT}/src/platform/ESP32"
    "${CHIP_ROOT}/src/platform/OpenThread"
    "${CHIP_ROOT}/src/include"
    "${CHIP_ROOT}/src/lib"
    "${CHIP_ROOT}/src"
    "${CHIP_ROOT}/zzz_generated/app-common"
    "${CHIP_ROOT}/examples/platform/esp32"
    "${CHIP_ROOT}/third_party/nlassert/repo/include"
    "${CHIP_ROOT}/third_party/nlio/repo/include"
    "${CMAKE_CURRENT_BINARY_DIR}/src/include"
    "${CMAKE_CURRENT_BINARY_DIR}/include"
    "${CMAKE_CURRENT_BINARY_DIR}/gen/include"
    "${CHIP_ROOT}/config/esp32/${CONFIG_CHIP_EXTERNAL_PLATFORM_DIR}"
    "${CHIP_ROOT}/config/esp32/${CONFIG_CHIP_EXTERNAL_PLATFORM_DIR}/../../"
)

idf_component_get_property(mbedtls_lib mbedtls COMPONENT_LIB)

idf_build_get_property(idf_target IDF_TARGET)
set(target_name "${idf_target}")

if(CONFIG_BT_ENABLED)
    idf_component_get_property(bt_lib bt COMPONENT_LIB)
    if((target_name STREQUAL "esp32h2") OR (target_name STREQUAL "esp32c2") OR (target_name STREQUAL "esp32c6"))
        idf_component_get_property(bt_dir bt COMPONENT_DIR)
        list(APPEND chip_libraries $<TARGET_FILE:${bt_lib}>)
        if (EXISTS ${bt_dir}/controller/lib_${target_name}/${target_name}-bt-lib/libble_app.a)
            list(APPEND chip_libraries "${bt_dir}/controller/lib_${target_name}/${target_name}-bt-lib/libble_app.a")
        elseif(EXISTS ${bt_dir}/controller/lib_${target_name}/${target_name}-bt-lib/${target_name}/libble_app.a)
            list(APPEND chip_libraries "${bt_dir}/controller/lib_${target_name}/${target_name}-bt-lib/${target_name}/libble_app.a")
	else()
            message(WARNING "There is no libble_app.a in the given path")
        endif()
    elseif(target_name STREQUAL "esp32p4")
        list(APPEND chip_libraries $<TARGET_FILE:${bt_lib}>)
    else()
        list(APPEND chip_libraries $<TARGET_FILE:${bt_lib}> -lbtdm_app)
    endif()
endif()

if (CONFIG_ENABLE_CHIP_SHELL)
    idf_component_get_property(console_lib console COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${console_lib}>)
endif()

if(CONFIG_OPENTHREAD_ENABLED)
    idf_component_get_property(openthread_lib openthread COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${openthread_lib}>)
    if (CONFIG_IEEE802154_ENABLED)
        idf_component_get_property(ieee802154_lib ieee802154 COMPONENT_LIB)
        list(APPEND chip_libraries $<TARGET_FILE:${ieee802154_lib}>)
    endif()
endif()

if(NOT CONFIG_USE_MINIMAL_MDNS)
    idf_build_get_property(build_components BUILD_COMPONENTS)
    # For IDF v5.x, the mdns component was moved to idf_managed_components.
    # We should use 'espressif__mdns' for 'idf_component_get_property'.
    if("espressif__mdns" IN_LIST build_components)
        idf_component_get_property(mdns_lib espressif__mdns COMPONENT_LIB)
        list(APPEND chip_libraries $<TARGET_FILE:${mdns_lib}>)
    elseif("mdns" IN_LIST build_components)
        idf_component_get_property(mdns_lib mdns COMPONENT_LIB)
        list(APPEND chip_libraries $<TARGET_FILE:${mdns_lib}>)
    endif()
endif()

if(CONFIG_OPENTHREAD_BORDER_ROUTER)
    idf_component_get_property(rcp_update_lib espressif__esp_rcp_update COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${rcp_update_lib}>)
    idf_component_get_property(serial_flasher_lib espressif__esp-serial-flasher COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${serial_flasher_lib}>)
endif()

if (CONFIG_ENABLE_ENCRYPTED_OTA)
    idf_component_get_property(esp_encrypted_img_lib espressif__esp_encrypted_img COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${esp_encrypted_img_lib}>)
endif()

# Let user set EXECUTABLE_COMPONENT_NAME and defaults to main if not specified
if (NOT EXECUTABLE_COMPONENT_NAME)
  set(EXECUTABLE_COMPONENT_NAME "main")
endif()

if (CONFIG_ENABLE_DELTA_OTA)
    idf_component_get_property(esp_delta_ota_lib espressif__esp_delta_ota COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${esp_delta_ota_lib}>)
endif()

idf_component_get_property(main_lib ${EXECUTABLE_COMPONENT_NAME} COMPONENT_LIB)
list(APPEND chip_libraries $<TARGET_FILE:${main_lib}>)

if (CONFIG_SEC_CERT_DAC_PROVIDER)
    idf_component_get_property(esp32_secure_cert_mgr_lib espressif__esp_secure_cert_mgr COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${esp32_secure_cert_mgr_lib}>)
endif()

if (CONFIG_ENABLE_ESP_INSIGHTS_TRACE)
    idf_build_get_property(build_components BUILD_COMPONENTS)
    # esp_insights can be used as an independent component or through component manager so,
    # We should check and add the right component.
    if("espressif__esp_insights" IN_LIST build_components)
        idf_component_get_property(esp_insights_lib espressif__esp_insights COMPONENT_LIB)
    elseif("esp_insights" IN_LIST build_components)
        idf_component_get_property(esp_insights_lib esp_insights COMPONENT_LIB)
    endif()

    list(APPEND chip_libraries $<TARGET_FILE:${esp_insights_lib}>)
endif()

idf_component_get_property(lwip_lib lwip COMPONENT_LIB)
list(APPEND chip_libraries $<TARGET_FILE:${lwip_lib}>)

if (CONFIG_ESP32_WIFI_ENABLED OR CONFIG_IDF_TARGET_ESP32P4)
    idf_component_get_property(esp_wifi_lib esp_wifi COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${esp_wifi_lib}>)
endif()
if (CONFIG_ESP32_WIFI_ENABLED)
    idf_component_get_property(esp_wifi_dir esp_wifi COMPONENT_DIR)
    if (CONFIG_IDF_TARGET_ESP32C2)
        set(blobs core net80211 pp)
    else()
        set(blobs core mesh net80211 pp)
    endif()

    foreach(blob ${blobs})
    list(APPEND chip_libraries "${esp_wifi_dir}/lib/${target_name}/lib${blob}.a")
    endforeach()

    idf_component_get_property(wpa_supplicant_lib wpa_supplicant COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${wpa_supplicant_lib}>)
endif()

if (CONFIG_ETH_ENABLED)
    idf_component_get_property(esp_eth_lib esp_eth COMPONENT_LIB)
    list(APPEND chip_libraries $<TARGET_FILE:${esp_eth_lib}>)
endif()

idf_component_get_property(esp_netif_lib esp_netif COMPONENT_LIB)
list(APPEND chip_libraries $<TARGET_FILE:${esp_netif_lib}>)

idf_component_get_property(esp_hw_support_lib esp_hw_support COMPONENT_LIB)
list(APPEND chip_libraries $<TARGET_FILE:${esp_hw_support_lib}>)

if (NOT CONFIG_IDF_TARGET_ESP32P4)
idf_component_get_property(esp_phy_lib esp_phy COMPONENT_LIB)
idf_component_get_property(esp_phy_dir esp_phy COMPONENT_DIR)
list(APPEND chip_libraries $<TARGET_FILE:${esp_phy_lib}>)

if (CONFIG_IDF_TARGET_ESP32)
    set(phy_blobs phy rtc)
elseif (CONFIG_IDF_TARGET_ESP32S2)
    set(phy_blobs phy)
else()
    set(phy_blobs phy btbb)
endif()
foreach(phy_blob ${phy_blobs})
    list(APPEND chip_libraries "${esp_phy_dir}/lib/${target_name}/lib${phy_blob}.a")
endforeach()
endif()

set(components_to_link esp_event hal esp_system soc efuse vfs driver freertos esp_timer)
if (NOT CONFIG_IDF_TARGET_ESP32P4)
list(APPEND components_to_link esp_coex)
endif()
idf_build_get_property(build_components BUILD_COMPONENTS)
foreach(component ${components_to_link})
    # Some of the components are not present in IDF v4.x
    # So, Check if the component is in the list of build components
    if("${component}" IN_LIST build_components)
        idf_component_get_property(lib_name ${component} COMPONENT_LIB)
        list(APPEND chip_libraries $<TARGET_FILE:${lib_name}>)
    endif()
endforeach()

target_link_libraries(${COMPONENT_LIB} INTERFACE -Wl,--start-group
                                                ${chip_libraries}
                                                $<TARGET_FILE:mbedcrypto> $<TARGET_FILE:mbedx509>
                                                $<TARGET_FILE:${mbedtls_lib}>
                                                -Wl,--end-group)

# Make the component dependent on our CHIP build
add_dependencies(${COMPONENT_LIB} chip_gn)

if(CONFIG_ENABLE_PW_RPC)
    set(WRAP_FUNCTIONS esp_log_write esp_log_writev)
    foreach(func ${WRAP_FUNCTIONS})
        target_link_libraries(${COMPONENT_LIB} INTERFACE "-Wl,--wrap=${func}")
    endforeach()
endif()

# Build Matter OTA image
if (CONFIG_CHIP_OTA_IMAGE_BUILD)
    chip_ota_image(chip-ota-image
        INPUT_FILES ${BUILD_DIR}/${CMAKE_PROJECT_NAME}.bin
        OUTPUT_FILE ${BUILD_DIR}/${CMAKE_PROJECT_NAME}-ota.bin
    )
    # Adding dependecy as app target so that this runs after images are ready
    add_dependencies(chip-ota-image app)
endif()
