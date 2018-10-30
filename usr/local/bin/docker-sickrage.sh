#!/bin/sh

# check for update
docker pull linuxserver/sickrage | grep "Downloaded" >/dev/null
if [ $? -eq 0 ]; then

    # stop existing
    docker stop sickrage

    # delete existing
    docker rm sickrage

    # create new
    docker create \
        --name=sickrage \
        --net=host \
        -v /opt/sickrage/config:/config \
        -v /download:/downloads \
        -v /tv:/tv \
        -e PGID=$(id -u sickrage) -e PUID=$(id -g sickrage) \
        -e TZ=Australia/Sydney \
        --restart unless-stopped \
        linuxserver/sickrage

    # add the sickrage process owner "abc" to the host's groups "download" and "tv"
    cat << EOF > /tmp/15-addgroups
#!/usr/bin/with-contenv bash
groupadd -g $(id -g download) download
groupadd -g $(id -g tv) tv
gpasswd -a abc download
gpasswd -a abc tv
EOF
    docker cp /tmp/15-addgroups sickrage:/etc/cont-init.d
    
    # start new
    docker start sickrage

    # clean up
    docker system prune -f
else

    # nothingtodohere
    echo "no update available"
fi
