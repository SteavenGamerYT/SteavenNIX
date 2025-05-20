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
if [ "$HOSTNAME" != "Omar-PC" ] && [ "$HOSTNAME" != "Omar-GamingLaptop" ] && [ "$HOSTNAME" != "Omar-Laptop" ] && [ "$HOSTNAME" != "Omar-PC-Server" ]; then
    echo "Invalid hostname: $HOSTNAME"
    echo "This script only supports Omar-PC, Omar-GamingLaptop, Omar-Laptop, and Omar-PC-Server"
    exit 1
fi


echo "Detected hostname: $HOSTNAME"

# Clean NixOS
echo "Removing Nixos garbage..."
cd /etc/nixos
nix-collect-garbage -d
/run/current-system/bin/switch-to-configuration boot
