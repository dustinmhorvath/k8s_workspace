# Some kubespray pieces pulled from https://blog.andreasm.io/2024/01/15/proxmox-with-opentofu-kubespray-and-kubernetes/
# Keeping that as a note since it was a useful article. I added some of the pieces for destroying nodes, though my 'when:' directives could probably use some polish.

resource "proxmox_vm_qemu" "rke-nodes" {
  depends_on = [local_file.ansible_inventory]
  count           = var.worker_count
  tags        = "terraform,rocky,k8s-worker"
  ssh_private_key = file("/root/.ssh/id_rsa")
  name        = "${var.worker_name}-${count.index + 1}"
  description = var.worker_description
  target_node = var.target_node
  os_type     = "cloud-init"
  full_clone  = false
  memory      = var.worker_memory
  #balloon     = 2048
  cpu {
    cores    = var.worker_cores
    sockets = 1
    type        = "host"
  }
  clone       = var.k8s_source_template
  #qemu_os     = "l26"
  #machine     = "q35"
  onboot      = true
  skip_ipv6   = true
  agent       = 1
  disks {
    virtio {
      virtio0 {
        disk {
          size    = var.worker_disk
          storage = "ceph-rbd"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "ceph-rbd"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-init section
  ssh_user  = var.ssh_user
  ipconfig0 = "ip=${var.ip_address_base}.${var.ip_address_start + count.index + 1}/24,gw=${var.gateway}"
  ciuser    = var.ssh_user
  cipassword = var.ssh_password
  #sshkeys   = file("/root/.ssh/id_rsa")

  # Post creation actions
  provisioner "remote-exec" {
    inline = concat(var.extend_root_disk_script, var.docker_ce)
    connection {
      type        = "ssh"
      user        = var.ssh_user
      password    = var.ssh_password
      private_key = file("/root/.ssh/id_rsa")
      host        = "${var.ip_address_base}.${var.ip_address_start + count.index + 1}"
    }
  }

  provisioner "local-exec" {
    when    = destroy
    on_failure  = continue
    command = "./kubespray-destroy.sh ${self.name}"     # > ansible_output.log 2>&1
    interpreter = ["/bin/bash", "-c"]
  }

}

# Generate inventory file
resource "local_file" "ansible_inventory" {
  filename = "kubespray/inventory/k8s-cluster/inventory.ini"
  content = <<-EOF

  [kube_control_plane]
  %{ for index in range(0, var.worker_count, 1) ~}
  ${var.worker_name}-${index + 1} ansible_host=${var.ip_address_base}.${var.ip_address_start + index + 1} etcd_member_name=${var.worker_name}-${index + 1}
  %{ endfor ~}

  [etcd:children]
  kube_control_plane

  [kube_node]
  %{ for index in range(0, var.worker_count, 1) ~}
  ${var.worker_name}-${index + 1} ansible_host=${var.ip_address_base}.${var.ip_address_start + index + 1}
  %{ endfor ~}

  EOF

}

# Generate group_vars file
resource "local_file" "group_vars" {
  filename = "kubespray/inventory/k8s-cluster/group_vars/k8s_cluster/addons.yml"
  content = <<-EOF

  ingress_nginx_class: nginx
  ingress_nginx_without_class: true
  ingress_nginx_default: true
  argocd_enabled: false
  cephfs_provisioner_enabled: false
  cert_manager_enabled: true
  cert_manager_namespace: "cert-manager"
  gateway_api_enabled: false
  helm_enabled: true
  ingress_alb_enabled: false
  ingress_nginx_enabled: true
  ingress_nginx_namespace: "ingress-nginx"
  krew_enabled: false
  krew_root_dir: "/usr/local/krew"
  kube_vip_enabled: false
  local_path_provisioner_enabled: false
  local_volume_provisioner_enabled: false
  metallb_enabled: false
  metallb_namespace: "metallb-system"
  metallb_speaker_enabled: "{{ metallb_enabled }}"
  metrics_server_enabled: false
  node_feature_discovery_enabled: true
  rbd_provisioner_enabled: false
  registry_enabled: false

  EOF

}

resource "null_resource" "cluster-provision" {
  provisioner "local-exec" {
    command = "./kubespray-provision.sh"     # > ansible_output.log 2>&1
    interpreter = ["/bin/bash", "-c"]
    #working_dir = "./"
    }
  depends_on = [proxmox_vm_qemu.rke-nodes, local_file.ansible_inventory, local_file.group_vars]
  lifecycle {
    replace_triggered_by = [
      proxmox_vm_qemu.rke-nodes,
      local_file.ansible_inventory
    ]
  }
}

resource "null_resource" "kubeconfig" {
  depends_on = [null_resource.cluster-provision]
  provisioner "local-exec" {
    command = "echo ${var.ssh_password} | scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${var.ip_address_base}.${var.ip_address_start + 1}:${var.remote_kubeconfig} ${var.local_kubeconfig} && sed -i 's/127.0.0.1/${var.ip_address_base}.${var.ip_address_start + 1}/g' ${var.local_kubeconfig}"
    interpreter = ["bash", "-c"] # Explicitly define the interpreter for consistency
  }
}

