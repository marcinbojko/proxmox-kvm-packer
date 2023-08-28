ballooning_minimum          = "0"
bios                        = "ovmf"
boot_command                = ["<wait5s><space>"]
boot_wait                   = "5s"
cd_files                    = ["./extra/files/windows/2022/proxmox/dc/Autounattend.xml", "./extra/files/windows/2022/proxmox/bootstrap.ps1"]
communicator                = "winrm"
cores                       = "4"
cpu_type                    = "host"
disable_kvm                 = false
disks = {
    cache_mode              = "writeback"
    disk_size               = "50G"
    format                  = "raw"
    type                    = "sata"
    storage_pool            = "zfs"
}
efi_config                  = {
    efi_storage_pool        = "zfs"
    efi_type                = "4m"
    pre_enrolled_keys       = true
}

insecure_skip_tls_verify    = true
iso_file                    = "images:iso/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
iso_storage_pool            = "local"
machine                     = "pc"
memory                      = "4096"
network_adapters = {
    bridge                  = "vmbr0"
    model                   = "virtio"
    firewall                = false
    mac_address             = ""
}
os                          = "win11"
proxmox_node                = "proxmox-amd9"
qemu_agent                  = true
scsi_controller             = "virtio-scsi-single"
sockets                     = "1"
sysprep_unattended          = "./extra/files/windows/2022/proxmox/unattend.xml"
task_timeout                = "20m"
template                    = "windows2021-dc.microsoft.com"
unmount_iso                 = true
winrm_password              = "password"
winrm_username              = "Administrator"
vga                         = {
    memory                  = "32"
    type                    = "virtio"
}
virtio_iso_file             = "images:iso/virtio-win.iso"
