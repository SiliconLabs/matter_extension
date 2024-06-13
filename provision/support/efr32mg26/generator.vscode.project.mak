####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/stash/matter/green/third_party/silabs/simplicity_sdk
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
 '-DCHIP_CONFIG_SHA256_CONTEXT_SIZE=256' \
 '-DCHIP_CRYPTO_PLATFORM=1' \
 '-DCHIP_LOG_FILTERING=1' \
 '-DCHIP_PLATFORM_CONFIG_INCLUDE=<platform/silabs/CHIPPlatformConfig.h>' \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DOTA_ENCRYPTION_ENABLE=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DSL_PROVISION_GENERATOR=1' \
 '-DEFR32MG26B410F3200IM48=1' \
 '-DSL_APP_PROPERTIES=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DCMSIS_NVIC_VIRTUAL=1' \
 '-DCMSIS_NVIC_VIRTUAL_HEADER_FILE="cmsis_nvic_virtual.h"' \
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DSL_MEMORY_POOL_LIGHT=1' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"' \
 '-DSL_CODE_COMPONENT_CORE=core'

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
 '-DEFR32MG26B410F3200IM48=1' \
 '-DSL_APP_PROPERTIES=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DCMSIS_NVIC_VIRTUAL=1' \
 '-DCMSIS_NVIC_VIRTUAL_HEADER_FILE="cmsis_nvic_virtual.h"' \
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DSL_MEMORY_POOL_LIGHT=1' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
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
 -I$(SDK_PATH)/../../../src/include \
 -I$(SDK_PATH)/../../../zzz_generated/app-common \
 -I$(SDK_PATH)/../../nlassert/repo/include \
 -I$(SDK_PATH)/../../nlio/repo/include \
 -I$(SDK_PATH)/platform/bootloader \
 -I$(SDK_PATH)/protocol/bluetooth/config \
 -I$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG26/Include \
 -I$(SDK_PATH)/platform/common/inc \
 -I$(SDK_PATH)/platform/CMSIS/Core/Include \
 -I$(SDK_PATH)/platform/CMSIS/RTOS2/Include \
 -I$(SDK_PATH)/platform/service/device_init/inc \
 -I$(SDK_PATH)/platform/emdrv/common/inc \
 -I$(SDK_PATH)/platform/emlib/inc \
 -I$(SDK_PATH)/util/third_party/freertos/cmsis/Include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM33_NTZ/non_secure \
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
 -I$(SDK_PATH)/platform/security/sl_component/se_manager/src \
 -I$(SDK_PATH)/util/third_party/segger/systemview/SEGGER \
 -I$(SDK_PATH)/platform/common/toolchain/inc \
 -I$(SDK_PATH)/platform/service/system/inc

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
 -mcmse \
 --specs=nano.specs \
 -g

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
 -mcmse \
 --specs=nano.specs \
 -g

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
$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.o

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

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o

$(OUTPUT_DIR)/sdk/_/_/_/src/crypto/CHIPCryptoPALPSA.o: $(SDK_PATH)/../../../src/crypto/CHIPCryptoPALPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/crypto/CHIPCryptoPALPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/crypto/CHIPCryptoPALPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/crypto/CHIPCryptoPALPSA.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/crypto/CHIPCryptoPALPSA.o

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

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o: $(SDK_PATH)/../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o: $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o: $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o

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

$(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o: $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG26/Source/startup_efr32mg26.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG26/Source/startup_efr32mg26.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG26/Source/startup_efr32mg26.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG26/Source/startup_efr32mg26.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG26/Source/startup_efr32mg26.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG26/Source/startup_efr32mg26.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG26/Source/system_efr32mg26.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG26/Source/system_efr32mg26.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG26/Source/system_efr32mg26.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG26/Source/system_efr32mg26.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG26/Source/system_efr32mg26.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG26/Source/system_efr32mg26.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_cmu.o: $(SDK_PATH)/platform/emlib/src/em_cmu.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_cmu.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_cmu.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_cmu.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_cmu.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o: $(SDK_PATH)/platform/emlib/src/em_core.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_core.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_core.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_emu.o: $(SDK_PATH)/platform/emlib/src/em_emu.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_emu.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_emu.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_emu.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_emu.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_gpio.o: $(SDK_PATH)/platform/emlib/src/em_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_gpio.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_msc.o: $(SDK_PATH)/platform/emlib/src/em_msc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_msc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_msc.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_msc.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_msc.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_se.o: $(SDK_PATH)/platform/emlib/src/em_se.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_se.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_se.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_se.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_se.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o: $(SDK_PATH)/platform/emlib/src/em_system.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_system.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_system.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o

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

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s2.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s2.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s2.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s2.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s2.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s2.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s2.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s2.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s2.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s2.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s2.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s2.o

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

$(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool.o: $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/memory_manager/src/sl_memory_manager_pool.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/memory_manager/src/sl_memory_manager_pool.o

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

$(OUTPUT_DIR)/project/_/_/generator/app.o: ../../generator/app.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/app.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/app.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/app.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/app.o

$(OUTPUT_DIR)/project/_/_/generator/efr32.o: ../../generator/efr32.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/efr32.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/efr32.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/efr32.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/efr32.o

$(OUTPUT_DIR)/project/_/_/generator/main.o: ../../generator/main.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/main.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/main.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/main.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/main.o

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA