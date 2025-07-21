#!/usr/bin/env bash

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Check if running NixOS
if [ ! -f /etc/nixos/configuration.nix ]; then
    echo "This script must be run on NixOS"
    exit 1
fi

# Get current hostname
HOSTNAME=$(hostname)

# Check if hostname is valid
if [ "$HOSTNAME" != "Omar-PC" ] && [ "$HOSTNAME" != "Omar-GamingLaptop" ] && [ "$HOSTNAME" != "Omar-Laptop" ] && [ "$HOSTNAME" != "Omar-PC-Server" ] && [ "$HOSTNAME" != "Hany-Laptop" ]; then
    echo "Invalid hostname: $HOSTNAME"
    echo "This script only supports Omar-PC, Omar-GamingLaptop, Omar-Laptop, Omar-PC-Server, and Hany-Laptop"
    exit 1
fi


echo "Detected hostname: $HOSTNAME"

# Repair NixOS
echo "Repairing Nixos..."
cd /etc/nixos
sudo nix-store --verify --check-contents --repair

# Repair User Flatpak
echo "Repairing user Flatpak..."
flatpak --user repair

# Repair Global Flatpak
echo "Repairing Global Flatpak"
sudo flatpak repair
