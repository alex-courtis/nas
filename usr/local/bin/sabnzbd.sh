#!/bin/sh
docker stop sabnzbd

docker rm sabnzbd

docker pull linuxserver/sabnzbd

docker create \
    --name=sabnzbd \
    -v /opt/sabnzbd/config:/config \
    -v /opt/sabnzbd/incomplete-downloads:/incomplete-downloads \
    -v /data/download:/download \
    -e PGID=$(id -u sabnzbd) -e PUID=$(id -g sabnzbd) \
    -e TZ=Australia/Sydney \
    -p 8080:8080 -p 9090:9090 \
    --restart unless-stopped \
    linuxserver/sabnzbd

# add the sabnzbd process owner "abc" to the host's group "download"
cat << EOF > /tmp/15-addgroups
#!/usr/bin/with-contenv bash
groupadd -g $(id -g download) download
gpasswd -a abc download
EOF
docker cp /tmp/15-addgroups sabnzbd:/etc/cont-init.d

docker start sabnzbd
