#
# creation
#

# disk ids
ls /dev/disk/by-id/ | grep "ata-"

# show block size
blockdev --getpbsz /dev/sda

# create
# vdevs
# 512 byte block -> 4k sector
# name pool
zpool create \
	-f \
	-m /srv \
	-o ashift=12 \
	pool \
	raidz \
	ata-Samsung_SSD_870_QVO_8TB_S5SSNF0WA05324A \
	ata-Samsung_SSD_870_QVO_8TB_S5SSNF0WA05327T \
	ata-Samsung_SSD_870_QVO_8TB_S5SSNF0WA05350J \
	ata-Samsung_SSD_870_QVO_8TB_S5SSNF0WA05377P

# show history
zpool history

# verify pool status
zpool status -v

# enable services
systemctl enable zfs.target
systemctl start zfs.target
systemctl enable zfs-zed.service
systemctl start zfs-zed.service
systemctl enable zfs-import.target
systemctl start zfs-import.target
systemctl enable zfs-import-cache.service
systemctl start zfs-import-cache.service

# AW advises against zfs-mount due to load order issues
# Use zfs-mount-generator
mkdir /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/pool

# generate the cache once
systemctl start zfs-import-cache.service

#
# data sets
#

# zfs create pool/archive
zfs create pool/download
# zfs create pool/media
zfs create pool/movie
zfs create pool/music
zfs create pool/save
zfs create pool/tmp
zfs create pool/tv

zfs set quota=1T pool/download
zfs set quota=512G pool/tmp
