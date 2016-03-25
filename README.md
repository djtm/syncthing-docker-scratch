# Syncthing Docker Scripts

This repository contains scripts to build and/or run scratch docker images for syncthing.

## Building

The `build.sh` script

1. retrieves a binary from the syncthing website
2. verifies the hash signature
3. creates a scratch docker image

for all Linux architectures.

Most people will want to reduce the amount of architectures to their need. Adjust the repository to upload to your own repo.

## Running

Run an image using the `run.sh` script. Adjust the architecture (`arch=`) to your needs. Adjust the script to mount the directories you want to share. Run the script as the user you want the syncthing container to run as.

## rkt

The amd64 container runs with rkt as well. Please see `rkt_run.sh` for standard stage1 and `rkt_clr.sh` for a "clear container"/lkvm stage1. Other architectures are not well supported by rkt at the moment. They need the container built on the same architecture its run on for docker2aci to work - and possibly further adjustments to rkt.
