#!/bin/sh
echo "\e[33mGeting DC5/DC6 Counter increments\e[0m"

cat /sys/kernel/debug/dri/0/i915_dmc_info

echo 1 > /sys/class/graphics/fb0/blank

sleep 2

cat /sys/kernel/debug/dri/0/i915_dmc_info

echo 0 > /sys/class/graphics/fb0/blank
