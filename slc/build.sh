#!/usr/bin/env bash

# This script generates and builds the SLC project for the given Matter application and board.
#
#   Usage:
#   ./slc/build.sh <slcp/slcw path> <board>
#
#   Example .slcp usage:
#   ./slc/build.sh slc/sample-app/lighting-app/efr32/lighting-app-thread.slcp brd4187c
#       output in: out/brd4187c/lighting-app-thread/
#
#   Example .slcw usage:
#   ./slc/build.sh slc/solutions/lighting-app/series-2/lighting-app-thread-bootloader.slcw brd4187c
#       output in: out/brd4187c/lighting-app-thread-solution/
#
#   Example --configuration option usage:
#   ./slc/build.sh slc/sample-app/lighting-app/efr32/lighting-app-thread.slcp brd4187c --configuration CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION:20,CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION_STRING:\"1.0.0-1.0\"
#       output in: out/brd4187c/lighting-app-thread/
#
#   --skip_gen option : Allows to skip the slc gen step and only run the make commande to rebuild modified files. slc gen normally regenerate your config, autogen, linker_options and makefile for your output folder.
#                       This option only works if the project as previously been generated
#   Example 
#   ./slc/build.sh slc/sample-app/lighting-app/efr32/lighting-app-thread.slcp brd4187c --skip_gen
#       output in: out/brd4187c/lighting-app-thread/
#
#   --sisdk option : Allows to build a project using a different SISDK folder, at the provided path, rather than the default one found in third_party/simplicity_sdk
#   Example 
#   ./slc/build.sh slc/sample-app/lighting-app/efr32/lighting-app-thread.slcp brd4187c --sisdk /Users/Shared/silabs/Github/sisdk
#       output in: out/brd4187c/lighting-app-thread/
#


MATTER_ROOT=$( pwd -P )
GSDK_ROOT=$MATTER_ROOT/third_party/simplicity_sdk
SILABS_APP_PATH=$1
SILABS_BOARD=$2
CONFIG_ARGS=""
BRD_ONLY=$(echo $SILABS_BOARD | cut -f1 -d";")
export POST_BUILD_EXE=$(which commander)

# Determine vars based on project type provided (.slcw solution example or .slcp project example file)
if [[ "$SILABS_APP_PATH" == *.slcw ]]; then
    if [[ "$SILABS_APP_PATH" == *917-soc* ]]; then
        SILABS_APP=$(basename "$SILABS_APP_PATH" .slcw)
        MAKE_FILE=$SILABS_APP.solution.Makefile
    else
        SILABS_APP=$(basename "$SILABS_APP_PATH" -bootloader.slcw)
        MAKE_FILE=$SILABS_APP-bootloader.solution.Makefile
    fi
    PROJECT_FLAG="-w"
    OUTPUT_DIR="out/$BRD_ONLY/$SILABS_APP-solution"

elif [[ "$SILABS_APP_PATH" == *.slcp ]]; then
    SILABS_APP=$(basename "$SILABS_APP_PATH" .slcp)
    PROJECT_FLAG="-p"
    OUTPUT_DIR="out/$BRD_ONLY/$SILABS_APP"
    MAKE_FILE=$SILABS_APP.Makefile

else
    echo "Did not provide a valid path for to .slcw or .slcp project file. Returning."
    exit
fi

# remove SILABS_APP_PATH and SILABS_BOARD from list of input args
shift 
shift 
skip_gen=false
while [ $# -gt 0 ]; do
    case "$1" in
    --clean)
        rm -rf $OUTPUT_DIR
        shift
        ;;
    --skip_gen)
        skip_gen=true
        shift
        ;;
    --sisdk)
        GSDK_ROOT="$2"
        shift
        shift
        ;;
    *)
        CONFIG_ARGS+="$1 "
        shift
        ;;
    esac
done
echo $CONFIG_ARGS
# Generate project


if ! [ -x "$(command -v slc)" ]; then
    echo "ERROR: please install slc_cli for your host."
    exit
fi 

if ! [ -d "$ARM_GCC_DIR" ]; then
    echo "ERROR: ARM_GCC_DIR is nil."
    exit
fi

if ! [ -d "$ARM_GCC_DIR/bin" ]; then
    echo "ERROR: $ARM_GCC_DIR path should have a bin folder."
    exit
fi

if ! [ -x "$(command -v arm-none-eabi-gcc)" ]; then
    echo "ERROR: $ARM_GCC_DIR/bin missing from PATH"
    echo "Run export PATH='\$PATH:$ARM_GCC_DIR/bin' to add to PATH"
    exit
fi

if ! [ -x "$(command -v arm-none-eabi-gcc-12.2.1)" ]; then
    echo "WARNING: might be an incompatible toolchain."
    echo "Please install gcc-arm-none-eabi-12.2.Rel1 for your host."
fi 

echo "Building $SILABS_APP for $SILABS_BOARD in $OUTPUT_DIR"

# Ensure Matter repo is registered as SDK extension
[ -d $GSDK_ROOT/extension ] && echo "Directory $GSDK_ROOT/extension exists." || mkdir $GSDK_ROOT/extension

EXTENSION_DIR=$GSDK_ROOT/extension/matter_extension
if [ ! -L "$EXTENSION_DIR" ]; then
    ln -s $MATTER_ROOT "$EXTENSION_DIR"
fi

WISECONNECT3_DIR=$GSDK_ROOT/extension/wifi_sdk
if [ ! -L "$WISECONNECT3_DIR" ]; then
    ln -s $MATTER_ROOT/third_party/wifi_sdk/ "$WISECONNECT3_DIR"
fi

ThirdPartyHwDrivers_DIR=third_party/third_party_hw_drivers_extension

# Trust SDK and Matter extension
echo "Ensure SDK and Matter extension are trusted by SLC."
slc configuration --sdk $GSDK_ROOT
slc signature trust --development-trust
slc signature trust  --extension-path "$EXTENSION_DIR"
slc signature trust --sdk $GSDK_ROOT --extension-path "$WISECONNECT3_DIR"
slc signature trust --extension-path "$ThirdPartyHwDrivers_DIR"

# Make ZAP available to SLC-CLI
if [ ! -f "$STUDIO_ADAPTER_PACK_PATH/apack.json" ]; then
    export STUDIO_ADAPTER_PACK_PATH=$ZAP_INSTALL_PATH
fi

if [ "$skip_gen" = false ]; then
    slc generate -d $OUTPUT_DIR $PROJECT_FLAG $SILABS_APP_PATH --with $SILABS_BOARD $CONFIG_ARGS --generator-timeout=180 -o makefile
    if [ $? -ne 0 ]; then
        echo "FAILED TO Generate : $SILABS_APP_PATH"
        exit 1
    fi
fi  

make all -C $OUTPUT_DIR -f $MAKE_FILE -j13
