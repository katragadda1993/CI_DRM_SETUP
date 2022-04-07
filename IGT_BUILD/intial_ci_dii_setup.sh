#!/bin/sh

if [[ $EUID -ne 0 ]]; then
   echo "\e[31mThis script must be run as root\e[0m"
   exit 1
fi

clear 

rm index.html

wget http://intel-gfx-ci-internal.igk.intel.com/archive/deploy/ > /dev/null  2>&1

CI_DII_BUILD=$(cat index.html | grep DII | tail -n 1 | cut -d '"' -f2 | cut -d '_' -f1-2)_prerelease

#CI_DRM_BUILD="CI_DRM_10463"

rm IGT_latest
wget http://intel-gfx-ci-internal.igk.intel.com/archive/deploy/IGT_latest> /dev/null  2>&1

CI_IGT=$(cat IGT_latest | grep IGT_ )

echo "Seting UP CI_DII_SETUP"

read -p "Do want to Continue CI_DII=$CI_DII_BUILD and IGT=$CI_IGT (Y/N)" choice
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

export ARCHIVE_URL="http://intel-gfx-ci-internal.igk.intel.com/archive"

cd /opt/scripts/dut/

./kdeploy.sh -n drm_intel -t $CI_DII_BUILD -u http://intel-gfx-ci-internal.igk.intel.com/archive/deploy/$CI_DII_BUILD/linux.tar.gz

cat /boot/drm_intel.tag | grep $CI_DII_BUILD

sudo grub-reboot igt

sudo update-grub2

./deploy_igt.sh x $CI_IGT

sudo apt-get install piglit
