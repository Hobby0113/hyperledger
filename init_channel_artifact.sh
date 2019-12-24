#!/bin/bash

echo "delete channel-artifact directory"
rm -rf ./multienv/docker-swarm/channel-artifact
echo "Extract files from channel-artifact.tar"
tar xvf ./multienv/docker-swarm/channel-artifact.tar -C ./multienv/docker-swarm/

