#!/bin/bash

TEMPLATE="packer-proxmox-lab/templates/rocky8.pkr.hcl"
VAR_FILE="packer-proxmox-lab/secrets.hcl"

#PACKER_TEMPLATE_VALIDATION=$(packer validate --var-file=$VAR_FILE $TEMPLATE)

packer build --on-error=abort --force --var-file=$VAR_FILE $TEMPLATE
