#!/bin/bash

### SYSTEM CONFIGURATION ###

# Localisation stuff...
cat <<LIST > /etc/locale.gen
en_GB.UTF-8 UTF-8
en_US.UTF-8 UTF-8
LIST

locale-gen
# Me likes British English
echo LANG=en_GB.UTF-8 > /etc/locale.conf
echo KEYMAP=us > /etc/vconsole.conf

# Configure timezone to UTC - a sane default, I believe...
ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Enable required services
systemctl enable dhcpcd.service
systemctl enable sshd.service

GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:vgcrypt"
cat <<GRUB_DEFAULTS >> /etc/default/grub
GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:vgcrypt"
GRUB_DEFAULTS

# Configure bootloader
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Clean all downloaded packages and caches to save as much space as possible
pacman -S --clean --clean --noconfirm

HOOKS="base udev autodetect modconf block consolefont keymap keyboard encrypt lvm2 filesystems fsck"
cat <<HOOKS >> /etc/mkinitcpio.conf
HOOKS="base udev autodetect modconf block consolefont keymap keyboard encrypt lvm2 filesystems fsck"
HOOKS
mkinitcpio -p linux

# Do not modify ls and prompts for all new users
patch -p 0 -i /root/support/bashrc.diff

# Create initial mandb database (recommended by man-db package)
mandb --quiet
