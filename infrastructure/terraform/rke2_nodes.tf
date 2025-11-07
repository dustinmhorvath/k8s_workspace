
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
    inline = concat(var.extend_root_disk_script, var.firewalld_k8s_config, var.docker_ce)
    connection {
      type        = "ssh"
      user        = var.ssh_user
      password    = var.ssh_password
      private_key = file("/root/.ssh/id_rsa")
      host        = "${var.ip_address_base}.${var.ip_address_start + count.index + 1}"
    }
  }

  #lifecycle {
  #    ignore_changes = [
  #       tags
  #    ]  
  #}

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
  [all]
  %{ for index in range(0, var.worker_count, 1) ~}
  ${var.worker_name}-${index + 1} ansible_host=${var.ip_address_base}.${var.ip_address_start + index + 1}
  %{ endfor ~}

  [kube_control_plane]
  %{ for index in range(0, var.worker_count, 1) ~}
	${var.worker_name}-${index + 1}
  %{ endfor ~}

  [etcd:children]
	kube_control_plane

  [kube_node]
  %{ for index in range(0, var.worker_count, 1) ~}
	${var.worker_name}-${index + 1}
  %{ endfor ~}

  [k8s_cluster:children]
  kube_node
  kube_control_plane

  EOF

}

resource "null_resource" "cluster-provision" {
  provisioner "local-exec" {
    command = "./kubespray-provision.sh"     # > ansible_output.log 2>&1
    interpreter = ["/bin/bash", "-c"]
    #working_dir = "./"
    }
  depends_on = [proxmox_vm_qemu.rke-nodes, local_file.ansible_inventory]
	lifecycle {
    replace_triggered_by = [
		  proxmox_vm_qemu.rke-nodes,
			local_file.ansible_inventory
		]
  }
}
