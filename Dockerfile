FROM scratch

ADD syncthing /syncthing

EXPOSE 8384/tcp 22000/tcp 21027/udp

ENTRYPOINT ["/syncthing", "-no-browser", "-no-restart"]
