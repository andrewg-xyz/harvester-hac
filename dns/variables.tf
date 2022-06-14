# --- Common Variables ---
variable "vlan_name" {
  description = "VLAN Name"
  type = string
  default = "dns"
}

variable "vlan_namespace" {
  description = "VLAN Namespace"
  type = string
  default = "harvester-public"
}

variable "vlan_id" {
  description = "VLAN ID"
  type = number
  default = 1
}

variable "cpu" {
  description = "CPU core count"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory for each node"
  type = string
  default = "4Gi"
}

variable "vm_namespace" {
  description = "namespace for VM"
  type = string
  default = "default"
}

variable "vm_disk_size" {
  description = "size of root disk"
  type = string
  default = "10Gi"
}

variable "network_gw" {
  description = "network gateway"
  type = string
  default = "23.0.0.1"
}

variable "network_nameserver" {
  description = "network nameserver"
  type = string
  default = "8.8.8.8"
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

# --- DNS 01 ---
variable "dns01_name" {
  description = "Name of VM"
  type = string
  default = "dns01"
}

variable "ci_dns01_ip" {
  description = "IP address of node"
  type = string
}

# --- DNS 02 ---
variable "dns02_name" {
  description = "Name of VM"
  type = string
  default = "dns02"
}

variable "ci_dns02_ip" {
  description = "IP address of node"
  type = string
}



