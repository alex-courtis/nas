#!/bin/sh
docker stop plex

docker rm plex

docker pull linuxserver/plex

docker create \
    --name=plex \
    --net=host \
    -e VERSION=public \
    -e PUID=$(id -u plex) -e PGID=$(id -g plex) \
    -e TZ=Australia/Sydney \
    -v /opt/plex/config:/config \
    -v /opt/plex/transcode:/transcode \
    -v /data/tv:/data/tv \
    -v /data/movie:/data/movie \
    -v /data/music:/data/music \
    --restart unless-stopped \
    linuxserver/plex

docker start plex
