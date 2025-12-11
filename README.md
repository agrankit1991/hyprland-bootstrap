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
- **Hyprpicker** - Color picker utility
- **Hyprpolkitagent** - Polkit authentication agent

### Utilities
- **Rofi** - Application launcher & powermenu ([adi1090x/rofi](https://github.com/adi1090x/rofi) themes)
- **SwayNC** - Notification center
- **Swww** - Wallpaper manager with smooth transitions
- **Cliphist** - Clipboard manager

## Prerequisites

- Arch Linux (or Arch-based distribution)
- Base system installed with internet connection
- Git installed

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/hyprland-bootstrap.git
cd hyprland-bootstrap

# Make the install script executable
chmod +x install.sh

# Run the installation
./install.sh
```

## Project Structure

```
hyprland-bootstrap/
├── install.sh              # Main installation script
├── scripts/                # Helper scripts
│   ├── packages.sh         # Package installation
│   ├── dotfiles.sh         # Dotfile deployment
│   └── post-install.sh     # Post-installation tasks
├── dotfiles/               # Configuration files
│   ├── hypr/               # Hyprland configs (modular)
│   │   ├── hyprland.conf   # Main config (sources other files)
│   │   ├── configs/
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

## Keybindings

| Key Combination | Action |
|-----------------|--------|
| `Super + Return` | Open terminal |
| `Super + Q` | Close window |
| `Super + D` | Open application launcher |
| `Super + E` | Open file manager |
| `Super + V` | Clipboard history |
| `Super + L` | Lock screen |
| `Super + M` | Logout menu |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + Arrow Keys` | Move focus |
| `Super + Shift + Arrow Keys` | Move window |
| `Print` | Screenshot (full screen) |
| `Super + Print` | Screenshot (selection) |
| `Super + Shift + Print` | Screenshot (window) |

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
- hyprshot, hyprpicker, hyprpolkitagent

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
