#!/usr/bin/env bash
# Build a Matter sample from installed Conan/SLT packages (matter + matter_app).
#
# Independent of a git checkout: no --export and no submodule updates.
# Installs SLT tools (conan, slc-cli, zap) and OS packages (make, find) as needed.
#
# Usage:
#   ./packages/build_app.sh <project.slcp|project.slcw> <board> [options...]
#   ./packages/build_app.sh matter_wifi_soc_lighting_app_freertos.slcw brd4338a
#   ./packages/build_app.sh --slcp <name>.slcp --board <board> --version 2.10.0-alpha.8
#   "$(slt where matter_app)/build_app.sh" --project <name>.slcp --board <board>
#
# Options:
#   --project NAME           Sample .slcp/.slcw basename (required)
#   --slcp NAME              Alias for --project
#   --board BOARD            Board id, e.g. brd4338a (required)
#   --version VER            matter_app version to install (default: env MATTER_PACKAGE_VERSION
#                            or 2.10.0)
#   --output_suffix SUFFIX   Append a suffix to the output directory
#   --with_app COMPONENTS    Add components to the application
#   --without_app COMPONENTS Remove components from the application
#   --with_bootloader LIST   Add components to the bootloader
#   --without_bootloader LIST Remove components from the bootloader
#   -pids PID                Build application, bootloader, or trustzone solution PIDs
#   --clean                   Remove the output directory before building
#   --skip_gen                Skip SLC generation and rebuild existing output
#   -j N                     make -jN (default: 8)
#   -h, --help               Show this help
#
# Prerequisites: `slt` on PATH. Uses SLT Conan engine (~/.silabs/slt/engines/conan).

set -euo pipefail

VERSION_DEFAULT="2.10.0"
MATTER_PACKAGE_VERSION="${MATTER_PACKAGE_VERSION:-${VERSION_DEFAULT}}"
PROJECT=""
BOARD=""
JOBS=8
OUTPUT_SUFFIX=""
WITH_APP_COMPONENTS=""
WITHOUT_APP_COMPONENTS=""
WITH_BOOTLOADER_COMPONENTS=""
WITHOUT_BOOTLOADER_COMPONENTS=""
PIDS=""
CLEAN=false
SKIP_GEN=false
EXTRA_GENERATE_ARGS=()

# Print the header comment block as help text, then exit (arg: exit code).
usage() {
  sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
  exit "${1:-0}"
}

# Print an error to stderr and exit with status 1.
die() {
  echo "error: $*" >&2
  exit 1
}

# Abort if the named command is not on PATH.
need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

# Install an OS package when the command is missing (apt-based systems).
# Args: command name, optional apt package name (defaults to command name).
ensure_os_cmd() {
  local cmd="$1"
  local pkg="${2:-$1}"
  if command -v "${cmd}" >/dev/null 2>&1; then
    return 0
  fi
  if command -v apt-get >/dev/null 2>&1; then
    echo "Installing OS package: ${pkg} (provides ${cmd})"
    if [[ "$(id -u)" -eq 0 ]]; then
      apt-get update -qq
      apt-get install -y "${pkg}"
    else
      need_cmd sudo
      sudo apt-get update -qq
      sudo apt-get install -y "${pkg}"
    fi
  else
    die "required command not found: ${cmd} (install package '${pkg}')"
  fi
  need_cmd "${cmd}"
}

