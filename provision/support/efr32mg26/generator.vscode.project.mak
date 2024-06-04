####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/stash/gsdk
UNAME:=$(shell $(POSIX_TOOL_PATH)uname -s | $(POSIX_TOOL_PATH)sed -e 's/^\(CYGWIN\).*/\1/' | $(POSIX_TOOL_PATH)sed -e 's/^\(MINGW\).*/\1/')
ifeq ($(UNAME),MINGW)
# Translate "C:/super" into "/C/super" for MinGW make.
SDK_PATH := /$(shell $(POSIX_TOOL_PATH)echo $(BASE_SDK_PATH) | sed s/://)
endif
SDK_PATH ?= $(BASE_SDK_PATH)
COPIED_SDK_PATH ?= gecko_sdk_4.4.3

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
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

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
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

INCLUDES += \
 -Iconfig \
 -Iautogen \
 -I../../generator \
 -I../../../examples \
 -I../../../examples/platform/silabs \
 -I../../../src \
 -I../../../src/include \
 -I../../../zzz_generated/app-common \
 -I../../../third_party/nlassert/repo/include \
 -I../../../third_party/nlio/repo/include \
 -I../../../third_party/silabs/simplicity_sdk/platform/bootloader \
 -I../../../third_party/silabs/simplicity_sdk/protocol/bluetooth/config \
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
 -I$(SDK_PATH)/platform/service/iostream/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config/preset \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/inc \
 -I$(SDK_PATH)/util/third_party/mbedtls/include \
 -I$(SDK_PATH)/util/third_party/mbedtls/library \
 -I$(SDK_PATH)/platform/emdrv/nvm3/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_psa_driver/inc \
 -I$(SDK_PATH)/platform/security/sl_component/se_manager/inc \
 -I$(SDK_PATH)/platform/security/sl_component/se_manager/src \
 -I$(SDK_PATH)/util/third_party/segger/systemview/SEGGER \
 -I$(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager \
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
 -std=c99 \
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

$(OUTPUT_DIR)/sdk/platform/common/toolchain/src/sl_memory.o: $(SDK_PATH)/platform/common/toolchain/src/sl_memory.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/toolchain/src/sl_memory.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/toolchain/src/sl_memory.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/toolchain/src/sl_memory.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/toolchain/src/sl_memory.o

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

$(OUTPUT_DIR)/sdk/util/silicon_labs/silabs_core/memory_manager/sl_malloc.o: $(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager/sl_malloc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager/sl_malloc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager/sl_malloc.c
CDEPS += $(OUTPUT_DIR)/sdk/util/silicon_labs/silabs_core/memory_manager/sl_malloc.d
OBJS += $(OUTPUT_DIR)/sdk/util/silicon_labs/silabs_core/memory_manager/sl_malloc.o

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

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.o: ../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o: ../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o: ../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionEncoder.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionManager.o: ../../../examples/platform/silabs/provision/ProvisionManager.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionManager.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionManager.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionManager.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionManager.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o: ../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o: ../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o: ../../../examples/platform/silabs/provision/ProvisionStorage.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionStorage.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionStorage.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorage.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o: ../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o: ../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o

$(OUTPUT_DIR)/project/_/_/_/src/crypto/CHIPCryptoPALPSA.o: ../../../src/crypto/CHIPCryptoPALPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/crypto/CHIPCryptoPALPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/crypto/CHIPCryptoPALPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/crypto/CHIPCryptoPALPSA.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/crypto/CHIPCryptoPALPSA.o

$(OUTPUT_DIR)/project/_/_/_/src/lib/support/Base64.o: ../../../src/lib/support/Base64.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/lib/support/Base64.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/lib/support/Base64.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/Base64.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/Base64.o

$(OUTPUT_DIR)/project/_/_/_/src/lib/support/BytesToHex.o: ../../../src/lib/support/BytesToHex.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/lib/support/BytesToHex.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/lib/support/BytesToHex.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/BytesToHex.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/BytesToHex.o

$(OUTPUT_DIR)/project/_/_/_/src/lib/support/logging/TextOnlyLogging.o: ../../../src/lib/support/logging/TextOnlyLogging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/lib/support/logging/TextOnlyLogging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/lib/support/logging/TextOnlyLogging.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/logging/TextOnlyLogging.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/logging/TextOnlyLogging.o

$(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/Logging.o: ../../../src/platform/silabs/Logging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/platform/silabs/Logging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/platform/silabs/Logging.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/Logging.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/Logging.o

$(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o: ../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o

$(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SilabsConfig.o: ../../../src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/project/_/_/_/src/setup_payload/Base38Encode.o: ../../../src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/setup_payload/Base38Encode.o

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