#!/bin/bash

#path to the build chip-tool
#if Vars are have no values, set default ones
if [[ ! $MATTER_ROOT  ]]; then
	export MATTER_ROOT="$HOME/connectedhomeip"
fi

if [[ ! $CHIPTOOL_PATH  ]]; then
	export CHIPTOOL_PATH="$MATTER_ROOT/out/standalone/chip-tool"
fi

if [[ ! $PINCODE  ]]; then
	export PINCODE=20202021
fi

if [[ ! $DISCRIMINATOR ]]; then
	export DISCRIMINATOR=3840
fi

if [[ ! $ENDPOINT ]]; then
	export ENDPOINT=1
fi

if [[ ! $NODE_ID ]]; then
	export NODE_ID=$((1 + $RANDOM % 100000))
fi

if [[ ! $LAST_NODE_ID ]]; then
	export LAST_NODE_ID="0"
fi

if [[ ! $THREAD_DATA_SET ]]; then
	export THREAD_DATA_SET="0"
fi

echo_green() {
    echo -e "\033[0;32m$*\033[0m"
}

echo_blue() {
    echo -e "\033[1;34m$*\033[0m"
}

echo_bold_white() {
    echo -e "\033[1;37m$*\033[0m"
}

Print_Help()
{
	echo "This bash script centralize and simplifies the use of chip-tool and starting a clean thread network"
	echo "Here is and overview of the Available cmds :"
	for commands in "${!cmd_list[@]}"; do echo $commands; done

	echo_bold_white "Available options  :"
	echo " -h, --help			Print this help"
	echo " -n, --nodeId DIGIT		Specify the Nodeid you are trying to reach"
	echo " -di, --discriminator DIGIT		Specify the discriminator of the device to commission"
	echo " -e, --endpoint DIGIT		Specify an endpoint to the desired the cluster"
	echo " -d, --dataset HEX_STRING       Thread Operation Dataset"
	echo " -s, --ssid STRING		WiFi AP ssid that the end devices needs to connect to"
	echo " -p, --password STRING		WiFi AP password"
	echo_green "Those configurations are held until the device is rebooted !"

	Print_Vars

	echo_green "You can also enter the full chip-tool command (without the chip-tool)
		e.g Mattertool levelcontrol read current-level 106 1"
}

Print_Vars()
{
	echo_bold_white "Active Vars:"
	echo "	MATTER_ROOT: $MATTER_ROOT "
	echo "	CHIPTOOL_PATH: $CHIPTOOL_PATH "
	echo "	NODE_ID:$NODE_ID"
	echo "	THREAD_DATA_SET: $THREAD_DATA_SET"
	echo "	PINCODE: $PINCODE"
	echo "	DISCRIMINATOR: $DISCRIMINATOR"
	echo "	SSID: $SSID"
	echo "	LAST_NODE_ID: $LAST_NODE_ID"
	echo_green "You can preset them with export X=Y before running the script"
}

Clean_Vars()
{
	echo_blue "Erasing Vars:"
	unset MATTER_ROOT
	unset CHIPTOOL_PATH
	unset NODE_ID
	unset THREAD_DATA_SET
	unset PINCODE
	unset DISCRIMINATOR
	unset SSID
	unset WIFI_PW
	unset LAST_NODE_ID
}

# Clean Build chip-tool from the given MATTER_ROOT path.
# Deletes any prior build and saved sessions information.
Clean_build_ChipTool ()
{
	echo_blue "Clean Build of Chip-tool"
	rm -rf "$MATTER_ROOT"/out
	rm -rf "$MATTER_ROOT"/tmp/chp_*
	"$MATTER_ROOT"/scripts/examples/gn_build_example.sh "$MATTER_ROOT"/examples/chip-tool "$MATTER_ROOT"/out/standalone
}

# Build or Rebuild chip-tool from the given MATTER_ROOT path.
# Not clean if it was previously built
Rebuild_ChipTool ()
{
	echo_blue "Rebuild Chip-tool"
	"$MATTER_ROOT"/scripts/examples/gn_build_example.sh "$MATTER_ROOT"/examples/chip-tool "$MATTER_ROOT"/out/standalone
}

#Start a Clean ThreadNetwork and save obtained dataset value for use in the thread provisionning command
Start_ThreadNetwork()
{
	echo_green "Starting a new thread network"
	sudo ot-ctl factoryreset
	sleep 3
	sudo ot-ctl srp server disable
    sudo ot-ctl thread stop
    sudo ot-ctl ifconfig down
    sudo ot-ctl dataset init new
    sudo ot-ctl dataset commit active
    sudo ot-ctl srp server enable
	sudo ot-ctl ifconfig up
	sudo ot-ctl thread start
	sleep 7
	Get_ThreadDataset
}

