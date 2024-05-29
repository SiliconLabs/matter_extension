####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/git/stash/gsdk
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
 -I../../../third_party/silabs/gecko_sdk/platform/bootloader \
 -I../../../third_party/silabs/gecko_sdk/protocol/bluetooth/config \
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
# SIMPLICITY_STUDIO_METADATA=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=END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA