#!/bin/sh
set -e

if [ ! -d /pkg/main/azusa.symlinks.core/ ]; then
	echo "apkg is not running on local system, cannot proceed"
	exit 1
fi

if [ `id -u` != "0" ]; then
	echo "You really need to run this as root"
	exit 1
fi

mkdir root
/pkg/main/azusa.symlinks.core/azusa/makeroot.sh root

# copy entrypoint
cp docker-entrypoint.sh root/usr/azusa
chmod +x root/usr/azusa/docker-entrypoint.sh

# generate archive
tar -C root -cp . | bzip2 -9 >root.tar.bz2
rm -fr root

# confirm file and display contents
tar tvjf root.tar.bz2
