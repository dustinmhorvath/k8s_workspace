#!/bin/sh

# Use parted to extend root partition to available /dev/vda space
parted -s -a opt /dev/vda "print free" "resizepart 2 100%" "print free"
pvresize /dev/vda2
#VGROUP=$(mount | grep root | awk "{ print \$1 }")
#lvextend -l +100%FREE -r $VGROUP
