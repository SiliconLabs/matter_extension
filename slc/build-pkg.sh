#!/usr/bin/env bash

# This script generates and builds the SLC project for the given Matter application and board.
#
# Platform SDKs (simplicity-sdk, wifi, thread, etc.) are resolved via slt install and pkg.slt
# in the app directory. The Matter extension is taken from the git checkout (MATTER_ROOT).
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
#   Create packages in local Conan cache:
#   ./slc/build.sh --create-package-version 2.10.0-0.dev [--clean]
#
#   Export from repo and build via packages/build_app.sh:
#   ./slc/build.sh --build-from-package-version 2.10.0-0.dev [--clean] \
#       matter_wifi_soc_lock_app_freertos.slcw brd4338a
#
#   --clean : Repo dev — remove out/ before build.
#             Package modes — remove matter/matter_app from Conan cache before export
#             (package out/ is removed with the cached package; not passed to build_app.sh).
#

die() {
	echo "ERROR: $*" >&2
	exit 1
}

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
			slc --exportLogs="${MATTER_ROOT}/out/artifacts/log"
			echo "Logs exported to ${MATTER_ROOT}/out/artifacts/log"
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MATTER_ROOT="${MATTER_ROOT:-$(cd "${SCRIPT_DIR}/.." && pwd)}"
echo "MATTER_ROOT: ${MATTER_ROOT}"

# Include env variables from .env file generated by sl_setup_env.py
set -a
if [ -f "${MATTER_ROOT}/slc/tools/.env" ]; then
	echo "Loading environment variables from ${MATTER_ROOT}/slc/tools/.env"
	# shellcheck disable=SC1091
	. "${MATTER_ROOT}/slc/tools/.env"
	PATH="${TOOLS_PATH}:${PATH}"
fi
set +a

if [ -x "${MATTER_ROOT}/slc/tools/slt" ]; then
	export PATH="${MATTER_ROOT}/slc/tools:${PATH}"
fi

DO_CREATE_PKG=false
DO_BUILD_FROM_PKG=false
MATTER_PACKAGE_VERSION=""
WANT_CLEAN=false
REMAINING_ARGS=()

while [ $# -gt 0 ]; do
	case "$1" in
	--create-package-version)
		[ -n "${2:-}" ] || die "--create-package-version needs a value"
		DO_CREATE_PKG=true
		MATTER_PACKAGE_VERSION="$2"
		shift 2
		;;
	--build-from-package-version)
		[ -n "${2:-}" ] || die "--build-from-package-version needs a value"
		DO_BUILD_FROM_PKG=true
		MATTER_PACKAGE_VERSION="$2"
		shift 2
		;;
	--clean)
		WANT_CLEAN=true
		shift
		;;
	*)
		REMAINING_ARGS+=("$1")
		shift
		;;
	esac
done
set -- "${REMAINING_ARGS[@]}"

if [ "${DO_CREATE_PKG}" = true ] && [ "${DO_BUILD_FROM_PKG}" = true ]; then
	die "use either --create-package-version or --build-from-package-version, not both"
fi

setup_conan() {
	if ! command -v slt >/dev/null 2>&1; then
		die "slt not found (run: python3 slc/sl_setup_env.py)"
	fi

	SLT_HOME="${SLT_HOME:-${HOME}/.silabs/slt}"
	CONAN="${SLT_HOME}/engines/conan/conan/conan"
	export CONAN_HOME="${CONAN_HOME:-${SLT_HOME}/installs/conan}"

	echo "Ensuring SLT Conan engine..."
	slt install conan
	[ -x "${CONAN}" ] || die "SLT Conan missing after install: ${CONAN}"
	echo "Using CONAN=${CONAN}"
	echo "CONAN_HOME=${CONAN_HOME}"
}

remove_matter_packages_from_cache() {
	setup_conan
	echo "Removing local matter / matter_app Conan packages..."
	"${CONAN}" remove "matter/*@silabs" -c || true
	"${CONAN}" remove "matter_app/*@silabs" -c || true
}

export_matter_packages() {
	local ver="$1"

	setup_conan
	echo "MATTER_PACKAGE_VERSION=${ver}"

	echo "Exporting matter/${ver}@silabs ..."
	"${CONAN}" export-pkg "${MATTER_ROOT}/packages/matter/conanfile.py" \
		--name=matter \
		--version="${ver}" \
		--user=silabs

	echo "Exporting matter_app/${ver}@silabs ..."
	"${CONAN}" export-pkg "${MATTER_ROOT}/packages/matter_app/conanfile.py" \
		--name=matter_app \
		--version="${ver}" \
		--user=silabs
}

