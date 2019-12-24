#!/bin/bash

echo "Delete channel-artifacts directory"
rm -rf ./multienv/docker-swarm/channel-artifacts
echo "Extract files from channel-artifacts.tar"
tar xvf ./multienv/docker-swarm/channel-artifacts.tar -C ./multienv/docker-swarm/

