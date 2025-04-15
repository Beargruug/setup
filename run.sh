#!/usr/bin/env zsh

# Clear the screen
clear

# Exit on any error
set -e

# Ensure the script is running in the correct directory
cd "$(dirname "$0")"

# Source utility functions
if [ ! -f "utils.sh" ]; then
    echo "Error: utils.sh not found!"
    exit 1
fi
source utils.sh

# Source the package list
if [ ! -f "packages.conf" ]; then
    echo "Error: packages.conf not found!"
    exit 1
fi

source packages.conf

echo "Starting system setup..."

# Update the system first
echo "Updating brew system..."
if ! brew update; then
    echo "Warning: Brew update failed at some points. Continuing with the setup..."
fi

echo "Upgrading brew system..."
if ! brew upgrade; then
    echo "Warning: Brew upgrade failed at some points. Continuing with the setup..."
fi

# Install packages
echo "Installing the setup..."
install_packages "${SYSTEM_UTILS[@]}"

# Run additional setup scripts
if [ -f "ssh.sh" ]; then
    echo "Installing SSH..."
    source ssh.sh
else
    echo "Warning: ssh.sh not found. Skipping SSH setup."
fi

if [ -f "dotfile.sh" ]; then
    echo "Installing Dotfiles..."
    source dotfile.sh
else
    echo "Warning: dotfile.sh not found. Skipping Dotfiles setup."
fi

if [ -f "skipper.sh" ]; then
    echo "Installing Skipper..."
    source skipper.sh
else
    echo "Warning: skipper.sh not found. Skipping Skipper setup."
fi

if [ -f "zsh.sh" ]; then
    echo "Checking Zsh..."
    source zsh.sh
else
    echo "Warning: zsh.sh not found. Skipping Zsh setup."
fi

echo "Setup complete!"
