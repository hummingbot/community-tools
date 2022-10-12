#!/bin/bash
# Specify hummingbot version, (default = "latest")
TAG=development

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
  CONF_FOLDER="$FOLDER/hummingbot_conf"
  LOGS_FOLDER="$FOLDER/hummingbot_logs"
  DATA_FOLDER="$FOLDER/hummingbot_data"
  PMM_SCRIPTS_FOLDER="$FOLDER/hummingbot_pmm_scripts"
  SCRIPTS_FOLDER="$FOLDER/hummingbot_scripts"
  CERTS_FOLDER="$FOLDER/hummingbot_certs"
  GATEWAY_CONF_FOLDER="$FOLDER/gateway_conf"
  GATEWAY_LOGS_FOLDER="$FOLDER/gateway_logs"

  mkdir $CONF_FOLDER
  mkdir $CONF_FOLDER/connectors
  mkdir $CONF_FOLDER/strategies
  mkdir $LOGS_FOLDER
  mkdir $DATA_FOLDER
  mkdir $PMM_SCRIPTS_FOLDER
  mkdir $CERTS_FOLDER
  mkdir $SCRIPTS_FOLDER
  mkdir $GATEWAY_CONF_FOLDER
  mkdir $GATEWAY_LOGS_FOLDER
  # 3) Set required permissions to save hummingbot password the first time
  sudo chmod a+rw $FOLDER/hummingbot_conf

  # 4) Set environment variable
  export STRATEGY="pure_market_making" # Name of the strategy to autorun
  export CONFIG_FILE_NAME="conf_pure_mm_$1.yml" # Name of the config file to autorun
  export CONFIG_PASSWORD='password' # Password to access your bot

  # 5) Launch a new instance of hummingbot
  docker run -itd --log-opt max-size=10m --log-opt max-file=5 \
  --name $1 \
  --network host \
  --mount "type=bind,source=$CONF_FOLDER,destination=/conf/" \
  --mount "type=bind,source=$LOGS_FOLDER,destination=/logs/" \
  --mount "type=bind,source=$DATA_FOLDER,destination=/data/" \
  --mount "type=bind,source=$PMM_SCRIPTS_FOLDER,destination=/pmm_scripts/" \
  --mount "type=bind,source=$SCRIPTS_FOLDER,destination=/scripts/" \
  --mount "type=bind,source=$CERTS_FOLDER,destination=/home/hummingbot/.hummingbot-gateway/certs/" \
  --mount "type=bind,source=$GATEWAY_CONF_FOLDER,destination=/home/hummingbot/.hummingbot-gateway/conf/" \
  --mount "type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock" \
  -e CONF_FOLDER="$CONF_FOLDER" \
  -e DATA_FOLDER="$DATA_FOLDER" \
  -e PMM_SCRIPTS_FOLDER="$PMM_SCRIPTS_FOLDER" \
  -e SCRIPTS_FOLDER="$SCRIPTS_FOLDER" \
  -e CERTS_FOLDER="$CERTS_FOLDER" \
  -e GATEWAY_LOGS_FOLDER="$GATEWAY_LOGS_FOLDER" \
  -e GATEWAY_CONF_FOLDER="$GATEWAY_CONF_FOLDER" \
  -e STRATEGY -e CONFIG_FILE_NAME -e CONFIG_PASSWORD \
  hummingbot/hummingbot:$TAG

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
