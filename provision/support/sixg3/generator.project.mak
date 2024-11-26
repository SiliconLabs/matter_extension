####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Users/lobelive/Documents/workspace/matter_extension/third_party/simplicity_sdk
UNAME:=$(shell $(POSIX_TOOL_PATH)uname -s | $(POSIX_TOOL_PATH)sed -e 's/^\(CYGWIN\).*/\1/' | $(POSIX_TOOL_PATH)sed -e 's/^\(MINGW\).*/\1/')
ifeq ($(UNAME),MINGW)
# Translate "C:/super" into "/C/super" for MinGW make.
SDK_PATH := /$(shell $(POSIX_TOOL_PATH)echo $(BASE_SDK_PATH) | sed s/://)
endif
SDK_PATH ?= $(BASE_SDK_PATH)
COPIED_SDK_PATH ?= simplicity_sdk_2024.12.0

# This uses the explicit build rules below
PROJECT_SOURCE_FILES =

C_SOURCE_FILES   += $(filter %.c, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cpp, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cc, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.s, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.S, $(PROJECT_SOURCE_FILES))
LIB_FILES        += $(filter %.a, $(PROJECT_SOURCE_FILES))

C_DEFS += \
 '-DCHIP_CONFIG_SHA256_CONTEXT_SIZE=256' \
 '-DCHIP_CRYPTO_PLATFORM=1' \
 '-DCHIP_LOG_FILTERING=1' \
 '-DCHIP_PLATFORM_CONFIG_INCLUDE=<platform/silabs/CHIPPlatformConfig.h>' \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DOTA_ENCRYPTION_ENABLE=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DSL_PROVISION_GENERATOR=1' \
 '-DSIMG301M114LIH=1' \
 '-DSL_CODE_COMPONENT_SYSTEM=system' \
 '-DSL_APP_PROPERTIES=1' \
 '-DHARDWARE_BOARD_DEFAULT_RF_BAND_2400=1' \
 '-DHARDWARE_BOARD_SUPPORTS_1_RF_BAND=1' \
 '-DHARDWARE_BOARD_SUPPORTS_RF_BAND_2400=1' \
 '-DHFXO_FREQ=38400000' \
 '-DSL_BOARD_NAME="BRD1019A"' \
 '-DSL_BOARD_REV="A02"' \
 '-DSL_CODE_COMPONENT_CLOCK_MANAGER=clock_manager' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DSL_CODE_COMPONENT_HAL_GPIO=hal_gpio' \
 '-DCMSIS_NVIC_VIRTUAL=1' \
 '-DCMSIS_NVIC_VIRTUAL_HEADER_FILE="cmsis_nvic_virtual.h"' \
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DNO_CRYPTO_ACCELERATION=1' \
 '-DSL_MEMORY_POOL_POWER_AWARE=1' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"' \
 '-DSL_CODE_COMPONENT_CORE=core' \
 '-DSL_TZ_NON_SECURE_EXECUTION=1' \
 '-DconfigENABLE_TRUSTZONE=0' \
 '-DconfigRUN_FREERTOS_SECURE_ONLY=0'

ASM_DEFS += \
 '-DCHIP_CONFIG_SHA256_CONTEXT_SIZE=256' \
 '-DCHIP_CRYPTO_PLATFORM=1' \
 '-DCHIP_LOG_FILTERING=1' \
 '-DCHIP_PLATFORM_CONFIG_INCLUDE=<platform/silabs/CHIPPlatformConfig.h>' \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DOTA_ENCRYPTION_ENABLE=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DSL_PROVISION_GENERATOR=1' \
 '-DSIMG301M114LIH=1' \
 '-DSL_CODE_COMPONENT_SYSTEM=system' \
 '-DSL_APP_PROPERTIES=1' \
 '-DHARDWARE_BOARD_DEFAULT_RF_BAND_2400=1' \
 '-DHARDWARE_BOARD_SUPPORTS_1_RF_BAND=1' \
 '-DHARDWARE_BOARD_SUPPORTS_RF_BAND_2400=1' \
 '-DHFXO_FREQ=38400000' \
 '-DSL_BOARD_NAME="BRD1019A"' \
 '-DSL_BOARD_REV="A02"' \
 '-DSL_CODE_COMPONENT_CLOCK_MANAGER=clock_manager' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DSL_CODE_COMPONENT_HAL_GPIO=hal_gpio' \
 '-DCMSIS_NVIC_VIRTUAL=1' \
 '-DCMSIS_NVIC_VIRTUAL_HEADER_FILE="cmsis_nvic_virtual.h"' \
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DNO_CRYPTO_ACCELERATION=1' \
 '-DSL_MEMORY_POOL_POWER_AWARE=1' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"' \
 '-DSL_CODE_COMPONENT_CORE=core' \
 '-DSL_TZ_NON_SECURE_EXECUTION=1' \
 '-DconfigENABLE_TRUSTZONE=0' \
 '-DconfigRUN_FREERTOS_SECURE_ONLY=0'

INCLUDES += \
 -Iconfig \
 -Iautogen \
 -I$(SDK_PATH)/../../provision/generator \
 -I$(SDK_PATH)/../matter_sdk/examples \
 -I$(SDK_PATH)/../matter_sdk/examples/platform/silabs \
 -I$(SDK_PATH)/../matter_sdk/src \
 -I$(SDK_PATH)/../matter_sdk/src/include \
 -I$(SDK_PATH)/../matter_sdk/src/platform/silabs \
 -I$(SDK_PATH)/../matter_sdk/src/platform/silabs/provision \
 -I$(SDK_PATH)/../matter_sdk/zzz_generated/app-common \
 -I$(SDK_PATH)/../nlassert/include \
 -I$(SDK_PATH)/../nlio/include \
 -I$(SDK_PATH)/platform/bootloader \
 -I$(SDK_PATH)/protocol/bluetooth/config \
 -I$(SDK_PATH)/platform/Device/SiliconLabs/SIMG301/Include \
 -I$(SDK_PATH)/platform/common/inc \
 -I$(SDK_PATH)/hardware/board/inc \
 -I$(SDK_PATH)/platform/service/clock_manager/inc \
 -I$(SDK_PATH)/platform/service/clock_manager/src \
 -I$(SDK_PATH)/platform/CMSIS/Core/Include \
 -I$(SDK_PATH)/platform/CMSIS/RTOS2/Include \
 -I$(SDK_PATH)/platform/service/device_manager/inc \
 -I$(SDK_PATH)/platform/emdrv/common/inc \
 -I$(SDK_PATH)/util/third_party/freertos/cmsis/Include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure \
 -I$(SDK_PATH)/platform/driver/gpio/inc \
 -I$(SDK_PATH)/platform/peripheral/inc \
 -I$(SDK_PATH)/platform/service/interrupt_manager/inc \
 -I$(SDK_PATH)/platform/service/interrupt_manager/inc/arm \
 -I$(SDK_PATH)/platform/service/iostream/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config/preset \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/inc \
 -I$(SDK_PATH)/util/third_party/mbedtls/include \
 -I$(SDK_PATH)/util/third_party/mbedtls/library \
 -I$(SDK_PATH)/platform/service/memory_manager/inc \
 -I$(SDK_PATH)/platform/service/memory_manager/src \
 -I$(SDK_PATH)/platform/emdrv/nvm3/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_psa_driver/inc \
 -I$(SDK_PATH)/platform/security/sl_component/se_manager/inc \
 -I$(SDK_PATH)/util/third_party/segger/systemview/SEGGER \
 -I$(SDK_PATH)/platform/common/toolchain/inc \
 -I$(SDK_PATH)/platform/service/system/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sli_psec_osal/inc

GROUP_START =-Wl,--start-group
GROUP_END =-Wl,--end-group

PROJECT_LIBS = \
 -lstdc++ \
 -lgcc \
 -lc \
 -lm \
 -lnosys \
 $(SDK_PATH)/platform/emdrv/nvm3/lib/libnvm3_CM33_gcc.a

LIBS += $(GROUP_START) $(PROJECT_LIBS) $(GROUP_END)

LIB_FILES += $(filter %.a, $(PROJECT_LIBS))

C_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -std=c18 \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -imacros sl_gcc_preinclude.h \
 -Wno-unused-parameter \
 -g \
 -mcmse \
 --specs=nano.specs

CXX_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -std=c++17 \
 -fno-rtti \
 -fno-exceptions \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -imacros sl_gcc_preinclude.h \
 -Wno-unused-parameter \
 -g \
 -mcmse \
 --specs=nano.specs

ASM_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -imacros sl_gcc_preinclude.h \
 -x assembler-with-cpp

LD_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -T"autogen/linkerfile.ld" \
 --specs=nano.specs \
 -Xlinker -Map=$(OUTPUT_DIR)/$(PROJECTNAME).map \
 -Wl,--wrap=_free_r -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r \
 -Wl,--no-warn-rwx-segments \
 -Wl,--gc-sections


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
$(OUTPUT_DIR)/sdk/_/_/provision/generator/app.o: $(SDK_PATH)/../../provision/generator/app.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../provision/generator/app.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../provision/generator/app.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/provision/generator/app.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/provision/generator/app.o

$(OUTPUT_DIR)/sdk/_/_/provision/generator/efr32.o: $(SDK_PATH)/../../provision/generator/efr32.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../provision/generator/efr32.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../provision/generator/efr32.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/provision/generator/efr32.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/provision/generator/efr32.o

$(OUTPUT_DIR)/sdk/_/_/provision/generator/main.o: $(SDK_PATH)/../../provision/generator/main.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../provision/generator/main.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../provision/generator/main.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/provision/generator/main.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/provision/generator/main.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/examples/platform/silabs/provision/ProvisionStorageCustom.o: $(SDK_PATH)/../matter_sdk/examples/platform/silabs/provision/ProvisionStorageCustom.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/examples/platform/silabs/provision/ProvisionStorageCustom.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/examples/platform/silabs/provision/ProvisionStorageCustom.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/examples/platform/silabs/provision/ProvisionStorageCustom.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/examples/platform/silabs/provision/ProvisionStorageCustom.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/examples/platform/silabs/provision/ProvisionStorageDefault.o: $(SDK_PATH)/../matter_sdk/examples/platform/silabs/provision/ProvisionStorageDefault.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/examples/platform/silabs/provision/ProvisionStorageDefault.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/examples/platform/silabs/provision/ProvisionStorageDefault.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/examples/platform/silabs/provision/ProvisionStorageDefault.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/examples/platform/silabs/provision/ProvisionStorageDefault.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/crypto/CHIPCryptoPALPSA.o: $(SDK_PATH)/../matter_sdk/src/crypto/CHIPCryptoPALPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/crypto/CHIPCryptoPALPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/crypto/CHIPCryptoPALPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/crypto/CHIPCryptoPALPSA.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/crypto/CHIPCryptoPALPSA.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/Base64.o: $(SDK_PATH)/../matter_sdk/src/lib/support/Base64.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/lib/support/Base64.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/lib/support/Base64.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/Base64.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/Base64.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/BytesToHex.o: $(SDK_PATH)/../matter_sdk/src/lib/support/BytesToHex.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/lib/support/BytesToHex.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/lib/support/BytesToHex.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/BytesToHex.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/BytesToHex.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/logging/TextOnlyLogging.o: $(SDK_PATH)/../matter_sdk/src/lib/support/logging/TextOnlyLogging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/lib/support/logging/TextOnlyLogging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/lib/support/logging/TextOnlyLogging.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/logging/TextOnlyLogging.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/lib/support/logging/TextOnlyLogging.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/Logging.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/Logging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/Logging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/Logging.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/Logging.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/Logging.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/AttestationKeyPSA.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/AttestationKeyPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/AttestationKeyPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/AttestationKeyPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/AttestationKeyPSA.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/AttestationKeyPSA.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionChannelRTT.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionChannelRTT.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionChannelRTT.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionChannelRTT.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionChannelRTT.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionChannelRTT.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionEncoder.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionEncoder.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionEncoder.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionEncoder.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionEncoder.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionEncoder.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionManager.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionManager.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionManager.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionManager.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionManager.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionManager.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionProtocolV1.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionProtocolV1.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionProtocolV1.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionProtocolV1.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionProtocolV1.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionProtocolV1.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionProtocolV2.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionProtocolV2.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionProtocolV2.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionProtocolV2.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionProtocolV2.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionProtocolV2.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionStorage.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionStorage.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionStorage.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/provision/ProvisionStorage.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionStorage.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/provision/ProvisionStorage.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/SilabsConfig.o: $(SDK_PATH)/../matter_sdk/src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/sdk/_/matter_sdk/src/setup_payload/Base38Encode.o: $(SDK_PATH)/../matter_sdk/src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_sdk/src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../matter_sdk/src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_sdk/src/setup_payload/Base38Encode.o

$(OUTPUT_DIR)/sdk/hardware/board/src/sl_board_control_gpio.o: $(SDK_PATH)/hardware/board/src/sl_board_control_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/hardware/board/src/sl_board_control_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/hardware/board/src/sl_board_control_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/hardware/board/src/sl_board_control_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/hardware/board/src/sl_board_control_gpio.o

$(OUTPUT_DIR)/sdk/hardware/board/src/sl_board_init.o: $(SDK_PATH)/hardware/board/src/sl_board_init.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/hardware/board/src/sl_board_init.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/hardware/board/src/sl_board_init.c
CDEPS += $(OUTPUT_DIR)/sdk/hardware/board/src/sl_board_init.d
OBJS += $(OUTPUT_DIR)/sdk/hardware/board/src/sl_board_init.o

$(OUTPUT_DIR)/sdk/platform/bootloader/app_properties/app_properties.o: $(SDK_PATH)/platform/bootloader/app_properties/app_properties.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/bootloader/app_properties/app_properties.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/bootloader/app_properties/app_properties.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/bootloader/app_properties/app_properties.d
OBJS += $(OUTPUT_DIR)/sdk/platform/bootloader/app_properties/app_properties.o

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

$(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.o: $(SDK_PATH)/platform/common/src/sl_syscalls.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_syscalls.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_syscalls.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_tz_non_secure_execution.o: $(SDK_PATH)/platform/common/src/sl_tz_non_secure_execution.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_tz_non_secure_execution.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_tz_non_secure_execution.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_tz_non_secure_execution.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_tz_non_secure_execution.o

$(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o: $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/SIMG301/Source/startup_simg301.o: $(SDK_PATH)/platform/Device/SiliconLabs/SIMG301/Source/startup_simg301.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/SIMG301/Source/startup_simg301.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/SIMG301/Source/startup_simg301.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/SIMG301/Source/startup_simg301.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/SIMG301/Source/startup_simg301.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/SIMG301/Source/system_simg301.o: $(SDK_PATH)/platform/Device/SiliconLabs/SIMG301/Source/system_simg301.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/SIMG301/Source/system_simg301.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/SIMG301/Source/system_simg301.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/SIMG301/Source/system_simg301.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/SIMG301/Source/system_simg301.o

$(OUTPUT_DIR)/sdk/platform/driver/gpio/src/sl_gpio.o: $(SDK_PATH)/platform/driver/gpio/src/sl_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/driver/gpio/src/sl_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/driver/gpio/src/sl_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/driver/gpio/src/sl_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/platform/driver/gpio/src/sl_gpio.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash_ext.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash_ext.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash_ext.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash_ext.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash_ext.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash_ext.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o

$(OUTPUT_DIR)/sdk/platform/peripheral/src/sl_hal_gpio.o: $(SDK_PATH)/platform/peripheral/src/sl_hal_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/peripheral/src/sl_hal_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/peripheral/src/sl_hal_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/peripheral/src/sl_hal_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/platform/peripheral/src/sl_hal_gpio.o

$(OUTPUT_DIR)/sdk/platform/peripheral/src/sl_hal_system.o: $(SDK_PATH)/platform/peripheral/src/sl_hal_system.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/peripheral/src/sl_hal_system.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/peripheral/src/sl_hal_system.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/peripheral/src/sl_hal_system.d
OBJS += $(OUTPUT_DIR)/sdk/platform/peripheral/src/sl_hal_system.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_extmem.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_extmem.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_extmem.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_extmem.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_extmem.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_extmem.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_hash.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_hash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_hash.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_signature.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_signature.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_signature.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_signature.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_signature.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_signature.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_util.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_util.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_util.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_util.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sli_se_manager_device_data.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sli_se_manager_device_data.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sli_se_manager_device_data.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sli_se_manager_device_data.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sli_se_manager_device_data.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sli_se_manager_device_data.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sli_se_manager_mailbox.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/se_aes.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/se_aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/se_aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/se_aes.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/se_aes.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/se_aes.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o

$(OUTPUT_DIR)/sdk/platform/service/clock_manager/src/sl_clock_manager.o: $(SDK_PATH)/platform/service/clock_manager/src/sl_clock_manager.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/clock_manager/src/sl_clock_manager.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/clock_manager/src/sl_clock_manager.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/clock_manager/src/sl_clock_manager.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/clock_manager/src/sl_clock_manager.o

$(OUTPUT_DIR)/sdk/platform/service/clock_manager/src/sl_clock_manager_hal_s3.o: $(SDK_PATH)/platform/service/clock_manager/src/sl_clock_manager_hal_s3.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/clock_manager/src/sl_clock_manager_hal_s3.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/clock_manager/src/sl_clock_manager_hal_s3.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/clock_manager/src/sl_clock_manager_hal_s3.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/clock_manager/src/sl_clock_manager_hal_s3.o

$(OUTPUT_DIR)/sdk/platform/service/device_manager/clocks/sl_device_clock_sixg301.o: $(SDK_PATH)/platform/service/device_manager/clocks/sl_device_clock_sixg301.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_manager/clocks/sl_device_clock_sixg301.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_manager/clocks/sl_device_clock_sixg301.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/clocks/sl_device_clock_sixg301.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/clocks/sl_device_clock_sixg301.o

$(OUTPUT_DIR)/sdk/platform/service/device_manager/gpios/sl_device_gpio_common.o: $(SDK_PATH)/platform/service/device_manager/gpios/sl_device_gpio_common.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_manager/gpios/sl_device_gpio_common.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_manager/gpios/sl_device_gpio_common.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/gpios/sl_device_gpio_common.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/gpios/sl_device_gpio_common.o

$(OUTPUT_DIR)/sdk/platform/service/device_manager/src/sl_device_clock.o: $(SDK_PATH)/platform/service/device_manager/src/sl_device_clock.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_manager/src/sl_device_clock.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_manager/src/sl_device_clock.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/src/sl_device_clock.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/src/sl_device_clock.o

$(OUTPUT_DIR)/sdk/platform/service/device_manager/src/sl_device_gpio.o: $(SDK_PATH)/platform/service/device_manager/src/sl_device_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_manager/src/sl_device_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_manager/src/sl_device_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/src/sl_device_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_manager/src/sl_device_gpio.o

$(OUTPUT_DIR)/sdk/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.o: $(SDK_PATH)/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/interrupt_manager/src/sl_interrupt_manager_cortexm.o

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

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager.o

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_cpp.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_cpp.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_cpp.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_cpp.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_cpp.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_cpp.o

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_dynamic_reservation.o

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool_common.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool_common.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool_common.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool_common.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool_common.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool_common.o

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool_power_aware.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool_power_aware.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool_power_aware.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool_power_aware.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool_power_aware.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool_power_aware.o

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_region.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_region.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_region.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_region.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_region.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_region.o

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_retarget.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_retarget.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_retarget.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_retarget.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_retarget.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_retarget.o

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sli_memory_manager_common.o: $(SDK_PATH)/platform/service/memory_manager/src/sli_memory_manager_common.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sli_memory_manager_common.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sli_memory_manager_common.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sli_memory_manager_common.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sli_memory_manager_common.o

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

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.o

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

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/aes.o: $(SDK_PATH)/util/third_party/mbedtls/library/aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/aes.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/aes.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/aes.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1parse.o: $(SDK_PATH)/util/third_party/mbedtls/library/asn1parse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/asn1parse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/asn1parse.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1parse.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1parse.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1write.o: $(SDK_PATH)/util/third_party/mbedtls/library/asn1write.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/asn1write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/asn1write.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1write.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1write.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/base64.o: $(SDK_PATH)/util/third_party/mbedtls/library/base64.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/base64.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/base64.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/base64.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/base64.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_core.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum_core.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum_core.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum_core.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_core.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_core.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod_raw.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod_raw.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod_raw.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod_raw.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod_raw.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod_raw.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher.o: $(SDK_PATH)/util/third_party/mbedtls/library/cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher_wrap.o: $(SDK_PATH)/util/third_party/mbedtls/library/cipher_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/cipher_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/cipher_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher_wrap.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/constant_time.o: $(SDK_PATH)/util/third_party/mbedtls/library/constant_time.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/constant_time.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/constant_time.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/constant_time.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/constant_time.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ctr_drbg.o: $(SDK_PATH)/util/third_party/mbedtls/library/ctr_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ctr_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ctr_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ctr_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ctr_drbg.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecdsa.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecdsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecdsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecdsa.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecdsa.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecdsa.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves_new.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves_new.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves_new.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves_new.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves_new.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves_new.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy.o: $(SDK_PATH)/util/third_party/mbedtls/library/entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/entropy.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy_poll.o: $(SDK_PATH)/util/third_party/mbedtls/library/entropy_poll.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/entropy_poll.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/entropy_poll.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy_poll.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy_poll.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/hmac_drbg.o: $(SDK_PATH)/util/third_party/mbedtls/library/hmac_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/hmac_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/hmac_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/hmac_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/hmac_drbg.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/md.o: $(SDK_PATH)/util/third_party/mbedtls/library/md.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/md.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/md.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/md.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/md.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/oid.o: $(SDK_PATH)/util/third_party/mbedtls/library/oid.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/oid.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/oid.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/oid.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/oid.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pem.o: $(SDK_PATH)/util/third_party/mbedtls/library/pem.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pem.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pem.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pem.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pem.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk.o: $(SDK_PATH)/util/third_party/mbedtls/library/pk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pk.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk_wrap.o: $(SDK_PATH)/util/third_party/mbedtls/library/pk_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pk_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pk_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk_wrap.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkcs5.o: $(SDK_PATH)/util/third_party/mbedtls/library/pkcs5.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pkcs5.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pkcs5.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkcs5.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkcs5.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkparse.o: $(SDK_PATH)/util/third_party/mbedtls/library/pkparse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pkparse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pkparse.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkparse.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkparse.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkwrite.o: $(SDK_PATH)/util/third_party/mbedtls/library/pkwrite.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pkwrite.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pkwrite.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkwrite.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkwrite.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform.o: $(SDK_PATH)/util/third_party/mbedtls/library/platform.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/platform.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform_util.o: $(SDK_PATH)/util/third_party/mbedtls/library/platform_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/platform_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/platform_util.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform_util.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform_util.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_aead.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_aead.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_aead.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_cipher.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_cipher.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_client.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_client.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_client.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_client.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_client.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_client.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ecp.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ecp.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ecp.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ffdh.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ffdh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ffdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ffdh.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ffdh.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ffdh.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_hash.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_hash.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_hash.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_mac.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_mac.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_mac.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_pake.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_pake.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_pake.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_pake.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_pake.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_pake.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_rsa.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_rsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_rsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_rsa.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_rsa.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_rsa.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_se.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_se.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_se.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_se.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_se.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_se.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_slot_management.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_slot_management.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_slot_management.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_slot_management.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_slot_management.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_slot_management.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_storage.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_storage.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_storage.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_storage.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_storage.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_storage.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_util.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_util.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_util.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_util.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha1.o: $(SDK_PATH)/util/third_party/mbedtls/library/sha1.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/sha1.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/sha1.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha1.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha1.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha256.o: $(SDK_PATH)/util/third_party/mbedtls/library/sha256.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/sha256.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/sha256.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha256.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha256.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha512.o: $(SDK_PATH)/util/third_party/mbedtls/library/sha512.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/sha512.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/sha512.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha512.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha512.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/threading.o: $(SDK_PATH)/util/third_party/mbedtls/library/threading.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/threading.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/threading.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/threading.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/threading.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_create.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_create.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_create.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_create.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_create.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_create.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crl.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_crl.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_crl.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_crl.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crl.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crl.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crt.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_crt.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crt.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crt.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_csr.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_csr.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_csr.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_csr.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509write.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509write.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_crt.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509write_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509write_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509write_crt.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_crt.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_crt.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_csr.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509write_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509write_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509write_csr.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_csr.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_csr.o

$(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o: $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o

$(OUTPUT_DIR)/project/autogen/sl_board_default_init.o: autogen/sl_board_default_init.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_board_default_init.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_board_default_init.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_board_default_init.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_board_default_init.o

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