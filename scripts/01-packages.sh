#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         Core Package Installation                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs core packages from the official Arch repositories using pacman.
# AUR packages are handled separately in 02-aur.sh
#

set -e

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/utils.sh"

# ── Package Lists ────────────────────────────────────────────────────────────

# Hyprland and core Wayland packages
PACKAGES_HYPRLAND=(
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    qt5-wayland
    qt6-wayland
)

# Hypr ecosystem tools
PACKAGES_HYPR_ECOSYSTEM=(
    hyprlock
    hypridle
    hyprpaper
)

# Core utilities
PACKAGES_CORE=(
    waybar
    rofi-wayland
    kitty
    nautilus
    swaync
    swww
    wl-clipboard
    cliphist
    grim
    slurp
)

# Audio (PipeWire)
PACKAGES_AUDIO=(
    pipewire
    pipewire-alsa
    pipewire-pulse
    pipewire-jack
    wireplumber
    pamixer
    playerctl
)

# System utilities
PACKAGES_SYSTEM=(
    polkit-gnome
    gnome-keyring
    network-manager-applet
    bluez
    bluez-utils
    blueman
    brightnessctl
    udiskie
    gvfs
    gvfs-mtp
    tumbler
    ffmpegthumbnailer
)

# Fonts
PACKAGES_FONTS=(
    ttf-jetbrains-mono-nerd
    ttf-font-awesome
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
)

# Theming
PACKAGES_THEMING=(
    papirus-icon-theme
    qt5ct
    qt6ct
    kvantum
    nwg-look
)

# CLI tools
PACKAGES_CLI=(
    neovim
    btop
    fastfetch
    unzip
    p7zip
    ripgrep
    fd
    fzf
    jq
    tree
    man-db
)

# ── Installation Functions ───────────────────────────────────────────────────

install_hyprland() {
    log_step "Installing Hyprland and Wayland packages..."
    install_pacman "${PACKAGES_HYPRLAND[@]}"
}

install_hypr_ecosystem() {
    log_step "Installing Hypr ecosystem tools..."
    install_pacman "${PACKAGES_HYPR_ECOSYSTEM[@]}"
}

install_core() {
    log_step "Installing core utilities..."
    install_pacman "${PACKAGES_CORE[@]}"
}

install_audio() {
    log_step "Installing audio stack (PipeWire)..."
    install_pacman "${PACKAGES_AUDIO[@]}"
}

install_system() {
    log_step "Installing system utilities..."
    install_pacman "${PACKAGES_SYSTEM[@]}"
}

install_fonts() {
    log_step "Installing fonts..."
    install_pacman "${PACKAGES_FONTS[@]}"
}

install_theming() {
    log_step "Installing theming tools..."
    install_pacman "${PACKAGES_THEMING[@]}"
}

install_cli() {
    log_step "Installing CLI tools..."
    install_pacman "${PACKAGES_CLI[@]}"
}

# ── Main Installation ────────────────────────────────────────────────────────

install_all_packages() {
    print_header "Installing Core Packages"
    
    log_info "Updating package database..."
    sudo pacman -Sy
    
    install_hyprland
    install_hypr_ecosystem
    install_core
    install_audio
    install_system
    install_fonts
    install_theming
    install_cli
    
    echo ""
    log_success "Core package installation complete!"
}

# Interactive mode - ask before each category
install_packages_interactive() {
    print_header "Installing Core Packages"
    
    log_info "Updating package database..."
    sudo pacman -Sy
    
    # Required packages
    install_hyprland
    install_hypr_ecosystem
    install_core
    install_audio
    
    # Optional categories
    if confirm "Install system utilities (polkit, network, bluetooth, etc.)?"; then
        install_system
    fi
    
    if confirm "Install fonts (JetBrains Mono Nerd, Noto, etc.)?"; then
        install_fonts
    fi
    
    if confirm "Install theming tools (qt5ct, kvantum, nwg-look)?"; then
        install_theming
    fi
    
    if confirm "Install CLI tools (neovim, btop, fastfetch, etc.)?"; then
        install_cli
    fi
    
    echo ""
    log_success "Package installation complete!"
}

# ── Entry Point ──────────────────────────────────────────────────────────────

run_package_install() {
    local mode="${INSTALL_MODE:-interactive}"
    
    case "$mode" in
        all)
            install_all_packages
            ;;
        minimal)
            print_header "Installing Core Packages (Minimal)"
            sudo pacman -Sy
            install_hyprland
            install_hypr_ecosystem
            install_core
            install_audio
            log_success "Minimal installation complete!"
            ;;
        interactive|*)
            install_packages_interactive
            ;;
    esac
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_package_install
fi
