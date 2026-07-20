#!/usr/bin/env bash

# Check if os-release exists and source it to get system variables
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Error: /etc/os-release not found. Cannot detect the operating system."
    exit 1
fi

# The $ID variable contains the lower-case string identifying the distribution
case "$ID" in
    ubuntu)
        echo "Detected Ubuntu."
        # --- UBUNTU SPECIFIC TASKS ---
        echo "Updating System"
        sudo apt update && sudo apt upgrade -y
        read -n 1 -s -r -p "Press any key to continue..."

        echo "Installing Cockpit"
        sudo apt install cockpit
        read -n 1 -s -r -p "Press any key to continue..."
        echo "Installing Cockpit Addons"
        sudo apt install cockpit-podman cockpit-files
        echo "Applying networking fix for Cockpit"
        sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
        printf "[keyfile]\nunmanaged-devices=none\n" >> /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
        read -n 1 -s -r -p "Press any key to continue..."

        echo "Setting Up Podman"
        sudo apt-get -y install podman podman-compose
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
        
    fedora)
        echo "Detected Fedora."
        # --- FEDORA SPECIFIC TASKS ---
        # e.g., sudo dnf install -y curl
        
        ;;
        
    arch)
        echo "Detected Arch Linux."
        # --- ARCH SPECIFIC TASKS ---
        sudo pacman -Syu

        
        ;;
        
    *)
        # Catch-all for any other distribution
        echo "Unsupported distribution: $ID (Name: $NAME)"
        exit 1
        ;;
esac

sudo chown jelly:jelly ./

echo "System configuration complete! Starting services."

podman compose up -d 

echo "Done! See readme for how to get started"