#!/bin/sh

cp -v --preserve=mode usr/local/bin/* /usr/local/bin

cp -v --preserve=mode etc/dma/dma.conf /etc/dma
echo "---skipping etc/dma/auth.conf---"

cp -v --preserve=mode etc/systemd/system/* /etc/systemd/system

cp -v --preserve=mode etc/mdadm.conf /etc

cp -v --preserve=mode etc/smartd.conf /etc

echo "---skipping etc/monitrc---"

# TODO remove
rm -v /etc/systemd/system/docker*
