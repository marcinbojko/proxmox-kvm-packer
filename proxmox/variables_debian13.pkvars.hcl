ballooning_minimum        = "0"
boot_command              = "<wait5><esc><wait>install auto=true priority=critical url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian/13/proxmox/preseed.cfg<enter>"
boot_wait                 = "15s"
cloud-init_path           = "extra/files/cloud-init/debian/generic/cloud.cfg"
cores                     = "4"
cpu_type                  = "host"
disable_kvm               = false
disks = {
    cache_mode            = "none"
    disk_size             = "50G"
    format                = "raw"
    type                  = "virtio"
    storage_pool          = "zfs"
    io_thread             = true
    discard               = true
}
insecure_skip_tls_verify  = true
iso_file                  = "images:iso/debian-13.4.0-amd64-DVD-1.iso"
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
task_timeout              = "60m"
template                  = "debian13"
unmount_iso               = true
