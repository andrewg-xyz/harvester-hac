terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.4.0"
    }
  }
}

resource "harvester_ssh_key" "sshkey" {
  name      = "ed25519"
  namespace = "default"
  public_key = var.public_ssh_key
}

resource "harvester_image" "ubuntu20" {
  name      = "ubuntu20"
  namespace = "harvester-public"

  display_name = "ubuntu20"
  source_type  = "download"
  url          = "http://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
}