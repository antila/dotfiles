#!/bin/bash

# https://github.com/kartoza/docker-helpers/blob/master/dstart

echo "Starting stopped containers"
for CONTAINER in `docker ps -a | awk '{print $1}' | grep -v CONTAINER`; do docker start $CONTAINER; done
# We do it twice to bring up containers that have link dependencies on others.
for CONTAINER in `docker ps -a | awk '{print $1}' | grep -v CONTAINER`; do docker start $CONTAINER; done
docker ps -a
