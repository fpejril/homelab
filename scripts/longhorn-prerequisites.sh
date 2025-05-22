#!/usr/bin/env bash
# Prepare Kubernetes node on Ubuntu 24.04 for longhorn installation
# Documentation: https://longhorn.io/docs/1.8.1/deploy/install/#installation-requirements

# Install open-iscsi and enable 
sudo apt install -y open-iscsi
sudo systemctl enable iscsid.service
sudo systemctl start iscsid.service

# Check NFSv4.1 & v4.2 support is enabled in kernel
cat /boot/config-`uname -r`| grep CONFIG_NFS_V4_1
cat /boot/config-`uname -r`| grep CONFIG_NFS_V4_2
sudo apt-get install -y nfs-common

for cmd in bash curl findmnt grep awk blkid lsblk; do
    command -v $cmd > /dev/null || sudo apt-get install -y $cmd
done
