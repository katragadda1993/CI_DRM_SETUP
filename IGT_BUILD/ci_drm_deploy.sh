#!/bin/sh

if [[ $EUID -ne 0 ]]; then
	echo "\e[31mThis script must be run as root\e[0m"
	exit 1
fi

clear

if [ -z "$1" ]
then
	rm index.html

	wget http://gfx-ci.fi.intel.com/archive/deploy/ > /dev/null  2>&1

	CI_DRM_BUILD=$(cat index.html | grep CI_DRM | tail -n 1 | cut -d '>' -f2 | cut -d '/' -f1)
else

	CI_DRM_BUILD="CI_DRM_$1"
fi

rm IGT_latest
wget http://gfx-ci.fi.intel.com/archive/deploy/IGT_latest > /dev/null  2>&1

CI_IGT=$(cat IGT_latest | grep IGT_ )

echo "\e[34mSeting UP CI_DRM_SETUP\e[0m"

read -p "Do want to Continue CI_DRM=$CI_DRM_BUILD and IGT=$CI_IGT (Y/N)" choice
case "$choice" in
	y|Y ) echo "yes";;
	n|N ) exit;;
	* ) echo "invalid";exit;;
esac

cd /opt/

export ARCHIVE_URL="http://gfx-ci.fi.intel.com/archive"

cd /opt/scripts/dut/

./Deploy.sh $CI_DRM_BUILD

cat /boot/drm_intel.tag | grep $CI_DRM_BUILD
ret=$?

if [ $ret != 0  ]
then
	echo "\e[35mNot Found Latest repo geting from backups\e[0m $CI_DRM_BUILD"
	ID=$(echo $CI_DRM_BUILD | cut -d '_' -f3)
	echo $ID
	cd /tmp/archive/
	wget https://gfx-assets.fm.intel.com/artifactory/gfx-osgc-assets-igk/builds/DRM/CI_DRM/$ID/artifacts/kernel.tar.gz
	cd /opt/scripts/dut
	./dut_deploy.sh
fi

sudo grub-reboot igt

sudo update-grub2

./deploy_igt.sh x $CI_IGT

read -p "Do You want restart PC (y/n)?" choice
case "$choice" in
	y|Y ) sudo reboot;;
	n|N ) echo "no";;
	* ) echo "invalid";;
esac
