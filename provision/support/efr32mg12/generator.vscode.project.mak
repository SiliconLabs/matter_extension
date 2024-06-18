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