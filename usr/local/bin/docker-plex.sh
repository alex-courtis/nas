#!/bin/sh

ver_cur="$(docker image inspect linuxserver/plex | jq -r '.[0].Config.Labels.build_version')"

docker pull linuxserver/plex
ver_new="$(docker image inspect linuxserver/plex | jq -r '.[0].Config.Labels.build_version')"

if [ "${ver_cur}" != "${ver_new}" ]; then

	cat << EOM | sendmail -D -t
to: alex@courtis.org
from: lord <alex@courtis.org>
subject: upgraded plex
MIME-Version: 1.0
Content-Type: text/html

<pre>
CUR:  ${ver_cur}
NEW:  ${ver_new} 
</pre>
EOM

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
        -v /srv/nfs/tv:/data/tv \
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
