FROM scratch

ADD syncthing /syncthing

EXPOSE 8384/tcp 22000/tcp

ENTRYPOINT ["/syncthing", "-no-browser", "-no-restart"]