if [[ $# -ge 2 && "$1" != -* ]]; then
  PROJECT="$1"
  BOARD="$2"
  shift 2
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project | --slcp)
      PROJECT="${2:-}"
      [[ -n "${PROJECT}" ]] || die "$1 needs a value"
      shift 2
      ;;
    --board)
      BOARD="${2:-}"
      [[ -n "${BOARD}" ]] || die "--board needs a value"
      shift 2
      ;;
    --version)
      MATTER_PACKAGE_VERSION="${2:-}"
      [[ -n "${MATTER_PACKAGE_VERSION}" ]] || die "--version needs a value"
      shift 2
      ;;
    --output_suffix)
      OUTPUT_SUFFIX="${2:-}"
      [[ -n "${OUTPUT_SUFFIX}" ]] || die "--output_suffix needs a value"
      shift 2
      ;;
    --output_suffix\ *)
      OUTPUT_SUFFIX="${1#--output_suffix }"
      shift
      ;;
    --with_app)
      WITH_APP_COMPONENTS="${2:-}"
      [[ -n "${WITH_APP_COMPONENTS}" ]] || die "--with_app needs a value"
      shift 2
      ;;
    --with_app\ *)
      WITH_APP_COMPONENTS="${1#--with_app }"
      shift
      ;;
    --without_app)
      WITHOUT_APP_COMPONENTS="${2:-}"
      [[ -n "${WITHOUT_APP_COMPONENTS}" ]] || die "--without_app needs a value"
      shift 2
      ;;
    --without_app\ *)
      WITHOUT_APP_COMPONENTS="${1#--without_app }"
      shift
      ;;
    --with_bootloader)
      WITH_BOOTLOADER_COMPONENTS="${2:-}"
      [[ -n "${WITH_BOOTLOADER_COMPONENTS}" ]] || die "--with_bootloader needs a value"
      shift 2
      ;;
    --with_bootloader\ *)
      WITH_BOOTLOADER_COMPONENTS="${1#--with_bootloader }"
      shift
      ;;
    --without_bootloader)
      WITHOUT_BOOTLOADER_COMPONENTS="${2:-}"
      [[ -n "${WITHOUT_BOOTLOADER_COMPONENTS}" ]] || die "--without_bootloader needs a value"
      shift 2
      ;;
    --without_bootloader\ *)
      WITHOUT_BOOTLOADER_COMPONENTS="${1#--without_bootloader }"
      shift
      ;;
    -pids)
      PIDS="${2:-}"
      [[ -n "${PIDS}" ]] || die "-pids needs a value"
      shift 2
      ;;
    -pids\ *)
      PIDS="${1#-pids }"
      shift
      ;;
    --configuration)
      [[ -n "${2:-}" ]] || die "--configuration needs a value"
      EXTRA_GENERATE_ARGS+=(--configuration "$2")
      shift 2
      ;;
    --configuration\ *)
      EXTRA_GENERATE_ARGS+=(--configuration "${1#--configuration }")
      shift
      ;;
    --clean)
      CLEAN=true
      shift
      ;;
    --skip_gen)
      SKIP_GEN=true
      shift
      ;;
    -j)
      JOBS="${2:-}"
      [[ -n "${JOBS}" ]] || die "-j needs a value"
      shift 2
      ;;
    -h | --help)
      usage 0
      ;;
    *)
      EXTRA_GENERATE_ARGS+=("$1")
      shift
      ;;
  esac
done

# LLVM builds require CMake output (same rule as slc/build.sh).
CONFIG_ARGS="${EXTRA_GENERATE_ARGS[*]:-} ${WITH_APP_COMPONENTS}"
USE_LLVM=false
if [[ "${CONFIG_ARGS}" == *toolchain_llvm* ]]; then
  USE_LLVM=true
fi
if [[ "${USE_LLVM}" == true ]]; then
  OUTPUT_FORMAT="cmake"
  CMAKE_SUBDIR="cmake_llvm"
else
  OUTPUT_FORMAT="makefile"
  CMAKE_SUBDIR=""
fi

cmake_configure_and_build() {
  local src_dir="$1"
  local label="$2"

  if [[ ! -f "${src_dir}/CMakeLists.txt" ]]; then
    die "${label} CMakeLists.txt not found at ${src_dir}"
  fi
  if [[ ! -f "${src_dir}/CMakePresets.json" ]]; then
    die "${label} CMakePresets.json not found at ${src_dir}"
  fi
  if ! (cd "${src_dir}" && cmake --preset project -DPOST_BUILD_EXE="${POST_BUILD_EXE:-}"); then
    die "failed to configure ${label}"
  fi
  if ! (cd "${src_dir}" && cmake --build --preset default_config -j"${JOBS}"); then
    die "failed to build ${label}"
  fi
}

[[ -n "${PROJECT}" && -n "${BOARD}" ]] || die "need both --project and --board"
if [[ "${PROJECT}" != *.slcp && "${PROJECT}" != *.slcw ]]; then
  PROJECT="${PROJECT}.slcp"
