terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.4.0"
    }
  }
}

resource "harvester_virtualmachine" "k3s0" {
  name      = var.k3s0_name
  namespace = var.vm_namespace
  cpu       = var.cpu
  memory    = var.memory

  run_strategy = "RerunOnFailure"
  hostname     = var.k3s0_name
  machine_type = "q35"

  ssh_keys = [
    data.harvester_ssh_key.sshkey.id
  ]

  network_interface {
    name         = "nic"
    network_name = data.harvester_network.vlan.id
  }

  disk {
    name        = "rootdisk-${var.k3s0_name}"
    type        = "disk"
    size        = var.vm_disk_size
    bus         = "virtio"
    boot_order  = 1
    image       = data.harvester_image.ubuntu20.id
    auto_delete = true
  }

  cloudinit {
    user_data    = <<-EOF
      #cloud-config
      user: ${var.ci_user}
      password: ${var.ci_secret}
      chpasswd:
        expire: false
      ssh_pwauth: true
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - "systemctl enable --now qemu-guest-agent"
        - "curl -sfL https://get.k3s.io | K3S_TOKEN=${random_string.random.result} sh -s - server --cluster-init --disable traefik"
      ssh_authorized_keys:
        - >-
          ${data.harvester_ssh_key.sshkey.public_key}
      EOF
    network_data = <<-EOF
      network:
        version: 2
        ethernets:
          enp1s0:
            addresses:
              - ${var.ci_k3s0_ip}/24
            gateway4: ${var.network_gw}
            nameservers:
              addresses: [${var.network_nameserver}]
    EOF
  }
}

resource "harvester_virtualmachine" "k3s-agents" {
  count     = 6
  name      = "${var.k3s_name}-${count.index}"
  namespace = var.vm_namespace
  cpu       = var.cpu
  memory    = var.memory

  run_strategy = "RerunOnFailure"
  hostname     = "${var.k3s_name}${count.index}"
  machine_type = "q35"

  ssh_keys = [
    data.harvester_ssh_key.sshkey.id
  ]

  network_interface {
    name         = "nic"
    network_name = data.harvester_network.vlan.id
  }

  disk {
    name        = "rootdisk-${var.k3s_name}${count.index}"
    type        = "disk"
    size        = var.vm_disk_size
    bus         = "virtio"
    boot_order  = 1
    image       = data.harvester_image.ubuntu20.id
    auto_delete = true
  }

  cloudinit {
    user_data    = <<-EOF
      #cloud-config
      user: ${var.ci_user}
      password: ${var.ci_secret}
      chpasswd:
        expire: false
      ssh_pwauth: true
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - "systemctl enable --now qemu-guest-agent"
        - "curl -sfL https://get.k3s.io | K3S_TOKEN=${random_string.random.result} sh -s - server --server https://${var.ci_k3s0_ip}:6443 --disable traefik"
      ssh_authorized_keys:
        - >-
          ${data.harvester_ssh_key.sshkey.public_key}
      EOF
    network_data = <<-EOF
      network:
        version: 2
        ethernets:
          enp1s0:
            addresses:
              - ${var.ci_k3s_agent_ip}${count.index}/24
            gateway4: ${var.network_gw}
            nameservers:
              addresses: [${var.network_nameserver}]
    EOF
  }
}

resource "random_string" "random" {
  length  = 16
  special = false
}