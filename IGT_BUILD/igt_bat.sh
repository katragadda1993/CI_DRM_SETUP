#!/bin/sh

if [ ! $1 ]
then
	echo "\e[31mplease give name of BAT run\e[0m"
	exit 1
fi

Date=$(date +'%d_%m_%Y_%H_%M_%S')

IGT_BUILD=$(ls /opt/igt/IGT_* | grep IGT)

CI_DRM_DII=$(cat /boot/drm_intel.tag)

RESULTS="$CI_DRM_DII"_"$IGT_BUILD"_"$Date"

read -p "Bat $1 Results Dir $RESULTS and Do you want't continue (Y/N)" choice
case "$choice" in
  y|Y ) echo "yes";;
  n|N ) echo "no";exit;;
  * ) echo "invalid";exit;;
esac


sudo LD_LIBRARY_PATH=/opt/igt/lib:/opt/igt/lib/x86_64-linux-gnu IGT_CI_META_TEST=yes INTEL_SIMULATION=0 /opt/igt/bin/igt_runner -o -l verbose -s --test-list /opt/igt/share/igt-gpu-tools/fast-feedback.testlist  --inactivity-timeout 91 --abort-on-monitored-error=taint --piglit-style-dmesg --dmesg-warn-level=5 -n "$CI_DRM_DII" --use-watchdog /opt/igt/libexec/igt-gpu-tools $RESULTS

FINAL_RESULT="$RESULTS"_"$1"

piglit summary html $FINAL_RESULT $RESULTS

scp -r $FINAL_RESULT mastan@10.145.169.54:/home/mastan/igt_results

if [ $? == 0 ]
then
sudo rm -rf $RESULTS
sudo rm -rf $FINAL_RESULT
fi
