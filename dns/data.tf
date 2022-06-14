data "harvester_ssh_key" "sshkey" {
  name      = "ed25519"
  namespace = "default"
}

data "harvester_image" "ubuntu20" {
  name      = "ubuntu20"
  namespace = "harvester-public"
}