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
	-m /srv/nfs \
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

zfs create pool/archive
zfs create pool/download
zfs create pool/misc
zfs create pool/movie
zfs create pool/music
zfs create pool/save
zfs create pool/tmp
zfs create pool/tv

zfs set quota=1T pool/download
zfs set quota=512G pool/tmp

#
# enable nfs
#
systemctl enable nfsv4-server.service
systemctl enable zfs-share.service
systemctl start nfsv4-server.service
systemctl start zfs-share.service

# explicit nfs for each, can't inherit fsid=root
zfs set sharenfs="rw=@192.168.1.0/24,fsid=root" pool
zfs set sharenfs="rw=@192.168.1.0/24" pool/archive
zfs set sharenfs="rw=@192.168.1.0/24" pool/download
zfs set sharenfs="rw=@192.168.1.0/24" pool/misc
zfs set sharenfs="rw=@192.168.1.0/24" pool/movie
zfs set sharenfs="rw=@192.168.1.0/24" pool/music
zfs set sharenfs="rw=@192.168.1.0/24" pool/save
zfs set sharenfs="rw=@192.168.1.0/24" pool/tmp
zfs set sharenfs="rw=@192.168.1.0/24" pool/tv

# show
exportfs -v
showmount -e lord
zfs get sharenfs

