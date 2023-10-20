#!/bin/bash

TEMPLATE="templates/ubuntu_2004_proxmox.json"
VAR_FILE="secrets.json"

PACKER_TEMPLATE_VALIDATION=$(packer validate --var-file=$VAR_FILE $TEMPLATE)

if [[ ${PACKER_TEMPLATE_VALIDATION} == "The configuration is valid." ]] ; then
    echo "[i] Packer template syntax validation successful"
    echo "[i] Building the VM template"
    ssh root@pve02.cloudalbania.com  "qm destroy 225 --skiplock"
    PACKER_LOG=1 packer build --force --var-file=$VAR_FILE $TEMPLATE
else
    echo "[X] Packer template syntax validation failed"
fi