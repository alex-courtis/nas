#!/bin/sh

groupadd -g 1100 media ; sudo useradd -M -s /sbin/nologin -d / -u 1100 -g 1100 media
groupadd -g 1101 music ; sudo useradd -M -s /sbin/nologin -d / -u 1101 -g 1101 music
groupadd -g 1102 download ; sudo useradd -M -s /sbin/nologin -d / -u 1102 -g 1102 download
groupadd -g 1103 tv ; sudo useradd -M -s /sbin/nologin -d / -u 1103 -g 1103 tv
groupadd -g 1104 movie ; sudo useradd -M -s /sbin/nologin -d / -u 1104 -g 1104 movie
groupadd -g 1105 scratch ; sudo useradd -M -s /sbin/nologin -d / -u 1105 -g 1105 scratch
groupadd -g 1106 save ; sudo useradd -M -s /sbin/nologin -d / -u 1106 -g 1106 save
groupadd -g 1107 archive ; sudo useradd -M -s /sbin/nologin -d / -u 1107 -g 1107 archive

groupadd -g 1200 plex ; sudo useradd -M -s /sbin/nologin -d / -u 1200 -g 1200 plex
groupadd -g 1201 sabnzbd ; sudo useradd -M -s /sbin/nologin -d / -u 1201 -g 1201 sabnzbd
groupadd -g 1203 sickchill ; sudo useradd -M -s /sbin/nologin -d / -u 1203 -g 1203 sickchill

