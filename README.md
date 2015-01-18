# Arch Linux - Base

> A minimal Arch Linux box for you to build upon

## Build recipe

The images have been built using [Packer](https://www.packer.io). The build recipe can be found on [Github](https://github.com/Dreamscapes/atlas-archlinux).

## Configuration

Only the absolutely necessary configuration has been done in order for the machine to work in a Vagrant environment:

- All drives are formatted as `ext4` on a MBR partition table
- Locale is set to `en_GB.UTF-8` (override with `localectl set-locale ???`)
- Keyboard is set to `us` (override with `localectl set-keymap ???`)
- Timezone is set to UTC
- root password is empty (**set one after installation to secure your box**)
- user & group `vagrant` has been added, with default password being *vagrant*
- user `vagrant` has passwordless `sudo` enabled
- ssh is enabled in order for Vagrant to be able to manage the VM

### Installed packages

Only the minimum required to get you going has been installed. The following packages / package groups have been installed:

- base
- base-devel
- openssh

#### VirtualBox

The following extra packages are installed to VirtualBox image:

- [virtualbox-guest-utils-nox](https://www.archlinux.org/packages/community/x86_64/virtualbox-guest-utils-nox)

The kernel module `i2c_piix4` has been disabled via */etc/modprobe.d/blacklist.conf*.

The following modules provided by the guest utilities are automatically loaded via */etc/modules-load.d/virtualbox.conf*:

- `vboxguest`
- `vboxsf`
- `vboxvideo`

#### Parallels

The following extra packages are installed to Parallels image:

- Parallels Guest Utilities

Note that with the latest kernel, 3.18, a patch was required in order for the guest utilities to install correctly due to a signature change in one of functions provided by the kernel. This means that you might not be able to easily update the guest utilities yourself.

#### VMWare

The guest utilities for VMWare are currently not installed, but you are free to install them yourself. Hopefully they will be added in a later release.

The following kernel modules have been disabled via */etc/modprobe.d/blacklist.conf*:

- `i2c_piix4`
- `intel_rapl`
