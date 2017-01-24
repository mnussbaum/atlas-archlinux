This is a fork of [Dreamscape's Arch Vagrant
box](https://github.com/Dreamscapes/atlas-archlinux), customized for my
particular setup.

It provides a minimal Arch Linux box with a root volume encrypted with LUKS.

Images are built using [Packer](https://www.packer.io).

### Kernel info

When it comes to Linux kernel modules, the kernel itself is a moving target -
even minor releases may introduce API changes that could break kernel modules
used by VM guest utilities. For this reason, the kernel will be upgraded
separately from other packages, after it has been verified that all guest
utilities are fully compatible with the new kernel version.

This is the only way to enjoy Arch Linux in a fully functional VM environment.

- **Kernel version: 4.6.4-1**

### OS info

- x64 architecture
- All drives are formatted as `ext4` on a MBR partition table
- Root partition is encrypted with LUKS.
- Locale is set to `en_GB.UTF-8` (override with `localectl set-locale ???`)
- Keyboard is set to `us` (override with `localectl set-keymap ???`)
- Timezone is set to UTC
- root password is empty (**set one after installation to secure your box**)
- user & group `vagrant` has been added, with default password being *vagrant* (**reset it after installation to secure your box**)
- user `vagrant` has passwordless `sudo` enabled
- ssh is enabled in order for Vagrant to be able to manage the VM

### HW info

- CPUs: 2
- HDD: 64 GB, dynamically allocated, with partitions for `/` and `/boot`
- Execution cap: left default (100%)
- RAM: 1024 MB

> Hardware configuration can easily be tweaked to your liking via Vagrantfile. See [Provider configuration](https://docs.vagrantup.com/v2/providers/configuration.html).

### Installed packages

Only the minimum required to get you going has been installed. The following packages / package groups have been installed:

- base
- base-devel
- openssh

The following packages have been added to pacman upgrade blacklist:

- linux
- linux-headers
- linux-firmware

#### VirtualBox

The following extra packages are installed to VirtualBox image:

- [virtualbox-guest-utils-nox](https://www.archlinux.org/packages/community/x86_64/virtualbox-guest-utils-nox)

The following packages have been added to pacman upgrade blacklist:

- virtualbox-guest-utils-nox
- virtualbox-guest-modules

The following kernel modules have been disabled via */etc/modprobe.d/blacklist.conf*:

- `i2c_piix4`

The following modules provided by the guest utilities are automatically loaded via */etc/modules-load.d/virtualbox.conf*:

- `vboxguest`
- `vboxsf`
- `vboxvideo`

## Building

#### Required configuration

Packer expects to find the following environment variables on your system:

- `PACKER_OUTDIR`: Directory where all the build artifacts will go

#### Building

```bash
packer build -var-file config.json packer.json
```

## License

This Packer template is licensed under the **BSD-3-Clause License**. See the [LICENSE](LICENSE) file for more information.
