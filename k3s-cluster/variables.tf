# --- Common Variables ---
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

# --- K3s Server ---
variable "k3s0_name" {
  description = "Name of VM"
  type = string
  default = "k3s-server"
}

variable "ci_k3s0_ip" {
  description = "IP address of node"
  type = string
}

# --- K3s Agents ---
variable "k3s_name" {
  description = "agent name"
  type = string
  default="k3s-agent"
}

variable "ci_k3s_agent_ip" {
  description = "Base IP address of node"
  type = string
}