#!/usr/bin/env bash

# Start time
start_time=$(date +%s%N)

export PACKER_LOG=0

if [ -e secrets/proxmox.sh ]; then
    # shellcheck source=secrets/proxmox.sh
    source secrets/proxmox.sh
else
    echo "secrets/proxmox.sh not found"
fi

version="ubuntu2204"
family="ubuntu"
var_file="proxmox/variables_proxmox_${version}.pkvars.hcl"
template="proxmox/proxmox_${family}.pkr.hcl"

packer validate --var-file="$var_file" -var="boot_command=<wait3>c<wait3>linux /casper/hwe-vmlinuz quiet autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds=\"nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu/22.04/proxmox/\"<enter><wait5>initrd /casper/hwe-initrd<wait5><enter>boot<wait5s><enter>" -var "template=ubuntu22.04.hwe" "$template"
rc=$?
 if [ $rc -ne 0 ]; then
        echo "Packer validate failed - exiting now"
        exit $rc
    else
        packer build --force --var-file="$var_file" -var="boot_command=<wait3>c<wait3>linux /casper/hwe-vmlinuz quiet autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds=\"nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu/22.04/proxmox/\"<enter><wait5>initrd /casper/hwe-initrd<wait5><enter>boot<wait5s><enter>" -var "template=ubuntu22.04.hwe" "$template"
        rc=$?
    fi

if [ $rc -ne 0 ]; then
        echo "Packer build failed - exiting now"
        exit $rc
fi

# End time
end_time=$(date +%s%N)

# Calculate time difference in seconds
time_diff_seconds=$(( (end_time - start_time) / 1000000000 ))


# Convert time difference to hours, minutes, and seconds
hours=$(( time_diff_seconds / 3600 ))
minutes=$(( (time_diff_seconds % 3600) / 60 ))
seconds=$(( time_diff_seconds % 60 ))

echo "Packer build took: $hours hours, $minutes minutes, and $seconds seconds."