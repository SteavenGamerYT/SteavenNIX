#!/usr/bin/env bash

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then

    echo "Please run this script with sudo or as root."
    exit 1
fi


# Verify that the system is running NixOS
if [ ! -f /etc/nixos/configuration.nix ]; then

    echo "This script must be run on a NixOS system."
    exit 1
fi


# Retrieve and validate the current hostname
HOSTNAME=$(hostname)



SUPPORTED_HOSTNAMES=("Omar-PC" "Omar-GamingLaptop" "Omar-Laptop" "Omar-PC-Server" "Hany-Laptop")

if [[ ! " ${SUPPORTED_HOSTNAMES[@]} " =~ " ${HOSTNAME} " ]]; then
    echo "Invalid hostname: $HOSTNAME"

    echo "This script only supports the following hostnames:"
    printf '%s\n' "${SUPPORTED_HOSTNAMES[@]}"
    exit 1
fi

echo "Detected supported hostname: $HOSTNAME"


# Repair NixOS store and system configuration
cd /etc/nixos || { echo "Failed to change directory to /etc/nixos"; exit 1; }
sudo nix-store --verify --check-contents --repair && {
    echo "NixOS repair completed successfully."
} || {
    echo "Failed to repair NixOS store and system configuration."
}







# Repair user Flatpak installation
echo "Repairing user Flatpak..."
flatpak --user repair



# Repair global/system-wide Flatpak installation
sudo flatpak repair
