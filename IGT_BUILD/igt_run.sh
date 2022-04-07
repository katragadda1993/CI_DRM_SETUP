#!/bin/sh

echo  "\e[33mGetting TestCase info from shards.txt run\e[0m"

if [ ! $1 ]
then
	echo "\e[31mNo tescase recieved from arguments\e[0m"
	exit 1
fi

cat /opt/igt/shards.txt | grep $1 > rerun.txt 

count=$(cat rerun.txt | wc -l)

if [ $count == 0 ]
then
	echo "\e[31mNo test cases found\e[0m";
	echo $1 > rerun.txt
fi

count=$(cat rerun.txt | wc -l) 

cat rerun.txt 

Date=$(date +'%d_%m_%Y_%H_%M_%S')

IGT_BUILD=$(ls /opt/igt/IGT_* | grep IGT)

CI_DRM_DII=$(cat /boot/drm_intel.tag)

RESULTS="$CI_DRM_DII"_"$IGT_BUILD"_"$Date"

read -p "Total Testcase $count  and Results Dir $RESULTS and Do you want't continue (Y/N)" choice
case "$choice" in
  y|Y ) echo "yes";;
  n|N ) echo "no";exit;;
  * ) echo "invalid";exit;;
esac


sudo LD_LIBRARY_PATH=/opt/igt/lib:/opt/igt/lib/x86_64-linux-gnu IGT_CI_META_TEST=yes INTEL_SIMULATION=0 /opt/igt/bin/igt_runner -o -l verbose -s --test-list ./rerun.txt --inactivity-timeout 91 --abort-on-monitored-error=taint --piglit-style-dmesg --dmesg-warn-level=5 -n "$CI_DRM_DII" --use-watchdog /opt/igt/libexec/igt-gpu-tools $RESULTS

FINAL_RESULT="$RESULTS"_"$1"

piglit summary html $FINAL_RESULT $RESULTS

scp -r $FINAL_RESULT mastan@10.145.169.54:/home/mastan/igt_results

if [ $? == 0 ]
then
sudo rm -rf $RESULTS
sudo rm -rf $FINAL_RESULT
fi
