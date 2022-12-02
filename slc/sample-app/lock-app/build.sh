#!/bin/bash

SILABS_BOARD=${1:-brd4161a}
echo "Building for $SILABS_BOARD"

MATTER_ROOT=$( cd "../../.." ; pwd -P )
GSDK_ROOT=$MATTER_ROOT/third_party/silabs/gecko_sdk

# Ensure Matter repo is registered as SDK extension

[ -d $GSDK_ROOT/extension ] && echo "Directory $GSDK_ROOT/extension exists." || mkdir $GSDK_ROOT/extension

EXTENSION_DIR=$GSDK_ROOT/extension/matter
if [ ! -L "$EXTENSION_DIR" ]; then
    ln -s ../../../../ $EXTENSION_DIR
fi

# Trust SDK and Matter extension
echo "Ensure SDK and Matter extension are trusted by SLC."
slc signature trust --sdk $GSDK_ROOT
slc signature trust --sdk $GSDK_ROOT --extension-path "$GSDK_ROOT/extension/matter/"

# Make ZAP available to SLC-CLI
export STUDIO_ADAPTER_PACK_PATH="$MATTER_ROOT/third_party/zap/repo/"

while [ $# -gt 0 ]; do
    case "$1" in
    --clean)
        rm -rf $SILABS_BOARD
        shift
        ;;
    *)
        shift
        ;;
    esac
done

# Generate project
slc generate -d $SILABS_BOARD -p lock-app.slcp -s $GSDK_ROOT --with $SILABS_BOARD

make -C $SILABS_BOARD -f lock-app.Makefile -j4
