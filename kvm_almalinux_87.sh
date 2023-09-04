#!/usr/bin/env bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PACKER_LOG=0
cloud="generic"
cloud_init_path="extra/files/cloud-init/rhel/generic/cloud.cfg"


# Check for script parameters
if [ "$#" -eq 1 ]; then
    if [[ "$1" =~ ^(oci|generic|alicloud)$ ]]; then
        cloud="$1"
    elif [ "$1" -eq 0 ] || [ "$1" -eq 1 ]; then
        PACKER_LOG="$1"
    else
        echo -e "${RED}Invalid parameter. Please provide a valid value for PACKER_LOG (0 or 1) or cloud (oci, generic, alibabacloud).${NC}"
        exit 1
    fi
elif [ "$#" -eq 2 ]; then
    if [ "$1" -eq 0 ] || [ "$1" -eq 1 ]; then
        PACKER_LOG="$1"
    else
        echo -e "${RED}Invalid value for PACKER_LOG. Please provide 0 or 1.${NC}"
        exit 1
    fi

    if [[ "$2" =~ ^(oci|generic|alicloud)$ ]]; then
        cloud="$2"
    else
        echo -e "${RED}Invalid cloud value. Please provide one of: oci, generic, alicloud.${NC}"
        exit 1
    fi
fi

# Set cloud_init_path based on cloud value
case $cloud in
    oci)
        cloud_init_path="extra/files/cloud-init/rhel/oci/cloud.cfg"
        ;;
    generic)
        cloud_init_path="extra/files/cloud-init/rhel/generic/cloud.cfg"
        ;;
    alicloud)
        cloud_init_path="extra/files/cloud-init/rhel/alicloud/cloud.cfg"
        ;;
    *)
        echo -e "${RED}Invalid cloud value.${NC}"
        exit 1
        ;;
esac

# Export PACKER_LOG
export PACKER_LOG

# Define other variables
version="almalinux-8.7"
family="rhel"
output_dir="packer-${version}-${cloud}-x86_64-qemu"
var_file="kvm/variables_kvm_${version}.pkvars.hcl"
template="kvm/kvm_${family}.pkr.hcl"


# Display variable values
echo -e "${BLUE}--- Variable Values ---${NC}"
echo -e "PACKER_LOG: ${YELLOW}$PACKER_LOG${NC}"
echo -e "Cloud: ${YELLOW}$cloud${NC}"
echo -e "Cloud Init Path: ${YELLOW}$cloud_init_path${NC}"
echo -e "Version: ${YELLOW}$version${NC}"
echo -e "Family: ${YELLOW}$family${NC}"
echo -e "Output Directory: ${YELLOW}$output_dir${NC}"
echo -e "Var File: ${YELLOW}$var_file${NC}"
echo -e "Template: ${YELLOW}$template${NC}"
echo -e "${BLUE}-----------------------${NC}"

# Start message
echo -e "${YELLOW}Starting the Packer script...${NC}"

# Check if output directory exists
if [ -d "./$output_dir" ]; then
    echo -e "${RED}$output_dir exists. Removing folder...${NC}"
    rm -rf "./$output_dir/"
else
    echo -e "${GREEN}$output_dir does not exist. Proceeding...${NC}"
fi

# Validate packer template
echo -e "${YELLOW}Validating Packer template...${NC}"
if ! packer validate  --var-file="$var_file" -var "cloud_init_path=$cloud_init_path" -var="template=$output_dir" "$template"; then
    echo -e "${RED}Packer validate failed - exiting now${NC}"
    exit 1
else
    echo -e "${GREEN}Packer template validation successful!${NC}"
fi

# Build packer template
echo -e "${YELLOW}Building Packer template...${NC}"
if ! packer build --force --var-file="$var_file" -var "cloud_init_path=$cloud_init_path" -var="template=$output_dir" "$template"; then
    echo -e "${RED}Packer build failed - exiting now${NC}"
    exit 1
else
    echo -e "${GREEN}Packer build completed successfully!${NC}"
fi
