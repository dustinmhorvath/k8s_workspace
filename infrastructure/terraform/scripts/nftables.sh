#!/bin/bash

systemctl disable --now firewalld,

# Ensure nftables is installed
dnf install -y nftables,

# Disable iptables-services if present
systemctl disable --now iptables || true
dnf remove -y iptables-services || true

# Enable nftables
systemctl enable --now nftables
systemctl status nftables
update-alternatives --set iptables /usr/sbin/iptables-nft

cat <<EOF > /etc/nftables.conf
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
