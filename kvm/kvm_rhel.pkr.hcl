variable "boot_command" {
  type = string
  default = ""
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_interface" {
  type = string
  default = "virtio"
}

variable "disk_size" {
  type    = string
  default = "50G"
}

variable "format" {
  type    = string
  default = "qcow2"
}

variable "headless" {
  type    = bool
  default = false
}

variable "iso_checksum" {
  type    = string
  default = ""
}

variable "iso_url" {
  type    = string
  default = ""
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "net_device" {
  type = string
  default = "virtio-net"
}

variable "shutdown_command" {
  type = string
  default = "shutdown -h now"
}

variable "ssh_username" {
  type = string
  default = "root"
}

variable "ssh_password" {
  type = string
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

variable "cloud_init_path" {
  type    = string
  default = ""
}

source "qemu" "rhel" {
  boot_command      = ["${var.boot_command}"]
  boot_wait         = "5s"
  disk_interface    = "${var.disk_interface}"
  disk_size         = "${var.disk_size}"
  format            = "${var.format}"
  headless          = "${var.headless}"
  http_directory    = "${path.cwd}/extra/files"
  iso_checksum      = "${var.iso_checksum}"
  iso_url           = "${var.iso_url}"
  net_device        = "${var.net_device}"
  output_directory  = "${var.template}"
  shutdown_command  = "${var.shutdown_command}"
  ssh_password      = "${var.ssh_password}"
  ssh_port          = "${var.ssh_port}"
  ssh_timeout       = "10000s"
  ssh_username      = "${var.ssh_username}"
  vm_name           = "${var.template}.${var.format}"
  accelerator       = "kvm"
  qemuargs          = [["-m","${var.memory}M"],["-smp","${var.cpus}"],["-cpu","host"]]
}

build {
   sources = ["source.qemu.rhel"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["dnf install -y cloud-init cloud-utils-growpart", "systemctl enable cloud-init-local.service", "systemctl enable cloud-init.service", "systemctl enable cloud-config.service", "systemctl enable cloud-final.service"]
    inline_shebang  = "/bin/sh -x"
  }

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "${path.cwd}/${var.cloud_init_path}"
  }

}

