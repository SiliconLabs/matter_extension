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
 '-DEFR32MG24A010F1024IM48=1' \
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
 '-DEFR32MG24A010F1024IM48=1' \
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
 -I$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Include \
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

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.o

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