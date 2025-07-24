#!/usr/bin/env bash
set -e  # Exit on error

# --- Check for root ---
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root."
    exit 1
fi

# --- Check for NixOS ---
if ! grep -qi 'nixos' /etc/os-release 2>/dev/null; then
    echo "❌ This script must be run on NixOS."
    exit 1
fi

# --- Check if nix command exists ---
if ! command -v nix >/dev/null 2>&1; then
    echo "❌ The 'nix' package manager is not installed or not in PATH."
    exit 1
fi

# --- Check if /etc/nixos/configuration.nix exists ---
if [ ! -f /etc/nixos/configuration.nix ]; then
    read -rp "⚠️ /etc/nixos/configuration.nix is missing. Continue anyway? (y/n): " answer
    case "$answer" in
        y|Y|yes|YES) echo "Continuing despite missing configuration.nix..." ;;
        *) echo "Aborting." ; exit 1 ;;
    esac
fi

# --- Check hostname against supported list ---
HOSTNAME=$(hostname)
VALID_HOSTNAMES=("Omar-PC" "Omar-GamingLaptop" "Omar-Laptop" "Omar-PC-Server" "Hany-Laptop")

if [[ ! " ${VALID_HOSTNAMES[*]} " =~ " $HOSTNAME " ]]; then
    echo "❌ Invalid hostname: $HOSTNAME"
    echo "Supported hostnames: ${VALID_HOSTNAMES[*]}"
    exit 1
fi

echo "✅ Detected hostname: $HOSTNAME"

# --- Copy files ---
echo "📁 Copying configuration files..."
cp -rv "$HOSTNAME"/* /etc/nixos/

# --- Rebuild configuration ---
echo "🔄 Running nixos-rebuild switch..."
nixos-rebuild switch
