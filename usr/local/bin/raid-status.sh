cat << EOM
/sys/block/md0/md/sync_action      $(cat /sys/block/md0/md/sync_action)
/sys/block/md0/md/last_sync_action $(cat /sys/block/md0/md/last_sync_action)
/sys/block/md0/md/mismatch_cnt     $(cat /sys/block/md0/md/mismatch_cnt)
$(cat /proc/mdstat | sed -E 's/[<>]//g')
$(sysctl dev.raid.speed_limit_min)
$(sysctl dev.raid.speed_limit_max)
group_thread_cnt=$(cat /sys/block/md0/md/group_thread_cnt)
EOM
