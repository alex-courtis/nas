#!/bin/sh

# mdcheck systemd service exists however this is enough

touch /tmp/raid-scrub.started
chmod 777 /tmp/raid-scrub.started

echo check > /sys/block/md0/md/sync_action

sleep 5
raid-scrub-monitor.sh
