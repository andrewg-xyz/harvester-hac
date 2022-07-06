# --- Common Variables ---
variable "vlan_name" {
  description = "VLAN Name"
  type = string
  default = "dns"
}

variable "cpu" {
  description = "CPU core count"
  type        = number
  default     = 4
}

variable "memory" {
  description = "Memory for each node"
  type = string
  default = "16Gi"
}

variable "vm_namespace" {
  description = "namespace for VM"
  type = string
  default = "default"
}

variable "vm_disk_size" {
  description = "size of root disk"
  type = string
  default = "25Gi"
}

variable "network_gw" {
  description = "network gateway"
  type = string
  default = "23.0.0.1"
}

variable "network_nameserver" {
  description = "network nameserver"
  type = string
  default = "23.0.0.1"
}

variable "ssh_key" {
  description = "SSH private key"
  type = string
  default = "~/.ssh/id_ed25519"
}

variable "ci_user" {
  description = "username"
  type = string
  default = "user"
}

variable "ci_secret" {
  description = "login secret"
  type = string
}

# --- VM ---
variable "vm_name" {
  description = "Name of VM"
  type = string
  default = "vm-worker"
}

variable "ci_vm_ip" {
  description = "IP address of node"
  type = string
}




