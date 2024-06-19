boot_command              = "<wait10> c setparams 'kickstart' <enter> linuxefi /images/pxeboot/vmlinuz inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux/8/proxmox/ks.cfg<enter> initrdefi /images/pxeboot/initrd.img<enter> boot<enter>"
efi_storage_pool          = "zfs"
efi_type                  = "4m"
pre_enrolled_keys         = "true"
bios                      = "ovmf"
machine                   = "q35"
use_efi                   = "true"
template                  = "rockylinux8.9.uefi"
tags                      = "uefi;template"