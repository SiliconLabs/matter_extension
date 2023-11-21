.PHONY = all clean


ifeq ($(OS),Windows_NT)
	POSIX_TOOL_PATH := /usr/bin/
endif
TOOLCHAIN_DIR := 
SDK_PATH := /home/selissia/chip/matter/third_party/silabs/gecko_sdk

ARM_GCC_DIR_WIN = 
ARM_GCC_DIR_OSX = 
ARM_GCC_DIR_LINUX = 
POST_BUILD_EXE_WIN = 
POST_BUILD_EXE_OSX = 
POST_BUILD_EXE_LINUX = 

# Pre-defined definitions in this file
ifeq ($(OS),Windows_NT)
	ARM_GCC_DIR ?= $(ARM_GCC_DIR_WIN)
	POST_BUILD_EXE ?= $(POST_BUILD_EXE_WIN)
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		ARM_GCC_DIR ?= $(ARM_GCC_DIR_OSX)
		POST_BUILD_EXE ?= $(POST_BUILD_EXE_OSX)
	else
		ARM_GCC_DIR ?= $(ARM_GCC_DIR_LINUX)
		POST_BUILD_EXE ?= $(POST_BUILD_EXE_LINUX)
	endif
endif

AR      = "$(ARM_GCC_DIR)/bin/arm-none-eabi-gcc-ar"
CC      = "$(ARM_GCC_DIR)/bin/arm-none-eabi-gcc"
CXX     = "$(ARM_GCC_DIR)/bin/arm-none-eabi-g++"
OBJCOPY = "$(ARM_GCC_DIR)/bin/arm-none-eabi-objcopy"
LD      = "$(ARM_GCC_DIR)/bin/arm-none-eabi-gcc"

# Command output is hidden by default, it can be enabled by
# setting VERBOSE=true on the commandline.
ifeq ($(VERBOSE),)
  ECHO = @
endif

PROJECTNAME := lighting-app-thread
SRC := .
OUTPUT_DIR := vscode-build
OBJ_DIR := $(OUTPUT_DIR)/obj

ASM_FLAGS := 

C_FLAGS := 

CXX_FLAGS := 
  
LD_FLAGS := 


-include lighting-app-thread.vscode.project.mak


