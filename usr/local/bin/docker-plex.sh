#!/bin/sh

# TODO mail on update

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
        -e VERSION=docker \
        -e PUID=$(id -u plex) -e PGID=$(id -g plex) \
        -e TZ=Australia/Sydney \
        -v /srv/plex/config:/config \
        -v /srv/plex/transcode:/transcode \
        -v /tv:/data/tv \
        -v /srv/nfs/movie:/data/movie \
        -v /srv/nfs/music:/data/music \
        --restart unless-stopped \
        linuxserver/plex

    # start new
    docker start plex

    # clean up
    docker system prune -f
else

    echo "no update available"
fi
