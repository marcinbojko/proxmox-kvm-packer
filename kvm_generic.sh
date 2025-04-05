#!/usr/bin/env bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Start time
start_time=$(date +%s%N)

# Default values
PACKER_LOG=0
cloud="generic"
cloud_init_path="extra/files/cloud-init/rhel/generic/cloud.cfg"
default_version="almalinux-8.7"
default_family="rhel"
default_uefi="false"

# Function to display usage
usage() {
	echo "Usage: $0 [-P <packer_log>] [-C <cloud>] [-F <family>] [-V <version>] [-U <uefi>]"
	echo "  -P <packer_log>   Set PACKER_LOG (0 or 1, default: 0)"
	echo "  -C <cloud>        Set cloud value (oci, generic, alicloud, default: generic)"
	echo "  -F <family>       Set family (default: rhel)"
	echo "  -V <version>      Set version (default: almalinux-8.7)"
	echo "  -U <uefi>         UEFI support (true or false, default: false)"
	exit 1
}

# Parse command-line arguments
while getopts ":P:C:F:V:U:" opt; do
	case ${opt} in
	P)
		PACKER_LOG=$OPTARG
		if [ "$PACKER_LOG" -ne 0 ] && [ "$PACKER_LOG" -ne 1 ]; then
			echo -e "${RED}Invalid value for PACKER_LOG. Please provide 0 or 1.${NC}"
			usage
		fi
		;;
	C)
		cloud=$OPTARG
		if [[ ! "$cloud" =~ ^(oci|generic|alicloud)$ ]]; then
			echo -e "${RED}Invalid cloud value. Please provide one of: oci, generic, alicloud.${NC}"
			usage
		fi
		;;
	F)
		family=$OPTARG
		;;
	V)
		version=$OPTARG
		;;
	U)
		uefi=$OPTARG
		if [ "$uefi" != "true" ] && [ "$uefi" != "false" ]; then
			echo -e "${RED}Invalid value for UEFI. Use 'true' or 'false'.${NC}"
			usage
		fi
		;;
	\?)
		usage
		;;
	esac
done

# Use defaults if parameters are not provided
family=${family:-$default_family}
version=${version:-$default_version}
uefi=${uefi:-$default_uefi}

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
	usage
	;;
esac

# Export PACKER_LOG
export PACKER_LOG

# Define other variables
output_dir="packer-${version}-${cloud}-x86_64-qemu"
var_file="kvm/variables_kvm_${version}.pkvars.hcl"
uefi_var_file="kvm/variables_kvm_${version}_uefi.pkvars.hcl"
template="kvm/kvm_${family}.pkr.hcl"

# Display variable values
echo -e "${BLUE}--- Variable Values ---${NC}"
echo -e "PACKER_LOG: ${YELLOW}$PACKER_LOG${NC}"
echo -e "Cloud: ${YELLOW}$cloud${NC}"
echo -e "Cloud Init Path: ${YELLOW}$cloud_init_path${NC}"
echo -e "Version: ${YELLOW}$version${NC}"
echo -e "Family: ${YELLOW}$family${NC}"
echo -e "UEFI: ${YELLOW}$uefi${NC}"
echo -e "Output Directory: ${YELLOW}$output_dir${NC}"
echo -e "Var File: ${YELLOW}$var_file${NC}"
echo -e "UEFI Var File: ${YELLOW}$uefi_var_file${NC}"
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
if [ "$uefi" == "true" ]; then
	if [ -e "$uefi_var_file" ]; then
		echo -e "${YELLOW}UEFI variables file '$uefi_var_file' found. Validating with Packer...${NC}"
		packer validate --var-file="$var_file" --var-file="$uefi_var_file" -var "cloud_init_path=$cloud_init_path" -var="template=$output_dir" "$template"
		rc=$?
	else
		echo -e "${RED}UEFI is enabled but the UEFI variables file '$uefi_var_file' not found. Exiting now.${NC}"
		exit 1
	fi
else
	echo -e "${YELLOW}UEFI not enabled. Validating with Packer...${NC}"
	packer validate --var-file="$var_file" -var "cloud_init_path=$cloud_init_path" -var="template=$output_dir" "$template"
	rc=$?
fi

if [ $rc -ne 0 ]; then
	echo -e "${RED}Packer validate failed - exiting now.${NC}"
	exit $rc
else
	echo -e "${GREEN}Packer template validation successful!${NC}"
	if [ "$uefi" == "true" ] && [ -e "$uefi_var_file" ]; then
		echo -e "${YELLOW}UEFI variables file found. Building with Packer...${NC}"
		packer build --force --var-file="$var_file" --var-file="$uefi_var_file" -var "cloud_init_path=$cloud_init_path" -var="template=$output_dir" "$template"
	else
		echo -e "${YELLOW}No UEFI variables file found or UEFI not enabled. Building with Packer...${NC}"
		packer build --force --var-file="$var_file" -var "cloud_init_path=$cloud_init_path" -var="template=$output_dir" "$template"
	fi
	rc=$?
fi

if [ $rc -ne 0 ]; then
	echo -e "${RED}Packer build failed - exiting now.${NC}"
	exit $rc
else
	echo -e "${GREEN}Packer build completed successfully!${NC}"
fi

# End time
end_time=$(date +%s%N)
time_diff_seconds=$(((end_time - start_time) / 1000000000))
hours=$((time_diff_seconds / 3600))
minutes=$(((time_diff_seconds % 3600) / 60))
seconds=$((time_diff_seconds % 60))
echo -e "${GREEN}Packer build took: ${hours} hours, ${minutes} minutes, and ${seconds} seconds.${NC}"
