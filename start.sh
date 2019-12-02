#!/bin/bash

echo "start docker"
sudo systemctl start docker
sudo service docker stop
sudo rm -rf /var/lib/docker/swarm
sudo service docker start
