####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/git/matter/stash/third_party/silabs/gecko_sdk
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
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DDEBUG_EFM=1' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-tinycrypt-config.h"' \
 '-DNVM3_LOCK_OVERRIDE=1' \
 '-DOPTIMIZE_TINYCRYPT_ASM=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_MBEDTLS_USE_TINYCRYPT=1' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DSL_PROVISION_GENERATOR=1' \
 '-DTINYCRYPT_PRIMITIVES=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4002A"' \
 '-DSL_BOARD_REV="A06"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DDEBUG_ENABLE=1' \
 '-DDEBUG_UART=1' \
 '-DENABLE_DEBUG_MODULE=1' \
 '-DFLASH_PAGE_SIZE=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

ASM_DEFS += \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DDEBUG_EFM=1' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-tinycrypt-config.h"' \
 '-DNVM3_LOCK_OVERRIDE=1' \
 '-DOPTIMIZE_TINYCRYPT_ASM=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_MBEDTLS_USE_TINYCRYPT=1' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DSL_PROVISION_GENERATOR=1' \
 '-DTINYCRYPT_PRIMITIVES=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4002A"' \
 '-DSL_BOARD_REV="A06"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DDEBUG_ENABLE=1' \
 '-DDEBUG_UART=1' \
 '-DENABLE_DEBUG_MODULE=1' \
 '-DFLASH_PAGE_SIZE=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

