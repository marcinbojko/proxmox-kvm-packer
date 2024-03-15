variable "boot_command" {
  type = string
  default = ""
}

variable "ansible_verbosity" {
  type    = list(string)
}

variable "ansible_extra_args" {
  type    = list(string)
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "ssh_username" {
  type = string
  default = "root"
}

variable "ssh_password" {
  type = string
  sensitive = true
  default = "password"
}

variable "ssh_port" {
  type = number
  default = 22
}
variable "template" {
  type    = string
  default = ""
}

variable "cloud-init_path" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = ""
}

variable "proxmox_token" {
  type    = string
  default = ""
}

variable "proxmox_url" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
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
    format       = "qcow2"
    storage_pool = "local"
    type         = "virtio"
  }
}

variable "boot_wait" {
  type    = string
  default = "10s"
}

variable "cores" {
  type    = string
  default = "1"
}

variable "sockets" {
  type    = string
  default = "1"
}

variable "os" {
  type    = string
  default = "l26"
}

variable "disable_kvm" {
  type    = bool
  default = false
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "network_adapters" {
  type = object({
    bridge      = string
    model       = string
    firewall    = bool
    mac_address = string
  })
  default = {
    bridge      = "vmbr0"
    model       = "virtio"
    firewall    = false
    mac_address = ""
  }
}

variable "ballooning_minimum" {
  type    = string
  default = "0"
}

variable "iso_file" {
  type    = string
  default = ""
}

variable "unmount_iso" {
  type    = bool
  default = true
}

variable "insecure_skip_tls_verify" {
  type    = bool
  default = true
}

variable "task_timeout" {
  type    = string
  default = "15m"
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-single"
}

variable "qemu_agent" {
  type    = bool
  default = true
}

variable "provision_script_options" {
  type    = string
  default = ""
}


locals {
  packer_timestamp = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "proxmox-iso" "linux" {
  ballooning_minimum        = "${var.ballooning_minimum}"
  boot_command              = ["${var.boot_command}"]
  boot_wait                 = "${var.boot_wait}"
  cores                     = "${var.cores}"
  cpu_type                  = "${var.cpu_type}"
  disable_kvm               = "${var.disable_kvm}"
  disks {
    cache_mode              = "${var.disks.cache_mode}"
    disk_size               = "${var.disks.disk_size}"
    format                  = "${var.disks.format}"
    storage_pool            = "${var.disks.storage_pool}"
    type                    = "${var.disks.type}"
  }
  http_directory            = "${path.cwd}/extra/files"
  insecure_skip_tls_verify  = true
  iso_file                  = "${var.iso_file}"
  memory                    = "${var.memory}"
  network_adapters {
    bridge                  = "${var.network_adapters.bridge}"
    model                   = "${var.network_adapters.model}"
    firewall                = "${var.network_adapters.firewall}"
    mac_address             = "${var.network_adapters.mac_address}"
  }
  node                      = "${var.proxmox_node}"
  os                        = "${var.os}"
  proxmox_url               = "${var.proxmox_url}"
  qemu_agent                = "${var.qemu_agent}"
  scsi_controller           = "${var.scsi_controller}"
  sockets                   = "${var.sockets}"
  ssh_password              = "${var.ssh_password}"
  ssh_port                  = "${var.ssh_port}"
  ssh_timeout               = "10000s"
  ssh_username              = "${var.ssh_username}"
  ssh_pty                   = "true"
  task_timeout              = "${var.task_timeout}"
  template_name             = "${var.template}.${local.packer_timestamp}"
  token                     = "${var.proxmox_token}"
  unmount_iso               = true
  username                  = "${var.proxmox_username}"

}

build {
   sources = ["source.proxmox-iso.linux"]



  provisioner "file" {
    destination = "/tmp/cloud.cfg"
    source      = "${path.cwd}/${var.cloud-init_path}"
  }

  provisioner "file" {
    destination = "/tmp/provision.sh"
    source      = "extra/files/ubuntu/shared/provision.sh"
  }


  provisioner "shell" {
    execute_command   = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    expect_disconnect = true
    inline            = [
      "echo '==> Installing provisioner script'",
      "systemctl enable qemu-guest-agent.service --now",
      "chmod +x /tmp/provision.sh",
      "/tmp/provision.sh ${var.provision_script_options}",
      "mv /tmp/cloud.cfg /etc/cloud/cloud.cfg",
      "sync",
      "sync",
      "reboot"
      ]
    inline_shebang    = "/bin/sh -x"
  }

  provisioner "file" {
    destination = "/tmp/motd.sh"
    source      = "extra/files/ubuntu/shared/motd.sh"
    pause_before = "60s"
  }

  provisioner "file" {
    destination = "/tmp/prepare_neofetch.sh"
    source      = "extra/files/ubuntu/shared/prepare_neofetch.sh"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["echo Last Phase",
    "chmod +x /tmp/prepare_neofetch.sh",
    "chmod +x /tmp/zeroing.sh",
    "/tmp/prepare_neofetch.sh",
    "/tmp/zeroing.sh",
    "/bin/rm -rfv /tmp/*",
    "/bin/rm -f /etc/ssh/*key*",
    "/usr/bin/ssh-keygen -A"
    ]
    inline_shebang  = "/bin/sh -x"
  }

}
