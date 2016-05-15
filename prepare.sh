SYNCTHING_VERSION="$2"
arch="$1"
tarball="syncthing-linux-${arch}-v${SYNCTHING_VERSION}.tar.gz"

rm sha256sum.txt.asc syncthing "$tarball"

set -x \
	&& wget "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/$tarball" \
		"https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/sha256sum.txt.asc" \
	&& gpg -u "$SYNCTHING_GPG_KEY" --verify sha256sum.txt.asc \
	&& grep -E " ${tarball}\$" sha256sum.txt.asc | sha256sum -c - \
	&& rm sha256sum.txt.asc \
	&& dir="$(basename "$tarball" .tar.gz)" \
	&& bin="$dir/syncthing" \
	&& tar -xvzf "$tarball" "$bin" \
	&& rm "$tarball" \
	&& mv "$bin" syncthing \
	&& rmdir "$dir" \
	&& echo "### Successfully prepared Syncthing version $SYNCTHING_VERSION for architecture $arch" ||
	echo Error during $1 $2 >> error.log