fi

export MATTER_PACKAGE_VERSION
REF="matter_app/${MATTER_PACKAGE_VERSION}@silabs"
echo "MATTER_PACKAGE_VERSION=${MATTER_PACKAGE_VERSION}"

need_cmd slt

SLT_HOME="${SLT_HOME:-${HOME}/.silabs/slt}"
CONAN="${SLT_HOME}/engines/conan/conan/conan"
export CONAN_HOME="${CONAN_HOME:-${SLT_HOME}/installs/conan}"

echo "Installing SLT tools (conan, slc-cli, zap)..."
slt install conan
# Matter slt_requirements use package id "slc-cli" (6.0.23+), not legacy "slc_cli" (6.0.9).
slt install slc-cli
slt install zap
[[ -x "${CONAN}" ]] || die "SLT Conan missing after install: ${CONAN}"
echo "Using CONAN=${CONAN}"
echo "CONAN_HOME=${CONAN_HOME}"

# Put a usable `slc` on PATH from SLT installs.
# Prefers package id "slc-cli" (Matter / 6.0.23+) over legacy "slc_cli" / "slc_cli_base" (6.0.9).
# Falls back to scanning SLT archive installs if `slt where` does not resolve.
ensure_slc_on_path() {
  local cand dir
  for cand in \
    "$(slt where slc-cli 2>/dev/null || true)" \
    "$(slt where slc_cli 2>/dev/null || true)" \
    "$(slt where slc_cli_base 2>/dev/null || true)"; do
    [[ -n "${cand}" ]] || continue
    for dir in "${cand}" "${cand}/slc_cli" "${cand}/bin"; do
      if [[ -x "${dir}/slc" ]]; then
        export PATH="${dir}:${PATH}"
        echo "Using slc from ${dir} ($("${dir}/slc" -version 2>/dev/null || echo unknown))"
        return 0
      fi
    done
  done

  # Fallback: prefer archive installs named slc-cli-* (newer) over slc_cli_*
  cand="$(find "${SLT_HOME}/installs/archive" -type f -path '*/slc-cli-*/slc_cli/slc' -executable 2>/dev/null | sort -r | head -n1 || true)"
  if [[ -z "${cand}" ]]; then
    cand="$(find "${SLT_HOME}/installs/archive" -type f -name slc -executable 2>/dev/null | sort -r | head -n1 || true)"
  fi
  if [[ -n "${cand}" ]]; then
    dir="$(dirname "${cand}")"
    export PATH="${dir}:${PATH}"
    echo "Using slc from ${dir} ($("${dir}/slc" -version 2>/dev/null || echo unknown))"
    return 0
  fi

  return 1
}


echo "Ensuring OS build tools (make, find)..."
ensure_os_cmd make make
ensure_os_cmd find findutils
if [[ "${USE_LLVM}" == true ]]; then
  ensure_os_cmd cmake cmake
fi

ensure_slc_on_path || die "slc not found after slt install slc-cli"

need_cmd slc
need_cmd make
need_cmd find
if [[ "${USE_LLVM}" == true ]]; then
  need_cmd cmake
fi

if [[ -z "${POST_BUILD_EXE:-}" ]]; then
  POST_BUILD_EXE="$(command -v commander 2>/dev/null || true)"
fi
export POST_BUILD_EXE

echo "Installing ${REF} via SLT..."
slt install "${REF}" -e conan

MATTER_APP="$(slt where matter_app)"
MATTER="$(slt where matter)"
[[ -n "${MATTER_APP}" ]] || die "slt where matter_app returned empty"
[[ -n "${MATTER}" ]] || die "slt where matter returned empty"
echo "MATTER_APP=${MATTER_APP}"
echo "MATTER=${MATTER}"

print_pkg_meta_version() {
  local root="$1"
  local label="$2"
  local meta="${root}/../d/metadata/package_metadata.yaml"
  local ver=""
  if [[ -f "${meta}" ]]; then
    ver="$(sed -n 's/^version:[[:space:]]*//p' "${meta}" | head -n1)"
  fi
  echo "${label} package version=${ver:-unknown}"
}

print_pkg_meta_version "${MATTER_APP}" "matter_app"
print_pkg_meta_version "${MATTER}" "matter"

