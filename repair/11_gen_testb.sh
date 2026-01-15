#!/bin/sh

# tune2fs -l /dev/md0 | grep "Block size"
# Block size:               4096

# fdisk -u -l /dev/md0 | grep "Sector size"
# Sector size (logical/physical): 512 bytes / 512 bytes

set -e

while IFS= read -r s; do
    echo "testb $(calc "${s}/(4096/512)")"
done < 01_mismatch_sector > 11_testb

echo "wrote 11_testb:"
cat 11_testb

echo "run it with:"
echo "debugfs -f 11_testb /dev/md0"

echo
echo "remove any unused from 01_mismatch_sector"
