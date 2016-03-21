# Syncthing Docker Scratch Image Builder

The `build.sh` script

1. retrieves a binary from the syncthing website
2. verifies the hash signature
3. creates a scratch docker image

for all Linux architectures.

## Building

Most people will want to reduce the amount of architectures to their need. Adjust the repository to upload to your own repo.

## Running

Run an image using the run.sh script. Adjust the script to mount the directories you want to share. Run as the user you want syncthing to run as.
