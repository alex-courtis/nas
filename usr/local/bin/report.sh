#!/bin/sh

cat << EOM | sendmail -D -t
$(lord-email-header.sh "$(uptime -p)")
-
$(zpool status -t)
-
$(df -h / /boot /tmp)

$(df -h /srv/nfs | grep -v "^Filesystem")

$(df -h /srv/plex /srv/sabnzbd /srv/sickchill | grep -v "^Filesystem")
-
$(sensors -A)
-
$(lord-email-footer.sh)
EOM

