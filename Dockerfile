FROM scratch

ADD syncthing /syncthing

ENTRYPOINT ["/syncthing", "-no-restart", "-no-browser"]
