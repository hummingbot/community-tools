#!/bin/bash
# init
remove_current_containers() {
  echo "Removing current containers ..."
  declare -a INSTANCES
  INSTANCES=( $(docker ps -a --format "{{.Names}}") )
  echo "Stop and removing ${INSTANCES[*]} ..."

  # Stop and remove current containers
  docker stop ${INSTANCES[@]}
  docker rm ${INSTANCES[@]}
}


# Script start here
remove_current_containers