#!/usr/bin/env bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
default_secrets_file="secrets/proxmox.sh"
default_version="rockylinux810"
default_family="rhel"
default_uefi="false"

# Start time
start_time=$(date +%s%N)

# Verbosity control
verbose=0
PACKER_LOG=0

log() {
	if [ "$verbose" -eq 1 ]; then
		echo -e "${YELLOW}[INFO]${NC} $1"
	fi
}

error() {
	echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
	echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to display usage
usage() {
	echo "Usage: $0 [-v] [-s <secrets_file>] [-V <version>] [-F <family>] [-U <uefi>]"
	echo "  -v                Enable verbose mode"
	echo "  -s <secrets_file> Path to the secrets file (default: secrets/proxmox.sh)"
	echo "  -V <version>      Version string (default: rockylinux810)"
	echo "  -F <family>       Family string (default: rhel)"
	echo "  -U <uefi>         UEFI support (default: false)"
	exit 1
}

# Parse command-line arguments
while getopts ":vs:V:F:U:" opt; do
	case ${opt} in
	v)
		verbose=1
		PACKER_LOG=1
		;;
	s)
		secrets_file=$OPTARG
		;;
	V)
		version=$OPTARG
		;;
	F)
		family=$OPTARG
		;;
	U)
		uefi=$OPTARG
		;;
	\?)
		usage
		;;
	esac
done

# Use defaults if parameters are not provided
secrets_file=${secrets_file:-$default_secrets_file}
version=${version:-$default_version}
family=${family:-$default_family}
uefi=${uefi:-$default_uefi}

# Validate UEFI parameter
if [ "$uefi" != "true" ] && [ "$uefi" != "false" ]; then
	error "Invalid value for UEFI. Use 'true' or 'false'."
	exit 1
fi

# Load secrets file
if [ -e "$secrets_file" ]; then
	# shellcheck source=/dev/null
	source "$secrets_file"
	log "Secrets file '$secrets_file' sourced successfully."
else
	error "Secrets file '$secrets_file' not found."
	exit 1
fi

var_file="proxmox/variables_${version}.pkvars.hcl"
uefi_var_file="proxmox/variables_${version}_uefi.pkvars.hcl"
template="proxmox/proxmox_${family}.pkr.hcl"

# Display variable values
echo -e "${BLUE}--- Variable Values ---${NC}"
echo -e "PACKER_LOG: ${YELLOW}$PACKER_LOG${NC}"
echo -e "Secrets File: ${YELLOW}$secrets_file${NC}"
echo -e "Version: ${YELLOW}$version${NC}"
echo -e "Family: ${YELLOW}$family${NC}"
echo -e "UEFI: ${YELLOW}$uefi${NC}"
echo -e "Var File: ${YELLOW}$var_file${NC}"
echo -e "UEFI Var File: ${YELLOW}$uefi_var_file${NC}"
echo -e "Template: ${YELLOW}$template${NC}"
echo -e "${BLUE}-----------------------${NC}"

# Start message
echo -e "${YELLOW}Starting the Packer script...${NC}"

# Packer init
echo -e "${YELLOW}Initializing Packer...${NC}"
packer init -upgrade .

# Validate with Packer
if [ "$uefi" == "true" ]; then
	if [ -e "$uefi_var_file" ]; then
		echo -e "${YELLOW}UEFI variables file '$uefi_var_file' found. Validating with Packer...${NC}"
		packer validate --var-file="$var_file" --var-file="$uefi_var_file" "$template"
		rc=$?
	else
		echo -e "${RED}UEFI is enabled but the UEFI variables file '$uefi_var_file' not found. Exiting now.${NC}"
		exit 1
	fi
else
	echo -e "${YELLOW}UEFI not enabled. Validating with Packer...${NC}"
	packer validate --var-file="$var_file" "$template"
	rc=$?
fi

if [ $rc -ne 0 ]; then
	echo -e "${RED}Packer validate failed - exiting now.${NC}"
	exit $rc
else
	echo -e "${GREEN}Packer template validation successful!${NC}"
	if [ "$uefi" == "true" ] && [ -e "$uefi_var_file" ]; then
		echo -e "${YELLOW}UEFI variables file found. Building with Packer...${NC}"
		packer build --force --var-file="$var_file" --var-file="$uefi_var_file" "$template"
	else
		echo -e "${YELLOW}No UEFI variables file found or UEFI not enabled. Building with Packer...${NC}"
		packer build --force --var-file="$var_file" "$template"
	fi
	rc=$?
	echo $rc
fi

if [ $rc -ne 0 ]; then
	echo -e "${RED}Packer build failed - exiting now.${NC}"
	exit $rc
else
	echo -e "${GREEN}Packer build completed successfully!${NC}"
fi

# End time
end_time=$(date +%s%N)

# Calculate time difference in seconds
time_diff_seconds=$(((end_time - start_time) / 1000000000))

# Convert time difference to hours, minutes, and seconds
hours=$((time_diff_seconds / 3600))
minutes=$(((time_diff_seconds % 3600) / 60))
seconds=$((time_diff_seconds % 60))

echo -e "${GREEN}Packer build took: $hours hours, $minutes minutes, and $seconds seconds.${NC}"
