#!/bin/sh

echo "\e[33mDownloading Required Packages to Compile igt-gpu-tools\e[0m"

apt-get install git

echo "\e[34mCloneing igt-gpu-tools to download Dockerfile.build-debian\e[0m"

git config --global http.sslverify false

git clone https://gitlab.freedesktop.org/drm/igt-gpu-tools 

cd igt-gpu-tools

cat Dockerfile.build-debian-minimal | sed  's/RUN//g' > minimal.sh

sh  minimal.sh

cat Dockerfile.build-debian | sed  's/RUN//g' > main.sh

sh main.sh

echo "\e[32mAll dependent packages installed\e[0m"

cd ..

rm -rf igt-gpu-tools

echo "\e[33mDownloading fresh repo of igt-gpu-tools\e[0m"

git clone https://gitlab.freedesktop.org/drm/igt-gpu-tools

cd igt-gpu-tools

meson build

ninja -C build test


