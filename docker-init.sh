#!/bin/bash

echo "Remove docker container"
docker rm -f `docker ps -aq`

