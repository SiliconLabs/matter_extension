####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH ?= /git/gsdk
UNAME:=$(shell $(POSIX_TOOL_PATH)uname -s | $(POSIX_TOOL_PATH)sed -e 's/^\(CYGWIN\).*/\1/' | $(POSIX_TOOL_PATH)sed -e 's/^\(MINGW\).*/\1/')
ifeq ($(UNAME),MINGW)
# Translate "C:/super" into "/C/super" for MinGW make.
SDK_PATH := /$(shell $(POSIX_TOOL_PATH)echo $(BASE_SDK_PATH) | sed s/://)
endif
SDK_PATH ?= $(BASE_SDK_PATH)
COPIED_SDK_PATH ?= simplicity_sdk_2024.6.0

# This uses the explicit build rules below
PROJECT_SOURCE_FILES =

C_SOURCE_FILES   += $(filter %.c, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cpp, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cc, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.s, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.S, $(PROJECT_SOURCE_FILES))
LIB_FILES        += $(filter %.a, $(PROJECT_SOURCE_FILES))

C_DEFS += \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DDEBUG_EFM=1' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-mbedtls-config.h"' \
 '-DNVM3_LOCK_OVERRIDE=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_MBEDTLS_USE_TINYCRYPT=1' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DSL_PROVISION_GENERATOR=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_EXTERNAL_LDO_FOR_PSRAM=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4338A"' \
 '-DSL_BOARD_REV="A07"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DCLOCK_ROMDRIVER_PRESENT=1' \
 '-DULPSS_CLOCK_ROMDRIVER_PRESENT=1' \
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DCRC_ROMDRIVER_PRESENT=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DDEBUG_ENABLE=1' \
 '-DDEBUG_UART=1' \
 '-DENABLE_DEBUG_MODULE=1' \
 '-DFLASH_PAGE_SIZE=4096' \
 '-DSLI_MULTITHREAD_DEVICE_SI91X=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DPLL_ROMDRIVER_PRESENT=1' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"' \
 '-DSL_CODE_COMPONENT_CORE=core'

ASM_DEFS += \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DDEBUG_EFM=1' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-mbedtls-config.h"' \
 '-DNVM3_LOCK_OVERRIDE=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_MBEDTLS_USE_TINYCRYPT=1' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DSL_PROVISION_GENERATOR=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_EXTERNAL_LDO_FOR_PSRAM=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4338A"' \
 '-DSL_BOARD_REV="A07"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DCLOCK_ROMDRIVER_PRESENT=1' \
 '-DULPSS_CLOCK_ROMDRIVER_PRESENT=1' \
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DCRC_ROMDRIVER_PRESENT=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DDEBUG_ENABLE=1' \
 '-DDEBUG_UART=1' \
 '-DENABLE_DEBUG_MODULE=1' \
 '-DFLASH_PAGE_SIZE=4096' \
 '-DSLI_MULTITHREAD_DEVICE_SI91X=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DPLL_ROMDRIVER_PRESENT=1' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"' \
 '-DSL_CODE_COMPONENT_CORE=core'

INCLUDES += \
 -Iconfig \
 -Iautogen \
 -I../../generator \
 -I$(SDK_PATH)/../../../examples \
 -I$(SDK_PATH)/../../../examples/platform/silabs \
 -I$(SDK_PATH)/../../../src \
 -I$(SDK_PATH)/../../../src/platform/silabs/SiWx917 \
 -I$(SDK_PATH)/../../../src/include \
 -I$(SDK_PATH)/../../../zzz_generated/app-common \
 -I$(SDK_PATH)/../../nlassert/repo/include \
 -I$(SDK_PATH)/../../nlio/repo/include \
 -I$(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/inc \
 -I$(SDK_PATH)/../../mbedtls/repo/library \
 -I$(SDK_PATH)/../../mbedtls/repo/include \
 -I$(SDK_PATH)/../../../src/lib/support \
 -I$(SDK_PATH)/../../../src/platform/silabs \
 -I$(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/inc \
 -I$(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/config \
 -I$(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/autogen \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config \
 -I$(SDK_PATH)/../wifi_sdk/components/service/bsd_socket/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/CMSIS/Driver/Include \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver \
 -I$(SDK_PATH)/../wifi_sdk/components/service/network_manager/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/rom_driver/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/board/silabs/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/config \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/common/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/multithread/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/errno/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/icmp \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/trng/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/protocol/wifi/inc \
 -I$(SDK_PATH)/../wifi_sdk/resources/certificates \
 -I$(SDK_PATH)/../wifi_sdk/resources/html \
 -I$(SDK_PATH)/../wifi_sdk/resources/other \
 -I$(SDK_PATH)/../wifi_sdk/components/common/inc \
 -I$(SDK_PATH)/platform/common/inc \
 -I$(SDK_PATH)/platform/CMSIS/Core/Include \
 -I$(SDK_PATH)/platform/CMSIS/RTOS2/Include \
 -I$(SDK_PATH)/platform/service/device_init/inc \
 -I$(SDK_PATH)/platform/emdrv/common/inc \
 -I$(SDK_PATH)/platform/emlib/inc \
 -I$(SDK_PATH)/util/third_party/freertos/cmsis/Include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F \
 -I$(SDK_PATH)/platform/service/iostream/inc \
 -I$(SDK_PATH)/platform/emdrv/nvm3/inc \
 -I$(SDK_PATH)/util/third_party/segger/systemview/SEGGER \
 -I$(SDK_PATH)/platform/service/system/inc

GROUP_START =-Wl,--start-group
GROUP_END =-Wl,--end-group

PROJECT_LIBS = \
 -lgcc \
 -lnosys \
 -lstdc++ \
 -lc \
 -lm \
 $(SDK_PATH)/platform/emdrv/nvm3/lib/libnvm3_CM4_gcc.a

LIBS += $(GROUP_START) $(PROJECT_LIBS) $(GROUP_END)

LIB_FILES += $(filter %.a, $(PROJECT_LIBS))

C_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -std=c18 \
 -Wall \
 -Wextra \
 -Og \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -Wno-unused-parameter \
 -mcpu=cortex-m4 \
 --specs=nano.specs \
 -g

CXX_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -std=c++17 \
 -fno-rtti \
 -fno-exceptions \
 -Wall \
 -Wextra \
 -Og \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -Wno-unused-parameter \
 -mcpu=cortex-m4 \
 --specs=nano.specs \
 -g

ASM_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -x assembler-with-cpp

LD_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -T"autogen/linkerfile_SoC.ld" \
 --specs=nano.specs \
 -Xlinker -Map=$(OUTPUT_DIR)/$(PROJECTNAME).map \
 -u _printf_float \
 -Wl,--gc-sections \
 -Wl,--no-warn-rwx-segments


####################################################################
# Pre/Post Build Rules                                             #
####################################################################
pre-build:
	# No pre-build defined

post-build: $(OUTPUT_DIR)/$(PROJECTNAME).out
	# No post-build defined

####################################################################
# SDK Build Rules                                                  #
####################################################################
$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionEncoder.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionManager.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionManager.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionManager.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionManager.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionManager.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionManager.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageFlash.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageFlash.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageFlash.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageFlash.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageFlash.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageFlash.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/syscalls_stubs.o: $(SDK_PATH)/../../../examples/platform/silabs/syscalls_stubs.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/syscalls_stubs.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/syscalls_stubs.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/syscalls_stubs.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/syscalls_stubs.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.o: $(SDK_PATH)/../../../src/lib/support/Base64.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/Base64.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/Base64.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/BytesToHex.o: $(SDK_PATH)/../../../src/lib/support/BytesToHex.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/BytesToHex.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/BytesToHex.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/BytesToHex.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/BytesToHex.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/logging/TextOnlyLogging.o: $(SDK_PATH)/../../../src/lib/support/logging/TextOnlyLogging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/logging/TextOnlyLogging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/logging/TextOnlyLogging.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/logging/TextOnlyLogging.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/logging/TextOnlyLogging.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/Logging.o: $(SDK_PATH)/../../../src/platform/silabs/Logging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/Logging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/Logging.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/Logging.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/Logging.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o: $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o: $(SDK_PATH)/../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o

$(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o: $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/aes.o: $(SDK_PATH)/../../mbedtls/repo/library/aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/aes.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/aes.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/aes.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1parse.o: $(SDK_PATH)/../../mbedtls/repo/library/asn1parse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/asn1parse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/asn1parse.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1parse.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1parse.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1write.o: $(SDK_PATH)/../../mbedtls/repo/library/asn1write.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/asn1write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/asn1write.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1write.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1write.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/base64.o: $(SDK_PATH)/../../mbedtls/repo/library/base64.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/base64.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/base64.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/base64.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/base64.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/bignum.o: $(SDK_PATH)/../../mbedtls/repo/library/bignum.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/bignum.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/bignum.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/bignum.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/bignum.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ccm.o: $(SDK_PATH)/../../mbedtls/repo/library/ccm.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ccm.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ccm.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ccm.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ccm.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher.o: $(SDK_PATH)/../../mbedtls/repo/library/cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher_wrap.o: $(SDK_PATH)/../../mbedtls/repo/library/cipher_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/cipher_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/cipher_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher_wrap.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/constant_time.o: $(SDK_PATH)/../../mbedtls/repo/library/constant_time.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/constant_time.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/constant_time.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/constant_time.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/constant_time.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ctr_drbg.o: $(SDK_PATH)/../../mbedtls/repo/library/ctr_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ctr_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ctr_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ctr_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ctr_drbg.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdh.o: $(SDK_PATH)/../../mbedtls/repo/library/ecdh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecdh.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdh.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdh.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdsa.o: $(SDK_PATH)/../../mbedtls/repo/library/ecdsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecdsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecdsa.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdsa.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdsa.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp.o: $(SDK_PATH)/../../mbedtls/repo/library/ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp_curves.o: $(SDK_PATH)/../../mbedtls/repo/library/ecp_curves.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecp_curves.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecp_curves.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp_curves.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp_curves.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/entropy.o: $(SDK_PATH)/../../mbedtls/repo/library/entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/entropy.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/entropy.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/entropy.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hkdf.o: $(SDK_PATH)/../../mbedtls/repo/library/hkdf.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/hkdf.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/hkdf.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hkdf.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hkdf.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hmac_drbg.o: $(SDK_PATH)/../../mbedtls/repo/library/hmac_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/hmac_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/hmac_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hmac_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hmac_drbg.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/md.o: $(SDK_PATH)/../../mbedtls/repo/library/md.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/md.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/md.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/md.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/md.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pem.o: $(SDK_PATH)/../../mbedtls/repo/library/pem.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/pem.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/pem.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pem.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pem.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pkcs5.o: $(SDK_PATH)/../../mbedtls/repo/library/pkcs5.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/pkcs5.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/pkcs5.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pkcs5.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pkcs5.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/platform.o: $(SDK_PATH)/../../mbedtls/repo/library/platform.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/platform.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/platform.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/platform.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha256.o: $(SDK_PATH)/../../mbedtls/repo/library/sha256.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/sha256.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/sha256.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha256.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha256.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha512.o: $(SDK_PATH)/../../mbedtls/repo/library/sha512.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/sha512.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/sha512.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha512.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha512.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509.o: $(SDK_PATH)/../../mbedtls/repo/library/x509.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/x509.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/x509.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509_create.o: $(SDK_PATH)/../../mbedtls/repo/library/x509_create.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/x509_create.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/x509_create.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509_create.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509_create.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/error.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/error.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/error.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/error.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/oid.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/oid.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/oid.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/oid.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/oid.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/oid.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkparse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkparse.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/platform_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/platform_util.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.o: $(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/board/silabs/src/rsi_board.o: $(SDK_PATH)/../wifi_sdk/components/board/silabs/src/rsi_board.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/board/silabs/src/rsi_board.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/board/silabs/src/rsi_board.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/board/silabs/src/rsi_board.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/board/silabs/src/rsi_board.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/common/src/sl_utility.o: $(SDK_PATH)/../wifi_sdk/components/common/src/sl_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/common/src/sl_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/common/src/sl_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/common/src/sl_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/common/src/sl_utility.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/crypto/multithread/src/sl_si91x_crypto_thread.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/multithread/src/sl_si91x_crypto_thread.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/multithread/src/sl_si91x_crypto_thread.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/multithread/src/sl_si91x_crypto_thread.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/crypto/multithread/src/sl_si91x_crypto_thread.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/crypto/multithread/src/sl_si91x_crypto_thread.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/crypto/trng/src/sl_si91x_trng.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/trng/src/sl_si91x_trng.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/trng/src/sl_si91x_trng.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/crypto/trng/src/sl_si91x_trng.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/crypto/trng/src/sl_si91x_trng.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/crypto/trng/src/sl_si91x_trng.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.o: $(SDK_PATH)/../wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.o: $(SDK_PATH)/../wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.o: $(SDK_PATH)/../wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net.o: $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.o: $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.o: $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.o: $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.o

$(OUTPUT_DIR)/sdk/platform/CMSIS/RTOS2/Source/os_systick.o: $(SDK_PATH)/platform/CMSIS/RTOS2/Source/os_systick.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/CMSIS/RTOS2/Source/os_systick.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/CMSIS/RTOS2/Source/os_systick.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/CMSIS/RTOS2/Source/os_systick.d
OBJS += $(OUTPUT_DIR)/sdk/platform/CMSIS/RTOS2/Source/os_systick.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.o: $(SDK_PATH)/platform/common/src/sl_assert.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_assert.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_assert.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_core_cortexm.o: $(SDK_PATH)/platform/common/src/sl_core_cortexm.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_core_cortexm.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_core_cortexm.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_core_cortexm.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_core_cortexm.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.o: $(SDK_PATH)/platform/common/src/sl_slist.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_slist.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_slist.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_string.o: $(SDK_PATH)/platform/common/src/sl_string.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_string.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_string.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_string.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_string.o

$(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o: $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o: $(SDK_PATH)/platform/emlib/src/em_core.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_core.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_core.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_nvic.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_nvic.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_nvic.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_nvic.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_nvic.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_nvic.o

$(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream.o: $(SDK_PATH)/platform/service/iostream/src/sl_iostream.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/iostream/src/sl_iostream.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/iostream/src/sl_iostream.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream.o

$(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream_rtt.o: $(SDK_PATH)/platform/service/iostream/src/sl_iostream_rtt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/iostream/src/sl_iostream_rtt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/iostream/src/sl_iostream_rtt.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream_rtt.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream_rtt.o

$(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.o: $(SDK_PATH)/platform/service/system/src/sl_system_init.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/system/src/sl_system_init.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/system/src/sl_system_init.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.o

$(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_kernel.o: $(SDK_PATH)/platform/service/system/src/sl_system_kernel.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/system/src/sl_system_kernel.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/system/src/sl_system_kernel.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_kernel.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_kernel.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/cmsis/Source/cmsis_os2.o: $(SDK_PATH)/util/third_party/freertos/cmsis/Source/cmsis_os2.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/cmsis/Source/cmsis_os2.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/cmsis/Source/cmsis_os2.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/cmsis/Source/cmsis_os2.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/cmsis/Source/cmsis_os2.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/croutine.o: $(SDK_PATH)/util/third_party/freertos/kernel/croutine.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/croutine.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/croutine.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/croutine.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/croutine.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/event_groups.o: $(SDK_PATH)/util/third_party/freertos/kernel/event_groups.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/event_groups.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/event_groups.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/event_groups.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/event_groups.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/list.o: $(SDK_PATH)/util/third_party/freertos/kernel/list.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/list.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/list.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/list.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/list.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_3.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_3.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_3.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_3.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_3.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_3.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/queue.o: $(SDK_PATH)/util/third_party/freertos/kernel/queue.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/queue.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/queue.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/queue.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/queue.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/stream_buffer.o: $(SDK_PATH)/util/third_party/freertos/kernel/stream_buffer.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/stream_buffer.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/stream_buffer.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/stream_buffer.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/stream_buffer.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/tasks.o: $(SDK_PATH)/util/third_party/freertos/kernel/tasks.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/tasks.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/tasks.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/tasks.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/tasks.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/timers.o: $(SDK_PATH)/util/third_party/freertos/kernel/timers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/timers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/timers.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/timers.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/timers.o

$(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o: $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o

$(OUTPUT_DIR)/project/_/_/generator/app.o: ../../generator/app.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/app.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/app.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/app.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/app.o

$(OUTPUT_DIR)/project/_/_/generator/main.o: ../../generator/main.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/main.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/main.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/main.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/main.o

$(OUTPUT_DIR)/project/_/_/generator/si917.o: ../../generator/si917.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/si917.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/si917.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/si917.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/si917.o

$(OUTPUT_DIR)/project/autogen/sl_event_handler.o: autogen/sl_event_handler.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_event_handler.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_event_handler.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_event_handler.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_event_handler.o

$(OUTPUT_DIR)/project/autogen/sl_iostream_handles.o: autogen/sl_iostream_handles.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_iostream_handles.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_iostream_handles.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_iostream_handles.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_iostream_handles.o

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA