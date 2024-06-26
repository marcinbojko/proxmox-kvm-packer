boot_command              = "<wait10> c setparams 'Installation' <enter> linuxefi /boot/x86_64/loader/linux autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/opensuse_leap/15/proxmox/uefi/autoinst.xml<enter> initrd /boot/x86_64/loader/initrd<enter> boot<enter>"
efi_storage_pool          = "zfs"
efi_type                  = "4m"
pre_enrolled_keys         = "true"
bios                      = "ovmf"
machine                   = "q35"
use_efi                   = "true"
template                  = "opensuse-leap-15.6.uefi"
tags                      = "uefi;template"
