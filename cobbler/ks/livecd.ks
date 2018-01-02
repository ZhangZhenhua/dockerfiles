lang en_US.UTF-8
keyboard us
timezone Asia/Shanghai --isUtc

selinux --disabled
firewall --disabled

part / --size 4096 --fstype ext4

services --enabled=NetworkManager,sshd --disabled=network

auth --useshadow --enablemd5
rootpw --plaintext centos

repo --name=base --baseurl=http://mirrors.aliyun.com/centos/7/os/x86_64/
repo --name=updates --baseurl=http://mirrors.aliyun.com/centos/7/updates/x86_64/
repo --name=extras --baseurl=http://mirrors.aliyun.com/centos/7/extras/x86_64/

%packages
@^minimal
@core
#kernel
bash
NetworkManager
e2fsprogs
rootfiles
openssh-server

# For UEFI/Secureboot support  
grub2
grub2-efi
efibootmgr
shim
%end
