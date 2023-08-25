ansible_extra_args        = ["-e", "@extra/playbooks/provision_alma8_variables.yml", "-e", "@variables/almalinux8.yml"]
ansible_verbosity         = ["-v"]
ballooning_minimum        = "0"
boot_command              = "<esc><enter><wait> linux textmode=1 autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/gen2-opensuse_leap_15/autoinst.xml <wait5><enter>"
boot_wait                 = "15s"
cloud-init_path           = "extra/files/cloud-init/suse/generic/cloud.cfg"
cores                     = "4"
cpu_type                  = "host"
disable_kvm               = false
disks = {
    cache_mode            = "writeback"
    disk_size             = "50G"
    format                = "raw"
    type                  = "virtio"
    storage_pool          = "zfs"
}
insecure_skip_tls_verify  = true
iso_file                  = "images:iso/openSUSE-Leap-15.5-DVD-x86_64-Build491.1-Media.iso"
memory                    = "4096"
network_adapters = {
    bridge                = "vmbr0"
    model                 = "virtio"
    firewall              = false
    mac_address           = ""
}
proxmox_node              = "proxmox2"
qemu_agent                = true
scsi_controller           = "virtio-scsi-pci"
sockets                   = "1"
ssh_password              = "password"
ssh_username              = "root"
task_timeout              = "20m"
template                  = "opensuse-leap-15-4.suse.com"
unmount_iso               = true
