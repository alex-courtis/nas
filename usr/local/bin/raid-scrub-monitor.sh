#!/bin/sh

STATUS="$(cat /sys/block/md0/md/sync_action)"

if [ "$STATUS" != "idle" ]; then

	PROGRESS=$(cat /proc/mdstat | grep "check =" | sed -E 's/^ *//g')

	cat << EOM | sendmail -D -t
$(lord-email-header.sh "${PROGRESS}")
$(raid-status.sh)
$(lord-email-footer.sh)
EOM

fi

