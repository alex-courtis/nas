#!/bin/sh

echo "BEFORE"
sysctl dev.raid.speed_limit_min
sysctl dev.raid.speed_limit_max
echo "group_thread_cnt=$(cat /sys/block/md0/md/group_thread_cnt)"

echo "SET"
# set manually, as sysctl starts before raid, see journal
# lord systemd-sysctl[495]: Couldn't write '5000000' to 'dev/raid/speed_limit_min', ignoring: No such file or directory
sysctl -w dev.raid.speed_limit_min=600000
sysctl -w dev.raid.speed_limit_max=600000

echo 8 > /sys/block/md0/md/group_thread_cnt

echo "AFTER"
sysctl dev.raid.speed_limit_min
sysctl dev.raid.speed_limit_max
echo "group_thread_cnt=$(cat /sys/block/md0/md/group_thread_cnt)"

