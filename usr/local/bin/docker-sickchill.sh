#!/bin/sh

# check for update
docker pull linuxserver/sickchill | grep "Downloaded" >/dev/null
if [ $? -eq 0 ]; then

    # stop existing
    docker stop sickchill

    # delete existing
    docker rm sickchill

    # create new
    docker create \
        --name=sickchill \
        -p 8081:8081 \
        -v /opt/sickchill/config:/config \
        -v /download:/downloads \
        -v /tv:/tv \
        -e PGID=$(id -u sickchill) -e PUID=$(id -g sickchill) \
        -e TZ=Australia/Sydney \
        --restart unless-stopped \
        linuxserver/sickchill

    # add the sickchill process owner "abc" to the host's groups "download" and "tv"
    cat << EOF > /tmp/15-addgroups
#!/usr/bin/with-contenv bash
groupadd -g $(id -g download) download
groupadd -g $(id -g tv) tv
gpasswd -a abc download
gpasswd -a abc tv
EOF
    docker cp /tmp/15-addgroups sickchill:/etc/cont-init.d
    
    # start new
    docker start sickchill

    # clean up
    docker system prune -f
else

    # nothingtodohere
    echo "no update available"
fi
