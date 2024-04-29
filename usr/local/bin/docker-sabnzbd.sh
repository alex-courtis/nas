#!/bin/sh

# check for update
docker pull linuxserver/sabnzbd | grep "Downloaded" >/dev/null
if [ $? -eq 0 ]; then

    # add the sabnzbd process owner "abc" to the host's group "download"
    cat << EOF > /opt/sabnzbd/custom-cont-init.d/15-addgroups
#!/usr/bin/with-contenv bash
groupadd -g $(id -g download) download
gpasswd -a abc download
EOF
	chmod 700 /opt/sabnzbd/custom-cont-init.d/15-addgroups

    # stop existing
    docker stop sabnzbd

    # delete existing
    docker rm sabnzbd

    # create new
    docker create \
        --name=sabnzbd \
        --net=host \
        -v /opt/sabnzbd/config:/config \
        -v /opt/sabnzbd/incomplete-downloads:/incomplete-downloads \
        -v /opt/sabnzbd/custom-cont-init.d:/custom-cont-init.d \
        -v /download:/download \
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
