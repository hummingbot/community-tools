#!/bin/bash
# Specify hummingbot version, (default = "latest")
TAG=latest

remove_current_containers() {
  echo "Removing current containers ..."
  declare -a INSTANCES
  INSTANCES=( $(docker ps -a --format "{{.Names}}") )
  echo "Stop and removing ${INSTANCES[*]} ..."

  # Stop and remove current containers
  docker stop ${INSTANCES[@]}
  docker rm ${INSTANCES[@]}
}

create_instance () {
 echo "Creating Hummingbot instance $1 Admin password may be required to set the required permissions ..."
 # 1) Create main folder for your new instance
 FOLDER="$PWD/$1_files"
 mkdir $FOLDER
 # 2) Create subfolders for hummingbot files
 mkdir $FOLDER/hummingbot_conf
 mkdir $FOLDER/hummingbot_logs
 mkdir $FOLDER/hummingbot_data
 mkdir $FOLDER/hummingbot_scripts
 mkdir $FOLDER/hummingbot_certs
 # 3) Set required permissions to save hummingbot password the first time
 sudo chmod a+rw $FOLDER/hummingbot_conf
 # 4) Set environment variable
 export STRATEGY="pure_market_making"
 export CONFIG_FILE_NAME="conf_pure_mm_$1.yml"
 export CONFIG_PASSWORD=''

 # 5) Launch a new instance of hummingbot
 docker run -itd  \
 --name $1 \
 --network host \
 --mount "type=bind,source=$FOLDER/hummingbot_conf,destination=/conf/" \
 --mount "type=bind,source=$FOLDER/hummingbot_logs,destination=/logs/" \
 --mount "type=bind,source=$FOLDER/hummingbot_data,destination=/data/" \
 --mount "type=bind,source=$FOLDER/hummingbot_scripts,destination=/scripts/" \
 --mount "type=bind,source=$FOLDER/hummingbot_certs,destination=/certs/" \
 -e STRATEGY -e CONFIG_FILE_NAME -e CONFIG_PASSWORD \
 coinalpha/hummingbot:$TAG

 # 6) Clean up
 unset STRATEGY CONFIG_FILE_NAME CONFIG_PASSWORD
}

# Script start here
remove_current_containers

while IFS='' read -r LinefromFile || [[ -n "${LinefromFile}" ]]; do

    [[ "$LinefromFile" =~ ^#.*$ ]] && continue
    create_instance "$LinefromFile"
    sleep 30

done < "bots_to_run"
