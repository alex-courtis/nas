#!/bin/sh

if [ $# -eq 0 ]; then
	echo "pass an argument:"
	echo " ${0} -n"
	echo " ${0} --delete-after"
	echo "an argument is required to run e.g."
	echo " ${0} --owner"
	exit 1
fi

rsync \
	$@ \
	--archive \
	--owner \
	--group \
	--verbose \
	--itemize-changes \
	--partial --progress \
	'oldlord:/data/' \
	/srv/nfs
