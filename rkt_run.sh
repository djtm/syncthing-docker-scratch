#!/bin/sh

[ -x ./rkt ] || echo Get rkt from https://github.com/coreos/rkt/releases and run this script inside the directory with the rkt binary.

CONFIG="$HOME/.config/syncthing-rkt"
SYNC="$HOME/Sync"
mkdir -p "$CONFIG" "$SYNC"

sudo ./rkt run --interactive  --insecure-options=image --dns 8.8.8.8 --hostname $(hostname)-rkt-syncthing \
--port 8384-tcp:8384 --port 22000-tcp:22000 \
--set-env GOGC=40 \
--volume=ssl,kind=host,source=/etc/ssl/certs,readOnly=true --mount volume=ssl,target=/etc/ssl/certs \
--volume=sync,kind=host,source="$SYNC" --mount volume=sync,target=/root/Sync \
--volume config,kind=host,source="$CONFIG" --mount volume=config,target=/root/.config/syncthing \
docker://djtm/syncthing-scratch-amd64 \
--cpu 200m --memory 500M \
-- -gui-address="http://0.0.0.0:8384" $*

# currently only amd64 supported.
# cpu and memory must stand after the container name
# run syntax: https://coreos.com/rkt/docs/latest/subcommands/run.html
# mount syntax: https://coreos.com/rkt/docs/latest/subcommands/run.html#mount-volumes-into-a-pod
# namespacing does not yet seem to work --private-users --no-overlay \

pidof syncthing 2>/dev/null && \
ionice -c 3 -p $(pidof syncthing) && \
renice 19 -p $(pidof syncthing)
