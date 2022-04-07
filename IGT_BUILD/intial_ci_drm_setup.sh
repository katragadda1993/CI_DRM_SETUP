#!/bin/sh


#!/bin/bash
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
  n|N ) echo "no";exit;;
  * ) echo "invalid";exit;;
esac

cd /opt/

rm scripts.tar.gz

wget http://gfx-ci.fi.intel.com/archive/scripts/scripts.tar.gz

ret=$?

if [ $ret != 0 ]
then
	echo "\e[31mscripts.tar.gz download failed\e[0m"
	exit
fi

tar -xvf scripts.tar.gz 

ret=$?

if [ $ret != 0 ]
then
        echo "\e[31mscripts.tar.gz Extract failed\e[0m"
        exit
fi

# commenting GRUB options using SED 

sed -e '/GRUB_DEVICE/s/^/#/g' -i /etc/default/grub
sed -e '/GRUB_DISABLE_LINUX_UUID/s/^/#/g' -i /etc/default/grub

/opt/scripts/system/prepare_dut.sh

/opt/scripts/dut/setup/gfxci_setup.sh

export ARCHIVE_URL="http://gfx-ci.fi.intel.com/archive"

cd /opt/scripts/dut/

./Deploy.sh $CI_DRM_BUILD

cat /boot/drm_intel.tag | grep $CI_DRM_BUILD

sudo grub-reboot igt

sudo update-grub2

./deploy_igt.sh x $CI_IGT

sudo apt-get install piglit

