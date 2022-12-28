terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.4"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = "https://192.168.1.131:8006/api2/json"
}
