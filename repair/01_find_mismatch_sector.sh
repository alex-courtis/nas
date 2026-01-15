#!/bin/sh

journalctl -b -g mismatch\ sector | \
	sed -E 's/.*in range ([0-9]+).*/\1/g' \
	> 01_mismatch_sector

echo "wrote 01_mismatch_sector:"
cat 01_mismatch_sector
