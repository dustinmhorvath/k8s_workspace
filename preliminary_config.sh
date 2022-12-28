#!/bin/sh
set -e

helm repo add ceph-csi https://ceph.github.io/csi-charts
helm repo add k8s-at-home https://k8s-at-home.com/charts/
helm repo update
helm upgrade --install --create-namespace --namespace "ceph-csi-cephfs" "ceph-csi-cephfs" ceph-csi/ceph-csi-cephfs

# Enable cross-namespace for traefik+authentik
# kubectl -n kube-system patch deployment traefik --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--providers.kubernetescrd.allowCrossNamespace=true"}]'
#--certificatesresolvers.letsencryptprod.acme.tlschallenge
#--certificatesresolvers.letsencryptprod.acme.email=dustinmhorvath@gmail.com
#--certificatesresolvers.letsencryptprod.acme.storage=acme.json
#--certificatesresolvers.letsencryptprod.acme.caserver=https://acme-prod-v02.api.letsencrypt.org/directory
