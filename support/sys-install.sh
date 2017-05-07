#!/bin/bash

### SYSTEM INSTALLATION ###

# Partition disks with the following layout on a DOS partition table:
# Device       Start   Size   Id  Type
# /dev/sda1     2048   200M   83  Linux
# /dev/sda2   411648    ???   83  Linux
echo -e "o\n  n\n p\n \n \n +512M\n  n\n p\n \n \n \n  w" | fdisk /dev/sda

# Key for encrypting root volume
echo -n "vagrant" | cryptsetup -v --cipher aes-xts-plain64 --key-size 256 luksFormat /dev/sda2 -
echo -n "vagrant" | cryptsetup luksOpen /dev/sda2 lvm
pvcreate /dev/mapper/lvm
vgcreate vgcrypt /dev/mapper/lvm
lvcreate --extents +100%FREE -n root vgcrypt

# Format filesystems
mkfs.ext2 /dev/sda1
mkfs.ext4 -O ^has_journal /dev/mapper/vgcrypt-root

# Mount the newly created filesystems
mkdir -p /mnt
mount /dev/mapper/vgcrypt-root /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

cat <<'LIST' > /etc/pacman.d/mirrorlist
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = https://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
Server = https://mirror.grig.io/archlinux/$repo/os/$arch
LIST

# Install required system packages
pacstrap /mnt base base-devel grub openssh

# Generate fstab
genfstab -U -p /mnt >> /mnt/etc/fstab

# Copy resources required for OS installation under chrooted root homefolder
mv /tmp/support /mnt/root/

# Configure the system...
arch-chroot /mnt /root/support/os-config.sh
# Configure vagrant...
arch-chroot /mnt /root/support/vagrant-config.sh
arch-chroot /mnt /root/support/install.sh
