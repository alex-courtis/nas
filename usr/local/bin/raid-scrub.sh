#!/bin/sh

# mdcheck systemd service exists however this is enough

echo check > /sys/block/md0/md/sync_action

raid-scrub-monitor.sh