Get_ThreadDataset()
{
	# copy command ouput first line and remove line feed to THREAD_DATA_SET
	export THREAD_DATA_SET=$(sudo ot-ctl dataset active -x | sed -n 1p | sed -e "s/\r//g")
	echo_green "New ThreadDataset: $THREAD_DATA_SET"
}

# start the matter commissionning process to a thread network by BLE
Pair_BLE_Thread ()
{
	if [[ "$THREAD_DATA_SET" == "0" ]]; then
		echo_blue "Provide OpenThread DataSet"
		return
	fi

	if [[ "$LAST_NODE_ID" == "$NODE_ID" ]]; then
		export NODE_ID=$((1 + $RANDOM % 100000))
	fi

	export LAST_NODE_ID="$NODE_ID"
	"${CHIPTOOL_PATH}" pairing ble-thread ${NODE_ID} hex:"${THREAD_DATA_SET}" "${PINCODE}" "${DISCRIMINATOR}"
	echo_blue "The Node id of the commissioned device is $NODE_ID"
}

# start the matter commissionning process to a WiFi network by BLE
Pair_BLE_WiFi ()
{
	if [[ ! $SSID ]]; then
		echo_blue "Provide SSID"
		return
	fi

	if [[ ! $WIFI_PW ]]; then
		echo_blue "Provide SSID password"
		return
	fi

	if [["$LAST_NODE_ID" == "$NODE_ID" ] && isNodeProvided = true]; then
		export NODE_ID=$((1 + $RANDOM % 100000))
	fi

	echo_green "Set Node id for the commissioned device : $NODE_ID"
	export LAST_NODE_ID = $NODE_ID
	"{$CHIPTOOL_PATH}" pairing ble-wifi "${NODE_ID}" "${SSID}" "${WIFI_PW}" "${PINCODE}" "${DISCRIMINATOR}"
}

Send_OnOff_Cmds ()
{
	"${CHIPTOOL_PATH}" onoff "${cmd}" "${NODE_ID}" "${ENDPOINT}"
}

Send_ParseSetupPayload ()
{
	"${CHIPTOOL_PATH}" payload parse-setup-payload "${optArgs[@]}"
}

# Preconfigure Command list
declare -A cmd_list=(
	["help"]=Print_Help
	["vars"]=Print_Vars
	["cleanVars"]=Clean_Vars
	["buildCT"]=Clean_build_ChipTool
	["rebuildCT"]=Rebuild_ChipTool
	["startThread"]=Start_ThreadNetwork
	["getThreadDataset"]=Get_ThreadDataset
	["bleThread"]=Pair_BLE_Thread
	["bleWifi"]=Pair_BLE_WiFi
	["on"]=Send_OnOff_Cmds
	["off"]=Send_OnOff_Cmds
	["toggle"]=Send_OnOff_Cmds
	["parsePayload"]=Send_ParseSetupPayload)

declare cmd=""
declare optArgs=()
declare isNodeProvided=false

# Activate Matter environment if it isn't already
pipEnv=$(pip -V)
if [[ "$pipEnv" != *"$MATTER_ROOT"* ]]; then
	source "$MATTER_ROOT"/scripts/activate.sh
fi

while [ $# -gt 0 ]; do
    case $1 in
        --help | -h)
		Print_Help
		return
		;;
        --nodeid | -n)
            if [[ -z "$2" ]]; then
                echo_blue "Provide node ID value"
                return
            fi
            export NODE_ID="$2"
			isNodeProvided=true
            shift
            shift
            ;;
		--discriminator | -di)
            if [[ -z "$2" ]]; then
                echo_blue "Provide discriminator value"
                return
            fi
            export DISCRIMINATOR="$2"
            shift
            shift
            ;;
        --endpoint | -e)
            if [[ -z "$2" ]]; then
                echo_blue "Provide endpoint value"
                return
            fi
            export ENDPOINT="$2"
            shift
            shift
            ;;
        --dataset | -d)
            if [[ -z "$2" ]]; then
                echo_blue "Provide dataset Hex Value"
                return
            fi
            export THREAD_DATA_SET="$2"
            shift
            shift
            ;;
        --ssid | -s)
            if [[ -z "$2" ]]; then
                echo_blue "Provide ssid name"
                return
            fi
            export SSID="$2"
            shift
            shift
            ;;
        --password | -p)
            if [[ -z "$2" ]]; then
                echo_blue "Provide ssid password"
                return
            fi
            export WIFI_PW="$2"
            shift
            shift
            ;;
	*)
            if [[ "$cmd" == "" ]] ; then
                cmd=$1
            else
            	optArgs+=("${1}")
            fi
            shift
            ;;
    esac
done

# In command list commands else args to chip-tool
if [[ ${cmd_list[$cmd]+_} ]]; then
	${cmd_list[$cmd]}
else
	"${CHIPTOOL_PATH}" "${cmd}" "${optArgs[@]}"
fi
