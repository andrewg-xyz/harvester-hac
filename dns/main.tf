terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.4.0"
    }
  }
}

resource "harvester_network" "vlan1" {
  name      = "vlan1"
  namespace = "harvester-public"

  vlan_id = 1

  route_dhcp_server_ip = ""
}

resource "harvester_virtualmachine" "ubuntu20-dev" {
  name      = "ubuntu-dev"
  namespace = "default"

  description = "test raw image"
  tags        = {
    ssh-user = "ubuntu"
  }

  cpu    = var.cpu
  memory = var.memory

  run_strategy = "RerunOnFailure"
  hostname     = "ubuntu-dev"
  machine_type = "q35"

  ssh_keys = [
    data.harvester_ssh_key.sshkey.id
  ]

  network_interface {
    name         = "nic-1"
    network_name = harvester_network.vlan1.id
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "10Gi"
    bus        = "virtio"
    boot_order = 1

    image       = data.harvester_image.ubuntu20.id
    auto_delete = true
  }

  #  disk {
  #    name        = "emptydisk"
  #    type        = "disk"
  #    size        = "20Gi"
  #    bus         = "virtio"
  #    auto_delete = true
  #  }

  cloudinit {
    user_data    = <<-EOF
      #cloud-config
      user: ubuntu
      password: root
      chpasswd:
        expire: false
      ssh_pwauth: true
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - - systemctl
          - enable
          - '--now'
          - qemu-guest-agent
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
              - 23.0.0.20/24
            gateway4: 23.0.0.1
            nameservers:
              addresses: [8.8.8.8]
    EOF
  }
}