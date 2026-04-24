boot_command              = "<wait10>c<wait5>linux /install.amd/vmlinuz auto=true priority=critical url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian/13/proxmox-uefi/preseed.cfg<enter>initrd /install.amd/initrd.gz<enter>boot<enter>"
efi_storage_pool          = "zfs"
efi_type                  = "4m"
pre_enrolled_keys         = true
bios                      = "ovmf"
machine                   = "q35"
use_efi                   = true
template                  = "debian13.uefi"
tags                      = "uefi;template"
