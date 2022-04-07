#!/bin/bash
echo "Geting Display info"
sudo cat /sys/kernel/debug/dri/0/i915_display_info | more
