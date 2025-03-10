variable "ssh_password" {
  description = "initial ssh root password"
  type        = string
}

variable "ssh_user" {
  description = "initial ssh root user"
  type        = string
}

variable "k8s_masters" {
  description = "vm variables in a dictionary "
  type        = map(any)
}

variable "k8s_workers" {
  description = "vm variables in a dictionary "
  type        = map(any)
}

variable "k8s_source_template" {
  description = ""
  type        = string
}

variable "extend_root_disk_script" {
  description = ""
  type        = list
}

variable "firewalld_k8s_config" {
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
}
variable "virtual_environment_ssh_username" {
  description = ""
  default     = "root"
  type        = string
}
