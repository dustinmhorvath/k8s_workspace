#!/bin/bash

# Ceph Cluster Maintenance
# Author: James McClune <jmcclune@mcclunetechnologies.net>

# Run this on Ceph monitor node (doesn't matter which one)

maintenanceConfig=$1

if [ $maintenanceConfig = "start" ]; then
    ceph osd set noout
    ceph osd set nobackfill
    ceph osd set norecover
    echo "Starting Ceph cluster maintenance..."
    exit 0
elif [ $maintenanceConfig = "stop" ]; then
    ceph osd unset noout
    ceph osd unset nobackfill
    ceph osd unset norecover
    echo "Stopping Ceph cluster maintenance..."
    exit 0
else
    echo "ERROR: You must specify either start or stop for Ceph maintenance."
    exit 1
fi