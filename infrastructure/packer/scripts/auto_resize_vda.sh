#!/bin/sh

# Use parted to extend root partition to available /dev/vda space
echo 1 > /sys/block/vda/device/rescan
parted -s -a opt /dev/vda "print free" "resizepart 2 100%" "print free"
/sbin/pvresize /dev/vda2

# Don't use everything for root
#VGROUP=$(mount | grep root | awk "{ print \$1 }")
lvresize -r -l +100%FREE local/var
