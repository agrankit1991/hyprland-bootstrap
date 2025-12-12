#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                       Base Package Installation                             ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs all base packages required for a functional Hyprland setup.
# All packages in this script are considered essential.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/install/base-packages.sh"

# ── Installation Functions ───────────────────────────────────────────────────

install_base_packages() {
    print_header "Installing Base Packages"
    
    log_info "Updating package database..."
    sudo pacman -Sy
    
    # Install Hyprland and Wayland
    log_step "Installing Hyprland and Wayland packages..."
    install_pacman "${PACKAGES_HYPRLAND[@]}"
    
    # Install Hypr ecosystem
    log_step "Installing Hypr ecosystem tools..."
    install_pacman "${PACKAGES_HYPR_ECOSYSTEM[@]}"
    
    # Install core utilities
    log_step "Installing core utilities..."
    install_pacman "${PACKAGES_CORE[@]}"
    
    # Install audio stack
    log_step "Installing audio stack (PipeWire)..."
    install_pacman "${PACKAGES_AUDIO[@]}"
    
    # Install system utilities
    log_step "Installing system utilities..."
    install_pacman "${PACKAGES_SYSTEM[@]}"
    
    # Install fonts
    log_step "Installing fonts..."
    install_pacman "${PACKAGES_FONTS[@]}"
    
    # Install theming tools
    log_step "Installing theming tools..."
    install_pacman "${PACKAGES_THEMING[@]}"
    
    # Install CLI tools
    log_step "Installing CLI tools..."
    install_pacman "${PACKAGES_CLI[@]}"
    
    echo ""
    log_success "Base package installation complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_base_packages
fi
