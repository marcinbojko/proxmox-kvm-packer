variable "ballooning_minimum" {
  type    = string
  default = "0"
}

variable "bios" {
  type    = string
  default = "ovmf"
}

variable "boot_command" {
  type = list(string)
  default = [
    "<wait3s><space><wait3s><space><wait3s><space><wait3s><space><wait5s><space><wait5s><space><wait5s><space><wait5s><space><wait5s><space>"
  ]
}

variable "boot_wait" {
  type    = string
  default = "10s"
}

variable "cd_files" {
  type = list(string)
  default = []
}

variable "communicator" {
  type    = string
  default = "winrm"
}

variable "cores" {
  type    = string
  default = "1"
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "disable_kvm" {
  type    = bool
  default = false
}

variable "disks" {
  type = object({
    cache_mode   = string
    disk_size    = string
    format       = string
    storage_pool = string
    type         = string
  })
  default = {
    cache_mode   = "none"
    disk_size    = "50G"
    format       = "raw"
    storage_pool = "local"
    type         = "virtio"
  }
}

variable "efi_config" {
  type = object({
    efi_storage_pool = string
    efi_type         = string
    pre_enrolled_keys = bool
  })
  default = {
    efi_storage_pool = "local"
    efi_type         = "4m"
    pre_enrolled_keys = true
  }
}

variable "insecure_skip_tls_verify" {
  type    = bool
  default = true
}

variable "iso_file" {
  type    = string
  default = ""
}

variable "iso_storage_pool" {
  type    = string
  default = "local"
}

variable "machine" {
  type    = string
  default = "q35"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "network_adapters" {
  type = object({
    bridge      = string
    model       = string
    firewall    = bool
    mac_address = string
    vlan_tag    = string
  })
  default = {
    bridge      = "vmbr0"
    model       = "virtio"
    firewall    = false
    mac_address = ""
    vlan_tag    = ""
  }
}

variable "os" {
  type    = string
  default = "l26"
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "proxmox_token" {
  type    = string
  default = ""
  sensitive = true
}

variable "proxmox_url" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = ""
}

variable "qemu_agent" {
  type    = bool
  default = true
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-single"
}

variable "sockets" {
  type    = string
  default = "1"
}

variable "sysprep_unattended" {
  type    = string
  default = ""
}

variable "task_timeout" {
  type    = string
  default = "15m"
}

variable "template" {
  type    = string
  default = ""
}

variable "unmount_iso" {
  type    = bool
  default = true
}

variable "winrm_username" {
  type = string
  default = "root"
}

variable "winrm_password" {
  type = string
  sensitive = true
  default = "password"
}

variable "winrm_port" {
  type = number
  default = 22
}

variable "vga" {
    type = object({
      type = string
      memory = string
    })
    default = {
      type = "std"
      memory = "256"
    }
  }

variable "virtio_iso_file" {
  type    = string
  default = "virtio-win.iso"
}

variable "use_efi" {
  type    = bool
  default = false
}

variable "tags" {
  type = string
  default = "uefi;template"
}

variable "pre_enrolled_keys" {
  type = bool
  default = false
}

variable "efi_type" {
  type    = string
  default = "4m"
}

variable "efi_storage_pool" {
  type    = string
  default = "local"
}

locals {
  packer_timestamp = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "proxmox-iso" "windows" {

  communicator = "${var.communicator}"
# extra drive for Autounnatended.xml
  additional_iso_files {
    unmount                 = "true"
    device                  = "sata4"
    iso_storage_pool        = "${var.iso_storage_pool}"
    cd_files                = "${var.cd_files}"
  }

  additional_iso_files {
    unmount                 = "true"
    device                  = "sata5"
    iso_file                = "${var.virtio_iso_file}"
  }
# EFI disk for secure boot
  efi_config {
    efi_storage_pool        = "${var.efi_config.efi_storage_pool}"
    efi_type                = "${var.efi_config.efi_type}"
    pre_enrolled_keys       = "${var.efi_config.pre_enrolled_keys}"
  }

  boot_command              = "${var.boot_command}"
  boot_wait                 = "${var.boot_wait}"
  bios                      = "${var.bios}"
  disks {
    cache_mode              = "${var.disks.cache_mode}"
    disk_size               = "${var.disks.disk_size}"
    format                  = "${var.disks.format}"
    storage_pool            = "${var.disks.storage_pool}"
    type                    = "${var.disks.type}"
  }
  memory                    = "${var.memory}"
  ballooning_minimum        = "${var.ballooning_minimum}"
  cores                     = "${var.cores}"
  sockets                   = "${var.sockets}"
  os                        = "${var.os}"
  disable_kvm               = "${var.disable_kvm}"
  cpu_type                  = "${var.cpu_type}"
  network_adapters {
    bridge                  = "${var.network_adapters.bridge}"
    model                   = "${var.network_adapters.model}"
    firewall                = "${var.network_adapters.firewall}"
    mac_address             = "${var.network_adapters.mac_address}"
    vlan_tag                = "${var.network_adapters.vlan_tag}"
  }

  machine                   = "${var.machine}"
  iso_file                  = "${var.iso_file}"
  node                      = "${var.proxmox_node}"
  proxmox_url               = "${var.proxmox_url}"
  token                     = "${var.proxmox_token}"
  username                  = "${var.proxmox_username}"
  template_name             = "${var.template}.${local.packer_timestamp}"
  unmount_iso               = "${var.unmount_iso}"
  insecure_skip_tls_verify  = "${var.insecure_skip_tls_verify}"
  scsi_controller           = "${var.scsi_controller}"
  winrm_password            = "${var.winrm_password}"
  winrm_timeout             = "8h"
  winrm_username            = "${var.winrm_username}"
  tags                      = "${var.tags}"
  task_timeout              = "${var.task_timeout}"
  qemu_agent                = "${var.qemu_agent}"
  vga {
    type                    = "${var.vga.type}"
    memory                  = "${var.vga.memory}"
  }
}

build {
  sources = ["source.proxmox-iso.windows"]
  provisioner "powershell" {
    elevated_password = "${var.winrm_password}"
    elevated_user     = "${var.winrm_username}"
    script            = "./extra/scripts/windows/shared/phase-1.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "1h"
  }

  provisioner "powershell" {
    elevated_password = "${var.winrm_password}"
    elevated_user     = "${var.winrm_username}"
    script            = "./extra/scripts/windows/shared/phase-2.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "1h"
  }

  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    update_limit = 10
  }

  provisioner "windows-restart" {
    restart_timeout = "1h"
  }

  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    update_limit = 10
  }

  provisioner "windows-restart" {
    restart_timeout = "1h"
  }

  provisioner "file" {
    destination = "C:\\Users\\Administrator\\Desktop\\extend-trial.cmd"
    source      = "./extra/scripts/windows/shared/extend-trial.cmd"
  }

  provisioner "powershell" {
    elevated_password = "${var.winrm_password}"
    elevated_user     = "${var.winrm_username}"
    script            = "./extra/scripts/windows/shared/phase-5a.software.ps1"
  }

  provisioner "powershell" {
    elevated_password = "${var.winrm_password}"
    elevated_user     = "${var.winrm_username}"
    script            = "./extra/scripts/windows/shared/phase-5d.windows-compress.ps1"
  }
  provisioner "windows-restart" {
    restart_timeout = "1h"
  }

  provisioner "file" {
    destination = "C:\\Windows\\System32\\Sysprep\\unattend.xml"
    source      = "${var.sysprep_unattended}"
  }

  provisioner "powershell" {
    inline = ["Write-Output Phase-5-Deprovisioning", "if (!(Test-Path -Path $Env:SystemRoot\\system32\\Sysprep\\unattend.xml)){ Write-Output 'No file';exit (10)}", "& $Env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quit /quiet /unattend:C:\\Windows\\system32\\sysprep\\unattend.xml"]
  }

}
