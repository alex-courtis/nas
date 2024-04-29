#
# drivetemp monitoring
#
echo drivetemp > /etc/modules-load.d/drivetemp.conf
modprobe drivetemp
sensors

#
# monit
#
cp /etc/nas/etc/monitrc /etc
systemctl enable monit
systemctl start monit


#
# TODO
#

# raid maintenance
# echo check > /sys/block/md0/md/sync_action
# cat /sys/block/md0/md/mismatch_cnt

# disk maintenance

# docker update mail
