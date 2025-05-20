This is a repository for my own application stack. It contains a few components:
1. packer configuration for building rocky VM templates on Proxmox
2. terraform configuration for deploying Proxmox VMs
3. Ansible playbook for deploying RKE2 cluster. RKE2 still feels a little bit jank and one of these days I'll shop for a better dynamic-provisioning k8s cluster deployment, preferably one that can just be built into the Terraform deployment.
4. Application stack currently built around ArgoCD. This is intended to deploy one top-level Application for Argo itself, which then contains configurations for child Applications that get deployed automatically.

Note: There currently isn't anything in here for deploying *secrets*. I'm deploying all of these separately from a resource manifest that isn't in version control atm.
