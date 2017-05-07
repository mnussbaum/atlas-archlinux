#!/bin/bash

cd /

### VirtualBox Guest Utils installation ###

pacman -Syyu --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils

# Enable VirtualBox kernel modules
mkdir -p /etc/modules-load.d
cat <<LIST > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
LIST

### Fixes for known errors ###

# Grub patch to fix boot error: "Fast TSC calibration failed"
patch -p 0 -i /tmp/support/grub.diff
grub-mkconfig -o /boot/grub/grub.cfg

cat <<LIST >> /etc/modprobe.d/blacklist.conf
# Disable i2c_piix4 kernel module to stop complaining about uninitialised SMBus address
blacklist i2c_piix4
LIST


### Finalise... ###

# Regenerate ramdisk
HOOKS="base udev autodetect modconf block consolefont keymap keyboard encrypt lvm2 filesystems fsck"
cat <<HOOKS >> /etc/mkinitcpio.conf
HOOKS="base udev autodetect modconf block consolefont keymap keyboard encrypt lvm2 filesystems fsck"
HOOKS
mkinitcpio -p linux
