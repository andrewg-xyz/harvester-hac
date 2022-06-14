terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.4.0"
    }
  }
}

resource "harvester_network" "vlan1" {
  name                 = var.vlan_name
  namespace            = var.vlan_namespace
  vlan_id              = var.vlan_id
  route_dhcp_server_ip = ""
}

resource "harvester_virtualmachine" "dns01" {
  name      = var.dns01_name
  namespace = var.vm_namespace
  cpu       = var.cpu
  memory    = var.memory

  run_strategy = "RerunOnFailure"
  hostname     = var.dns01_name
  machine_type = "q35"

  ssh_keys = [
    data.harvester_ssh_key.sshkey.id
  ]

  network_interface {
    name         = "nic"
    network_name = harvester_network.vlan1.id
  }

  disk {
    name       = "rootdisk-${var.dns01_name}"
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
        - "curl -sSL https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v"
        - "curl -sSLO https://go.dev/dl/go1.17.7.linux-amd64.tar.gz"
        - "sudo tar -C /usr/local -xzf go1.17.7.linux-amd64.tar.gz"
        - "export GOPATH=/home/user/go"
        - "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin"
        - "sudo GOPATH=/home/user/go /usr/local/go/bin/go install github.com/bakito/adguardhome-sync@latest"
        - "cp /tmp/adguardsync.sh /home/user/adguardsync.sh && chmod +x /home/user/adguardsync.sh"
        - "echo 'export GOPATH=/home/user/go' >> /home/user/.bashrc"
        - "echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /home/user/.bashrc"
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
              - ${var.ci_dns01_ip}/24
            gateway4: ${var.network_gw}
            nameservers:
              addresses: [${var.network_nameserver}]
    EOF
  }

  provisioner "file" {
    source = "scripts/adguardsync.sh"
    destination = "/tmp/adguardsync.sh"

    connection {
      type     = "ssh"
      user     = var.ci_user
      private_key = "${file(var.ssh_key)}"
      host = var.ci_dns01_ip
    }
  }
}

resource "harvester_virtualmachine" "dns02" {
  name      = var.dns02_name
  namespace = var.vm_namespace
  cpu       = var.cpu
  memory    = var.memory

  run_strategy = "RerunOnFailure"
  hostname     = var.dns02_name
  machine_type = "q35"

  ssh_keys = [
    data.harvester_ssh_key.sshkey.id
  ]

  network_interface {
    name         = "nic"
    network_name = harvester_network.vlan1.id
  }

  disk {
    name       = "rootdisk-${var.dns02_name}"
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
        - "curl -sSL https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v"
        - "curl -sSLO https://go.dev/dl/go1.17.7.linux-amd64.tar.gz"
        - "sudo tar -C /usr/local -xzf go1.17.7.linux-amd64.tar.gz"
        - "export GOPATH=/home/user/go"
        - "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin"
        - "sudo GOPATH=/home/user/go /usr/local/go/bin/go install github.com/bakito/adguardhome-sync@latest"
        - "cp /tmp/adguardsync.sh /home/user/adguardsync.sh && chmod +x /home/user/adguardsync.sh"
        - "echo 'export GOPATH=/home/user/go' >> /home/user/.bashrc"
        - "echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /home/user/.bashrc"
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
              - ${var.ci_dns02_ip}/24
            gateway4: ${var.network_gw}
            nameservers:
              addresses: [${var.network_nameserver}]
    EOF
  }

  provisioner "file" {
    source = "scripts/adguardsync.sh"
    destination = "/tmp/adguardsync.sh"

    connection {
      type     = "ssh"
      user     = var.ci_user
      private_key = "${file(var.ssh_key)}"
      host = var.ci_dns02_ip
    }
  }
}