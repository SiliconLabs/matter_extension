#!/bin/bash

# Example usage:
# ./build.sh lighting-app brd4161a

SILABS_APP=$1
SILABS_BOARD=$2

echo "Building $SILABS_APP for $SILABS_BOARD"

MATTER_ROOT=$( cd "../" ; pwd -P )
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
slc generate -d sample-app/$SILABS_APP/$SILABS_BOARD -p sample-app/$SILABS_APP/$SILABS_APP.slcp -s $GSDK_ROOT --with $SILABS_BOARD

make -C sample-app/$SILABS_APP/$SILABS_BOARD -f $SILABS_APP.Makefile -j4
