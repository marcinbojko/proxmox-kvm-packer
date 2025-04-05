ansible_extra_args        = ["-e", "@extra/playbooks/provision_alma8_variables.yml", "-e", "@variables/almalinux8.yml","--scp-extra-args", "'-O'"]
ansible_verbosity         = ["-v"]
ballooning_minimum        = "0"
boot_command              = "<esc><enter><wait> linux textmode=1 autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/opensuse_leap/15/proxmox/bios/autoinst.xml <wait5><enter>"
boot_wait                 = "15s"
cloud-init_path           = "extra/files/cloud-init/suse/generic/cloud.cfg"
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
iso_file                  = "images:iso/openSUSE-Leap-15.5-DVD-x86_64-Build491.1-Media.iso"
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
template                  = "opensuse-leap-15.5"
unmount_iso               = true
