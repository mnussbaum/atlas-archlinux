#!/bin/bash

cd /

### VirtualBox Guest Utils installation ###

# Set pacman repository to point to the ARM because VirtualBox requires the most recent kernel
# available for Arch Linux
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
mv /tmp/arm-mirrorlist /etc/pacman.d/mirrorlist

# Install VirtualBox Guest Utils without X.Org support
pacman -Syy --noconfirm virtualbox-guest-utils-nox

# Enable VirtualBox kernel modules
mkdir -p /etc/modules-load.d
cat <<LIST > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
LIST

# Prevent guest utilities from being upgraded (they might depend on newer kernel version and cause
# unresolvable conflict)
patch -p 0 -i /tmp/virtualbox/pacman.conf.diff

# Restore pacman mirrorlist and refresh databases
rm /etc/pacman.d/mirrorlist
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist
pacman -Syy


### Fixes for known errors ###

# Grub patch to fix boot error: "Fast TSC calibration failed"
patch -p 0 -i /tmp/virtualbox/grub.diff
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