ASM_INCLUDES := -I"config" -I"config/btconf" -I"config/common" -I"autogen" -I"$(SDK_PATH)/../../../examples/lighting-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../examples/platform/silabs" -I"$(SDK_PATH)/../../../src" -I"$(SDK_PATH)/../../../src/include" -I"$(SDK_PATH)/../../../src/lib" -I"$(SDK_PATH)/../../nlassert/repo/include" -I"$(SDK_PATH)/../../nlio/repo/include" -I"$(SDK_PATH)/../../../zzz_generated/app-common" -I"../../../../inc" -I"$(SDK_PATH)/../../../examples/platform/silabs/efr32" -I"$(SDK_PATH)/../../../src/platform/silabs/efr32" -I"$(SDK_PATH)/../../../examples/providers" -I"$(SDK_PATH)/../../../examples/common/QRCode/repo/c" -I"$(SDK_PATH)/../../../src/app/clusters/basic-information" -I"$(SDK_PATH)/../../../src/app/clusters/color-control-server" -I"$(SDK_PATH)/../../../src/app/clusters/diagnostic-logs-server" -I"$(SDK_PATH)/../../../src/app/clusters/general-commissioning-server" -I"$(SDK_PATH)/../../../src/app/clusters/general-diagnostics-server" -I"$(SDK_PATH)/../../../src/app/clusters/groups-server" -I"$(SDK_PATH)/../../../src/app/clusters/identify-server" -I"$(SDK_PATH)/../../../examples/platform/silabs/display" -I"$(SDK_PATH)/../../../examples/window-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../examples/thermostat/silabs/efr32/include" -I"$(SDK_PATH)/../../../src/app/clusters/level-control" -I"$(SDK_PATH)/../../../src/app/clusters/network-commissioning" -I"$(SDK_PATH)/../../../src/app/clusters/occupancy-sensor-server" -I"$(SDK_PATH)/../../../src/app/clusters/on-off-server" -I"$(SDK_PATH)/../../../src/app/clusters/ota-requestor" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config/preset" -I"$(SDK_PATH)/util/third_party/segger/systemview/SEGGER" -I"$(SDK_PATH)/../../../src/lib/shell" -I"$(SDK_PATH)/../../../src/lib/shell/commands" -I"$(SDK_PATH)/../../../examples/shell/shell_common/include" -I"$(SDK_PATH)/../../../examples/lock-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../src/app/clusters/software-diagnostics-server" -I"$(SDK_PATH)/../../../src/app/clusters/switch-server" -I"$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Include" -I"$(SDK_PATH)/platform/common/inc" -I"$(SDK_PATH)/protocol/bluetooth/inc" -I"$(SDK_PATH)/protocol/bluetooth/bgstack/ll/inc" -I"$(SDK_PATH)/hardware/board/inc" -I"$(SDK_PATH)/platform/bootloader" -I"$(SDK_PATH)/platform/bootloader/api" -I"$(SDK_PATH)/platform/driver/button/inc" -I"$(SDK_PATH)/platform/CMSIS/Core/Include" -I"$(SDK_PATH)/platform/CMSIS/RTOS2/Include" -I"$(SDK_PATH)/platform/service/device_init/inc" -I"$(SDK_PATH)/platform/emdrv/dmadrv/inc" -I"$(SDK_PATH)/platform/middleware/glib/dmd" -I"$(SDK_PATH)/platform/middleware/glib" -I"$(SDK_PATH)/platform/emdrv/common/inc" -I"$(SDK_PATH)/platform/emlib/inc" -I"$(SDK_PATH)/util/third_party/freertos/cmsis/Include" -I"$(SDK_PATH)/util/third_party/freertos/kernel/include" -I"$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F" -I"$(SDK_PATH)/platform/middleware/glib/glib" -I"$(SDK_PATH)/platform/emdrv/gpiointerrupt/inc" -I"$(SDK_PATH)/platform/driver/leddrv/inc" -I"$(SDK_PATH)/hardware/driver/memlcd/src/ls013b7dh03" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/inc" -I"$(SDK_PATH)/util/third_party/mbedtls/include" -I"$(SDK_PATH)/util/third_party/mbedtls/library" -I"$(SDK_PATH)/hardware/driver/memlcd/inc" -I"$(SDK_PATH)/hardware/driver/memlcd/inc/memlcd_usart" -I"$(SDK_PATH)/platform/service/mpu/inc" -I"$(SDK_PATH)/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_usart" -I"$(SDK_PATH)/platform/emdrv/nvm3/inc" -I"$(SDK_PATH)/util/third_party/openthread/src" -I"$(SDK_PATH)/util/third_party/openthread/src/cli" -I"$(SDK_PATH)/util/third_party/openthread/include" -I"$(SDK_PATH)/util/third_party/openthread/include/openthread" -I"$(SDK_PATH)/util/third_party/openthread/src/core" -I"$(SDK_PATH)/util/third_party/openthread/third_party/tcplp" -I"$(SDK_PATH)/util/third_party/openthread/examples/platforms" -I"$(SDK_PATH)/util/third_party/openthread/examples/platforms/utils" -I"$(SDK_PATH)/protocol/openthread/platform-abstraction/efr32" -I"$(SDK_PATH)/protocol/openthread/platform-abstraction/include" -I"$(SDK_PATH)/platform/service/power_manager/inc" -I"$(SDK_PATH)/platform/security/sl_component/sl_psa_driver/inc" -I"$(SDK_PATH)/platform/radio/rail_lib/common" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/ble" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/ieee802154" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/wmbus" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/zwave" -I"$(SDK_PATH)/platform/radio/rail_lib/chip/efr32/efr32xg1x" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/sidewalk" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/pa-conversions" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/pa-conversions/efr32xg1x" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_power_manager_init" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_pti" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_rssi" -I"$(SDK_PATH)/util/plugin/security_manager" -I"$(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager" -I"$(SDK_PATH)/platform/common/toolchain/inc" -I"$(SDK_PATH)/protocol/openthread/include" -I"$(SDK_PATH)/platform/service/system/inc" -I"$(SDK_PATH)/platform/service/sleeptimer/inc" -I"$(SDK_PATH)/platform/security/sl_component/sl_protocol_crypto/src" -I"$(SDK_PATH)/platform/emdrv/uartdrv/inc" -I"$(SDK_PATH)/platform/service/udelay/inc" 
C_INCLUDES := -I"config" -I"config/btconf" -I"config/common" -I"autogen" -I"$(SDK_PATH)/../../../examples/lighting-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../examples/platform/silabs" -I"$(SDK_PATH)/../../../src" -I"$(SDK_PATH)/../../../src/include" -I"$(SDK_PATH)/../../../src/lib" -I"$(SDK_PATH)/../../nlassert/repo/include" -I"$(SDK_PATH)/../../nlio/repo/include" -I"$(SDK_PATH)/../../../zzz_generated/app-common" -I"../../../../inc" -I"$(SDK_PATH)/../../../examples/platform/silabs/efr32" -I"$(SDK_PATH)/../../../src/platform/silabs/efr32" -I"$(SDK_PATH)/../../../examples/providers" -I"$(SDK_PATH)/../../../examples/common/QRCode/repo/c" -I"$(SDK_PATH)/../../../src/app/clusters/basic-information" -I"$(SDK_PATH)/../../../src/app/clusters/color-control-server" -I"$(SDK_PATH)/../../../src/app/clusters/diagnostic-logs-server" -I"$(SDK_PATH)/../../../src/app/clusters/general-commissioning-server" -I"$(SDK_PATH)/../../../src/app/clusters/general-diagnostics-server" -I"$(SDK_PATH)/../../../src/app/clusters/groups-server" -I"$(SDK_PATH)/../../../src/app/clusters/identify-server" -I"$(SDK_PATH)/../../../examples/platform/silabs/display" -I"$(SDK_PATH)/../../../examples/window-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../examples/thermostat/silabs/efr32/include" -I"$(SDK_PATH)/../../../src/app/clusters/level-control" -I"$(SDK_PATH)/../../../src/app/clusters/network-commissioning" -I"$(SDK_PATH)/../../../src/app/clusters/occupancy-sensor-server" -I"$(SDK_PATH)/../../../src/app/clusters/on-off-server" -I"$(SDK_PATH)/../../../src/app/clusters/ota-requestor" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config/preset" -I"$(SDK_PATH)/util/third_party/segger/systemview/SEGGER" -I"$(SDK_PATH)/../../../src/lib/shell" -I"$(SDK_PATH)/../../../src/lib/shell/commands" -I"$(SDK_PATH)/../../../examples/shell/shell_common/include" -I"$(SDK_PATH)/../../../examples/lock-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../src/app/clusters/software-diagnostics-server" -I"$(SDK_PATH)/../../../src/app/clusters/switch-server" -I"$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Include" -I"$(SDK_PATH)/platform/common/inc" -I"$(SDK_PATH)/protocol/bluetooth/inc" -I"$(SDK_PATH)/protocol/bluetooth/bgstack/ll/inc" -I"$(SDK_PATH)/hardware/board/inc" -I"$(SDK_PATH)/platform/bootloader" -I"$(SDK_PATH)/platform/bootloader/api" -I"$(SDK_PATH)/platform/driver/button/inc" -I"$(SDK_PATH)/platform/CMSIS/Core/Include" -I"$(SDK_PATH)/platform/CMSIS/RTOS2/Include" -I"$(SDK_PATH)/platform/service/device_init/inc" -I"$(SDK_PATH)/platform/emdrv/dmadrv/inc" -I"$(SDK_PATH)/platform/middleware/glib/dmd" -I"$(SDK_PATH)/platform/middleware/glib" -I"$(SDK_PATH)/platform/emdrv/common/inc" -I"$(SDK_PATH)/platform/emlib/inc" -I"$(SDK_PATH)/util/third_party/freertos/cmsis/Include" -I"$(SDK_PATH)/util/third_party/freertos/kernel/include" -I"$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F" -I"$(SDK_PATH)/platform/middleware/glib/glib" -I"$(SDK_PATH)/platform/emdrv/gpiointerrupt/inc" -I"$(SDK_PATH)/platform/driver/leddrv/inc" -I"$(SDK_PATH)/hardware/driver/memlcd/src/ls013b7dh03" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/inc" -I"$(SDK_PATH)/util/third_party/mbedtls/include" -I"$(SDK_PATH)/util/third_party/mbedtls/library" -I"$(SDK_PATH)/hardware/driver/memlcd/inc" -I"$(SDK_PATH)/hardware/driver/memlcd/inc/memlcd_usart" -I"$(SDK_PATH)/platform/service/mpu/inc" -I"$(SDK_PATH)/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_usart" -I"$(SDK_PATH)/platform/emdrv/nvm3/inc" -I"$(SDK_PATH)/util/third_party/openthread/src" -I"$(SDK_PATH)/util/third_party/openthread/src/cli" -I"$(SDK_PATH)/util/third_party/openthread/include" -I"$(SDK_PATH)/util/third_party/openthread/include/openthread" -I"$(SDK_PATH)/util/third_party/openthread/src/core" -I"$(SDK_PATH)/util/third_party/openthread/third_party/tcplp" -I"$(SDK_PATH)/util/third_party/openthread/examples/platforms" -I"$(SDK_PATH)/util/third_party/openthread/examples/platforms/utils" -I"$(SDK_PATH)/protocol/openthread/platform-abstraction/efr32" -I"$(SDK_PATH)/protocol/openthread/platform-abstraction/include" -I"$(SDK_PATH)/platform/service/power_manager/inc" -I"$(SDK_PATH)/platform/security/sl_component/sl_psa_driver/inc" -I"$(SDK_PATH)/platform/radio/rail_lib/common" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/ble" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/ieee802154" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/wmbus" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/zwave" -I"$(SDK_PATH)/platform/radio/rail_lib/chip/efr32/efr32xg1x" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/sidewalk" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/pa-conversions" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/pa-conversions/efr32xg1x" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_power_manager_init" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_pti" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_rssi" -I"$(SDK_PATH)/util/plugin/security_manager" -I"$(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager" -I"$(SDK_PATH)/platform/common/toolchain/inc" -I"$(SDK_PATH)/protocol/openthread/include" -I"$(SDK_PATH)/platform/service/system/inc" -I"$(SDK_PATH)/platform/service/sleeptimer/inc" -I"$(SDK_PATH)/platform/security/sl_component/sl_protocol_crypto/src" -I"$(SDK_PATH)/platform/emdrv/uartdrv/inc" -I"$(SDK_PATH)/platform/service/udelay/inc" 
CXX_INCLUDES := -I"config" -I"config/btconf" -I"config/common" -I"autogen" -I"$(SDK_PATH)/../../../examples/lighting-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../examples/platform/silabs" -I"$(SDK_PATH)/../../../src" -I"$(SDK_PATH)/../../../src/include" -I"$(SDK_PATH)/../../../src/lib" -I"$(SDK_PATH)/../../nlassert/repo/include" -I"$(SDK_PATH)/../../nlio/repo/include" -I"$(SDK_PATH)/../../../zzz_generated/app-common" -I"../../../../inc" -I"$(SDK_PATH)/../../../examples/platform/silabs/efr32" -I"$(SDK_PATH)/../../../src/platform/silabs/efr32" -I"$(SDK_PATH)/../../../examples/providers" -I"$(SDK_PATH)/../../../examples/common/QRCode/repo/c" -I"$(SDK_PATH)/../../../src/app/clusters/basic-information" -I"$(SDK_PATH)/../../../src/app/clusters/color-control-server" -I"$(SDK_PATH)/../../../src/app/clusters/diagnostic-logs-server" -I"$(SDK_PATH)/../../../src/app/clusters/general-commissioning-server" -I"$(SDK_PATH)/../../../src/app/clusters/general-diagnostics-server" -I"$(SDK_PATH)/../../../src/app/clusters/groups-server" -I"$(SDK_PATH)/../../../src/app/clusters/identify-server" -I"$(SDK_PATH)/../../../examples/platform/silabs/display" -I"$(SDK_PATH)/../../../examples/window-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../examples/thermostat/silabs/efr32/include" -I"$(SDK_PATH)/../../../src/app/clusters/level-control" -I"$(SDK_PATH)/../../../src/app/clusters/network-commissioning" -I"$(SDK_PATH)/../../../src/app/clusters/occupancy-sensor-server" -I"$(SDK_PATH)/../../../src/app/clusters/on-off-server" -I"$(SDK_PATH)/../../../src/app/clusters/ota-requestor" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config/preset" -I"$(SDK_PATH)/util/third_party/segger/systemview/SEGGER" -I"$(SDK_PATH)/../../../src/lib/shell" -I"$(SDK_PATH)/../../../src/lib/shell/commands" -I"$(SDK_PATH)/../../../examples/shell/shell_common/include" -I"$(SDK_PATH)/../../../examples/lock-app/silabs/efr32/include" -I"$(SDK_PATH)/../../../src/app/clusters/software-diagnostics-server" -I"$(SDK_PATH)/../../../src/app/clusters/switch-server" -I"$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Include" -I"$(SDK_PATH)/platform/common/inc" -I"$(SDK_PATH)/protocol/bluetooth/inc" -I"$(SDK_PATH)/protocol/bluetooth/bgstack/ll/inc" -I"$(SDK_PATH)/hardware/board/inc" -I"$(SDK_PATH)/platform/bootloader" -I"$(SDK_PATH)/platform/bootloader/api" -I"$(SDK_PATH)/platform/driver/button/inc" -I"$(SDK_PATH)/platform/CMSIS/Core/Include" -I"$(SDK_PATH)/platform/CMSIS/RTOS2/Include" -I"$(SDK_PATH)/platform/service/device_init/inc" -I"$(SDK_PATH)/platform/emdrv/dmadrv/inc" -I"$(SDK_PATH)/platform/middleware/glib/dmd" -I"$(SDK_PATH)/platform/middleware/glib" -I"$(SDK_PATH)/platform/emdrv/common/inc" -I"$(SDK_PATH)/platform/emlib/inc" -I"$(SDK_PATH)/util/third_party/freertos/cmsis/Include" -I"$(SDK_PATH)/util/third_party/freertos/kernel/include" -I"$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F" -I"$(SDK_PATH)/platform/middleware/glib/glib" -I"$(SDK_PATH)/platform/emdrv/gpiointerrupt/inc" -I"$(SDK_PATH)/platform/driver/leddrv/inc" -I"$(SDK_PATH)/hardware/driver/memlcd/src/ls013b7dh03" -I"$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/inc" -I"$(SDK_PATH)/util/third_party/mbedtls/include" -I"$(SDK_PATH)/util/third_party/mbedtls/library" -I"$(SDK_PATH)/hardware/driver/memlcd/inc" -I"$(SDK_PATH)/hardware/driver/memlcd/inc/memlcd_usart" -I"$(SDK_PATH)/platform/service/mpu/inc" -I"$(SDK_PATH)/hardware/driver/mx25_flash_shutdown/inc/sl_mx25_flash_shutdown_usart" -I"$(SDK_PATH)/platform/emdrv/nvm3/inc" -I"$(SDK_PATH)/util/third_party/openthread/src" -I"$(SDK_PATH)/util/third_party/openthread/src/cli" -I"$(SDK_PATH)/util/third_party/openthread/include" -I"$(SDK_PATH)/util/third_party/openthread/include/openthread" -I"$(SDK_PATH)/util/third_party/openthread/src/core" -I"$(SDK_PATH)/util/third_party/openthread/third_party/tcplp" -I"$(SDK_PATH)/util/third_party/openthread/examples/platforms" -I"$(SDK_PATH)/util/third_party/openthread/examples/platforms/utils" -I"$(SDK_PATH)/protocol/openthread/platform-abstraction/efr32" -I"$(SDK_PATH)/protocol/openthread/platform-abstraction/include" -I"$(SDK_PATH)/platform/service/power_manager/inc" -I"$(SDK_PATH)/platform/security/sl_component/sl_psa_driver/inc" -I"$(SDK_PATH)/platform/radio/rail_lib/common" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/ble" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/ieee802154" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/wmbus" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/zwave" -I"$(SDK_PATH)/platform/radio/rail_lib/chip/efr32/efr32xg1x" -I"$(SDK_PATH)/platform/radio/rail_lib/protocol/sidewalk" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/pa-conversions" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/pa-conversions/efr32xg1x" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_power_manager_init" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_pti" -I"$(SDK_PATH)/platform/radio/rail_lib/plugin/rail_util_rssi" -I"$(SDK_PATH)/util/plugin/security_manager" -I"$(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager" -I"$(SDK_PATH)/platform/common/toolchain/inc" -I"$(SDK_PATH)/protocol/openthread/include" -I"$(SDK_PATH)/platform/service/system/inc" -I"$(SDK_PATH)/platform/service/sleeptimer/inc" -I"$(SDK_PATH)/platform/security/sl_component/sl_protocol_crypto/src" -I"$(SDK_PATH)/platform/emdrv/uartdrv/inc" -I"$(SDK_PATH)/platform/service/udelay/inc" 

-include $(CDEPS)
-include $(CXXDEPS)
-include $(ASMDEPS_s)
-include $(ASMDEPS_S)

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

ASM_SOURCES := $(call rwildcard, $(SRC), *.s) $(call rwildcard, $(SRC), *.S)
C_SOURCES := $(call rwildcard, $(SRC), *.c)
CXX_SOURCES := $(call rwildcard, $(SRC), *.cpp) $(call rwildcard, $(SRC), *.cc)

ASM_OBJECTS := $(patsubst $(SRC)/%.s, $(OBJ_DIR)/%.o, $(filter %s, $(ASM_SOURCES)))
ASM_OBJECTS += $(patsubst $(SRC)/%.S, $(OBJ_DIR)/%.o, $(filter %S, $(ASM_SOURCES)))
C_OBJECTS := $(patsubst $(SRC)/%.c, $(OBJ_DIR)/%.o, $(filter %c, $(C_SOURCES)))
CXX_OBJECTS := $(patsubst $(SRC)/%.cpp, $(OBJ_DIR)/%.o, $(filter %cpp, $(CXX_SOURCES)))
CXX_OBJECTS += $(patsubst $(SRC)/%.cc, $(OBJ_DIR)/%.o, $(filter %cc, $(CXX_SOURCES)))
PROJ_OBJECTS := $(ASM_OBJECTS)
PROJ_OBJECTS += $(C_OBJECTS)
PROJ_OBJECTS += $(CXX_OBJECTS)

ASM_FLAGS += -MP -MD
C_FLAGS += -MP -MD
CXX_FLAGS += -MP -MD

override CFLAGS = $(C_FLAGS) $(C_DEFS) $(INCLUDES) $(DEPFLAGS)
override CXXFLAGS = $(CXX_FLAGS) $(C_DEFS) $(INCLUDES) $(DEPFLAGS)
override ASMFLAGS = $(ASM_FLAGS) $(ASM_DEFS) $(INCLUDES) $(DEPFLAGS)

DEPS := $(C_OBJECTS:%.o=%.d)

all: pre-build $(OUTPUT_DIR)/$(PROJECTNAME).out post-build
	$(ECHO)$(OBJCOPY) $(OUTPUT_DIR)/$(PROJECTNAME).out -O binary $(OUTPUT_DIR)/$(PROJECTNAME).bin
	$(ECHO)$(OBJCOPY) $(OUTPUT_DIR)/$(PROJECTNAME).out -O ihex $(OUTPUT_DIR)/$(PROJECTNAME).hex
	$(ECHO)$(OBJCOPY) $(OUTPUT_DIR)/$(PROJECTNAME).out -O srec $(OUTPUT_DIR)/$(PROJECTNAME).s37

clean:
	$(POSIX_TOOL_PATH)rm -rf $(OUTPUT_DIR)

$(OUTPUT_DIR)/$(PROJECTNAME).out: $(OBJS) $(PROJ_OBJECTS) $(LIB_FILES)
	@$(POSIX_TOOL_PATH)echo 'Linking $(OUTPUT_DIR)/$(PROJECTNAME).out'
	@$(POSIX_TOOL_PATH)echo $(OBJS) > $(OUTPUT_DIR)/objs
	@$(POSIX_TOOL_PATH)echo $(PROJ_OBJECTS) > $(OUTPUT_DIR)/proj_objs
	$(ECHO)$(LD) @$(OUTPUT_DIR)/objs @$(OUTPUT_DIR)/proj_objs $(LIBS) $(LD_FLAGS) -o $(OUTPUT_DIR)/$(PROJECTNAME).out

$(OBJ_DIR)/%.o: $(SRC)/%.s
	@$(POSIX_TOOL_PATH)echo 'Building $<'
	$(ECHO)$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(ASMFLAGS) -c "$<" -o "$@"

$(OBJ_DIR)/%.o: $(SRC)/%.S
	@$(POSIX_TOOL_PATH)echo 'Building $<'
	$(ECHO)$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(ASMFLAGS) -c "$<" -o "$@"

$(OBJ_DIR)/%.o: $(SRC)/%.c
	@$(POSIX_TOOL_PATH)echo 'Building $<'
	$(ECHO)$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c "$<" -o "$@"

$(OBJ_DIR)/%.o: $(SRC)/%.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $<'
	$(ECHO)$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CXXFLAGS) -c "$<" -o "$@"

$(OBJ_DIR)/%.o: $(SRC)/%.cc
	@$(POSIX_TOOL_PATH)echo 'Building $<'
	$(ECHO)$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CXXFLAGS) -c "$<" -o "$@"

-include $(DEPS)