#!/bin/bash

# inf Foreman, Rocky linux has a .treeinfo file that hass appstream as dependency.
# as the upstream location is not the same path in Foreman this blocks kickstart 
# installations

# cp -a /root/.treeinfo /var/lib/pulp/published/yum/http/repos/CloudAlbania/Library/custom/RockyLinux_8/BaseOS_x86_64/.treeinfo

# To fix this remove the AppStream after BaseOS in [tree] section

# [tree]
# arch = x86_64
# build_timestamp = 1636882114
# platforms = x86_64,xen
# variants = BaseOS,AppStream <- This one

# and remove the following section:

# [variant-AppStream]
# id = AppStream
# name = AppStream
# type = variant
# uid = AppStream
# packages = ../../../AppStream/x86_64/os/Packages
# repository = ../../../AppStream/x86_64/os/