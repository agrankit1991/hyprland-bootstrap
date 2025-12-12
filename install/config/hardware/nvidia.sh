#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                  Hyprland NVIDIA Setup Script for Arch Linux               ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# This script automates the installation and configuration of NVIDIA drivers
# for use with Hyprland on Arch Linux, following the official Hyprland wiki.

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

configure_nvidia_hyprland() {
    log_step "Checking for NVIDIA GPU..."
    if [ -n "$(lspci | grep -i 'nvidia')" ]; then
        log_substep "NVIDIA GPU detected. Proceeding with driver setup."

        # --- Driver Selection ---
        # Turing (16xx, 20xx), Ampere (30xx), Ada (40xx), and newer recommend the open-source kernel modules
        if echo "$(lspci | grep -i 'nvidia')" | grep -q -E "RTX [2-9][0-9]|GTX 16"; then
            NVIDIA_DRIVER_PACKAGE="nvidia-open-dkms"
        else
            NVIDIA_DRIVER_PACKAGE="nvidia-dkms"
        fi

        # Check which kernel is installed and set appropriate headers package
        KERNEL_HEADERS="linux-headers"
        if pacman -Q linux-zen &>/dev/null; then
            KERNEL_HEADERS="linux-zen-headers"
        elif pacman -Q linux-lts &>/dev/null; then
            KERNEL_HEADERS="linux-lts-headers"
        elif pacman -Q linux-hardened &>/dev/null; then
            KERNEL_HEADERS="linux-hardened-headers"
        fi

        # force package database refresh
        sudo pacman -Syu --noconfirm

        PACKAGES_TO_INSTALL=(
            "${KERNEL_HEADERS}"
            "${NVIDIA_DRIVER_PACKAGE}"
            "nvidia-utils"
            "lib32-nvidia-utils"
            "egl-wayland"
            "libva-nvidia-driver"
            "qt5-wayland"
            "qt6-wayland"
        )

        sudo pacman -S --needed --noconfirm "${PACKAGES_TO_INSTALL[@]}"

        # Configure modprobe for early KMS
        echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

        # Configure mkinitcpio for early loading
        MKINITCPIO_CONF="/etc/mkinitcpio.conf"

        # Define modules
        NVIDIA_MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

        # Create backup
        sudo cp "$MKINITCPIO_CONF" "${MKINITCPIO_CONF}.backup"

        # Remove any old nvidia modules to prevent duplicates
        sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' "$MKINITCPIO_CONF"
        # Add the new modules at the start of the MODULES array
        sudo sed -i -E "s/^(MODULES=\()/\1${NVIDIA_MODULES} /" "$MKINITCPIO_CONF"
        # Clean up potential double spaces
        sudo sed -i -E 's/  +/ /g' "$MKINITCPIO_CONF"

        sudo mkinitcpio -P

        # Add NVIDIA environment variables to hyprland.conf
        HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
        if [ -f "$HYPRLAND_CONF" ]; then
            cat >>"$HYPRLAND_CONF" <<'EOF'

# NVIDIA environment variables
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
        fi
        log_success "NVIDIA drivers and configuration applied for Hyprland."
    else
        log_info "No NVIDIA GPU detected. Skipping NVIDIA setup."
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_nvidia_hyprland
fi
