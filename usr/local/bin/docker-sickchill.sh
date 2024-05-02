#!/bin/sh

# check for update
docker pull linuxserver/sickchill | grep "Downloaded" >/dev/null
if [ $? -eq 0 ]; then

    # stop existing
    docker stop sickchill

    # delete existing
    docker rm sickchill

    # add the sickchill process owner "abc" to the host's groups "download" and "tv"
    cat << EOF > /srv/sickchill/custom-cont-init.d/15-addgroups
#!/usr/bin/with-contenv bash
groupadd -g $(id -g download) download
groupadd -g $(id -g tv) tv
gpasswd -a abc download
gpasswd -a abc tv
EOF
    chmod 700 /srv/sickchill/custom-cont-init.d/15-addgroups

    # create new
    docker create \
        --name=sickchill \
        --net=host \
        -v /srv/sickchill/config:/config \
        -v /srv/sickchill/custom-cont-init.d:/custom-cont-init.d \
        -v /srv/nfs/download:/downloads \
        -v /srv/nfs/tv:/tv \
        -e PGID=$(id -u sickchill) -e PUID=$(id -g sickchill) \
        -e TZ=Australia/Sydney \
        --restart unless-stopped \
        linuxserver/sickchill

    # start new
    docker start sickchill

    # clean up
    docker system prune -f
else

    echo "no update available"
fi
