lang en_US
keyboard us
timezone America/Toronto --isUtc
# Make sure this gets changed somewhere along the line......
rootpw somepassword
#platform x86, AMD64, or Intel EM64T
text

# Install repos
### url --url=https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/
# no need for AppStream as the repo is referenced in .treeinfo at
### https://dl.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/.treeinfo

bootloader --location=mbr --append="rhgb crashkernel=auto"
zerombr

clearpart --all --initlabel
partition /boot --fstype ext3 --size 512 --asprimary --ondisk=vda
partition pv.01 --size=1 --grow --ondisk=vda

volgroup local pv.01

logvol / --fstype="ext4" --vgname=local --size=8192 --name=root
logvol /home --fstype="ext4" --vgname=local --size=2048 --name=home
logvol /opt --fstype="ext4" --vgname=local --size=3072 --name=opt
logvol /tmp --fstype="ext4" --vgname=local --size=2048 --name=tmp
logvol /var --fstype="ext4" --vgname=local --size=8192 --name=var
logvol /var/log --fstype="ext4" --vgname=local --size=2048 --name=var_log
logvol swap --recommended --vgname=local --size=2048 --name=swap --fstype swap

#auth --passalgo=sha512 --useshadow 
selinux --disabled
firewall --disabled
firstboot --disable
skipx

%packages
@^minimal-environment
kexec-tools
qemu-guest-agent
%end

%post
#yum install -y qemu-guest-agent
# Disable the horrible, awful, unnecessary password requirements. None of your fucking business.
sed -i 's/pam_passwdqc.so.*/pam_unix/' /etc/pam.d/system-auth
sed -i 's/^#\?.*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/\(disable_root: \).*/\10/' /etc/cloud/cloud.cfg
sed -i 's/\(ssd_pwauth: \).*/\11/' /etc/cloud/cloud.cfg
%end


reboot
