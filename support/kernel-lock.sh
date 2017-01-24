#!/bin/bash

### KERNEL VERSION LOCK ###

# Linux kernel seems to be a moving target when it comes to kernel modules - method signatures and
# data structures change with almost every minor release, making it difficult for virtualisation
# software tools to maintain compatibility with newest versions. To make this a bit more stable,
# I will be locking kernel versions into last known stable releases that are compatible with all
# virtualisation tools (VirtualBox, Parallels, VMWare).

# Docs: Arch Rollback Machine (https://wiki.archlinux.org/index.php/Arch_Rollback_Machine)

# Set pacman repository to point to the ARM
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
mv /root/support/arm-mirrorlist /etc/pacman.d/mirrorlist

# Install kernel and API headers
pacman -Syy --noconfirm linux linux-firmware linux-headers
# Blacklist kernel and headers from upgrades
patch -p 0 -i /root/support/pacman.conf.diff

# Restore pacman mirrorlist and refresh databases
rm /etc/pacman.d/mirrorlist
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist
pacman -Syy
