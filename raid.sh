pacman -S mdadm arch-install-scripts


#
# remove
#

umount /dev/md0
mdadm -S /dev/md0
for disk in a b c d; do
	mdadm --misc --zero-superblock "/dev/sd${disk}1"
done


#
# partitions
#
for disk in a b c d; do
	wipefs --all "/dev/sd${disk}"
	parted --script "/dev/sd${disk}" \
		mktable GPT \
		mkpart raid 1MiB 100% \
		type 1 A19D880F-05FC-4D3B-A006-743F0F84911E
done


#
# raid device
#

# https://www.zdnet.com/article/chunks-the-hidden-key-to-raid-performance/
mdadm --create --verbose \
	--level=5 \
	--metadata=1.2 \
	--chunk=16 \
	--raid-devices=4 /dev/md0 \
	/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

mdadm --detail /dev/md0

cat /proc/mdstat # no need to wait for spare

raid-speed-limits.sh

# wait for build


#
# notifications
#

echo "MAILADDR alex@courtis.org" >> /etc/mdadm.conf
mdadm --detail --scan >> /etc/mdadm.conf

mdadm --monitor --oneshot --test /dev/md0


#
# filesystem
#

wipefs --all /dev/md0

# hardware block size, 4K
blockdev --getbsz /dev/sda

# stride = chunk size / block size = 16K / 4K = 4
# stripe width = number of data disks * stride = 3 * 4 = 12

mkfs.ext4 -v -L nfs -b 4096 -E stride=4,stripe-width=12 /dev/md0


#
# mount
#

mkdir /srv/nfs
mount /dev/md0 /srv/nfs

genfstab -U /srv/nfs >> /etc/fstab

# remove swap, set last fsck to 2, change point to /srv/nfs
vi /etc/fstab

