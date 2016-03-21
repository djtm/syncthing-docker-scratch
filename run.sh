#!/bin/bash

arch=386 # 386 amd64 arm arm64 ppc64 ppc64le
repository="djtm/syncthing-scratch-$arch"

set -x

CONFIG="$HOME/.config/syncthing"
mkdir -p "$CONFIG" $HOME/Sync

docker pull $repository
docker stop syncthing
docker rm syncthing

docker run -d \
	-m 500m -c 300 \
	--memory-swap 20m \
	-e GOGC=40 \
	--name syncthing \
	--restart always \
	-v "$CONFIG:/.config/syncthing" \
	-v $HOME/Sync:/Sync \
	--user "$(id -u):$(id -g)" \
	--net host \
	$repository "$@"

# Mount additional directories with -v localdir:containerdir.
# -m 500m for 500 MB memory limit
# -e GOGC=40 for stricter Go garbage collection (40%).
# -c 300 for 300 cpushares, compare to /sys/fs/cgroup/cpu/cpu.shares
# --user runs syncthing as the user this script is run as.
# you can try -p 8384:8384 instead of --net host
# You can add syncthing parameters to the end of this script:
# e.g. sh run.sh -version

timeout 10s docker logs -f syncthing
pidof syncthing 2>/dev/null && \
ionice -c 3 -p $(pidof syncthing) && \
renice 19 -p $(pidof syncthing)

# ionice and renice to reduce impact on running system.
# All these settings are NOT for perfect performance, but for
# minimum impact on the running system.
