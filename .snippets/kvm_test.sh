#!/bin/bash

# Function to print messages with timestamp and color
log() {
    local color=$1
    local message=$2
    echo -e "\e[${color}m$(date '+[%Y-%m-%d %H:%M:%S]') - ${message}\e[0m"
}

# Function to remove subfolders starting with packer- in the parent directory
remove_packer_folders() {
    local parent_dir=$1
    for folder in "$parent_dir"/packer-*; do
        if [[ -d "$folder" ]]; then
            rm -rf "$folder"
            log 32 "Removed folder: $folder" # Green color for success messages
        fi
    done
}

# Define the array of parameters
params=("generic" "oci" "alicloud")

# Navigate to the parent directory
cd ..

log 34 "Navigated to parent directory: $(pwd)" # Blue color for informational messages

# Remove subfolders starting with packer-
remove_packer_folders "$(pwd)"

# Find all .sh files starting with kvm_ and run them with each parameter from the array
for file in kvm_*.sh; do
    if [[ -f "$file" ]]; then
        log 32 "Processing file: $file" # Green color for success messages

        for param in "${params[@]}"; do
            log 34 "Running $file with parameter: $param"

            # Capture the start time
            start_time=$(date +%s)

            # Execute the script and redirect output if needed
            if [[ -n "$1" ]]; then
                bash "$file" "$param" >> "$1" 2>&1
            else
                bash "$file" "$param"
            fi

            # Calculate the time taken for the operation
            end_time=$(date +%s)
            duration=$((end_time - start_time))

            log 34 "$file executed with $param in ${duration} seconds"
        done
    else
        log 31 "No .sh files starting with kvm_ found!" # Red color for error messages
    fi
done

# Note: To redirect output to a log file, run the script as: ./script_name.sh output.log
