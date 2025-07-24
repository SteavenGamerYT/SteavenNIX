#!/usr/bin/env bash

# Exit on error
set -e

usage() {
    echo "Usage: $0"
    echo "This script must be run as root on a NixOS system."
    echo "Supported hostnames are Omar-PC, Omar-GamingLaptop, Omar-Laptop, Omar-PC-Server, and Hany-Laptop."
    exit 1
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    usage
fi

# Function to check for NixOS system
check_nixos() {
if [ ! -f /etc/nixos/configuration.nix ]; then
    echo "This script must be run on a NixOS system."
    exit 1
fi
}

# Validate and set hostname
validate_hostname() {
SUPPORTED_HOSTNAMES=("Omar-PC" "Omar-GamingLaptop" "Omar-Laptop" "Omar-PC-Server" "Hany-Laptop")

    if [[ ! " ${SUPPORTED_HOSTNAMES[*]} " =~ " ${HOSTNAME} " ]]; then
    echo "Invalid hostname: $HOSTNAME"
    echo "This script only supports the following hostnames:"
    printf "%s\n" "${SUPPORTED_HOSTNAMES[@]}"
    exit 1
fi

echo "Detected hostname: $HOSTNAME"
}

# Main logic
check_nixos
HOSTNAME=$(hostname)
validate_hostname
# Clean NixOS garbage
echo "Removing Nixos garbage..."
cd /etc/nixos
nix-collect-garbage -d
/run/current-system/bin/switch-to-configuration boot
