#
# drivetemp monitoring
#
echo drivetemp > /etc/modules-load.d/drivetemp.conf
modprobe drivetemp
sensors

