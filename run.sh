#!/bin/bash
set -x

# Setting the following variables should allow for most typical adjustments.
# You can add syncthing parameters to the end of this script:
# e.g. sh run.sh -version

arch=amd64 		# 386 amd64 arm arm64 ppc64 ppc64le
GOGC=40 		# Go Garbage collection, 40 % memory "generosity", less means stricter
CONFIG="$HOME/.config/syncthing-docker"		# Syncthing configuration directory, includes index files
usr="$(id -u):$(id -g)" # uid:gid, e.g. 1000:1000 by default runs syncthing as the uid and gid this script is run as
Sync="$HOME/Sync"	# Path to your Sync Folder
ssl="/etc/ssl/certs"	# path to ssl certificates
cpushares="300" 	# 300 cpushares, see /sys/fs/cgroup/cpu/cpu.shares
memory="500m" 		# for 500 MB memory limit
swap="520m" 		# Total memory limit (memory + swap), https://docs.docker.com/engine/reference/run/#user-memory-constraints
swappiness="1" 		# 0-100, no disables swap.
bklioweight="10" 	# 0-1000
dockercustom=""		# custom additional docker commands
syncthingcustom=""	# custom additional syncthing commands
repository="djtm/syncthing-scratch-$arch"

# prevent directories being created by docker with root user
mkdir -p "$CONFIG" $HOME/Sync

# first get updates before we stop
docker pull $repository
docker stop syncthing
docker rm syncthing

docker run \
	--name syncthing \
 	-p 8384:8384/tcp -p 22000:22000/tcp -p 21027:21027/udp \
	-e GOGC \
	--user "$usr" \
	--cpu-shares "$cpushares" \
	--memory "$memory" \
	--memory-swap "$swap" \
	--memory-swappiness "$swappiness" \
	--blkio-weight "$bklioweight" \
	-v "$CONFIG:/.config/syncthing" \
	-v "$Sync":/Sync \
        -v "$ssl":/etc/ssl/certs:ro \
	-d --restart always \
 	--read-only \
	--cap-drop all \
 	$dockercustom \
	"$repository" $syncthingcustom "$@"

# Mount additional directories with -v localdir:containerdir.
# --read-only mounts "/" read-only, the user should not have write access anyway.
#	--net host \
# -p hostport:containerport/protocol

timeout 10s docker logs -f syncthing
# $(docker inspect --format '{{.State.Pid}}' syncthing) might be nice, but does not catch both processes.
PID="$(pidof syncthing 2>/dev/null)" && \
ionice -c 3 -p $(pidof syncthing) && \
renice 19 -p $(pidof syncthing)

# ionice and renice to further reduce impact on running system.
# All these settings are NOT for perfect performance, but for
# minimum impact on the running system.

# If relaying shows "0/1" for you, the CA Certificates might not be mounted
# from the right place. For possible location see
# https://www.happyassassin.net/2015/01/12/a-note-about-ssltls-trusted-certificate-stores-and-platforms/
