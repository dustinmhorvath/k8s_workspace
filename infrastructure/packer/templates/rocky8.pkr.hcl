packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "iso_url" {
  type    = string
  default = "local:iso/Rocky-8.9-x86_64-dvd1.iso"
}

variable "vm-cpu-num" {
  type    = string
  default = "4"
}

variable "vm-disk-size" {
  type    = string
  default = "30G"
}

variable "vm-mem-size" {
  type    = string
  default = "4096"
}

variable "vm-name" {
  type    = string
  default = "rocky-8-template"
}

variable "proxmox-url" {
  type    = string
}
variable "proxmox-username" {
  type    = string
}

variable "proxmox-password" {
  type    = string
}

variable "proxmox-node" {
  type    = string
}

variable "ssh-password" {
  type    = string
}


source "proxmox-iso" "autogenerated_1" {
  boot_command            = ["<esc><wait>", "linux text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky8.ks<enter>"]
  cloud_init              = "true"
  cloud_init_storage_pool = "local-lvm"
  cores                   = "${var.vm-cpu-num}"
  disks {
    disk_size         = "${var.vm-disk-size}"
    format            = "raw"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm-thin"
    type              = "virtio"
  }
  http_directory           = "${path.root}/../kickstarts"
  insecure_skip_tls_verify = "true"
  #iso_checksum             = "sha256:${var.checksum}"
  iso_file                 = "${var.iso_url}"
  machine                  = "q35"
  memory                   = "${var.vm-mem-size}"
  network_adapters {
    bridge   = "vmbr0"
    firewall = false
    model    = "virtio"
  }
  node                 = "${var.proxmox-node}"
  os                   = "l26"
  password             = "${var.proxmox-password}"
  proxmox_url          = "${var.proxmox-url}"
  qemu_agent           = "true"
  scsi_controller      = "pvscsi"
  ssh_password         = "${var.ssh-password}"
  ssh_private_key_file = "/root/.ssh/id_rsa"
  ssh_timeout          = "90m"
  ssh_username         = "root"
  template_description = "Proxmox Rocky Linux 8 packer image"
  template_name        = "${var.vm-name}"
  unmount_iso          = "true"
  username             = "${var.proxmox-username}"
  vm_id                = "223"
  vm_name              = "${var.vm-name}"

  #cd_content = {
  #  #"meta-data" = jsonencode(local.instance_data)
  #  "user-data" = templatefile("user-data", { packages = ["nginx"] })
  #}
  #cd_label = "cidata"

}


build {
  sources = ["source.proxmox-iso.autogenerated_1"]

  provisioner "shell" {
    inline = ["mkdir -m 700 ~/.ssh/"]
  }

  provisioner "file" {
    destination = "/root/.ssh/authorized_keys"
    source      = "/root/.ssh/id_rsa.pub"
	}

  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbook.yml"
    use_proxy = "false"
		user = "root"
		ssh_host_key_file = "/root/.ssh/id_rsa.pub"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]

  }

}
