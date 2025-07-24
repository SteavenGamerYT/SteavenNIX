#!/usr/bin/env bash

# Exit on error
set -e

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script with sudo or as root"
        exit 1
    fi
}

# Function to check if running on NixOS
check_nixos() {
    if [ ! -f /etc/nixos/configuration.nix ]; then
        echo "This script must be run on a NixOS system."
        exit 1
    fi
}

# Function to validate the hostname
validate_hostname() {
    local valid_hostnames=("Omar-PC" "Omar-GamingLaptop" "Omar-Laptop" "Omar-PC-Server" "Hany-Laptop")
    
    if ! [[ " ${valid_hostnames[*]} " =~ " ${HOSTNAME} " ]]; then
        echo "Invalid hostname: $HOSTNAME"
        echo "This script only supports the following hostnames:"
        printf "%s\n" "${valid_hostnames[@]}"
        exit 1
    fi
}

# Function to update NixOS
update_nixos() {
    cd /etc/nixos || { echo "Failed to change directory to /etc/nixos"; exit 1; }
    nix flake update
    nix-channel --update
    nixos-rebuild switch --upgrade
}

# Main script execution starts here
check_root
check_nixos

HOSTNAME=$(hostname)
validate_hostname "$HOSTNAME"

echo "Detected hostname: $HOSTNAME"
echo "Updating NixOS..."
update_nixos

echo "NixOS update completed."