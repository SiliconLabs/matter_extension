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
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA