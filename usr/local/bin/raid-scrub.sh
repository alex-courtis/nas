#!/bin/sh

# reload, as sysctl starts before raid, see
# lord systemd-sysctl[495]: Couldn't write '5000000' to 'dev/raid/speed_limit_min', ignoring: No such file or directory
sysctl --system

# mdcheck systemd service exists however this is enough

echo check > /sys/block/md0/md/sync_action

raid-scrub-monitor.sh
