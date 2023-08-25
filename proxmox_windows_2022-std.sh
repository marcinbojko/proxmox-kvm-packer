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

template1="./proxmox/proxmox_windows.pkr.hcl"
var_file="./proxmox/variables_proxmox_windows2022-std.pkvars.hcl"
packer="packer"


if  [ -z "$1" ] || [ "$1" -eq 1 ]; then
    # 1 pass
    $packer --version
    $packer validate --var-file="$var_file" "$template1"

    rc=$?
    if [ $rc -ne 0 ]; then
           echo "Packer validate failed - exiting now"
           exit $rc
       else
           $packer build --force --var-file="$var_file" "$template1"
           rc=$?
    fi

    if [ $rc -ne 0 ]; then
        echo "Packer build failed - exiting now"
        exit $rc
    else
        echo "Packer build for $template1 success"
    fi
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
