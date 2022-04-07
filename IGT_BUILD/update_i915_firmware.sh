#!/bin/sh

#Note:- This step Required when ever i915 driver wedged due to firmware loading
#Like dependent firmware not found in /lib/firmware/i915
#update firmware before installing linux debs.

echo "\e[33mDownloading i915 Required firmwares\e[0m"

rm linux-firmware.tar.gz

wget -N http://gfx-ci.fi.intel.com/archive/scripts/linux-firmware.tar.gz

ret=$?

if [ $ret != 0 ]
then
	echo  "\e[31mFirmwares Download failed\e[0m"
	exit 1
fi

echo "\e[32mFirmwares Download Success\e[0m"

sudo tar -xvzf linux-firmware.tar.gz --directory=/lib/firmware/   

if [ $ret != 0 ]
then
        echo "\e[31mFirmwares Update failed\e[0m"
        exit 1
fi

sync

rm linux-firmware.tar.gz

echo "\e[32mFirmwares Update Succes\e[0m"
