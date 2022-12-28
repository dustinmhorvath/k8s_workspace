resource "proxmox_vm_qemu" "rocky8-k8s-kubespray-masters" {
  for_each    = var.k8s_masters
  name        = each.value.name
  desc        = each.value.name
  target_node = each.value.target_node
  os_type     = "cloud-init"
  full_clone  = true
  memory      = each.value.memory
  balloon     = 2048
  sockets     = "1"
  cores       = each.value.vcpu
  cpu         = "host"
  scsihw      = "virtio-scsi-pci"
  clone       = var.k8s_source_template
  agent       = 1
  disk {
    size    = each.value.disk_size
    type    = "virtio"
    storage = "vm-pool"
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-init section
  ipconfig0 = "ip=${each.value.ip}/24,gw=${each.value.gw}"
  ssh_user  = var.ssh_user
#  sshkeys   = var.ssh_pub_key

  # Post creation actions
  provisioner "remote-exec" {
    inline = concat(var.extend_root_disk_script, var.firewalld_k8s_config)
    connection {
      type        = "ssh"
      user        = var.ssh_user
      password    = var.ssh_password
#      private_key = file("~/.ssh/id_rsa")
      host        = each.value.ip
    }
  }
}

resource "proxmox_vm_qemu" "rocky8-k8s-kubespray-workers" {
  for_each    = var.k8s_workers
  name        = each.value.name
  desc        = each.value.name
  target_node = each.value.target_node
  os_type     = "cloud-init"
  full_clone  = true
  memory      = each.value.memory
  balloon     = 2048
  sockets     = "1"
  cores       = each.value.vcpu
  cpu         = "host"
  scsihw      = "virtio-scsi-pci"
  clone       = var.k8s_source_template
  agent       = 1
  disk {
    size    = each.value.disk_size
    type    = "virtio"
    storage = "vm-pool"
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-init section
  ipconfig0 = "ip=${each.value.ip}/24,gw=${each.value.gw}"
  ssh_user  = var.ssh_user
#  sshkeys   = var.ssh_pub_key

  # Post creation actions
  provisioner "remote-exec" {
    inline = concat(var.extend_root_disk_script, var.firewalld_k8s_config)
    connection {
      type        = "ssh"
      user        = var.ssh_user
      password    = var.ssh_password
#      private_key = file("~/.ssh/id_rsa")
      host        = each.value.ip
    }
  }
#  provisioner "local-exec" {
#    #command = "cp -rfp kubespray/inventory/sample/ kubespray/inventory/mycluster"
#    # //build the inventory file here somehow, from terraform vars
#    #command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i kubespray/inventory/mycluster/inventory.ini --become --become-user=root kubespray/cluster.yml"
#  }
}
