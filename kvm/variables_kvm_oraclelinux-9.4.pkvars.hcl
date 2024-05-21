boot_command          = "<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/oraclelinux/9/kvm/ks-kvm.cfg<enter><wait10><wait10><esc>"
cpus                  = "4"
cloud_init_path       = "extra/files/cloud-init/rhel/generic/cloud.cfg"
disk_interface        = "virtio"
disk_size             = "60G"
format                = "qcow2"
headless              = false
iso_checksum          = "sha256:77034a4945474cb7c77820bd299cac9a557b8a298a5810c31d63ce404ad13c5e"
iso_url               = "https://yum.oracle.com/ISOS/OracleLinux/OL9/u4/x86_64/OracleLinux-R9-U4-x86_64-dvd.iso"
memory                = "4096"
net_device            = "virtio-net"
shutdown_command      = "sudo -S /sbin/halt -h -p"
ssh_password          = "password"
ssh_username          = "root"
template              = "oraclelinux-9.4-x86_64"
