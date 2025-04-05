
ansible_extra_args        = ["-e", "@extra/playbooks/provision_alma9_variables.yml", "-e", "@variables/almalinux9.yml","-e", "{\"install_updates\": false}","--scp-extra-args", "'-O'"]
ansible_verbosity         = ["-v"]
ballooning_minimum        = "0"
boot_command              = "<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux/9/proxmox/ks.cfg<enter><wait10>esc<wait60><esc>"
boot_wait                 = "15s"
cloud-init_path           = "extra/files/cloud-init/rhel/generic/cloud.cfg"
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
iso_file                  = "images:iso/AlmaLinux-9.3-x86_64-dvd.iso"
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
template                  = "almalinux9.3"
unmount_iso               = true
