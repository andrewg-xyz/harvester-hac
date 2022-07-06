terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.4.0"
    }
  }
}

resource "harvester_virtualmachine" "linux-vm" {
  name      = var.vm_name
  namespace = var.vm_namespace
  cpu       = var.cpu
  memory    = var.memory

  run_strategy = "RerunOnFailure"
  hostname     = var.vm_name
  machine_type = "q35"

  ssh_keys = [
    data.harvester_ssh_key.sshkey.id
  ]

  network_interface {
    name         = "nic"
    network_name = data.harvester_network.vlan1.id
  }

  disk {
    name       = "rootdisk-${var.vm_name}"
    type       = "disk"
    size       = var.vm_disk_size
    bus        = "virtio"
    boot_order = 1
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
              - ${var.ci_vm_ip}/24
            gateway4: ${var.network_gw}
            nameservers:
              addresses: [8.8.8.8]
    EOF
  }
}