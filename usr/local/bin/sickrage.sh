#!/bin/sh
docker stop sickrage

docker rm sickrage

docker pull linuxserver/sickrage

docker create \
    --name=sickrage \
    --net=host \
    -v /opt/sickrage/config:/config \
    -v /data/download:/downloads \
    -v /data/tv:/tv \
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

docker start sickrage
