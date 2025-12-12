# Dotfiles Configuration

This directory contains all the configuration files that will be deployed to your system during installation.

## Structure

```
dotfiles/
├── hypr/                   # Hyprland configuration
│   ├── hyprland.conf      # Main config (sources all modules)
│   ├── configs/           # Modular configuration files
│   │   ├── variables.conf     # User variables (auto-generated)
│   │   ├── monitors.conf      # Monitor setup
│   │   ├── keybinds.conf      # Key bindings
│   │   ├── autostart.conf     # Startup applications
│   │   ├── windowrules.conf   # Window rules
│   │   ├── animations.conf    # Animations & layout
│   │   ├── appearance.conf    # Visual styling
│   │   ├── input.conf         # Input device settings
│   │   └── nvidia.conf        # Nvidia-specific settings
│   ├── hyprlock.conf      # Lock screen configuration
│   ├── hypridle.conf      # Idle management
│   └── hyprsunset.conf    # Blue light filter
├── waybar/                # Status bar
│   ├── config.jsonc       # Waybar configuration
│   └── style.css          # Waybar styling
├── kitty/                 # Terminal emulator
│   └── kitty.conf         # Terminal configuration
├── rofi/                  # Application launcher (will be populated by scripts)
├── swaync/                # Notification center (will be populated by scripts)
├── wallpapers/            # Default wallpapers
├── scripts/               # Utility scripts (will be populated by scripts)
└── README.md              # This file
```

## Customization

### User Variables

The most important file for customization is `~/.config/hypr/configs/variables.conf`, which is auto-generated during installation based on your `config.sh` settings. You can edit this file after installation to customize:

- Default applications
- Theme colors
- Appearance settings
- Monitor configuration
- Wallpaper

### Key Bindings

Edit `~/.config/hypr/configs/keybinds.conf` to customize keyboard shortcuts.

### Monitor Setup

Edit `~/.config/hypr/configs/monitors.conf` for multi-monitor configurations.

### Themes

The configuration uses the Catppuccin Mocha color scheme by default. Colors can be customized in the variables.conf file.

## Notes

- Configuration files use variables from `variables.conf` for consistency
- Modular structure makes it easy to customize specific aspects
- All configurations are designed to work together seamlessly
- Backup of existing configurations is created automatically