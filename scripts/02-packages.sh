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
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

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
    pipewire-pulse    # PulseAudio compatibility layer
    wireplumber       # Session manager for PipeWire
)

# System utilities
PACKAGES_SYSTEM=(
    sddm              # Simple Desktop Display Manager (login screen)
    gnome-keyring     # Secure password/secret storage
    network-manager-applet  # System tray network manager
    udiskie           # Auto-mount removable drives
    gvfs              # Virtual filesystem (trash, network mounts)
    tumbler           # Thumbnail generator for file managers
    ffmpegthumbnailer # Video thumbnail generator
)

# Fonts
PACKAGES_FONTS=(
    ttf-jetbrains-mono-nerd  # JetBrains Mono with Nerd Font icons (Starship compatible)
    noto-fonts               # Google Noto fonts (wide language support, including basic Devanagari/Hindi)
    noto-fonts-emoji         # Emoji font support
    noto-fonts-extra         # Extended scripts (Tamil, Telugu, Gujarati, etc.)
)

# Theming (Essential tools only - themes installed separately)
PACKAGES_THEMING=(
    qt5ct               # Qt5 theme configuration tool
    qt6ct               # Qt6 theme configuration tool
)

# CLI tools
PACKAGES_CLI=(
    # Text editors
    neovim      # Modern vim-based text editor
    
    # System monitoring
    btop        # Beautiful system monitor (better than htop)
    htop        # Interactive process viewer
    fastfetch   # Fast system info display
    
    # File management & archives
    unzip       # ZIP archive extraction
    p7zip       # 7-Zip archive support
    
    # Better core utilities
    ripgrep     # Fast grep alternative (rg)
    fd          # Fast find alternative
    bat         # Better cat with syntax highlighting
    eza         # Better ls with colors and icons
    zoxide      # Smart cd that learns your habits
    
    # Disk & filesystem
    duf         # Better df for disk usage display
    ncdu        # Interactive disk usage analyzer
    tree        # Directory tree viewer
    
    # Search & navigation
    fzf         # Fuzzy finder
    
    # Documentation & help
    tldr        # Simplified man pages
    man-db      # Manual pages
    
    # Data processing
    jq          # JSON processor
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
