#!/bin/bash

TEMPLATE="templates/rocky8.json"
VAR_FILE="secrets.json"

#PACKER_TEMPLATE_VALIDATION=$(packer validate --var-file=$VAR_FILE $TEMPLATE)

packer build --on-error=abort --force --var-file=$VAR_FILE $TEMPLATE
