#!/bin/sh

set -e

while IFS= read -r s; do
    echo "testb $(calc "${s}/(4096/512)")"
done < 01_mismatch_sector > 11_testb

echo "wrote 11_testb:"
cat 11_testb

echo "run it with:"
echo "debugfs -f 11_testb /dev/md0"
