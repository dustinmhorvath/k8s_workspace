#!/bin/bash

set -e

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root --private-key /root/keys/id_rsa ./rke2_ansible/setup_rke2.yml -i rke2_ansible/inventory
