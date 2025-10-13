# Windows Desktop Proxmox Template Variables
# Supports Windows 10, 11, 12, etc. - Desktop editions
# Customize these values for your environment

# Proxmox Connection

proxmox_node     = "proxmox6"

# Template Configuration
template = "windows-desktop-11-pro"

# ISO Configuration
# Examples:
#   Windows 10: local:iso/Win10_22H2_English_x64.iso
#   Windows 11: local:iso/Win11_24H2_English_x64.iso
#   Windows 12: local:iso/Win12_English_x64.iso
iso_file         = "images:iso/Win11_24H2_EnglishInternational_x64.iso"
iso_storage_pool = "local"
virtio_iso_file  = "local:iso/virtio-win.iso"

# CD Files for Autounattend
cd_files = [
  "./extra/files/windows/11/proxmox/pro/Autounattend.xml",
  "./extra/files/windows/11/proxmox/bootstrap.ps1"
]

# Sysprep Configuration
sysprep_unattended = "./extra/files/windows/11/proxmox/unattend.xml"

# Hardware Configuration
cores  = "4"
sockets = "1"
memory = "8192"
ballooning_minimum = "0"

# Disk Configuration
disks = {
  cache_mode   = "writeback"
  disk_size    = "64G"
  format       = "raw"
  storage_pool = "zfs"
  type         = "virtio"
}

# EFI Configuration (Required for Windows 11)
bios = "ovmf"
efi_config = {
  efi_storage_pool  = "zfs"
  efi_type          = "4m"
  pre_enrolled_keys = true
}

# TPM Configuration (Required for Windows 11)
tpm_config = {
  tpm_storage_pool = "zfs"
  tpm_version      = "v2.0"
}

# Network Configuration
network_adapters = {
  bridge      = "vmbr0"
  model       = "virtio"
  firewall    = false
  mac_address = ""
  vlan_tag    = ""
}

# VGA Configuration
vga = {
  type   = "virtio"
  memory = "32"
}

# System Configuration
os              = "win11"
machine         = "q35"
cpu_type        = "host"
scsi_controller = "virtio-scsi-single"
qemu_agent      = true

# WinRM Configuration
communicator    = "winrm"
winrm_username  = "Administrator"
winrm_password  = "password"
winrm_port      = 5985

# Boot Configuration
# With proper Autounattend.xml, no boot command is needed
boot_wait = "10s"
boot_command = []

# Additional Settings
unmount_iso               = true
insecure_skip_tls_verify  = true
task_timeout              = "30m"
tags                      = "uefi;template;windows-desktop"
