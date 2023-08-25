
ansible_extra_args        = ["-e", "@extra/playbooks/provision_rocky8_variables.yml", "-e", "@variables/rockylinux8.yml"]
ansible_verbosity         = ["-v"]
ballooning_minimum        = "0"
boot_command              = "<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/gen2-rockylinux8/ks-kvm.cfg<enter><wait10>esc<wait60><esc>"
boot_wait                 = "15s"
cloud-init_path           = "extra/files/cloud-init/rhel/generic/cloud.cfg"
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
iso_file                  = "images:iso/Rocky-8.8-x86_64-dvd1.iso"
memory                    = "4096"
network_adapters = {
    bridge                = "vmbr0"
    model                 = "virtio"
    firewall              = false
    mac_address           = ""
}
proxmox_node              = "proxmox5"
qemu_agent                = true
scsi_controller           = "virtio-scsi-pci"
sockets                   = "1"
ssh_password              = "password"
ssh_username              = "root"
task_timeout              = "20m"
template                  = "rockylinux8.8"
unmount_iso               = true


