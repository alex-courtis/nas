#!/bin/sh

set -e

while IFS= read -r s; do
    echo "icheck $(calc "${s}/(4096/512)")"
done < 01_mismatch_sector > 21_icheck

echo "wrote 21_icheck:"
cat 21_icheck

echo
echo "run 22_gen_ncheck"
