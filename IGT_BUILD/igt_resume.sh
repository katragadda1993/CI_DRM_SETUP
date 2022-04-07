#!/bin/sh
  
if [ ! -d $1 ]
then
        echo -e "\e[31m$1 not found continue resume run\e[0m"
        exit 1;
fi

TEST_NAME=$(cat $1/joblist.txt | head -n 1 | sed 's/\ /_/g')
echo $TEST_NAME
sudo LD_LIBRARY_PATH=/opt/igt/lib:/opt/igt/lib/x86_64-linux-gnu IGT_CI_META_TEST=yes INTEL_SIMULATION=0 /opt/igt/bin/igt_resume $1

FINAL_RESULT="$1"_"$TEST_NAME"
echo $FINAL_RESULT

piglit summary html $FINAL_RESULT $1

scp -r $FINAL_RESULT mastan@10.145.169.54:/home/mastan/igt_results


if [ $? == 0 ]
then
sudo rm -rf $1
sudo rm -rf $FINAL_RESULT
sudo rm rerun.txt 
fi

