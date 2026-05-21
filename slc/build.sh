#!/usr/bin/env bash

# This script generates and builds the SLC project for the given Matter application and board.
#
#   Usage:
#   ./slc/build.sh <slcp/slcw path> <board>
#
#   Example .slcp usage:
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_freertos.slcp brd4187c
#       output in: out/brd4187c/matter_thread_soc_lighting_app_freertos/
#
#   Example .slcw usage:
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_series_2_freertos.slcw brd4187c
#       output in: out/brd4187c/matter_thread_soc_lighting_app_series_2_freertos_solution/
#
#   Example --configuration option usage:
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_freertos.slcp brd4187c --configuration CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION:20,CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION_STRING:\"1.0.0-1.0\"
#       output in: out/brd4187c/matter_thread_soc_lighting_app_freertos/
#
#   --skip_gen option : Allows to skip the slc gen step and only run the make command to rebuild modified files. slc gen normally regenerate your config, autogen, linker_options and makefile for your output folder.
#                       This option only works if the project has previously been generated
#   Example
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_freertos.slcp brd4187c --skip_gen
#       output in: out/brd4187c/matter_thread_soc_lighting_app_freertos/
#
#   --sisdk option : Allows to build a project using a different SISDK folder, at the provided path, rather than the default one found in third_party/simplicity_sdk
#   Example
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_freertos.slcp brd4187c --sisdk /Users/Shared/silabs/Github/sisdk
#       output in: out/brd4187c/matter_thread_soc_lighting_app_freertos/
#
#   --with_app option : Allows to specify additional components for the application build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_freertos.slcp brd4187c --with_app '<component1>,<component2>'
#       output in: out/brd4187c/matter_thread_soc_lighting_app_freertos/
#
#   --without_app option : Allows to exclude specific components from the application build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_freertos.slcp brd4187c --without_app '<component1>,<component2>'
#       output in: out/brd4187c/matter_thread_soc_lighting_app_freertos/
#
#   --with_bootloader option : Allows to specify additional components for the bootloader build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/apps/thermostat/wifi/matter_wifi_917_ncp_thermostat_freertos.slcw brd4187c --with_bootloader '<component1>,<component2>'
#       output in: out/brd4187c/matter_wifi_917_ncp_thermostat_freertos_solution/
#
#   --without_bootloader option : Allows to exclude specific components from the bootloader build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/apps/thermostat/wifi/matter_wifi_917_ncp_thermostat_freertos.slcw brd4187c --without_bootloader '<component1>,<component2>'
#       output in: out/brd4187c/matter_wifi_917_ncp_thermostat_freertos_solution/
#
#   -pids option : Allows to build only specific parts of a solution (.slcw) project. If provided for .slcp file, silently ignored.
#   Valid arguments: 'bootloader' or 'application'
#   Example bootloader-only build:
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_series_2_freertos.slcw brd4187c -pids bootloader
#       output in: out/brd4187c/matter_thread_soc_lighting_app_series_2_freertos_solution/ (builds only bootloader)
#   Example application-only build:
#   ./slc/build.sh slc/apps/lighting_app/thread/matter_thread_soc_lighting_app_series_2_freertos.slcw brd4187c -pids application
#       output in: out/brd4187c/matter_thread_soc_lighting_app_series_2_freertos_solution/ (builds only application)
#

# Helper functions to build component arguments
build_with_arg() {
	local board="$1"
	local components="$2"

	if [ -n "$components" ]; then
		echo "--with $board,$components"
	else
		echo "--with $board"
	fi
}

build_without_arg() {
	local components="$1"

	if [ -n "$components" ]; then
		echo "--without $components"
	else
		echo ""
	fi
}

# Helper function to run slc generate with retry on timeout
run_slc_generate_with_retry() {
	local max_retries=3
	local attempt=1
	local exit_code=0
	local output=""

	while [ $attempt -le $max_retries ]; do
		echo "Running: slc $* (attempt $attempt/$max_retries)"
		output=$(slc "$@" 2>&1)
		exit_code=$?
		echo "$output"

		if [ $exit_code -eq 0 ]; then
			break
		fi

		# Check for ConcurrentModificationException
		if echo "$output" | grep -q "ConcurrentModificationException: Internal Error. Please see logs."; then
			echo "ConcurrentModificationException detected. Exporting logs..."
			slc --exportLogs=out/artifacts/log
			echo "Logs exported to out/artifacts/log"
			if [ $attempt -lt $max_retries ]; then
				echo "Retrying slc generate command after ConcurrentModificationException..."
				sleep 1
			else
				echo "Maximum retries reached after ConcurrentModificationException."
			fi
		# Check for timeout
		elif echo "$output" | grep -qi "Generation did not complete within .* seconds!"; then
			if [ $attempt -lt $max_retries ]; then
				echo "Timeout detected. Retrying slc generate command..."
				sleep 1
			else
				echo "Maximum retries reached after timeout."
			fi
		else
			echo "Attempt $attempt failed with exit code $exit_code (not a timeout or ConcurrentModificationException - no retry)"
			break
		fi

		attempt=$((attempt + 1))
	done
	return $exit_code
}

MATTER_ROOT="${MATTER_ROOT:-$(pwd -P)}"
echo "MATTER_ROOT: $MATTER_ROOT"
: "${SISDK_ROOT:=$MATTER_ROOT/third_party/simplicity_sdk}"

# include env variables from .env file generated by sl_setup_env.py
set -a
if [ -f "$MATTER_ROOT/slc/tools/.env" ]; then
	echo "Loading environment variables from $MATTER_ROOT/slc/tools/.env"
	. "$MATTER_ROOT/slc/tools/.env"
	PATH="$TOOLS_PATH:$PATH"
fi
set +a

# Validate required arguments
if [ -z "$1" ] || [ -z "$2" ]; then
	echo "ERROR: Missing required arguments."
	echo "Usage: $0 <slcp/slcw path> <board> [options...]"
	exit 1
fi

SILABS_APP_PATH=$1
SILABS_BOARD=$2
CONFIG_ARGS=""
BRD_ONLY=$(echo "$SILABS_BOARD" | cut -f1 -d";")
if [ -z "$POST_BUILD_EXE" ]; then
	export POST_BUILD_EXE=$(which commander)
fi

# Determine vars based on project type provided (.slcw solution example or .slcp project example file)
if [[ "$SILABS_APP_PATH" == *.slcw ]]; then
	SILABS_APP=$(basename "$SILABS_APP_PATH" .slcw)
	MAKE_FILE=$SILABS_APP.solution.Makefile
	PROJECT_FLAG="-w"
	OUTPUT_DIR="out/$BRD_ONLY/${SILABS_APP}_solution"
	# CMake subdir under OUTPUT_DIR for solution (only used when USE_LLVM=true).
	CMAKE_SUBDIR="cmake_llvm"

elif [[ "$SILABS_APP_PATH" == *.slcp ]]; then
	SILABS_APP=$(basename "$SILABS_APP_PATH" .slcp)
	PROJECT_FLAG="-p"
	OUTPUT_DIR="out/$BRD_ONLY/$SILABS_APP"
	MAKE_FILE=$SILABS_APP.Makefile
	CMAKE_SUBDIR="cmake_llvm"

else
	echo "ERROR: Did not provide a valid path for a .slcw or .slcp project file."
	exit 1
fi

# Remove SILABS_APP_PATH and SILABS_BOARD from argument list
shift
shift
skip_gen=false
WITH_APP_COMPONENTS=""
WITHOUT_APP_COMPONENTS=""
WITH_BOOTLOADER_COMPONENTS=""
WITHOUT_BOOTLOADER_COMPONENTS=""
PIDS_ARG=""
GENERATE_BOOTLOADER=true
GENERATE_APPLICATION=true
GENERATE_TZ_SECURE=false
while [ $# -gt 0 ]; do
	case "$1" in
	--clean)
		rm -rf "$OUTPUT_DIR"
		shift
		;;
	--skip_gen)
		skip_gen=true
		shift
		;;
	--sisdk)
		SISDK_ROOT="$2"
		shift
		shift
		;;
	--output_suffix)
		OUTPUT_DIR="${OUTPUT_DIR}_$2"
		shift
		shift
		;;
	--with_app)
		WITH_APP_COMPONENTS="$2"
		shift
		shift
		;;
	--with_app\ *)
		WITH_APP_COMPONENTS="${1#--with_app }"
		shift
		;;
	--without_app)
		WITHOUT_APP_COMPONENTS="$2"
		shift
		shift
		;;
	--without_app\ *)
		WITHOUT_APP_COMPONENTS="${1#--without_app }"
		shift
		;;

	--with_bootloader)
		WITH_BOOTLOADER_COMPONENTS="$2"
		shift
		shift
		;;
	--with_bootloader\ *)
		WITH_BOOTLOADER_COMPONENTS="${1#--with_bootloader }"
		shift
		;;

	--without_bootloader)
		WITHOUT_BOOTLOADER_COMPONENTS="$2"
		shift
		shift
		;;
	--without_bootloader\ *)
		WITHOUT_BOOTLOADER_COMPONENTS="${1#--without_bootloader }"
		shift
		;;

	-pids)
		PIDS_ARG="$2"
		if [ "$PIDS_ARG" = "bootloader" ]; then
			GENERATE_APPLICATION=false
		elif [ "$PIDS_ARG" = "application" ]; then
			GENERATE_BOOTLOADER=false
		elif [ "$PIDS_ARG" = "trustzone" ]; then
			GENERATE_APPLICATION=true
			GENERATE_BOOTLOADER=true
			GENERATE_TZ_SECURE=true
		else
			echo "ERROR: Invalid -pids argument: $PIDS_ARG. Must be 'bootloader', 'application', or 'trustzone'"
			exit 1
		fi
		shift
		shift
		;;

	*)
		# Collect remaining arguments as configuration options
		CONFIG_ARGS+="$1 "
		shift
		;;
	esac
done

# Detect LLVM toolchain build by the presence of the toolchain_llvm component.
# Only support "with" since building app with llvm and bootloader with gcc doesn't make sense.
# LLVM build is only supported for CMake projects.
USE_LLVM=false
if [[ "$CONFIG_ARGS" == *toolchain_llvm* ]]; then
	USE_LLVM=true
fi

if [ "$USE_LLVM" = true ]; then
	OUTPUT_FORMAT="cmake"
else
	OUTPUT_FORMAT="makefile"
fi

# Helper to build with CMake (Required for LLVM toolchain).
# Args: <source_dir> <Label (App vs bootloader vs solution)>
cmake_configure_and_build() {
	local src_dir="$1"
	local label="$2"

	if [ ! -f "$src_dir/CMakeLists.txt" ]; then
		echo "ERROR: $label CMakeLists.txt not found at $src_dir"
		return 1
	fi
	if [ ! -f "$src_dir/CMakePresets.json" ]; then
		echo "ERROR: $label CMakePresets.json not found at $src_dir"
		return 1
	fi
	if ! (cd "$src_dir" && cmake --preset project -DPOST_BUILD_EXE="$POST_BUILD_EXE"); then
		echo "ERROR: Failed to configure $label"
		return 1
	fi
	if ! (cd "$src_dir" && cmake --build --preset default_config); then
		echo "ERROR: Failed to build $label"
		return 1
	fi
}

if [[ "$OUTPUT_DIR" == *"cmp-concurrent-high-bw-phy-em1" ]]; then
	python3 slc/script/em1-augmentation.py EM2 ## to change the sleep.c file from EM1 to EM2
fi

# Validate required tools and environment

if ! [ -x "$(command -v slc)" ]; then
	echo "ERROR: please install slc_cli for your host."
	exit 1
fi

if ! [ -d "$ARM_GCC_DIR" ]; then
	echo "ERROR: ARM_GCC_DIR is not set or directory does not exist."
	exit 1
fi

if ! [ -d "$ARM_GCC_DIR/bin" ]; then
	echo "ERROR: $ARM_GCC_DIR path should have a bin folder."
	exit 1
fi

if ! [ -x "$(command -v arm-none-eabi-gcc-14.2.1)" ]; then
	echo "WARNING: might be an incompatible toolchain."
	echo "Please install gcc-arm-none-eabi-14.2.Rel1 for your host."
fi

echo "Building $SILABS_APP for $SILABS_BOARD in $OUTPUT_DIR"


EXTENSION_DIR=$MATTER_ROOT
WISECONNECT3_DIR=$MATTER_ROOT/third_party/wifi_sdk


# Make ZAP available to SLC-CLI
if [ -z "$STUDIO_ADAPTER_PACK_PATH" ] || [ ! -f "$STUDIO_ADAPTER_PACK_PATH/apack.json" ]; then
	if [ -n "$ZAP_INSTALL_PATH" ]; then
		export STUDIO_ADAPTER_PACK_PATH="$ZAP_INSTALL_PATH"
	fi
fi

if [ "$skip_gen" = false ]; then
	if [[ "$SILABS_APP_PATH" == *.slcw ]]; then
		if [[ "$SILABS_APP_PATH" != *wifi_soc* ]] && [ "$GENERATE_BOOTLOADER" = true ]; then
			# Get bootloader arguments
			BOOTLOADER_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_BOOTLOADER_COMPONENTS")
			BOOTLOADER_WITHOUT_ARG=$(build_without_arg "$WITHOUT_BOOTLOADER_COMPONENTS")

			# Generate bootloader
			echo "Generating bootloader..."
			run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" $BOOTLOADER_WITH_ARG $BOOTLOADER_WITHOUT_ARG -pids bootloader $CONFIG_ARGS --generator-timeout=180 -o "$OUTPUT_FORMAT"
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate bootloader for: $SILABS_APP_PATH"
				exit 1
			fi
		fi

		if [ "$GENERATE_TZ_SECURE" = true ]; then
			# Get trustzone args
			WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")

			echo "Generating trustzone-secure..."
			run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" $WITH_ARG -pids trustzone-secure $CONFIG_ARGS --generator-timeout=180 -o "$OUTPUT_FORMAT"
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate application for: $SILABS_APP_PATH"
				exit 1
			fi
		fi

		if [[ "$SILABS_APP_PATH" != *bootloader* ]] && [ "$GENERATE_APPLICATION" = true ]; then
			# Get application args
			APP_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")
			APP_WITHOUT_ARG=$(build_without_arg "$WITHOUT_APP_COMPONENTS")

			echo "Generating application..."
			run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" $APP_WITH_ARG $APP_WITHOUT_ARG -pids application $CONFIG_ARGS --generator-timeout=180 -o "$OUTPUT_FORMAT"
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate application for: $SILABS_APP_PATH"
				exit 1
			fi
		fi
	else
        APP_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")
        APP_WITHOUT_ARG=$(build_without_arg "$WITHOUT_APP_COMPONENTS")
		# Generate .slcp projects
		run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" $APP_WITH_ARG $APP_WITHOUT_ARG $CONFIG_ARGS --generator-timeout=180 -o "$OUTPUT_FORMAT"
		if [ $? -ne 0 ]; then
			echo "ERROR: Failed to generate project for: $SILABS_APP_PATH"
			exit 1
		fi
	fi
