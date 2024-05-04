#!/bin/sh

ver_cur="$(docker image inspect linuxserver/sabnzbd | jq -r '.[0].Config.Labels.build_version')"

docker pull linuxserver/sabnzbd
ver_new="$(docker image inspect linuxserver/sabnzbd | jq -r '.[0].Config.Labels.build_version')"

if [ "${ver_cur}" != "${ver_new}" ]; then

	cat << EOM | sendmail -D -t
to: alex@courtis.org
from: lord <alex@courtis.org>
subject: upgraded sabnzbd

CUR ${ver_cur}
NEW ${ver_new} 
EOM

    # add the sabnzbd process owner "abc" to the host's group "download"
    cat << EOF > /srv/sabnzbd/custom-cont-init.d/15-addgroups
#!/usr/bin/with-contenv bash
groupadd -g $(id -g download) download
gpasswd -a abc download
EOF
	chmod 700 /srv/sabnzbd/custom-cont-init.d/15-addgroups

    # stop existing
    docker stop sabnzbd

    # delete existing
    docker rm sabnzbd

    # create new
    docker create \
        --name=sabnzbd \
        --net=host \
        -v /srv/sabnzbd/config:/config \
        -v /srv/sabnzbd/incomplete-downloads:/incomplete-downloads \
        -v /srv/sabnzbd/custom-cont-init.d:/custom-cont-init.d \
        -v /srv/nfs/download:/download \
        -e PGID=$(id -u sabnzbd) -e PUID=$(id -g sabnzbd) \
        -e TZ=Australia/Sydney \
        --restart unless-stopped \
        linuxserver/sabnzbd

    # start new
    docker start sabnzbd

    # clean up
    docker system prune -f
else

    echo "no update available"
fi
