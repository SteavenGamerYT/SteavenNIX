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
if [ "$HOSTNAME" != "Omar-PC" ] && [ "$HOSTNAME" != "Omar-GamingLaptop" ]; then
    echo "Invalid hostname: $HOSTNAME"
    echo "This script only supports Omar-PC and Omar-GamingLaptop"
    exit 1
fi

echo "Detected hostname: $HOSTNAME"

# Copy configuration files
echo "Copying configuration files..."
cp -v "$HOSTNAME/configuration.nix" /etc/nixos/
cp -v "$HOSTNAME/hardware-configuration.nix" /etc/nixos/
cp -v "$HOSTNAME/i3.nix" /etc/nixos/
cp -v "$HOSTNAME/kvm.nix" /etc/nixos/

# Copy package definitions
echo "Setting up package definitions..."
mkdir -pv /etc/nixos/packages
cp -rv "$HOSTNAME/packages"/* /etc/nixos/packages/

# Build and switch to new configuration
echo "Building and switching to new configuration..."
nixos-rebuild switch