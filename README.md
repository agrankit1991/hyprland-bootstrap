# Hyprland Bootstrap

A comprehensive setup script for configuring Hyprland and essential applications to create a complete, polished desktop environment on Arch Linux.

## Overview

This project provides an automated way to set up a fully functional Hyprland-based desktop environment with carefully curated dotfiles and configurations.

## Features

### Core
- **Hyprland** - A dynamic tiling Wayland compositor
- **Waybar** - Highly customizable status bar
- **SDDM** - Display manager
- **Kitty** - GPU-accelerated terminal emulator
- **Nautilus** - GTK file manager

### Hypr Ecosystem
- **Hyprlock** - GPU-accelerated screen locker
- **Hypridle** - Idle management daemon (screen timeout, auto-lock, suspend)
- **Hyprsunset** - Blue light filter with time-based profiles
- **Hyprshot** - Screenshot utility (window, region, monitor)
- **Hyprpolkitagent** - Polkit authentication agent

### Utilities
- **Rofi** - Application launcher & powermenu ([adi1090x/rofi](https://github.com/adi1090x/rofi) themes)
- **SwayNC** - Notification center
- **Swww** - Wallpaper manager with smooth transitions
- **Cliphist** - Clipboard manager

### Developer Tools (Optional)
- **mise** - Polyglot runtime manager (replaces asdf, nvm, pyenv, etc.)
- **Java** - OpenJDK (LTS versions via mise)
- **Node.js** - JavaScript runtime (via mise)
- **npm/pnpm** - Node package managers
- **Python** - Python runtime (via mise)
- **Go** - Go programming language (via mise)
- **Rust** - Rust toolchain (via rustup)
- **PostgreSQL** - Relational database
- **Redis** - In-memory data store
- **Docker** - Container runtime
- **Gradle** - Build automation tool
- **Maven** - Java build tool

### Security Essentials (Optional)
- **UFW** - Simple firewall with sensible defaults
- **ClamAV** - Open-source antivirus with scheduled scans
- **Timeshift** - System backup & restore snapshots
- **Firejail** - Sandboxing for browsers & untrusted apps

## Prerequisites

- Arch Linux (or Arch-based distribution)
- Base system installed with internet connection
- Git installed

## Installation

### Quick Install (Full)

```bash
# Clone the repository
git clone https://github.com/yourusername/hyprland-bootstrap.git
cd hyprland-bootstrap

# Edit configuration (optional but recommended)
nvim config.sh

# Run the installation
chmod +x install.sh
./install.sh
```

### Selective Install

Run individual modules as needed:

```bash
# Install only specific components
./install.sh --nvidia      # Nvidia drivers only
./install.sh --dotfiles    # Deploy dotfiles only
./install.sh --packages    # Install packages only
./install.sh --skip-nvidia # Full install, skip Nvidia
./install.sh --dev-tools   # Developer tools only
./install.sh --security    # Security hardening only
```

### Security Essentials Install

```bash
# Install security essentials
./install.sh --security

# Or run individual modules
./scripts/security/install-firewall.sh    # UFW with sensible defaults
./scripts/security/install-antivirus.sh   # ClamAV + weekly scans
./scripts/security/install-backup.sh      # Timeshift snapshots
./scripts/security/install-sandbox.sh     # Firejail for browsers
```

### Developer Tools Install

```bash
# Install all developer tools
./install.sh --dev-tools

# Or run individual dev tool modules
./scripts/dev/install-mise.sh           # mise runtime manager
./scripts/dev/install-languages.sh      # Java, Node, Python, Go, Rust
./scripts/dev/install-databases.sh      # PostgreSQL, Redis
./scripts/dev/install-containers.sh     # Docker, docker-compose
./scripts/dev/install-build-tools.sh    # Gradle, Maven
```

### Configuration File (`config.sh`)

Edit before installation to customize:

```bash
# ── Installation Options ──
INSTALL_NVIDIA=true           # Install Nvidia drivers
INSTALL_SDDM_THEME=true       # Install SDDM theme
BACKUP_EXISTING=true          # Backup existing configs

# ── Installation Mode ──
# "all"         - Install everything without prompts
# "interactive" - Ask before installing each component
# "minimal"     - Core Hyprland setup only
INSTALL_MODE="interactive"

# ── AUR Helper ──
AUR_HELPER="yay"              # yay | paru

# ── Default Applications ──
TERMINAL="kitty"
BROWSER="brave"
FILE_MANAGER="nautilus"
EDITOR="code"

# ── Theme ──
GTK_THEME="catppuccin-mocha-blue"
ICON_THEME="Papirus-Dark"
CURSOR_THEME="Bibata-Modern-Ice"
```

## Project Structure

```
hyprland-bootstrap/
├── install.sh              # Main installation script (interactive menu)
├── config.sh               # User configuration (edit before install)
├── scripts/                # Modular installation scripts
│   ├── 00-checks.sh        # Pre-flight checks (arch, internet, user)
│   ├── 01-deps.sh          # Base dependencies & yay AUR helper
│   ├── 02-packages.sh      # Core package installation
│   ├── 03-nvidia.sh        # Nvidia driver setup
│   ├── 04-dotfiles.sh      # Dotfile deployment & backup
│   ├── 05-services.sh      # Enable systemd services
│   ├── 06-sddm.sh          # SDDM theme & configuration
│   ├── 07-rofi.sh          # Rofi theme installation (adi1090x)
│   ├── 08-gtk-qt.sh        # GTK/Qt theming setup
│   ├── 09-post-install.sh  # Final cleanup & instructions
│   ├── dev/                # Developer tools (optional)
│   │   ├── install-mise.sh         # mise runtime manager
│   │   ├── install-languages.sh    # Programming languages
│   │   ├── install-databases.sh    # PostgreSQL, Redis
│   │   ├── install-containers.sh   # Docker setup
│   │   └── install-build-tools.sh  # Gradle, Maven, etc.
│   └── security/           # Security essentials (optional)
│       ├── install-firewall.sh     # UFW with sensible defaults
│       ├── install-antivirus.sh    # ClamAV + scheduled scans
│       ├── install-backup.sh       # Timeshift configuration
│       └── install-sandbox.sh      # Firejail for browsers
├── lib/                    # Shared functions
│   ├── colors.sh           # Terminal colors & formatting
│   ├── utils.sh            # Helper functions (logging, prompts)
│   └── packages.sh         # Package lists & install functions
├── dotfiles/               # Configuration files
│   ├── hypr/               # Hyprland configs (modular)
│   │   ├── hyprland.conf   # Main config (sources other files)
│   │   ├── configs/
│   │   │   ├── variables.conf   # User-configurable defaults
│   │   │   ├── monitors.conf
│   │   │   ├── keybinds.conf
│   │   │   ├── autostart.conf
│   │   │   ├── windowrules.conf
│   │   │   ├── animations.conf
│   │   │   ├── input.conf
│   │   │   ├── appearance.conf
│   │   │   └── nvidia.conf      # Nvidia environment variables
│   │   ├── hyprlock.conf
│   │   ├── hypridle.conf
│   │   └── hyprsunset.conf
│   ├── waybar/             # Waybar config
│   │   ├── config.jsonc
│   │   └── style.css
│   ├── rofi/               # Rofi launcher config
│   ├── swaync/             # Notification center config
│   ├── kitty/              # Terminal config
│   └── ...
├── wallpapers/             # Default wallpapers
├── themes/                 # GTK/Qt themes
└── README.md
```

## Configuration

After installation, configuration files are located at:

### Hyprland (Modular Structure)
```
~/.config/hypr/
├── hyprland.conf           # Main config (sources all modules)
├── configs/
│   ├── variables.conf      # User defaults (apps, theme colors, gaps)
│   ├── monitors.conf       # Monitor setup & workspaces
│   ├── keybinds.conf       # All keybindings
│   ├── autostart.conf      # exec-once commands
│   ├── windowrules.conf    # Window rules & layers
│   ├── animations.conf     # Animations & bezier curves
│   ├── input.conf          # Keyboard, mouse, touchpad
│   ├── appearance.conf     # Gaps, borders, colors
│   └── nvidia.conf         # Nvidia GPU environment variables
├── hyprlock.conf
├── hypridle.conf
└── hyprsunset.conf         # Blue light filter profiles
```

### Other Apps
- Waybar: `~/.config/waybar/`
- Rofi: `~/.config/rofi/`
- Kitty: `~/.config/kitty/`
- SwayNC: `~/.config/swaync/`

### Variables (Easy Configuration)

All user-configurable defaults are in `~/.config/hypr/configs/variables.conf`:

```bash
# ── Default Applications ──
$terminal     = kitty
$browser      = brave
$fileManager  = nautilus
$editor       = code
$launcher     = ~/.config/rofi/launchers/type-1/launcher.sh
$powermenu    = ~/.config/rofi/powermenu/type-1/powermenu.sh

# ── Theme Colors ──
$accent       = rgb(89b4fa)    # Catppuccin Blue
$accentAlpha  = 89b4fa
$background   = rgb(1e1e2e)    # Catppuccin Base
$foreground   = rgb(cdd6f4)    # Catppuccin Text

# ── Appearance ──
$borderSize   = 2
$rounding     = 10
$gapsIn       = 5
$gapsOut      = 10
$opacity      = 0.95

# ── Wallpaper ──
$wallpaper    = ~/.config/hypr/wallpapers/default.jpg
```

Other config files use these variables:
```bash
# In keybinds.conf
bind = $mainMod, Return, exec, $terminal
bind = $mainMod, B, exec, $browser
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, D, exec, $launcher

# In appearance.conf
general {
    border_size = $borderSize
    gaps_in = $gapsIn
    gaps_out = $gapsOut
    col.active_border = $accent
}
```

## Keybindings

| Key Combination | Action | Variable |
|-----------------|--------|----------|
| `Super + Return` | Open terminal | `$terminal` |
| `Super + B` | Open browser | `$browser` |
| `Super + E` | Open file manager | `$fileManager` |
| `Super + C` | Open editor | `$editor` |
| `Super + D` | Open application launcher | `$launcher` |
| `Super + M` | Logout menu | `$powermenu` |
| `Super + Q` | Close window | - |
| `Super + V` | Clipboard history | - |
| `Super + L` | Lock screen | - |
| `Super + 1-9` | Switch workspace | - |
| `Super + Shift + 1-9` | Move window to workspace | - |
| `Super + Arrow Keys` | Move focus | - |
| `Super + Shift + Arrow Keys` | Move window | - |
| `Print` | Screenshot (full screen) | - |
| `Super + Print` | Screenshot (selection) | - |
| `Super + Shift + Print` | Screenshot (window) | - |

## Customization

### Changing Wallpaper

```bash
# Set wallpaper with transition
swww img /path/to/wallpaper.jpg --transition-type grow
```

### Screenshots (Hyprshot)

```bash
hyprshot -m output   # Capture entire monitor
hyprshot -m window   # Capture active window
hyprshot -m region   # Select region to capture
```

### Blue Light Filter (Hyprsunset)

```bash
hyprsunset -t 4500   # Set temperature (lower = warmer)
hyprsunset           # Default 4000K
```

### Changing Theme

GTK themes can be configured using `nwg-look` or by editing `~/.config/gtk-3.0/settings.ini`.

## Included Packages

### Core
- hyprland, xdg-desktop-portal-hyprland
- waybar, rofi, swaync
- kitty, nautilus
- sddm

### Nvidia Drivers
- nvidia-dkms (or nvidia-open-dkms for Turing+)
- nvidia-utils, lib32-nvidia-utils
- egl-wayland
- libva-nvidia-driver (VA-API hardware acceleration)

### Hypr Ecosystem
- hyprlock, hypridle, hyprsunset
- hyprshot, hyprpolkitagent

### Utilities
- swww (wallpaper)
- cliphist, wl-clipboard (clipboard)
- brightnessctl, pamixer, playerctl
- gnome-keyring
- network-manager-applet, blueman

### Fonts & Themes
- ttf-jetbrains-mono-nerd
- papirus-icon-theme
- catppuccin-gtk-theme (AUR)

### Developer Tools (Optional)

#### Runtime Manager
- mise (polyglot runtime manager)

#### Languages (via mise)
- java (OpenJDK 21 LTS)
- node (LTS) + npm/pnpm
- python + pip
- go
- rust (via rustup)

#### Databases
- postgresql, postgresql-libs
- redis

#### Containers
- docker, docker-compose
- docker-buildx

#### Build Tools
- gradle
- maven
- make, cmake

### Security Essentials (Optional)

#### Firewall
- ufw (simple firewall)
- gufw (optional GUI)

#### Antivirus
- clamav, clamtk (GUI)
- freshclam (virus database updates)

#### Backup
- timeshift (system snapshots)

#### Sandboxing
- firejail (isolate browsers & apps)

## Nvidia Setup

The install script automatically configures Nvidia proprietary drivers for Hyprland.

### What Gets Configured

1. **Driver Installation**
   - `nvidia-dkms` (or `nvidia-open-dkms` for Turing/Ampere/Ada+)
   - `nvidia-utils`, `lib32-nvidia-utils`
   - `egl-wayland`, `libva-nvidia-driver`

2. **Kernel Modules** (`/etc/mkinitcpio.conf`)
   ```
   MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
   ```

3. **DRM Modeset** (`/etc/modprobe.d/nvidia.conf`)
   ```
   options nvidia_drm modeset=1
   ```

4. **Environment Variables** (`~/.config/hypr/configs/nvidia.conf`)
   ```bash
   env = LIBVA_DRIVER_NAME,nvidia
   env = __GLX_VENDOR_LIBRARY_NAME,nvidia
   env = NVD_BACKEND,direct
   
   # Electron/Chromium Wayland support
   env = ELECTRON_OZONE_PLATFORM_HINT,auto
   ```

### Verify Installation

```bash
# Check DRM modeset is enabled
cat /sys/module/nvidia_drm/parameters/modeset
# Should return: Y

# Check driver version
nvidia-smi
```

### Nvidia Troubleshooting

| Issue | Solution |
|-------|----------|
| Flickering in Electron apps | Add `--enable-features=WaylandLinuxDrmSyncobj` flag |
| Screen tearing | Ensure `nvidia_drm modeset=1` is set |
| Suspend/resume issues | Enable `nvidia-suspend.service`, `nvidia-hibernate.service`, `nvidia-resume.service` |
| Multi-monitor issues | Try `AQ_DRM_DEVICES` to set primary GPU |

## Troubleshooting

### Screen sharing not working
Ensure `xdg-desktop-portal-hyprland` is installed and running.

### No audio
Check if `pipewire`, `pipewire-pulse`, and `wireplumber` are running.

### Keybindings not working
Verify your hyprland config syntax: `hyprctl reload`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Hypr Ecosystem](https://wiki.hypr.land/Hypr-Ecosystem/)
- [adi1090x/rofi](https://github.com/adi1090x/rofi) for launcher themes
- [r/unixporn](https://reddit.com/r/unixporn) for inspiration
