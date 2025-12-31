variable "ssh_password" {
  description = "initial ssh root password"
  type        = string
	sensitive   = true
}

variable "ssh_user" {
  description = "initial ssh root user"
  type        = string
}

variable "k8s_source_template" {
  description = ""
  type        = string
}

variable "extend_root_disk_script" {
  description = ""
  type        = list
}

variable "iptables_k8s_config" {
  description = ""
  type        = list
}

variable "k8s_network_tidbits" {
  description = ""
  type        = list
}

variable "virtual_environment_endpoint" {
  description = ""
  type        = string
}
variable "virtual_environment_username" {
  description = ""
  type        = string
}
variable "virtual_environment_password" {
  description = ""
  type        = string
	sensitive   = true
}

variable "worker_count" {
  description = "number of worker nodes"
  type        = number
}
variable "worker_name" {
  description = "name prefix for worker nodes"
  type        = string
}
variable "virtual_environment_ssh_username" {
  description = ""
  default     = "root"
  type        = string
}
variable "worker_disk" {
  description = "size of worker disk in gigabytes"
  type        = number
}
variable "worker_disk_location" {
  description = "the storage device on which to put the primary disk"
	default     = "local-lvm"
  type        = string
}
variable "worker_cores" {
  description = "number of worker cores"
  type        = number
}
variable "worker_memory" {
  description = "amount of worker memory in megabytes"
  type        = number
}
variable "worker_description" {
  description = "description string for worker nodes"
  type        = string
}
variable "gameserver_count" {
  description = "number of gameserver nodes"
  type        = number
}
variable "gameserver_name" {
  description = "name prefix for gameserver nodes"
  type        = string
}
variable "gameserver_disk" {
  description = "size of gameserver disk in gigabytes"
  type        = number
}
variable "gameserver_disk_location" {
  description = "the storage device on which to put the primary disk"
	default     = "local-lvm"
  type        = string
}
variable "gameserver_cores" {
  description = "number of gameserver cores"
  type        = number
}
variable "gameserver_memory" {
  description = "amount of gameserver memory in megabytes"
  type        = number
}
variable "gameserver_description" {
  description = "description string for gameserver nodes"
  type        = string
}

variable "ip_address_start" {
  description = "value of 4th ip octet"
  type        = number
}
variable "target_node" {
  description = "pve node on which to deploy VMs"
  type        = string
}
variable "ip_address_base" {
  description = "first 3 octets of ip"
  type        = string
}
variable "gateway" {
  description = "ip of gateway"
  type        = string
}
variable "local_kubeconfig" {
  description = "destination path for kubeconfig"
  type        = string
}
variable "remote_kubeconfig" {
  description = "remote path of kubeconfig"
  type        = string
}
