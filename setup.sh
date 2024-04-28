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


# TODO
# raid maintenance
# disk maintenance
# 7 day systemd heartbeat timer
printf "from: lord <alex@courtis.org>\nsubject: %s\n" "$(uptime -p)" | sendmail alex@courtis.org
