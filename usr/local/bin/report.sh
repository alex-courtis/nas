#!/bin/sh

# -D run in foreground to prevent systemd from killing it

cat << EOM | sendmail -D -t
to: alex@courtis.org
from: lord <alex@courtis.org>
subject: $(uptime -p)

-
/sys/block/md0/md/sync_action      $(cat /sys/block/md0/md/sync_action)
/sys/block/md0/md/last_sync_action $(cat /sys/block/md0/md/last_sync_action)
/sys/block/md0/md/mismatch_cnt     $(cat /sys/block/md0/md/mismatch_cnt)
-
$(cat /proc/mdstat)
-
$(df -h / /boot /tmp)

$(df -h /srv/nfs | grep -v "^Filesystem")

$(df -h /srv/plex /srv/sabnzbd /srv/sickrage | grep -v "^Filesystem")
-
EOM

