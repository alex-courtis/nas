#!/bin/sh

# must be member of optical

set -e

VOL_ID="LORD_$(date +%Y%m%d_%H%M%S)"

ISO="/srv/nfs/tmp/${VOL_ID}.iso"

mkisofs \
	-V "${VOL_ID}" \
	-J \
	-r \
	-graft-points \
	-o "${ISO}" \
	/misc=/srv/nfs/misc \
	/music=/srv/nfs/music \
	/save=/srv/nfs/save

printf "burn %s ? " "${ISO}" ; read -r yn
if [ "${yn}" != "y" ]; then
	exit 1
fi

growisofs \
	-dvd-compat \
	-Z "/dev/sr0=${ISO}"

