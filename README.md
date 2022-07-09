# harvester-hac

Homelab as Code, using [Harvester HCI](https://docs.harvesterhci.io/v1.0/).

9JUL22 - I've paused using Harvester. some issue with libvirt prevented me from running VMs reliably.

## Cluster Creation

Manually installed and configured a three node harvester cluster.

### TLS Certificates

[Harvester Setting](https://docs.harvesterhci.io/v1.0/settings/settings/#ssl-certificates)

#### Generate Certificates
`certbot certonly --manual --preferred-challenges dns --config-dir=./certs/config --work-dir=./certs/work --logs-dir=./certs/logs
`

## Repository Structure

Top level folders equate to an environment or specific function (i.e. dns).
