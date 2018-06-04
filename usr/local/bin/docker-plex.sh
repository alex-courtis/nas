#!/bin/sh

# TODO parameterise this, if conditional update works

# check for update
docker pull linuxserver/plex | grep "Downloaded" >/dev/null
if [ $? -eq 0 ]; then

    # stop existing
    docker stop plex

    # delete existing
    docker rm plex

    # create new
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
    
    # start new
    docker start plex

    # clean up
    docker system prune -f
else

    # nothingtodohere
    echo "no update available"
fi
