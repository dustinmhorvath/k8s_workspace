virtual_environment_username = "root@pve"
virtual_environment_password = ""
virtual_environment_endpoint = "https://192.168.1.201:8006"

worker_count = 3
worker_disk = 60
worker_cores = 4
worker_memory = 8192
worker_name = "rke-node"
worker_description = "k8s worker managed by terraform"

target_node = "pve01"
ip_address_base = "192.168.1"
ip_address_start = 165
gateway = "192.168.1.1"

firewalld_k8s_config = [
    "sudo dnf install firewalld",
    "sudo systemctl enable --now firewalld",
    "sudo firewall-cmd --permanent --add-service=http",
    "sudo firewall-cmd --permanent --add-service=https",
    "sudo firewall-cmd --permanent --add-port=4001/tcp",
    "sudo firewall-cmd --permanent --add-port=6443/tcp",
    "sudo firewall-cmd --permanent --add-port=6443/udp",
    "sudo firewall-cmd --permanent --add-port=8080/tcp",
    "sudo firewall-cmd --permanent --add-port=8080/udp",
    "sudo firewall-cmd --permanent --add-port=9345/tcp",
    "sudo firewall-cmd --permanent --add-port=2379-2380/tcp",
    "sudo firewall-cmd --permanent --add-port=10250/tcp",
    "sudo firewall-cmd --permanent --add-port=10251/tcp",
    "sudo firewall-cmd --permanent --add-port=10252/tcp",
    "sudo firewall-cmd --permanent --add-port=10255/tcp",
    "sudo firewall-cmd --permanent --add-port=16443/tcp",
    "sudo firewall-cmd --permanent --add-port=8472/udp",
    "sudo firewall-cmd --permanent --add-port=30000-32767/tcp",
    "sudo firewall-cmd --add-masquerade --permanent",
    "sudo firewall-cmd --zone=public  --add-masquerade --permanent",
    "sudo firewall-cmd --reload",
    "sudo systemctl restart firewalld"
]
    #"sudo firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -i docker0 -j ACCEPT -m comment --comment \"kube-proxy redirects\" ",
    #"sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 1 -o docker0 -j ACCEPT -m comment --comment \"docker subnet\" ",

extend_root_disk_script = [
    "sudo bash /etc/auto_resize_vda.sh"
    ]

docker_ce = [
    "dnf remove -y docker",

    "dnf install -y dnf-plugins-core",
    "dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
    
    "dnf install -y docker-ce",
    "systemctl enable --now docker",
		"modprobe br_netfilter",
    #"echo 'br_netfilter' >> /etc/modules-load.d/kubespray",
    "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf",
    "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf",

    "echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config",
		"systemctl restart sshd"
]

k8s_source_template = "rocky-8-template"

