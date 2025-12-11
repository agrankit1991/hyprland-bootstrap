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
    hyprland                    # Dynamic tiling Wayland compositor
    xdg-desktop-portal-hyprland # Screen sharing & file picker for Hyprland
    xdg-desktop-portal-gtk      # GTK file picker dialogs
    qt5-wayland                 # Qt5 Wayland integration
    qt6-wayland                 # Qt6 Wayland integration
)

# Hypr ecosystem tools
PACKAGES_HYPR_ECOSYSTEM=(
    hyprlock          # GPU-accelerated screen locker
    hypridle          # Idle daemon (auto-lock, screen off, suspend)
    hyprpaper         # Fast wallpaper utility
    hyprshot          # Screenshot tool (region, window, monitor)
    hyprpicker        # Color picker
    hyprsunset        # Blue light filter
    hyprpolkitagent   # Polkit authentication popups
)

# Core utilities
PACKAGES_CORE=(
    waybar            # Highly customizable status bar
    rofi-wayland      # Application launcher & dmenu replacement
    kitty             # GPU-accelerated terminal emulator
    nautilus          # GTK file manager (GNOME Files)
    swaync            # Notification center for Wayland
    swww              # Wallpaper daemon with transitions
    wl-clipboard      # Wayland clipboard utilities (wl-copy, wl-paste)
    cliphist          # Clipboard history manager
    grim              # Screenshot utility for Wayland
    slurp             # Region selector for screenshots
)

# Audio (PipeWire)
PACKAGES_AUDIO=(
    pipewire          # Modern audio/video server (replaces PulseAudio)
    pipewire-alsa     # ALSA compatibility layer
    pipewire-pulse    # PulseAudio compatibility layer
    pipewire-jack     # JACK compatibility for pro audio apps
    wireplumber       # Session manager for PipeWire
    pamixer           # CLI volume control
    playerctl         # CLI media player control (play, pause, next)
)

# System utilities
PACKAGES_SYSTEM=(
    polkit-gnome      # Graphical authentication agent for sudo prompts
    gnome-keyring     # Secure password/secret storage
    network-manager-applet  # System tray network manager
    bluez             # Bluetooth protocol stack
    bluez-utils       # Bluetooth CLI utilities (bluetoothctl)
    blueman           # GTK Bluetooth manager
    brightnessctl     # Screen brightness control
    udiskie           # Auto-mount removable drives
    gvfs              # Virtual filesystem (trash, network mounts)
    gvfs-mtp          # MTP support for Android devices
    tumbler           # Thumbnail generator for file managers
    ffmpegthumbnailer # Video thumbnail generator
)

# Fonts
PACKAGES_FONTS=(
    ttf-jetbrains-mono-nerd  # JetBrains Mono with Nerd Font icons
    ttf-font-awesome         # Icon font used by Waybar
    noto-fonts               # Google Noto fonts (wide language support)
    noto-fonts-emoji         # Emoji font
    noto-fonts-cjk           # Chinese, Japanese, Korean fonts
)

# Theming
PACKAGES_THEMING=(
    papirus-icon-theme  # Modern icon theme
    qt5ct               # Qt5 theme configuration tool
    qt6ct               # Qt6 theme configuration tool
    kvantum             # SVG-based theme engine for Qt
    nwg-look            # GTK theme/icon/cursor configurator
)

# CLI tools
PACKAGES_CLI=(
    neovim      # Modern vim-based text editor
    btop        # Beautiful system monitor
    fastfetch   # Fast system info display
    unzip       # ZIP archive extraction
    p7zip       # 7-Zip archive support
    ripgrep     # Fast grep alternative (rg)
    fd          # Fast find alternative
    fzf         # Fuzzy finder
    jq          # JSON processor
    tree        # Directory tree viewer
    man-db      # Manual pages
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
