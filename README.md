[![](https://badge.imagelayers.io/djtm/syncthing-scratch-amd64:latest.svg)](https://imagelayers.io/?images=djtm/syncthing-scratch-amd64:latest 'Get your own badge on imagelayers.io')
# Syncthing Docker Scripts

This repository contains scripts to build and/or run scratch docker images for syncthing. 

## Running

### Docker
Run an image using the `run.sh` script. To run the current version container with docker on amd64:
```bash
wget https://github.com/djtm/syncthing-docker-scratch/raw/master/run.sh && bash run.sh
```
[![asciicast](https://asciinema.org/a/41919.png)](https://asciinema.org/a/41919)

For other architectures, adjust `arch=` to your needs. By default, the script runs 
the container as the user you run the script as. The default path for storing 
configuration files is `$HOME.config/syncthing-docker`. As default volume is 
`$HOME/Sync` is mounted. You can mount additional directories with 
`dockeropts="-v /local/dir:/container/dir"`. The default settings are 
tuned for minimum impact on the running system. You can add syncthing 
parameters to the end of the script, e.g. `bash run.sh -help`.

### Beta builds and tags

While the current version is always tagged with the `:latest` flag, the current beta version
is tagged as `:beta`. This should allow for easy beta testing with your scripts. Please note
binaries are rarely released for beta versions. New major versions are not tagged `:latest` for
a while. They are available under the major version tag first, e.g. `:0.13`. Later, `0.13` will 
be tagged `:latest` and `0.12` will only be available as `:0.12(.x)`. If you want to be sure you
can determin the upgrade to a major version please use the current major version tag in your
run script.

### rkt

The amd64 container runs with rkt as well. Please see `rkt_run.sh` for standard stage1 
and `rkt_clr.sh` for a _highly experimental_ "clear container"/lkvm stage1. 
Other architectures are not well supported by rkt at the moment. They need 
the container built on the same architecture its run on for docker2aci to work 
and possibly further adjustments to rkt.

## Building

The `build.sh` script

1. retrieves a binary from the syncthing website
2. verifies the hash signature
3. creates a scratch docker image
4. uploads the image to docker
5. removes all images from the local system

for Linux architectures. `bash build.sh 0.12.21` builds, uploads, and purges containers for all architectures.

Most people will want to reduce the amount of architectures to their need. 
You can adjust the script to upload to your own repository. Containers are 
tagged with the version of syncthing given as command line. The system uploads
the currently built version under the `:latest` tag as well.

## Issues
- You need to be in the docker group to be allowed to start docker containers.
- If relaying shows `0/1` for you, the CA Certificates might not be mounted
from the right place. Please adjust the path in `ssl=`. For possible locations see:
https://www.happyassassin.net/2015/01/12/a-note-about-ssltls-trusted-certificate-stores-and-platforms/
- `rkt_clr.sh` does not mount any volumes. All modifications to the container will be discarded.
- rkt only runs a container on the architecture it was built on.

## Security
If you care about security, please use the build script to create the containers locally.
The scripts and image are already generally trying to take security into account. 
Feedback welcome.
