#!/bin/bash
# ============================================================================= Environment


# ============================================================================= Predefind
NC='\033[0m';GREEN='\033[0;32m';RED='\033[0;31m';BLUE='\033[0;34m';
PURPLE='\033[0;35m';YELLOW='\033[0;33m';


# ============================================================================= Function

show_help() {
		echo "\nHelp Description:"
		echo "\t[OPTION]\t[PARAMETER]"
		echo "\tsingle\tSwitch docker-compose yml file to single mode."
		echo "\tcluster\tSwitch docker-compose yml file to cluster mode."
		echo ""
		echo "\t{example1}$ sh dc-switch.sh single"
		echo "\t{example2}$ sh dc-switch.sh cluster"
}

main() {
	case "$1" in
	-h|--help)
		show_help
    ;;
	single )
		echo "Switch to mode: single"
		cp -f docker-compose-single.yml docker-compose.yml 
	;;
	cluster )
		echo "Switch to mode: cluster"
		cp -f docker-compose-cluster.yml docker-compose.yml 
	;;
	*)    # default option	
		echo "Unrecognized parameter."
		show_help
	;;
	esac
	
	echo "done"
}

# ============================================================================= Main
main $@