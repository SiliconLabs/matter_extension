
#!/bin/bash

OTBR_ROOT="$HOME/ot-br-posix"

declare SKIP_BOOTSTRAP=1
declare SKIP_SETUP=1
declare SKIP_UPDATE=1
declare setIf="eth0"
declare setDebugLog=""

Print_Help()
{
	echo "This bash script centralize and simplifies the local otbr installation"
	echo "Available options  :"
	echo " -h, --help 			Print this help"
	echo " -if, --interface <eth0|wlan0>	Select infrastructure interface. Default eth0"
	echo " -i, --install			Bootstrap, setup and install the OTBR. Usually for a new intallation"
	echo " -s, --setup			Runs the OTBR setup only, use this to change the configurated infrastructure interface (use in combination with -if wlan0 for wifi)"
	echo " -u, --update			Update the OTBR installation after the repo is updated"
	echo " -dbg, --debug			Set OT_LOG_LEVEL to DEBUG"       
}

main()
{
	# bootstrap the otbr environnement
	if [[ "$SKIP_BOOTSTRAP" -eq 0 ]]; then
		echo "Bootstrapping OTBR posix"
		"$OTBR_ROOT"/script/bootstrap
	fi

	#setup otbr / change interface
	if [[ "$SKIP_SETUP" -eq 0 ]]; then
		echo "Setting up the OTBR with interface "$setIf""
		INFRA_IF_NAME=$setIf $setDebugLog"$OTBR_ROOT"/script/setup
	fi

	#update otbr
	if [[ "$SKIP_UPDATE" -eq 0 ]]; then
		echo "Updating OTBR"
		"$OTBR_ROOT"/script/update
	fi

	sudo cp "$HOME/scripts/templates/configurations_"$setIf".sh" "$HOME/scripts/configurations.sh"
}

if [[ $# -eq 0 ]] ; then
	Print_Help
	return
fi

while [ $# -gt 0 ]; do
	case $1 in
		--help | -h)
			Print_Help
			return
			;;
		--interface | -if)
			if [[ -z "$2" ]]; then
				echo "Povide interface name. eth0 (ethernet) or wlan0 (WiFi)"
				echo "default is eth0"
				return
			fi
			if [ "$2" != "wlan0" ] && [ "$2" != "eth0" ]; then
				echo "Invalid interface. Use eth0 or wlan0"
			fi
			setIf=$2
			shift
			shift
			;;
		--install | -i)
			SKIP_BOOTSTRAP=0
			SKIP_SETUP=0
			SKIP_UPDATE=1
			shift
			;;
		--setup | -s)
			SKIP_BOOTSTRAP=1
			SKIP_SETUP=0
			SKIP_UPDATE=1
			shift
			;;
		--update | -u)
			SKIP_BOOTSTRAP=0
			SKIP_SETUP=1
			SKIP_UPDATE=0
			shift
			;;
		--debug | -dbg)
			setDebugLog="OTBR_OPTIONS='-DOT_LOG_LEVEL=DEBG' "
			shift	
			;;
		*)
			shift
			;;
	esac
done

main
