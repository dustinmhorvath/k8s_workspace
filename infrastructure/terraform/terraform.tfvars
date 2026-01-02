virtual_environment_username = "root@pve"
virtual_environment_password = ""
virtual_environment_endpoint = "https://192.168.1.201:8006"

ssh_user = "root"
ssh_password = "somepassword"

local_kubeconfig  = "./kubeconfig"
remote_kubeconfig = "/root/.kube/config"

worker_count = 3
worker_disk = 60
worker_cores = 8
worker_memory = 8192
worker_name = "rke-node"
worker_disk_location = "local-lvm"
worker_description = "k8s worker managed by terraform"
gameserver_count = 1
gameserver_disk = 60
gameserver_cores = 12
gameserver_memory = 20480
gameserver_name = "kube-gameserver"
gameserver_disk_location = "local-lvm"
gameserver_description = "k8s gameserver managed by terraform"

target_node = "pve01"
ip_address_base = "192.168.1"
ip_address_start = 165
gateway = "192.168.1.1"

extend_root_disk_script = [
    "sudo bash /etc/auto_resize_vda.sh"
    ]

k8s_network_tidbits = [
    "systemctl disable --now nftables",
    "systemctl disable --now firewalld",
    #"modprobe br_netfilter",

    "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf",
    "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf",
    "echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf",
    "echo 'net.ipv4.conf.all.rp_filter=0' >> /etc/sysctl.conf",
    "echo 'net.ipv4.conf.eth0.rp_filter=0' >> /etc/sysctl.conf",
    "echo 'net.ipv4.conf.default.rp_filter=0' >> /etc/sysctl.conf",
    "sysctl -p",

    "echo 'virtio_scsi' > /etc/modules-load.d/virtio_scsi.conf",
    "echo 'manage_etc_hosts: false' >> /etc/cloud/cloud.cfg.d/99-99-disable-hosts.cfg",
    "sed -i '/update_etc_hosts/s/^/#/' /etc/cloud/cloud.cfg",
    "sed -i '/::/s/^/#/' /etc/hosts",
    "sed -i '/127.0.0.1 rke-node/s/^/#/' /etc/hosts",

    "echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config",
    "systemctl restart sshd"

]

k8s_source_template = "rocky-8-template"

