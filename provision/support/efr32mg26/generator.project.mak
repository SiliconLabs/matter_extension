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