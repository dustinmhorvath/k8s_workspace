# build VM templates in proxmox with packer

Note that we need a server and not live_server (this is the default one you get from the downloads page) Ubuntu ISO.

Link: <https://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.5-server-amd64.iso>

## Running the builds

Run these wrapper scripts to make sure pre-existing VMs get cleaned up before new templates are created.

### Ubuntu 18.04

    bash ./scripts/ubuntu1804_proxmox.sh

### Rocky Linux 8

    bash ./scripts/rocky84_proxmox_mirrors.sh
