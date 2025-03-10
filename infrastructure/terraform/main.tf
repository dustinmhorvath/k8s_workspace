terraform {
  required_providers {
    ansible = {
      source = "ansible/ansible"
      version = "1.3.0"
    }
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc1"
#      source = "bpg/proxmox"
#      version = "0.60.1"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = "https://192.168.1.201:8006/api2/json"
#  endpoint = "https://192.168.1.201:8006/api2/json"
#  #api_token = var.virtual_environment_api_token
#  insecure = true
#  ssh {
#    agent = true
#    username = var.virtual_environment_ssh_username
#  }
}

