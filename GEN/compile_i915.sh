#!/bin/sh

echo  "\e[33mCompileing i915 module only\e[0m"

cd /home/mastan/worksapce/external/CI_DRM_BUILDS/drm-tip

make -C . M=drivers/gpu/drm/i915/ -j64

ret=$?

if [ $ret != 0 ]
then
	echo "\e[31m Compile i915.ko failed $ret"
	exit 1
fi

echo  "\e[32m Compile i915.ko Success\e[0m"
