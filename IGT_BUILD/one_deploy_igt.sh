#!/bin/sh

if [[ $EUID -ne 0 ]]; then
	echo "\e[31mThis script must be run as root\e[0m"
	exit 1
fi

clear

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
        echo  "\e[31mscripts.tar.gz Extract failed\e[0m"
        exit
fi


if [ -z "$1" ]
then

	rm IGT_latest

	wget http://gfx-ci.fi.intel.com/archive/deploy/IGT_latest > /dev/null  2>&1

	CI_IGT=$(cat IGT_latest | grep IGT_ )

else

	CI_IGT="IGT_$1"
fi

read -p "Do want to Continue IGT=$CI_IGT (Y/N)" choice
case "$choice" in
	y|Y ) echo "yes";;
	n|N ) exit;;
	* ) echo "invalid";exit;;
esac

cd /opt/

export ARCHIVE_URL="http://gfx-ci.fi.intel.com/archive"

cd /opt/scripts/dut/

./deploy_igt.sh x $CI_IGT


wget http://archive.ubuntu.com/ubuntu/pool/main/j/json-c/libjson-c3_0.12.1-1.3ubuntu0.3_amd64.deb
sudo dpkg -i libjson-c3_0.12.1-1.3ubuntu0.3_amd64.deb

sudo apt-get install liboping0 libgsl-dev libxmlrpc-core-c3
sudo apt install libgsl-dev -y
sudo apt install libxmlrpc-core-c3 -y

wget http://archive.ubuntu.com/ubuntu/pool/main/p/procps/libprocps6_3.3.12-3ubuntu1_amd64.deb
dpkg -i libprocps6_3.3.12-3ubuntu1_amd64.deb