# Accept repo-relative paths (matter_build_action / slc/build.sh style) or basenames.
if [[ -f "${MATTER_APP}/${PROJECT}" ]]; then
  PROJECT_PATH="${MATTER_APP}/${PROJECT}"
elif [[ -f "${PROJECT}" ]]; then
  PROJECT_PATH="${PROJECT}"
else
  PROJECT_BASENAME="$(basename "${PROJECT}")"
  PROJECT_PATH="$(find "${MATTER_APP}" -type f -name "${PROJECT_BASENAME}" 2>/dev/null | head -n1 || true)"
fi
[[ -n "${PROJECT_PATH}" ]] || die "could not find ${PROJECT} under ${MATTER_APP}"
PROJECT="$(basename "${PROJECT_PATH}")"

APP_DIR="$(dirname "${PROJECT_PATH}")"
if [[ "${PROJECT}" == *.slcw ]]; then
  PROJECT_BASE="${PROJECT%.slcw}"
  PROJECT_FLAG="-w"
  MAKEFILE="${PROJECT_BASE}.solution.Makefile"
  BOARD_DIR="$(printf '%s' "${BOARD}" | cut -d';' -f1 | tr ',' '_')"
  OUT_DIR="out/${BOARD_DIR}/${PROJECT_BASE}_solution"
else
  PROJECT_BASE="${PROJECT%.slcp}"
  PROJECT_FLAG="-p"
  MAKEFILE="${PROJECT_BASE}.Makefile"
  BOARD_DIR="$(printf '%s' "${BOARD}" | cut -d';' -f1 | tr ',' '_')"
  OUT_DIR="out/${BOARD_DIR}/${PROJECT_BASE}"
fi
if [[ -n "${OUTPUT_SUFFIX}" ]]; then
  OUT_DIR="${OUT_DIR}_${OUTPUT_SUFFIX}"
fi
if [[ "${CLEAN}" == true ]]; then
  rm -rf "${APP_DIR:?}/${OUT_DIR}"
fi

echo "App dir: ${APP_DIR}"
echo "Project: ${PROJECT}  board: ${BOARD}  out: ${OUT_DIR}"

cd "${APP_DIR}"

echo "Running slt install (project pkg.slt / pkg.slconf)..."
slt install

run_generate() {
  local pid="$1"
  local with_components="$2"
  local without_components="$3"
  local with_value="${BOARD}"
  local args=()

  if [[ -n "${with_components}" ]]; then
    with_value="${with_value},${with_components}"
  fi
  args=(generate -d "${OUT_DIR}" "${PROJECT_FLAG}" "${PROJECT}" --with "${with_value}")
  if [[ -n "${without_components}" ]]; then
    args+=(--without "${without_components}")
  fi
  if [[ -n "${pid}" ]]; then
    args+=(-pids "${pid}")
  fi
  args+=("${EXTRA_GENERATE_ARGS[@]}")
  args+=(--generator-timeout=300 -o "${OUTPUT_FORMAT}")

  echo "Running slc ${args[*]}"
  slc "${args[@]}"
}

if [[ "${PROJECT_FLAG}" == "-p" ]]; then
  if [[ "${SKIP_GEN}" == false ]]; then
    run_generate "" "${WITH_APP_COMPONENTS}" "${WITHOUT_APP_COMPONENTS}"
  fi
  if [[ "${USE_LLVM}" == true ]]; then
    cmake_configure_and_build "${OUT_DIR}/${CMAKE_SUBDIR}" "project"
  else
    [[ -f "${OUT_DIR}/${MAKEFILE}" ]] || die "expected ${OUT_DIR}/${MAKEFILE} after generate"
    echo "Building with make -j${JOBS}..."
    make -C "${OUT_DIR}" -f "${MAKEFILE}" -j"${JOBS}"
  fi
