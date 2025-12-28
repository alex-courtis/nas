#!/bin/sh

ACTION="$(cat /sys/block/md0/md/sync_action)"

if [ "$ACTION" != "idle" ]; then

	STATUS=$(raid-status.sh)
	echo "${STATUS}"

	PROGRESS=$(cat /proc/mdstat | grep "check =" | sed -E 's/^ *//g')

	cat << EOM | sendmail -D -t
$(lord-email-header.sh "${PROGRESS}")
${STATUS}
$(lord-email-footer.sh)
EOM

fi

