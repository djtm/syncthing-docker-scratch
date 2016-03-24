#!/usr/bin/env bash
set -x

version=$1
arch="386 amd64 arm arm64 ppc64 ppc64le"
repo="djtm/syncthing-scratch"

# gpg: key 00654A3E: public key "Syncthing Release Management <release@syncthing.net>" imported
export SYNCTHING_GPG_KEY=37C84554E7E0A261E4F76E1ED26E6ED000654A3E
gpg --keyserver pool.sks-keyservers.net --recv-keys "${SYNCTHING_GPG_KEY}" \

# prepare arch version
for i in $arch; do
sh prepare.sh $i $version
docker build -t ${repo}-${i}:${version} .
docker build -t ${repo}-${i} .
docker push ${repo}-${i}:${version}
docker push ${repo}-${i}
done
