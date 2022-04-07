#!/bin/sh

echo  "\e[33mDownloading i915.ko module from Last compiled images\e[0m"

rm i915.ko

scp -r mastan@10.145.169.54:/home/mastan/worksapce/external/CI_DRM_BUILDS/drm-tip/drivers/gpu/drm/i915/i915.ko .

ret=$?

if [ $ret != 0 ]
then
	echo  "\e[31m Dowloading i915 driver failed Please Check path driver compiled or not\e[0m"
	exit 1
fi

cp i915.ko  /lib/modules/$(uname -r)/kernel/drivers/gpu/drm/i915/i915.ko

ret=$?

if [ $ret != 0 ]
then
	echo  "\e[31mCopy i915 driver failed Please Check path driver\e[0m"
	exit 1
fi

update-initramfs -u

ret=$?

if [ $ret != 0 ]
then
	echo  "\e[31mupdate-initramfs failed\e[0m"
	exit 1
fi

echo  "\e[32mi915.ko updated Please reboot\e[0m"
