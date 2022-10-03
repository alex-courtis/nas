#!/bin/sh

# check for update
docker pull linuxserver/sabnzbd | grep "Downloaded" >/dev/null
if [ $? -eq 0 ]; then

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
        -v /download:/download \
        -e PGID=$(id -u sabnzbd) -e PUID=$(id -g sabnzbd) \
        -e TZ=Australia/Sydney \
        --restart unless-stopped \
        linuxserver/sabnzbd

    # add the sabnzbd process owner "abc" to the host's group "download"
    cat << EOF > /tmp/15-addgroups
#!/usr/bin/with-contenv bash
groupadd -g $(id -g download) download
gpasswd -a abc download
EOF
docker cp /tmp/15-addgroups sabnzbd:/etc/cont-init.d

    # start new
    docker start sabnzbd

    # clean up
    docker system prune -f
else

    # nothingtodohere
    echo "no update available"
fi