INCLUDES += \
 -Iconfig \
 -Iautogen \
 -I../../generator \
 -I$(SDK_PATH)/../../../examples \
 -I$(SDK_PATH)/../../../examples/platform/silabs \
 -I$(SDK_PATH)/../../../src \
 -I$(SDK_PATH)/../../../src/platform/silabs/SiWx917 \
 -I$(SDK_PATH)/../../../src/include \
 -I$(SDK_PATH)/../../../zzz_generated/app-common \
 -I$(SDK_PATH)/../../nlassert/repo/include \
 -I$(SDK_PATH)/../../nlio/repo/include \
 -I$(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/inc \
 -I$(SDK_PATH)/../../mbedtls/repo/library \
 -I$(SDK_PATH)/../../mbedtls/repo/include \
 -I$(SDK_PATH)/../../../src/lib/support \
 -I$(SDK_PATH)/../../../src/platform/silabs \
 -I$(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/bsd_socket/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/CMSIS/Driver/Include \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/config \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/rom_driver/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/board/silabs/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/protocol/wifi/inc \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/resources/certificates \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/resources/html \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/resources/other \
 -I$(SDK_PATH)/../../../../../stash/wifi_sdk/components/common/inc \
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
 -I$(SDK_PATH)/platform/emdrv/nvm3/inc \
 -I$(SDK_PATH)/util/third_party/segger/systemview/SEGGER \
 -I$(SDK_PATH)/platform/service/system/inc

GROUP_START =-Wl,--start-group
GROUP_END =-Wl,--end-group

PROJECT_LIBS = \
 -lgcc \
 -lnosys \
 -lstdc++ \
 -lc \
 -lm \
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
 -Og \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -Wno-unused-parameter \
 -mcpu=cortex-m4 \
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
 -Og \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -Wno-unused-parameter \
 -mcpu=cortex-m4 \
 --specs=nano.specs \
 -g

ASM_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -x assembler-with-cpp

LD_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -T"autogen/linkerfile_SoC.ld" \
 --specs=nano.specs \
 -Xlinker -Map=$(OUTPUT_DIR)/$(PROJECTNAME).map \
 -u _printf_float \
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
$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/board/silabs/src/rsi_board.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/board/silabs/src/rsi_board.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/board/silabs/src/rsi_board.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/board/silabs/src/rsi_board.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/board/silabs/src/rsi_board.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/board/silabs/src/rsi_board.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/common/src/sl_utility.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/common/src/sl_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/common/src/sl_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/common/src/sl_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/common/src/sl_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/common/src/sl_utility.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.o

$(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.o: $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../../../../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/_/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o

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

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/syscalls_stubs.o: $(SDK_PATH)/../../../examples/platform/silabs/syscalls_stubs.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/syscalls_stubs.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/syscalls_stubs.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/syscalls_stubs.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/syscalls_stubs.o

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

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o: $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o: $(SDK_PATH)/../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o

$(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o: $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/aes.o: $(SDK_PATH)/../../mbedtls/repo/library/aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/aes.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/aes.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/aes.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1parse.o: $(SDK_PATH)/../../mbedtls/repo/library/asn1parse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/asn1parse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/asn1parse.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1parse.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1parse.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1write.o: $(SDK_PATH)/../../mbedtls/repo/library/asn1write.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/asn1write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/asn1write.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1write.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/asn1write.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/base64.o: $(SDK_PATH)/../../mbedtls/repo/library/base64.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/base64.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/base64.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/base64.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/base64.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/bignum.o: $(SDK_PATH)/../../mbedtls/repo/library/bignum.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/bignum.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/bignum.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/bignum.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/bignum.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ccm.o: $(SDK_PATH)/../../mbedtls/repo/library/ccm.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ccm.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ccm.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ccm.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ccm.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher.o: $(SDK_PATH)/../../mbedtls/repo/library/cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher_wrap.o: $(SDK_PATH)/../../mbedtls/repo/library/cipher_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/cipher_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/cipher_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/cipher_wrap.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/constant_time.o: $(SDK_PATH)/../../mbedtls/repo/library/constant_time.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/constant_time.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/constant_time.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/constant_time.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/constant_time.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ctr_drbg.o: $(SDK_PATH)/../../mbedtls/repo/library/ctr_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ctr_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ctr_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ctr_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ctr_drbg.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdh.o: $(SDK_PATH)/../../mbedtls/repo/library/ecdh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecdh.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdh.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdh.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdsa.o: $(SDK_PATH)/../../mbedtls/repo/library/ecdsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecdsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecdsa.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdsa.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecdsa.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp.o: $(SDK_PATH)/../../mbedtls/repo/library/ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp_curves.o: $(SDK_PATH)/../../mbedtls/repo/library/ecp_curves.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/ecp_curves.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/ecp_curves.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp_curves.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/ecp_curves.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/entropy.o: $(SDK_PATH)/../../mbedtls/repo/library/entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/entropy.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/entropy.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/entropy.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hkdf.o: $(SDK_PATH)/../../mbedtls/repo/library/hkdf.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/hkdf.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/hkdf.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hkdf.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hkdf.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hmac_drbg.o: $(SDK_PATH)/../../mbedtls/repo/library/hmac_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/hmac_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/hmac_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hmac_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/hmac_drbg.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/md.o: $(SDK_PATH)/../../mbedtls/repo/library/md.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/md.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/md.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/md.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/md.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pem.o: $(SDK_PATH)/../../mbedtls/repo/library/pem.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/pem.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/pem.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pem.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pem.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pkcs5.o: $(SDK_PATH)/../../mbedtls/repo/library/pkcs5.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/pkcs5.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/pkcs5.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pkcs5.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/pkcs5.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/platform.o: $(SDK_PATH)/../../mbedtls/repo/library/platform.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/platform.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/platform.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/platform.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha256.o: $(SDK_PATH)/../../mbedtls/repo/library/sha256.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/sha256.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/sha256.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha256.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha256.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha512.o: $(SDK_PATH)/../../mbedtls/repo/library/sha512.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/sha512.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/sha512.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha512.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/sha512.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509.o: $(SDK_PATH)/../../mbedtls/repo/library/x509.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/x509.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/x509.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509.o

$(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509_create.o: $(SDK_PATH)/../../mbedtls/repo/library/x509_create.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../mbedtls/repo/library/x509_create.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../../mbedtls/repo/library/x509_create.c
CDEPS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509_create.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/mbedtls/repo/library/x509_create.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/error.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/error.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/error.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/error.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/oid.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/oid.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/oid.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/oid.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/oid.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/oid.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkparse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkparse.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/platform_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/platform_util.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o: $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o

$(OUTPUT_DIR)/sdk/_/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.o: $(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c
CDEPS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.d
OBJS += $(OUTPUT_DIR)/sdk/_/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.o

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

$(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.o: $(SDK_PATH)/platform/common/src/sl_slist.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_slist.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_slist.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_string.o: $(SDK_PATH)/platform/common/src/sl_string.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_string.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_string.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_string.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_string.o

$(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o: $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o: $(SDK_PATH)/platform/emlib/src/em_core.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_core.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_core.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o

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

$(OUTPUT_DIR)/project/_/_/generator/main.o: ../../generator/main.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/main.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/main.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/main.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/main.o

$(OUTPUT_DIR)/project/_/_/generator/si917.o: ../../generator/si917.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/si917.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/si917.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/si917.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/si917.o

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA