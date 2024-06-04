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