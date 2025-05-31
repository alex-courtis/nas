#!/bin/sh

# must be member of optical

set -e

if [ $# -lt 2 ]; then
	printf "usage: %s <vol prefix> dirs\n" "${0}"
	printf "e.g. LORD /srv/nfs/misc /srv/nfs/music /srv/nfs/save\n"
	exit 1
fi

VOL_ID="${1}_$(date +%Y%m%d_%H%M%S)"

shift

ISO="/srv/nfs/tmp/${VOL_ID}.iso"

du -shc "${@}"
echo

PATHSPECS=""
for d in "${@}"; do
	PATHSPECS="${PATHSPECS}/$(basename "${d}")=${d} "
done

printf "pathspecs: %s\n\n" "${PATHSPECS}"

printf "make iso %s ? " "${ISO}" ; read -r yn
if [ "${yn}" != "y" ]; then
	exit 1
fi

mkisofs \
	-V "${VOL_ID}" \
	-J \
	-r \
	-graft-points \
	-o "${ISO}" \
	${PATHSPECS}

printf "burn %s ? " "${ISO}" ; read -r yn
if [ "${yn}" != "y" ]; then
	exit 1
fi

growisofs \
	-dvd-compat \
	-Z "/dev/sr0=${ISO}"

