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

$(OUTPUT_DIR)/project/autogen/sl_device_init_clocks.o: autogen/sl_device_init_clocks.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_device_init_clocks.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_device_init_clocks.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_device_init_clocks.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_device_init_clocks.o

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
# SIMPLICITY_STUDIO_METADATA=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=END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA