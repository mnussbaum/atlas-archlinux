#!/bin/bash

### SYSTEM INSTALLATION ###

# Partition disks with the following layout on a DOS partition table:
# Device       Start   Size   Id  Type
# /dev/sda1     2048   200M   83  Linux
# /dev/sda2   411648    ???   83  Linux
echo -e "o\n  n\n p\n \n \n +200M\n  n\n p\n \n \n \n  w" | fdisk /dev/sda

# Format filesystems
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda2

# Mount the newly created filesystems
mkdir -p /mnt
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Override pacman repos (the primary one is too slow for my network :) )
# (we WILL restore the mirrorlist to the original one for the final VM)
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
cat <<'LIST' > /etc/pacman.d/mirrorlist
Server = https://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = https://mirror.grig.io/archlinux/$repo/os/$arch
Server = https://arch.localmsp.org/arch/$repo/os/$arch
LIST

# Install required system packages
pacstrap /mnt base base-devel grub openssh

# Generate fstab
genfstab -U -p /mnt >> /mnt/etc/fstab

# Copy shared resources required for OS installation under chrooted root homefolder
mv /tmp/shared /mnt/root/

# Lock the kernel version...
arch-chroot /mnt /root/shared/kernel-lock.sh
# Configure the system...
arch-chroot /mnt /root/shared/os-config.sh
# Configure vagrant...
arch-chroot /mnt /root/shared/vagrant-config.sh

# Restore the original mirrorlist
mv /etc/pacman.d/mirrorlist.bak /mnt/etc/pacman.d/mirrorlist

# Cleanup all the mess
rm -r /mnt/root/shared
