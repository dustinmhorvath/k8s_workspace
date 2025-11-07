#version=RHEL8
ignoredisk --only-use=sda
# Partition clearing information
clearpart --none --initlabel
# Use graphical install
# graphical
# Use CDROM installation media
cdrom
text
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --ipv6=auto --activate
network  --hostname=localhost.localdomain
repo --name="AppStream" --baseurl=file:///run/install/repo/AppStream
# Root password
rootpw somepassword
selinux --disabled
firewall --disabled
firstboot --disable
# Do not configure the X Window System
skipx
# System timezone
#timezone America/Toronto --isUtc
# Disk partitioning information
#part / --fstype="xfs" --grow --size=6144
#part swap --fstype="swap" --size=512
autopart --type=lvm --fstype=ext4
reboot


%packages
@^minimal-environment
openssh-server
openssh-clients
sudo
kexec-tools
qemu-guest-agent
cloud-init
curl
# allow for ansible
python3
python3-libselinux

# unnecessary firmware
-aic94xx-firmware
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6050-firmware
-libertas-usb8388-firmware
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware
-ql2400-firmware
-ql2500-firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%pre
update-crypto-policies --set LEGACY
touch /etc/growroot-disabled
%end

%post
# Disable the horrible, awful, unnecessary password requirements. None of your fucking business.
sed -i 's/pam_passwdqc.so.*/pam_unix/' /etc/pam.d/system-auth
sed -i 's/^#\?.*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/\(disable_root: \).*/\10/' /etc/cloud/cloud.cfg
sed -i 's/\(ssd_pwauth: \).*/\11/' /etc/cloud/cloud.cfg
touch /etc/growroot-disabled


# this is installed by default but we don't need it in virt
echo "Removing linux-firmware package."
yum -C -y remove linux-firmware

# set virtual-guest as default profile for tuned
echo "virtual-guest" > /etc/tuned/active_profile

#echo "Zeroing out empty space."
# This forces the filesystem to reclaim space from deleted files
# dd bs=1M if=/dev/zero of=/var/tmp/zeros || :
# rm -f /var/tmp/zeros
# echo "(Don't worry -- that out-of-space error was expected.)"

yum update -y
yum clean all
%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
