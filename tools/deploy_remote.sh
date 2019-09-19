#!/bin/bash

REMOTE_ADDR="192.168.22.3" 
REMOTE_ACC="jenkins" 
R_BASEFOLDERNAME="icis" 
WDIR=.

# ------------------------------------------------------------------------------------------------
NC='\033[0m';GREEN='\033[0;32m';RED='\033[0;31m';BLUE='\033[0;34m';
PURPLE='\033[0;35m';YELLOW='\033[0;33m';

DEPLOY_VERSION_FN=".deploy_version"
DEPLOY_VERSION=""

# ------------------------------------------------------------------------------------------------
check_working_directory() {
	cd $WDIR
	FOLDERNAME="${PWD##*/}" # "tools"
	echo -n "Working dir shall under [${GREEN}tools/${NC}]..."
	if [ "tools" = "$FOLDERNAME" ]; then
		echo "Yes."
	else
		echo "No. I got:[${RED}$FOLDERNAME${NC}]"
		exit 1
	fi

	# pwd shall be 'bin/'
	cd ..
	FOLDERNAME="${PWD##*/}" # "icis_elkn_stack"
	echo "Target [$FOLDERNAME] <== Make sure this project folder name is correct!! (in 5 sec)"
	sleep 5

	# build version file	
	DEPLOY_VERSION=`date +"%Y-%m-%d %H:%M:%S"`
	echo $DEPLOY_VERSION > $DEPLOY_VERSION_FN
	echo "This DEPLOY_VERSION:${BLUE}"`cat $DEPLOY_VERSION_FN`${NC}
}

version_confirm() {
	RESULT=$(ssh $REMOTE_ACCADDR "cat $R_BASEFOLDERNAME/$FOLDERNAME/$DEPLOY_VERSION_FN"); 
	# echo RESULTS = $RESULTS
	
	if [ "$RESULT" = "$DEPLOY_VERSION" ]; then 
		echo "== build ${GREEN}version Confirmed${NC} =="
	else 
		echo "== build ${RED}version Failed${NC} =="
	fi 
}

check_remote_setting() {
	if [ ! -z "$REMOTE_ACC" ] && [ ! -z "$REMOTE_ADDR" ]; then
		REMOTE_ACCADDR=$REMOTE_ACC@$REMOTE_ADDR
	fi

	# REMOTE_ACCADDR="someone@192.168.xx.xx"
	if [ -z "$REMOTE_ACCADDR" ]; then 
		echo "${RED}REMOTE_ACCADDR${NC} is EMPTY but must be set first!"
		exit 0
	fi
}
# Copy project to remote target folder.
copy_project_to_remote_target_folder() {
	echo -n "Zipping project to [../$FOLDERNAME.zip] ..."
	zip -ruq "../$FOLDERNAME".zip .
	echo "made."
	ls -alF "../$FOLDERNAME".zip

	cd ..
	echo ""
	echo "[Enter Remote: $REMOTE_ACCADDR]"
	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME; if [ -e $FOLDERNAME.bak.zip ]; then rm $FOLDERNAME.bak.zip; fi"
	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME; if [ -e $FOLDERNAME.zip ]; then mv $FOLDERNAME.zip $FOLDERNAME.bak.zip; fi"
	scp $FOLDERNAME.zip $REMOTE_ACCADDR:~/$R_BASEFOLDERNAME 
	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME; ls -alF $FOLDERNAME.zip"

	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME; if [ -e $FOLDERNAME ]; then rm -rf $FOLDERNAME; fi"
	echo "[CHK if target folder removed - success as fault respose] pwd: $REMOTE_ACCADDR:~/$R_BASEFOLDERNAME/$FOLDERNAME"
	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME; ls -alF $FOLDERNAME"

	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME; unzip -oq $FOLDERNAME.zip -d $FOLDERNAME"
	# -q  quiet mode (-qq => quieter)
	# -o  overwrite files WITHOUT prompting

	echo "[CHK if target folder build with Result]"
	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME; echo \$(pwd) ; ls -alF $FOLDERNAME"

	version_confirm	
}

# Check remote environment
check_remote_environment() {
	echo "docker volume:"
	ssh $REMOTE_ACCADDR "docker volume ls | grep icis"
}

# Run by yml.
run_by_yml() {
	echo ""

	echo "[Docker Compose Stop] ..."
	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME/$FOLDERNAME; docker-compose down"
	echo "[Docker Compose Start] ..."
	ssh $REMOTE_ACCADDR "cd $R_BASEFOLDERNAME/$FOLDERNAME; docker-compose up -d"
	echo "[Docker Compose Start] ... ${GREEN}all done${NC}."
}


main() {
	check_working_directory
	check_remote_setting
	copy_project_to_remote_target_folder
	check_remote_environment
	run_by_yml
}

# ------------------------------------------------------------------------------------------------
main