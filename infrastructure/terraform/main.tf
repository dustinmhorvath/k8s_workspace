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

#variable "var.rancher2_access_key" {
#  type = string
#	default = "hkjhadlkjbrgliv"
#}
#
#variable "var.rancher2_secret_key" {
#  type = string
#	default = "lksjhgkjafgkjalkbfvlkj"
#}
#
#provider "rancher2" {
#  api_url    = "https://rancher.perihelion.host"
#  access_key = var.rancher2_access_key
#  secret_key = var.rancher2_secret_key
#}
