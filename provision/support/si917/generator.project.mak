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
COPIED_SDK_PATH ?= gecko_sdk_4.4.1

# This uses the explicit build rules below
PROJECT_SOURCE_FILES =

C_SOURCE_FILES   += $(filter %.c, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cpp, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cc, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.s, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.S, $(PROJECT_SOURCE_FILES))
LIB_FILES        += $(filter %.a, $(PROJECT_SOURCE_FILES))

C_DEFS += \
 '-DCHIP_CRYPTO_MBEDTLS=1' \
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
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
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
 '-DCHIP_CRYPTO_MBEDTLS=1' \
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
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
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
 -I$(SDK_PATH)/../wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/rsi_usart.h \
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
 -std=c99 \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -mcpu=cortex-m4 \
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