#!/bin/sh

CONFIG="$HOME/.config/syncthing"
mkdir -p "$CONFIG" $HOME/Sync

sudo rkt run --interactive  --insecure-options=image --net=host --dns 8.8.8.8 --hostname $(hostname)-rkt-syncthing \
--volume=ssl,kind=host,source=/etc/ssl/certs,readOnly=true --mount volume=ssl,target=/etc/ssl/certs \
--volume=sync,kind=host,source=$HOME/Sync --mount volume=sync,target=/root/Sync \
--volume config,kind=host,source="$CONFIG" --mount volume=config,target=/root/.config/syncthing \
docker://djtm/syncthing-scratch-amd64 \
--cpu 200m --memory 500M \
-- $*

# currently only amd64 supported.
# cpu and memory must stand after the container name
# https://coreos.com/rkt/docs/latest/subcommands/run.html

pidof syncthing 2>/dev/null && \
ionice -c 3 -p $(pidof syncthing) && \
renice 19 -p $(pidof syncthing)
