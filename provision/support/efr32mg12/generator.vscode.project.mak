####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/git/gsdk
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
 '-DEFR32MG12P232F512GM68=1' \
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
 '-DEFR32MG12P232F512GM68=1' \
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
 -I$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Include \
 -I$(SDK_PATH)/platform/common/inc \
 -I$(SDK_PATH)/platform/CMSIS/Core/Include \
 -I$(SDK_PATH)/platform/CMSIS/RTOS2/Include \
 -I$(SDK_PATH)/platform/service/device_init/inc \
 -I$(SDK_PATH)/platform/emdrv/common/inc \
 -I$(SDK_PATH)/platform/emlib/inc \
 -I$(SDK_PATH)/util/third_party/freertos/cmsis/Include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F \
 -I$(SDK_PATH)/platform/service/iostream/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config/preset \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/inc \
 -I$(SDK_PATH)/util/third_party/mbedtls/include \
 -I$(SDK_PATH)/util/third_party/mbedtls/library \
 -I$(SDK_PATH)/platform/emdrv/nvm3/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_psa_driver/inc \
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
 $(SDK_PATH)/platform/emdrv/nvm3/lib/libnvm3_CM4_gcc.a

LIBS += $(GROUP_START) $(PROJECT_LIBS) $(GROUP_END)

LIB_FILES += $(filter %.a, $(PROJECT_LIBS))

C_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -std=c99 \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -imacros sl_gcc_preinclude.h \
 -Wno-unused-parameter \
 --specs=nano.specs \
 -g

CXX_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
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
 --specs=nano.specs \
 -g

ASM_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -imacros sl_gcc_preinclude.h \
 -x assembler-with-cpp

LD_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
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

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.o

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

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_crypto.o: $(SDK_PATH)/platform/emlib/src/em_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_crypto.o

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

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o: $(SDK_PATH)/platform/emlib/src/em_system.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_system.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_system.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o

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

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/crypto_management.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/crypto_management.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/crypto_management.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/crypto_management.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/crypto_management.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/crypto_management.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.o

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

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s1.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s1.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s1.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s1.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s1.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s1.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s1.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s1.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s1.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s1.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s1.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s1.o

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

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.o

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