install_matter_app_package() {
	local ver="$1"
	local ref="matter_app/${ver}@silabs"

	export MATTER_PACKAGE_VERSION="${ver}"
	echo "Installing ${ref} via SLT..."
	slt install "${ref}" -e conan
}

if [ "${DO_CREATE_PKG}" = true ]; then
	[ "${WANT_CLEAN}" = true ] && remove_matter_packages_from_cache
	export_matter_packages "${MATTER_PACKAGE_VERSION}"
	install_matter_app_package "${MATTER_PACKAGE_VERSION}"
	echo "Export done."
	exit 0
fi

if [ "${DO_BUILD_FROM_PKG}" = true ]; then
	if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
		die "--build-from-package-version requires <project.slcp|project.slcw> <board> [options...]"
	fi
	[ "${WANT_CLEAN}" = true ] && remove_matter_packages_from_cache
	export_matter_packages "${MATTER_PACKAGE_VERSION}"
	# build_app.sh only accepts positional project/board when they are the first args.
	exec "${MATTER_ROOT}/packages/build_app.sh" "$1" "$2" --version "${MATTER_PACKAGE_VERSION}" "${@:3}"
fi

# --- Repo development build (default) ---

# Validate required arguments
if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
	die "Missing required arguments. Usage: $0 <slcp/slcw path> <board> [options...]"
fi

SILABS_APP_PATH=$1
SILABS_BOARD=$2
CONFIG_ARGS=""
# tr converts board,part to board_part to avoid breaking clang builds.
BRD_ONLY=$(echo "$SILABS_BOARD" | cut -f1 -d";" | tr ',' '_')
if [ -z "${POST_BUILD_EXE:-}" ]; then
	export POST_BUILD_EXE
	POST_BUILD_EXE="$(command -v commander || true)"
fi

