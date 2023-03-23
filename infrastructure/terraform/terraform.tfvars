k8s_masters = {
  m1 = { target_node = "pve01", vcpu = "4", memory = "12288", disk_size = "50G", name = "k8s-mast-01.perihelion.host", ip = "192.168.1.161", gw = "192.168.1.1" },
}

k8s_workers = {
  w1 = { target_node = "pve01", vcpu = "6", memory = "16384", disk_size = "50G", name = "k8s-wk-01.perihelion.host", ip = "192.168.1.162", gw = "192.168.1.1" },
  w2 = { target_node = "pve01", vcpu = "6", memory = "20480", disk_size = "50G", name = "k8s-wk-02.perihelion.host", ip = "192.168.1.163", gw = "192.168.1.1" },
}

firewalld_k8s_config = [
    "sudo dnf install firewalld",
    "sudo systemctl enable --now firewalld",
    "sudo firewall-cmd --permanent --add-port=4001/tcp",
    "sudo firewall-cmd --permanent --add-port=6443/tcp",
    "sudo firewall-cmd --permanent --add-port=9345/tcp",
    "sudo firewall-cmd --permanent --add-port=2379-2380/tcp",
    "sudo firewall-cmd --permanent --add-port=10250/tcp",
    "sudo firewall-cmd --permanent --add-port=10251/tcp",
    "sudo firewall-cmd --permanent --add-port=10252/tcp",
    "sudo firewall-cmd --permanent --add-port=10255/tcp",
    "sudo firewall-cmd --permanent --add-port=16443/tcp",
    "sudo firewall-cmd --permanent --add-port=8472/udp",
    "sudo firewall-cmd --permanent --add-port=30000-32767/tcp",
    "sudo firewall-cmd --permanent --add-service=http",
    "sudo firewall-cmd --permanent --add-service=https",
    "sudo firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -i docker0 -j ACCEPT -m comment --comment \"kube-proxy redirects\" ",
    "sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 1 -o docker0 -j ACCEPT -m comment --comment \"docker subnet\" ",
    "sudo firewall-cmd --add-masquerade --permanent",
    "sudo systemctl restart firewalld"
]

extend_root_disk_script = [
    "sudo bash /etc/auto_resize_vda.sh"
    ]

k8s_source_template = "rocky-8-template"

ssh_user = "root"
ssh_password = "somepassword"

