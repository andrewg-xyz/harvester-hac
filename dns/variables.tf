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