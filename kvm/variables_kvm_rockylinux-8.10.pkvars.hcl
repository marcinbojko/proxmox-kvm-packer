boot_command          = "<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux/8/kvm/ks.cfg<enter><wait10><wait10><esc>"
cpus                  = "4"
cloud_init_path       = "extra/files/cloud-init/rhel/generic/cloud.cfg"
disk_interface        = "virtio"
disk_size             = "60G"
format                = "qcow2"
headless              = false
iso_checksum          = "sha256:642ada8a49dbeca8cca6543b31196019ee3d649a0163b5db0e646c7409364eeb"
iso_url               = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.10-x86_64-dvd1.iso"
memory                = "4096"
net_device            = "virtio-net"
shutdown_command      = "sudo -S /sbin/halt -h -p"
ssh_password          = "password"
ssh_username          = "root"
template              = "rockylinux-8.10-x86_64"