####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = third_party/silabs/gecko_sdk
UNAME:=$(shell $(POSIX_TOOL_PATH)uname -s | $(POSIX_TOOL_PATH)sed -e 's/^\(CYGWIN\).*/\1/' | $(POSIX_TOOL_PATH)sed -e 's/^\(MINGW\).*/\1/')
ifeq ($(UNAME),MINGW)
# Translate "C:/super" into "/C/super" for MinGW make.
SDK_PATH := /$(shell $(POSIX_TOOL_PATH)echo $(BASE_SDK_PATH) | sed s/://)
endif
SDK_PATH ?= $(BASE_SDK_PATH)
COPIED_SDK_PATH ?= gecko_sdk_4.4.0

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
 '-DEXT_IRQ_COUNT=75' \
 '-DFLASH_PAGE_SIZE=4096' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-mbedtls-config.h"' \
 '-DOPTIMIZE_TINYCRYPT_ASM=1' \
 '-DPROVISION_CHANNEL_ENABLED=1' \
 '-DSIWX_917=1' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DTINYCRYPT_PRIMITIVES=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4338A"' \
 '-DSL_BOARD_REV="A02"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DconfigUSE_POSIX_ERRNO=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

ASM_DEFS += \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DEXT_IRQ_COUNT=75' \
 '-DFLASH_PAGE_SIZE=4096' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-mbedtls-config.h"' \
 '-DOPTIMIZE_TINYCRYPT_ASM=1' \
 '-DPROVISION_CHANNEL_ENABLED=1' \
 '-DSIWX_917=1' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DTINYCRYPT_PRIMITIVES=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4338A"' \
 '-DSL_BOARD_REV="A02"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DconfigUSE_POSIX_ERRNO=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

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
 -I$(SDK_PATH)/../wifi_sdk/components/service/bsd_socket/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/CMSIS/Driver/Include \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/config \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver \
 -I$(SDK_PATH)/../wifi_sdk/components/service/network_manager/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/rom_driver/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/chip/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/board/silabs/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/core/config \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/errno/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/icmp \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/sl_net/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/inc \
 -I$(SDK_PATH)/../wifi_sdk/components/protocol/wifi/inc \
 -I$(SDK_PATH)/../wifi_sdk/resources/certificates \
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
 -std=c99 \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 --specs=nano.specs \
 -g

CXX_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -std=c++11 \
 -fno-rtti \
 -fno-exceptions \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -std=gnu++17 \
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

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionCommands.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionCommands.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionCommands.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionCommands.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionCommands.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionCommands.o

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

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/RttStreamChannel.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/RttStreamChannel.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/RttStreamChannel.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/RttStreamChannel.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/RttStreamChannel.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/RttStreamChannel.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.o: $(SDK_PATH)/../../../src/lib/support/Base64.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/Base64.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/Base64.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPMem-Malloc.o: $(SDK_PATH)/../../../src/lib/support/CHIPMem-Malloc.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/CHIPMem-Malloc.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/CHIPMem-Malloc.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPMem-Malloc.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPMem-Malloc.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPMem.o: $(SDK_PATH)/../../../src/lib/support/CHIPMem.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/CHIPMem.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/CHIPMem.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPMem.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPMem.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPPlatformMemory.o: $(SDK_PATH)/../../../src/lib/support/CHIPPlatformMemory.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/CHIPPlatformMemory.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/CHIPPlatformMemory.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPPlatformMemory.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/CHIPPlatformMemory.o

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

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.o

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

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o

$(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.o: $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c
CDEPS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.d
OBJS += $(OUTPUT_DIR)/sdk/_/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.o

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

$(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.o: $(SDK_PATH)/platform/common/src/sl_syscalls.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_syscalls.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_syscalls.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.o

$(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o: $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o

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

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_4.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_4.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_4.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_4.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_4.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_4.o

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

$(OUTPUT_DIR)/project/_/_/generator/nvm3_si917.o: ../../generator/nvm3_si917.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/nvm3_si917.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../generator/nvm3_si917.c
CDEPS += $(OUTPUT_DIR)/project/_/_/generator/nvm3_si917.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/nvm3_si917.o

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA