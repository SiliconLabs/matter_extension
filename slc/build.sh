#!/usr/bin/env bash

# This script generates and builds the SLC project for the given Matter application and board.
#
#   Usage:
#   ./slc/build.sh <slcp/slcw path> <board>
#
#   Example .slcp usage:
#   ./slc/build.sh slc/apps/lighting-app/thread/lighting-app.slcp brd4187c
#       output in: out/brd4187c/lighting-app/
#
#   Example .slcw usage:
#   ./slc/build.sh slc/apps/lighting-app/thread/lighting-app-series-2.slcw brd4187c
#       output in: out/brd4187c/lighting-app-solution/
#
#   Example --configuration option usage:
#   ./slc/build.sh slc/apps/lighting-app/thread/lighting-app.slcp brd4187c --configuration CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION:20,CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION_STRING:\"1.0.0-1.0\"
#       output in: out/brd4187c/lighting-app/
#
#   --skip_gen option : Allows to skip the slc gen step and only run the make command to rebuild modified files. slc gen normally regenerate your config, autogen, linker_options and makefile for your output folder.
#                       This option only works if the project has previously been generated
#   Example
#   ./slc/build.sh slc/apps/lighting-app/thread/lighting-app.slcp brd4187c --skip_gen
#       output in: out/brd4187c/lighting-app/
#
#   --sisdk option : Allows to build a project using a different SISDK folder, at the provided path, rather than the default one found in third_party/simplicity_sdk
#   Example
#   ./slc/build.sh slc/apps/lighting-app/thread/lighting-app.slcp brd4187c --sisdk /Users/Shared/silabs/Github/sisdk
#       output in: out/brd4187c/lighting-app/
#
#   --with_app option : Allows to specify additional components for the application build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/sample-app/lighting-app/efr32/lighting-app-thread.slcp brd4187c --with_app '<component1>,<component2>'
#       output in: out/brd4187c/lighting-app-thread/
#
#   --without_app option : Allows to exclude specific components from the application build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/sample-app/lighting-app/efr32/lighting-app-thread.slcp brd4187c --without_app '<component1>,<component2>'
#       output in: out/brd4187c/lighting-app-thread/
#
#   --with_bootloader option : Allows to specify additional components for the bootloader build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/solutions/thermostat/series-2/thermostat-917-ncp-bootloader.slcw brd4187c --with_bootloader '<component1>,<component2>'
#       output in: out/brd4187c/thermostat-917-ncp-solution/
#
#   --without_bootloader option : Allows to exclude specific components from the bootloader build for solutions only. If provided for .slcp file, silently ignored.
#   Example
#   ./slc/build.sh slc/solutions/thermostat/series-2/thermostat-917-ncp-bootloader.slcw brd4187c --without_bootloader '<component1>,<component2>'
#       output in: out/brd4187c/thermostat-917-ncp-solution/
#
#   -pids option : Allows to build only specific parts of a solution (.slcw) project. If provided for .slcp file, silently ignored.
#   Valid arguments: 'bootloader' or 'application'
#   Example bootloader-only build:
#   ./slc/build.sh slc/apps/lighting-app/thread/lighting-app-series-2.slcw brd4187c -pids bootloader
#       output in: out/brd4187c/lighting-app-solution/ (builds only bootloader)
#   Example application-only build:
#   ./slc/build.sh slc/apps/lighting-app/thread/lighting-app-series-2.slcw brd4187c -pids application
#       output in: out/brd4187c/lighting-app-solution/ (builds only application)
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

MATTER_ROOT=$(pwd -P)
: "${SISDK_ROOT:=$MATTER_ROOT/third_party/simplicity_sdk}"

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
	OUTPUT_DIR="out/$BRD_ONLY/$SILABS_APP-solution"

elif [[ "$SILABS_APP_PATH" == *.slcp ]]; then
	SILABS_APP=$(basename "$SILABS_APP_PATH" .slcp)
	PROJECT_FLAG="-p"
	OUTPUT_DIR="out/$BRD_ONLY/$SILABS_APP"
	MAKE_FILE=$SILABS_APP.Makefile

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
		OUTPUT_DIR="${OUTPUT_DIR}-$2"
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

