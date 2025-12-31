virtual_environment_username = "root@pve"
virtual_environment_password = ""
virtual_environment_endpoint = "https://192.168.1.201:8006"

ssh_user = "root"
ssh_password = "somepassword"

local_kubeconfig  = "./kubeconfig"
remote_kubeconfig = "/root/.kube/config"

worker_count = 3
worker_disk = 60
worker_cores = 6
worker_memory = 8192
worker_name = "rke-node"
worker_disk_location = "local-lvm"
worker_description = "k8s worker managed by terraform"
gameserver_count = 1
gameserver_disk = 60
gameserver_cores = 8
gameserver_memory = 16384
gameserver_name = "kube-gameserver"
gameserver_disk_location = "local-lvm"
gameserver_description = "k8s gameserver managed by terraform"

target_node = "pve01"
ip_address_base = "192.168.1"
ip_address_start = 165
gateway = "192.168.1.1"

iptables_k8s_config = [
    "systemctl disable --now firewalld",
    #"systemctl disable --now nftables",
    "iptables -F",
    "iptables -X",
    "iptables -t nat -F",
    "iptables -t nat -X",
    "iptables -t mangle -F",
    "iptables -t mangle -X",
    "iptables -P INPUT ACCEPT",
    "iptables -P FORWARD ACCEPT",
    "iptables -P OUTPUT ACCEPT",
    "iptables -A INPUT -i lo -j ACCEPT",
    "iptables -A OUTPUT -o lo -j ACCEPT",
    "iptables -A INPUT  -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT",
    "iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT",
    "iptables -A INPUT -p tcp -s 192.168.1.0/24 -m multiport --dports 2379,2380 -j ACCEPT",
    "iptables -A OUTPUT -p tcp -d 192.168.1.0/24 -m multiport --sports 2379,2380 -j ACCEPT",
    "iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 6443 -j ACCEPT",
    "iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 10250 -j ACCEPT",
    "iptables -A INPUT -p tcp -s 127.0.0.1 --dport 10257 -j ACCEPT",
    "iptables -A INPUT -p tcp -s 127.0.0.1 --dport 10259 -j ACCEPT",
    "iptables -A INPUT -p icmp -j ACCEPT",
    "iptables -A INPUT -p udp -s 192.168.1.0/24 -j ACCEPT",
    "dnf install -y iptables-services",
    "iptables-save > /etc/sysconfig/iptables",
    "systemctl enable iptables",
    "systemctl restart iptables",
]

nftables_k8s_config = [
    "systemctl disable --now firewalld",
		# Ensure nftables is installed
dnf install -y nftables

# Disable iptables-services if present
systemctl disable --now iptables || true
dnf remove -y iptables-services || true

# Enable nftables
systemctl enable --now nftables
systemctl status nftables
update-alternatives --set iptables /usr/sbin/iptables-nft
cat this stuff to /etc/nftables.conf:
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0;
        policy drop;

        # Loopback
        iif lo accept

        # Established connections
        ct state established,related accept

        # ICMP (critical for cluster health)
        ip protocol icmp accept
        ip6 nexthdr icmpv6 accept

        # SSH
        tcp dport 22 accept

        # Kubernetes control plane
        tcp dport { 6443, 2379-2380, 10250, 10257, 10259 } accept

        # NodePorts
        tcp dport 30000-32767 accept
        udp dport 30000-32767 accept

        # CNI overlay (adjust if needed)
        udp dport 8472 accept        # VXLAN
        udp dport 4789 accept        # Calico VXLAN

        # MetalLB (ARP + BGP if used)
        udp dport 7946 accept
    }

    chain forward {
        type filter hook forward priority 0;
        policy accept;
    }

    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}
EOF

nft -f /etc/nftables.conf
nft list ruleset
systemctl enable nftables


]

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

