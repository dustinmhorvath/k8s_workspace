terraform {
  required_providers {
    ansible = {
      source = "ansible/ansible"
      version = "1.3.0"
    }
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc03"
    }
		rancher2 = {
      source = "rancher/rancher2"
      version = "8.2.1"
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

# Rancher2 provider configuration
provider "rancher2" {
  api_url    = "https://192.168.1.165"
	#alias      = "bootstrap"
	#bootstrap  = true
  token_key = "kljgjn8gi3n7492gjr83r8h"
}
