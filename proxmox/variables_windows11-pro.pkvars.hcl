ballooning_minimum          = "0"
bios                        = "ovmf"
boot_command                = []
boot_wait                   = "5s"
cd_files                    = ["./extra/files/windows/11/proxmox/pro/autounattend.xml", "./extra/files/windows/11/proxmox/bootstrap.ps1"]
communicator                = "winrm"
cores                       = "4"
cpu_type                    = "host"
disable_kvm                 = false
disks = {
    cache_mode              = "writeback"
    disk_size               = "64G"
    format                  = "raw"
    type                    = "sata"
    storage_pool            = "zfs"

}
efi_config                  = {
    efi_storage_pool        = "zfs"
    efi_type                = "4m"
    pre_enrolled_keys       = true
}
tpm_config                  = {
    tpm_storage_pool        = "zfs"
    tpm_version             = "v2.0"
}

insecure_skip_tls_verify    = true
iso_file                    = "images:iso/Win11_24H2_EnglishInternational_x64.iso"
iso_storage_pool            = "local"
machine                     = "pc"
memory                      = "8192"
network_adapters = {
    bridge                  = "vmbr0"
    model                   = "virtio"
    firewall                = false
    mac_address             = ""
    vlan_tag                = 0
}
os                          = "win11"
proxmox_node                = "proxmox6"
qemu_agent                  = true
scsi_controller             = "virtio-scsi-single"
sockets                     = "1"
sysprep_unattended          = "./extra/files/windows/11/proxmox/unattend.xml"
task_timeout                = "20m"
template                    = "windows11-pro.microsoft.com"
unmount_iso                 = true
winrm_password              = "password"
winrm_username              = "Administrator"
vga                         = {
    memory                  = "32"
    type                    = "virtio"
}
virtio_iso_file             = "images:iso/virtio-win.iso"
