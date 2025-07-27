resource "proxmox_cloud_init_disk" "ci" {
  for_each    = var.rke_nodes

  name      = each.value.name
  pve_node  = each.value.target_node
  storage   = "ceph-rbd"

  meta_data = yamlencode({
    instance_id    = sha1(each.value.name)
    local-hostname = each.value.name
  })

  user_data = <<-EOT
  #cloud-config
  #users:
  #  - default
  #ssh_authorized_keys:
  #  - ssh-rsa AAAAB3N......
  EOT

  network_config = yamlencode({
    version = 1
    config = [{
      type = "physical"
      name = "enp6s18"
      subnets = [{
        type            = "static"
        address         = "${each.value.ip}/24"
        gateway         = "${each.value.gw}"
        dns_nameservers = [
          "1.1.1.1", 
          "8.8.8.8"
          ]
      }]
    }]
  })
}

resource "proxmox_vm_qemu" "rke-nodes" {
  for_each    = var.rke_nodes
  name        = each.value.name
  description = each.value.name
  target_node = each.value.target_node
  os_type     = "cloud-init"
  full_clone  = false
  memory      = each.value.memory
  #balloon     = 2048
  cpu {
    cores    = each.value.vcpu
    sockets = 1
    type        = "host"
  }
  clone       = var.k8s_source_template
  qemu_os     = "l26"
  machine     = "q35"
  onboot      = true
  agent       = 1
  disks {
    virtio {
      virtio0 {
        disk {
          size    = each.value.disk_size
          storage = "ceph-rbd"
        }
      }
    }
    scsi {
      scsi0 {
        cdrom {
          iso = "${proxmox_cloud_init_disk.ci[each.key].id}"
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
  #sshkeys   = file("/root/.ssh/id_rsa")

  # Post creation actions
  provisioner "remote-exec" {
    inline = concat(var.extend_root_disk_script, var.firewalld_k8s_config)
    connection {
      type        = "ssh"
      user        = var.ssh_user
      password    = var.ssh_password
      private_key = file("/root/.ssh/id_rsa")
      host        = each.value.ip
    }
  }

}

resource rke_cluster "rke2-cluster" {
  dynamic "nodes" {
    for_each         = var.rke_nodes
    content {
      address          = nodes.value.ip
      internal_address = nodes.value.ip
      user             = var.ssh_user
      role             = ["controlplane", "worker", "etcd"]
      ssh_key          = file("/root/.ssh/id_rsa")
    }
  }
}
