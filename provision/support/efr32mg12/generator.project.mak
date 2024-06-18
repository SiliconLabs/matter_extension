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