#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         Base Package Definitions                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# This file contains all package lists for the Hyprland bootstrap installation.
# Package lists are organized by category and can be sourced by installation scripts.
#

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
    reflector         # Arch Linux mirror list updater
    git               # Version control system
    fcitx5            # Input method framework
    fcitx5-gtk        # Fcitx5 GTK module
    fcitx5-qt         # Fcitx5 Qt module
    fcitx5-configtool # Fcitx5 configuration tool
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
    fastfetch   # Fast system info display
    
    # File management & archives
    unzip       # ZIP archive extraction
        
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