fi

# Build the project
if [ "$GENERATE_BOOTLOADER" = true ] && [ "$GENERATE_APPLICATION" = false ]; then
	echo "Building bootloader only..."
	if [ "$USE_LLVM" = true ]; then
		BOOTLOADER_CMAKE_DIR=$(find "$OUTPUT_DIR/matter_bootloader" -maxdepth 1 -name "cmake_llvm" -type d | head -1)
		if [ -z "$BOOTLOADER_CMAKE_DIR" ]; then
			echo "ERROR: No bootloader cmake_llvm dir found in $OUTPUT_DIR/matter_bootloader"
			exit 1
		fi
		cmake_configure_and_build "$BOOTLOADER_CMAKE_DIR" "bootloader" || exit 1
	else
		BOOTLOADER_MAKEFILE=$(find "$OUTPUT_DIR/matter_bootloader" -maxdepth 1 -name "*.Makefile" | head -1)
		if [ -z "$BOOTLOADER_MAKEFILE" ]; then
			echo "ERROR: No bootloader Makefile found in $OUTPUT_DIR/matter_bootloader"
			exit 1
		fi
		BOOTLOADER_MAKEFILE_NAME=$(basename "$BOOTLOADER_MAKEFILE")
		if ! make all -C "$OUTPUT_DIR/matter_bootloader" -f "$BOOTLOADER_MAKEFILE_NAME" -j13; then
			echo "ERROR: Failed to build bootloader"
			exit 1
		fi
	fi
elif [ "$GENERATE_BOOTLOADER" = false ] && [ "$GENERATE_APPLICATION" = true ]; then
	echo "Building application only..."
	if [ "$USE_LLVM" = true ]; then
		APP_CMAKE_DIR=$(find "$OUTPUT_DIR" -mindepth 2 -maxdepth 2 -name "cmake_llvm" -type d ! -path "*matter-bootloader*" | head -1)
		if [ -z "$APP_CMAKE_DIR" ]; then
			echo "ERROR: No application cmake_llvm dir found in $OUTPUT_DIR"
			exit 1
		fi
		cmake_configure_and_build "$APP_CMAKE_DIR" "application" || exit 1
	else
		APP_MAKEFILE=$(find "$OUTPUT_DIR" -mindepth 2 -maxdepth 2 -name "*.Makefile" ! -name "*.solution.Makefile" | head -1)
		if [ -z "$APP_MAKEFILE" ]; then
			echo "ERROR: No application Makefile found in $OUTPUT_DIR"
			exit 1
		fi
		APP_DIR=$(dirname "$APP_MAKEFILE")
		APP_MAKEFILE_NAME=$(basename "$APP_MAKEFILE")
		if ! make all -C "$APP_DIR" -f "$APP_MAKEFILE_NAME" -j13; then
			echo "ERROR: Failed to build application"
			exit 1
		fi
	fi
else
	echo "Building solution..."
	if [ "$USE_LLVM" = true ]; then
		# Note: When slc-cli 6.0.21 releases, need to revert back to: 
		# cmake_configure_and_build "$OUTPUT_DIR/$CMAKE_SUBDIR" "solution" || exit 1 
		cmake_configure_and_build "$OUTPUT_DIR/${SILABS_APP}_llvm_cmake" "solution" || exit 1        
	else
		if ! make all -C "$OUTPUT_DIR" -f "$MAKE_FILE" -j13; then
			echo "ERROR: Failed to build solution"
			exit 1
		fi
	fi
fi

if [[ "$OUTPUT_DIR" == *"cmp-concurrent-high-bw-phy-em1" ]]; then
	python3 slc/script/em1-augmentation.py EM1 ## to revert the changes made to the sleep.c file from EM2 to EM1
fi