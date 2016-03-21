FROM scratch

ADD syncthing /syncthing

ENTRYPOINT ["/syncthing", "-no-browser"]
