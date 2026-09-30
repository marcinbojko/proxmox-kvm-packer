
ansible_extra_args        = ["-e", "@extra/playbooks/provision_rocky9_variables.yml", "-e", "@variables/rockylinux9.yml", "-e", "{\"docker_prepare\": true, \"extra_device\": \"disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1\"}", "--scp-extra-args", "'-O'"]
ansible_verbosity         = ["-v"]
ballooning_minimum        = "0"
boot_command              = "<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux/9/proxmox/ks-docker.cfg<enter><wait10><esc><wait30><esc>"
boot_wait                 = "15s"
cloud-init_path           = "extra/files/cloud-init/rhel/generic/cloud.cfg"
cores                     = "4"
cpu_type                  = "host"
disable_kvm               = false
disks = {
    cache_mode            = "none"
    disk_size             = "80G"
    format                = "raw"
    type                  = "scsi"
    storage_pool          = "zfs"
    io_thread             = true
    discard               = true
}
extra_disks = [
  {
    cache_mode            = "none"
    disk_size             = "140G"
    format                = "raw"
    type                  = "scsi"
    storage_pool          = "zfs"
    io_thread             = true
    discard               = true
  }
]
insecure_skip_tls_verify  = true
iso_file                  = "images:iso/Rocky-9.8-x86_64-dvd.iso"
memory                    = "4096"
network_adapters = {
    bridge                = "vmbr0"
    model                 = "virtio"
    firewall              = false
    mac_address           = ""
    vlan_tag              = ""
}
proxmox_node              = "proxmox6"
qemu_agent                = true
scsi_controller           = "virtio-scsi-single"
sockets                   = "1"
ssh_password              = "password"
ssh_username              = "root"
task_timeout              = "20m"
template                  = "rockylinux9.8.docker"
unmount_iso               = true
tags                      = "bios;template;docker"
