####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/stash/matter/blue/third_party/silabs/simplicity_sdk
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
# SIMPLICITY_STUDIO_METADATA=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=END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA