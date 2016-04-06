#!/bin/sh

[ -x ./rkt ] || echo Get rkt from https://github.com/coreos/rkt/releases and run this script inside the directory with the rkt binary.

CONFIG="$HOME/.config/syncthing-rkt"
SYNC="$HOME/Sync"
mkdir -p "$CONFIG" "$SYNC"

echo You can *only* access the forwarded ports at your non-local network addresses ,e.g. 192.168. ... . See https://github.com/coreos/rkt/issues/2283
echo The support for lkvm is still pretty experimental, be warned. Mounting seems broken in rkt 1.2.1 + lkvm.
echo '#sudo ./rkt list shows the VM IP address.'

sudo ./rkt run --interactive --debug --stage1-path=stage1-kvm.aci \
--insecure-options=image --dns 8.8.8.8 \
--volume=ssl,kind=host,source=/etc/ssl/certs --mount volume=ssl,target=/etc/ssl/certs \
--volume=sync,kind=host,source="$SYNC" --mount volume=sync,target=/root/Sync \
--volume=config,kind=host,source="$CONFIG" --mount volume=config,target=/root/.config/syncthing \
--port 8384-tcp:8384 --port 22000-tcp:22000 --port 21027-udp:21027 \
   docker://djtm/syncthing-scratch-amd64 \
--cpu 300m --memory 500M -- -gui-address="http://0.0.0.0:8384" $*

# The port names, e.g. 8384-tcp are created from the docker image's expose 8384/tcp by docker2aci.