if ! [ -x "$(command -v arm-none-eabi-gcc-12.2.1)" ]; then
	echo "WARNING: might be an incompatible toolchain."
	echo "Please install gcc-arm-none-eabi-12.2.Rel1 for your host."
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
		if [[ "$SILABS_APP_PATH" != *-siwx* ]] && [ "$GENERATE_BOOTLOADER" = true ]; then
			# Get bootloader arguments
			BOOTLOADER_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_BOOTLOADER_COMPONENTS")
			BOOTLOADER_WITHOUT_ARG=$(build_without_arg "$WITHOUT_BOOTLOADER_COMPONENTS")

			# Generate bootloader
			echo "Generating bootloader..."
			run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" $BOOTLOADER_WITH_ARG $BOOTLOADER_WITHOUT_ARG -pids bootloader $CONFIG_ARGS --generator-timeout=180 -o makefile
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate bootloader for: $SILABS_APP_PATH"
				exit 1
			fi
		fi

		if [ "$GENERATE_TZ_SECURE" = true ]; then
			# Get trustzone args
			WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")

			echo "Generating trustzone-secure..."
			run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" $WITH_ARG -pids trustzone-secure $CONFIG_ARGS --generator-timeout=180 -o makefile
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate application for: $SILABS_APP_PATH"
				exit 1
			fi
		fi

		if [ "$GENERATE_APPLICATION" = true ]; then
			# Get application args
			APP_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")
			APP_WITHOUT_ARG=$(build_without_arg "$WITHOUT_APP_COMPONENTS")

			echo "Generating application..."
			run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" $APP_WITH_ARG $APP_WITHOUT_ARG -pids application $CONFIG_ARGS --generator-timeout=180 -o makefile
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate application for: $SILABS_APP_PATH"
				exit 1
			fi
		fi
	else
		# Generate .slcp projects
		run_slc_generate_with_retry generate -d "$OUTPUT_DIR" --sdk-package-path "$SISDK_ROOT" --sdk-package-path "$EXTENSION_DIR" --sdk-package-path "$WISECONNECT3_DIR" $PROJECT_FLAG "$SILABS_APP_PATH" --with "$SILABS_BOARD" $CONFIG_ARGS --generator-timeout=180 -o makefile
		if [ $? -ne 0 ]; then
			echo "ERROR: Failed to generate project for: $SILABS_APP_PATH"
			exit 1
		fi
	fi
fi

# Build the project
if [ "$GENERATE_BOOTLOADER" = true ] && [ "$GENERATE_APPLICATION" = false ]; then
	# Use bootloader makefile instead of solution makefile
	echo "Building bootloader only..."
	BOOTLOADER_MAKEFILE=$(find "$OUTPUT_DIR/matter-bootloader" -maxdepth 1 -name "*.Makefile" | head -1)
	if [ -z "$BOOTLOADER_MAKEFILE" ]; then
		echo "ERROR: No bootloader Makefile found in $OUTPUT_DIR/matter-bootloader"
		exit 1
	fi
	BOOTLOADER_MAKEFILE_NAME=$(basename "$BOOTLOADER_MAKEFILE")
	if ! make all -C "$OUTPUT_DIR/matter-bootloader" -f "$BOOTLOADER_MAKEFILE_NAME" -j13; then
		echo "ERROR: Failed to build bootloader"
		exit 1
	fi
elif [ "$GENERATE_BOOTLOADER" = false ] && [ "$GENERATE_APPLICATION" = true ]; then
	# Use application makefile instead of solution makefile
	echo "Building application only..."
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
else
	echo "Building solution..."
	if ! make all -C "$OUTPUT_DIR" -f "$MAKE_FILE" -j13; then
		echo "ERROR: Failed to build solution"
		exit 1
	fi
fi