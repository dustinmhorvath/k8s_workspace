#!/bin/bash

set -e

VENVDIR=.env
python3 -m virtualenv --python=$(which python3) $VENVDIR && \
source $VENVDIR/bin/activate && \
pip3 install ansible
export ANSIBLE_HOST_KEY_CHECKING=false

ansible-playbook 01_cluster_deploy.yml -i localhost,

cd /mnt/ceph/k8s_workspace/infrastructure/kubespray                && ansible-playbook -i /mnt/ceph/k8s_workspace/infrastructure/kubespray/inventory/cluster_test/hosts.yaml cluster.yml
cd /mnt/ceph/k8s_workspace/infrastructure/02_cluster_configuration && ansible-playbook -i /mnt/ceph/k8s_workspace/infrastructure/kubespray/inventory/cluster_test/hosts.yaml cluster_config.yml