else
  GENERATE_BOOTLOADER=true
  GENERATE_APPLICATION=true
  GENERATE_TRUSTZONE=false
  case "${PIDS}" in
    "")
      ;;
    application)
      GENERATE_BOOTLOADER=false
      ;;
    bootloader)
      GENERATE_APPLICATION=false
      ;;
    trustzone)
      GENERATE_TRUSTZONE=true
      ;;
    *)
      die "invalid -pids value: ${PIDS}"
      ;;
  esac

  if [[ "${SKIP_GEN}" == false ]]; then
    if [[ "${PROJECT}" != *wifi_soc* && "${GENERATE_BOOTLOADER}" == true ]]; then
      run_generate bootloader "${WITH_BOOTLOADER_COMPONENTS}" "${WITHOUT_BOOTLOADER_COMPONENTS}"
    fi
    if [[ "${GENERATE_TRUSTZONE}" == true ]]; then
      run_generate trustzone-secure "${WITH_APP_COMPONENTS}" ""
    fi
    if [[ "${PROJECT}" != *bootloader* && "${GENERATE_APPLICATION}" == true ]]; then
      run_generate application "${WITH_APP_COMPONENTS}" "${WITHOUT_APP_COMPONENTS}"
    fi
  fi

  if [[ "${USE_LLVM}" == true ]]; then
    if [[ "${GENERATE_BOOTLOADER}" == true && "${GENERATE_APPLICATION}" == false ]]; then
      BUILD_CMAKE_DIR="$(find "${OUT_DIR}/matter_bootloader" -maxdepth 1 -name "${CMAKE_SUBDIR}" -type d -print -quit)"
      [[ -n "${BUILD_CMAKE_DIR}" ]] || die "bootloader ${CMAKE_SUBDIR} not found under ${OUT_DIR}"
      cmake_configure_and_build "${BUILD_CMAKE_DIR}" "bootloader"
    elif [[ "${GENERATE_BOOTLOADER}" == false && "${GENERATE_APPLICATION}" == true ]]; then
      BUILD_CMAKE_DIR="$(find "${OUT_DIR}" -mindepth 2 -maxdepth 2 -name "${CMAKE_SUBDIR}" -type d ! -path "*matter-bootloader*" -print -quit)"
      [[ -n "${BUILD_CMAKE_DIR}" ]] || die "application ${CMAKE_SUBDIR} not found under ${OUT_DIR}"
      cmake_configure_and_build "${BUILD_CMAKE_DIR}" "application"
    else
      cmake_configure_and_build "${OUT_DIR}/${CMAKE_SUBDIR}" "solution"
    fi
  elif [[ "${GENERATE_BOOTLOADER}" == true && "${GENERATE_APPLICATION}" == false ]]; then
    BUILD_MAKEFILE="$(find "${OUT_DIR}/matter_bootloader" -maxdepth 1 -name "*.Makefile" -print -quit)"
    [[ -n "${BUILD_MAKEFILE}" ]] || die "bootloader Makefile not found under ${OUT_DIR}"
    BUILD_DIR="$(dirname "${BUILD_MAKEFILE}")"
    MAKEFILE="$(basename "${BUILD_MAKEFILE}")"
    echo "Building with make -j${JOBS}..."
    make all -C "${BUILD_DIR}" -f "${MAKEFILE}" -j"${JOBS}"
  elif [[ "${GENERATE_BOOTLOADER}" == false && "${GENERATE_APPLICATION}" == true ]]; then
    BUILD_MAKEFILE="$(find "${OUT_DIR}" -mindepth 2 -maxdepth 2 -name "*.Makefile" ! -name "*.solution.Makefile" -print -quit)"
    [[ -n "${BUILD_MAKEFILE}" ]] || die "application Makefile not found under ${OUT_DIR}"
    BUILD_DIR="$(dirname "${BUILD_MAKEFILE}")"
    MAKEFILE="$(basename "${BUILD_MAKEFILE}")"
    echo "Building with make -j${JOBS}..."
    make all -C "${BUILD_DIR}" -f "${MAKEFILE}" -j"${JOBS}"
  else
    BUILD_DIR="${OUT_DIR}"
    [[ -f "${BUILD_DIR}/${MAKEFILE}" ]] || die "expected ${BUILD_DIR}/${MAKEFILE} after generate"
    echo "Building with make -j${JOBS}..."
    make all -C "${BUILD_DIR}" -f "${MAKEFILE}" -j"${JOBS}"
  fi
fi

echo "Done: ${APP_DIR}/${OUT_DIR}"
