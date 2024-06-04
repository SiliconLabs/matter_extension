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