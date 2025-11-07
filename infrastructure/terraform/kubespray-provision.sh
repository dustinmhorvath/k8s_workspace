#!/bin/bash

# Set working directory
WORKING_DIR="./"
cd "$WORKING_DIR" || exit

# Set virtual environment variables
VENVDIR="env"
KUBESPRAYDIR="kubespray"

# Activate virtual environment
source "$VENVDIR/bin/activate" || exit

# Change to Kubespray directory
cd "$KUBESPRAYDIR" || exit

# Run Ansible playbook
ansible-playbook -i inventory/k8s-cluster/inventory.ini --become --become-user=root cluster.yml -u root

