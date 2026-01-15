#!/bin/sh

inodes=$(debugfs -f 21_icheck /dev/md0 2>&1 | \
	grep -E "^[0-9].*[0-9]$" | \
	sed -E 's/.*\t/\n/')

for n in $inodes; do
	echo "ncheck ${n}"
done > 22_ncheck

echo "wrote 22_ncheck"
cat 22_ncheck

echo "run it with:"
echo "debugfs -f 22_ncheck /dev/md0"
