#!/bin/sh

if [ -z "$1" ]
then
	echo "\e[34mPlease provide Debians folder name 10890\e[0m"
	exit
fi

build_name=CI_DRM_$1

echo "Downloading local *.deb files from Local PC $build_name"

scp -r mastan@10.145.169.54:/home/mastan/worksapce/external/CI_DRM_BUILDS/CI_DRM_BUILDS/$build_name .

ret=$?

if [ $ret != 0 ]
then
	echo "\e[31m Debians Download failed\e[0m"
	exit 1
fi

cd $build_name

dpkg -i *.deb

ret=$?

if [ $ret != 0 ]
then
	echo "\e[31m dpkg installation failed\e[0m"
	exit 1
fi

echo $build_name > /boot/drm_intel.tag

echo "\e[33mChangeing Boot Param's\e[0m"

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="nmi_watchdog=panic,auto panic=5 softdog.soft_panic=5 drm.debug=0xe log_buf_len=1M trace_clock=global 3 ro"/g' /etc/default/grub

update-grub2

ret=$?

if [ $ret != 0 ]
then
	echo "\e[31m grub update failed\e[0m"
	exit 1
fi

echo "\e[32mDebians Installation Complete\e[0m"
awk -F\' '/menuentry / {print $2}' /boot/grub/grub.cfg