# Resolve project file path (repo-relative or absolute).
if [[ "${SILABS_APP_PATH}" == /* ]]; then
	PROJECT_PATH="${SILABS_APP_PATH}"
elif [ -f "${SILABS_APP_PATH}" ]; then
	PROJECT_PATH="$(cd "$(dirname "${SILABS_APP_PATH}")" && pwd)/$(basename "${SILABS_APP_PATH}")"
elif [ -f "${MATTER_ROOT}/${SILABS_APP_PATH}" ]; then
	PROJECT_PATH="$(cd "$(dirname "${MATTER_ROOT}/${SILABS_APP_PATH}")" && pwd)/$(basename "${SILABS_APP_PATH}")"
else
	die "Project file not found: ${SILABS_APP_PATH}"
fi

PROJECT_APP_DIR="$(dirname "${PROJECT_PATH}")"
PROJECT_FILE="$(basename "${PROJECT_PATH}")"

USE_SOLUTION=false

# Determine vars based on project type provided (.slcw solution example or .slcp project example file)
if [[ "${PROJECT_FILE}" == *.slcw ]]; then
	SILABS_APP=$(basename "$PROJECT_FILE" .slcw)
	MAKE_FILE=$SILABS_APP.solution.Makefile
	PROJECT_FLAG="-w"
	OUTPUT_DIR="${MATTER_ROOT}/out/${BRD_ONLY}/${SILABS_APP}_solution"
	CMAKE_SUBDIR="cmake_llvm"
	USE_SOLUTION=true

elif [[ "${PROJECT_FILE}" == *.slcp ]]; then
	SILABS_APP=$(basename "$PROJECT_FILE" .slcp)
	PROJECT_FLAG="-p"
	OUTPUT_DIR="${MATTER_ROOT}/out/${BRD_ONLY}/${SILABS_APP}"
	MAKE_FILE=$SILABS_APP.Makefile
	CMAKE_SUBDIR="cmake_llvm"
	USE_SOLUTION=false
else
	die "Did not provide a valid path for a .slcw or .slcp project file."
fi

# Remove project path and board from argument list
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
	--skip_gen)
		skip_gen=true
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

if [ "${WANT_CLEAN}" = true ]; then
	rm -rf "${OUTPUT_DIR}"
fi

# Detect LLVM toolchain build by the presence of the toolchain_llvm component.
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

# Prepend local Matter extension into pkg.slconf after slt install.
# Command-line --sdk-package-path replaces slconf paths; patch the file instead.
prepend_sdk_paths_to_slconf() {
	local slconf="${PROJECT_APP_DIR}/autogen/pkg.slconf"
	if [ ! -f "${slconf}" ]; then
		echo "ERROR: missing ${slconf} after slt install"
		exit 1
	fi
	python3 - "${slconf}" "${MATTER_ROOT}" <<'PY'
import sys

path, matter_root = sys.argv[1], sys.argv[2]
extra = [matter_root]

text = open(path, encoding="utf-8").read()
needle = "sdk-package-path = [\n"
if needle not in text:
    raise SystemExit(f"sdk-package-path not found in {path}")

lines = []
for root in extra:
    if f'"{root}"' in text:
        continue
    lines.append(f'  "{root}",    # local sdk path\n')

if not lines:
    sys.exit(0)

text = text.replace(needle, needle + "".join(lines), 1)
open(path, "w", encoding="utf-8").write(text)
PY
}

# Build slc generate argument list (SDK paths from pkg.slconf after slt install).
build_generate_args() {
	local -n _out=$1
	shift
	_out=(generate -d "${OUTPUT_DIR}")
	_out+=("${PROJECT_FLAG}" "${PROJECT_FILE}")
	while [ $# -gt 0 ]; do
		_out+=("$1")
		shift
	done
	_out+=(--generator-timeout=180 -o "${OUTPUT_FORMAT}")
}

run_generate() {
	local gen_args=()
	build_generate_args gen_args "$@"
	# shellcheck disable=SC2086
	run_slc_generate_with_retry "${gen_args[@]}" ${CONFIG_ARGS}
}

if [[ "$OUTPUT_DIR" == *"cmp-concurrent-high-bw-phy-em1" ]]; then
	(cd "${MATTER_ROOT}" && python3 slc/script/em1-augmentation.py EM2)
fi

if ! command -v slc >/dev/null 2>&1; then
	echo "ERROR: please install slc_cli for your host."
	exit 1
fi

if ! command -v slt >/dev/null 2>&1; then
	echo "ERROR: please install slt for your host (run: python3 slc/sl_setup_env.py)."
	exit 1
fi

if [ -z "${ARM_GCC_DIR:-}" ] || [ ! -d "${ARM_GCC_DIR}" ]; then
	echo "ERROR: ARM_GCC_DIR is not set or directory does not exist."
	exit 1
fi

if [ ! -d "${ARM_GCC_DIR}/bin" ]; then
	echo "ERROR: ${ARM_GCC_DIR} path should have a bin folder."
	exit 1
fi

if ! command -v arm-none-eabi-gcc-14.2.1 >/dev/null 2>&1; then
	echo "WARNING: might be an incompatible toolchain."
	echo "Please install gcc-arm-none-eabi-14.2.Rel1 for your host."
fi

echo "Building ${SILABS_APP} for ${SILABS_BOARD} in ${OUTPUT_DIR}"
echo "App dir: ${PROJECT_APP_DIR}"
echo "Project: ${PROJECT_FILE}"

# Make ZAP available to SLC-CLI
if [ -z "${STUDIO_ADAPTER_PACK_PATH:-}" ] || [ ! -f "${STUDIO_ADAPTER_PACK_PATH}/apack.json" ]; then
	if [ -n "${ZAP_INSTALL_PATH:-}" ]; then
		export STUDIO_ADAPTER_PACK_PATH="${ZAP_INSTALL_PATH}"
	fi
fi

if [ ! -f "${PROJECT_APP_DIR}/pkg.slt" ]; then
	echo "ERROR: missing ${PROJECT_APP_DIR}/pkg.slt (run: python3 slc/script/generate_pkg_slt.py -d slc)"
	exit 1
fi

(
	cd "${PROJECT_APP_DIR}"
	echo "Running slt install (project pkg.slt / pkg.slconf)..."
	slt install
	prepend_sdk_paths_to_slconf

	if [ "$skip_gen" = false ]; then
	if [[ "${PROJECT_FILE}" == *.slcw ]]; then
		if [[ "${PROJECT_FILE}" != *wifi_soc* ]] && [ "$GENERATE_BOOTLOADER" = true ]; then
			BOOTLOADER_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_BOOTLOADER_COMPONENTS")
			BOOTLOADER_WITHOUT_ARG=$(build_without_arg "$WITHOUT_BOOTLOADER_COMPONENTS")

			echo "Generating bootloader..."
			# shellcheck disable=SC2086
			run_generate ${BOOTLOADER_WITH_ARG} ${BOOTLOADER_WITHOUT_ARG} -pids bootloader
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate bootloader for: ${PROJECT_FILE}"
				exit 1
			fi
		fi

		if [ "$GENERATE_TZ_SECURE" = true ]; then
			WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")

			echo "Generating trustzone-secure..."
			# shellcheck disable=SC2086
			run_generate ${WITH_ARG} -pids trustzone-secure
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate trustzone-secure for: ${PROJECT_FILE}"
				exit 1
			fi
		fi

		if [[ "${PROJECT_FILE}" != *bootloader* ]] && [ "$GENERATE_APPLICATION" = true ]; then
			APP_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")
			APP_WITHOUT_ARG=$(build_without_arg "$WITHOUT_APP_COMPONENTS")

			echo "Generating application..."
			# shellcheck disable=SC2086
			run_generate ${APP_WITH_ARG} ${APP_WITHOUT_ARG} -pids application
			if [ $? -ne 0 ]; then
				echo "ERROR: Failed to generate application for: ${PROJECT_FILE}"
				exit 1
			fi
		fi
	else
		APP_WITH_ARG=$(build_with_arg "$SILABS_BOARD" "$WITH_APP_COMPONENTS")
		APP_WITHOUT_ARG=$(build_without_arg "$WITHOUT_APP_COMPONENTS")
		# shellcheck disable=SC2086
		run_generate ${APP_WITH_ARG} ${APP_WITHOUT_ARG}
		if [ $? -ne 0 ]; then
			echo "ERROR: Failed to generate project for: ${PROJECT_FILE}"
			exit 1
		fi
	fi
	fi
)

# Build the project
if [ "$GENERATE_BOOTLOADER" = true ] && [ "$GENERATE_APPLICATION" = false ]; then
	echo "Building bootloader only..."
	if [ "$USE_LLVM" = true ]; then
		BOOTLOADER_CMAKE_DIR=$(find "${OUTPUT_DIR}/matter_bootloader" -maxdepth 1 -name "cmake_llvm" -type d | head -1)
		if [ -z "$BOOTLOADER_CMAKE_DIR" ]; then
			echo "ERROR: No bootloader cmake_llvm dir found in ${OUTPUT_DIR}/matter_bootloader"
			exit 1
		fi
		cmake_configure_and_build "$BOOTLOADER_CMAKE_DIR" "bootloader" || exit 1
	else
		BOOTLOADER_MAKEFILE=$(find "${OUTPUT_DIR}/matter_bootloader" -maxdepth 1 -name "*.Makefile" | head -1)
		if [ -z "$BOOTLOADER_MAKEFILE" ]; then
			echo "ERROR: No bootloader Makefile found in ${OUTPUT_DIR}/matter_bootloader"
			exit 1
		fi
		BOOTLOADER_MAKEFILE_NAME=$(basename "$BOOTLOADER_MAKEFILE")
		if ! make all -C "${OUTPUT_DIR}/matter_bootloader" -f "$BOOTLOADER_MAKEFILE_NAME" -j13; then
			echo "ERROR: Failed to build bootloader"
			exit 1
		fi
	fi
elif [ "$GENERATE_BOOTLOADER" = false ] && [ "$GENERATE_APPLICATION" = true ]; then
	echo "Building application only..."
	if [ "$USE_LLVM" = true ]; then
		APP_CMAKE_DIR=$(find "${OUTPUT_DIR}" -mindepth 2 -maxdepth 2 -name "cmake_llvm" -type d ! -path "*matter-bootloader*" | head -1)
		if [ -z "$APP_CMAKE_DIR" ]; then
			echo "ERROR: No application cmake_llvm dir found in ${OUTPUT_DIR}"
			exit 1
		fi
		cmake_configure_and_build "$APP_CMAKE_DIR" "application" || exit 1
	else
		APP_MAKEFILE=$(find "${OUTPUT_DIR}" -mindepth 2 -maxdepth 2 -name "*.Makefile" ! -name "*.solution.Makefile" | head -1)
		if [ -z "$APP_MAKEFILE" ]; then
			echo "ERROR: No application Makefile found in ${OUTPUT_DIR}"
			exit 1
		fi
		APP_BUILD_DIR=$(dirname "$APP_MAKEFILE")
		APP_MAKEFILE_NAME=$(basename "$APP_MAKEFILE")
		if ! make all -C "$APP_BUILD_DIR" -f "$APP_MAKEFILE_NAME" -j13; then
			echo "ERROR: Failed to build application"
			exit 1
		fi
	fi
else
	echo "Building solution..."
	if [ "$USE_LLVM" = true ]; then
		cmake_configure_and_build "${OUTPUT_DIR}/${CMAKE_SUBDIR}" "solution" || exit 1
	else
		if ! make all -C "${OUTPUT_DIR}" -f "$MAKE_FILE" -j13; then
			echo "ERROR: Failed to build solution"
			exit 1
		fi
	fi
fi

if [[ "$OUTPUT_DIR" == *"cmp-concurrent-high-bw-phy-em1" ]]; then
	(cd "${MATTER_ROOT}" && python3 slc/script/em1-augmentation.py EM1)
fi
