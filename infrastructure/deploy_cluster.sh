#!/bin/bash

set -e
ansible-playbook 01_cluster_deploy.yml -i localhost,
source .env/bin/activate
cd /mnt/ceph/k8s_workspace/infrastructure/kubespray             && ansible-playbook -i /mnt/ceph/k8s_workspace/infrastructure/kubespray/inventory/cluster_test/hosts.yaml cluster.yml
cd /mnt/ceph/k8s_workspace/infrastructure/02_cluster_configuration && ansible-playbook -i /mnt/ceph/k8s_workspace/infrastructure/kubespray/inventory/cluster_test/hosts.yaml cluster_config.yml
