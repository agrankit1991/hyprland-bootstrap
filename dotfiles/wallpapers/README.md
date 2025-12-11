# Wallpapers Directory

This directory contains default wallpapers for the Hyprland desktop environment.

## Usage

The wallpaper is set in the `variables.conf` file:
```bash
$wallpaper = ~/.config/hypr/wallpapers/default.jpg
```

## Adding Wallpapers

1. Add your wallpaper files to this directory
2. Update the `$wallpaper` variable in `~/.config/hypr/configs/variables.conf`
3. Reload Hyprland or set the wallpaper manually:
   ```bash
   swww img ~/.config/hypr/wallpapers/your-wallpaper.jpg
   ```

## Supported Formats

- JPG/JPEG
- PNG
- WEBP
- GIF (animated)

## Recommended Resolution

- For best performance, use wallpapers that match your monitor's resolution
- 4K wallpapers work well but may use more memory
- Animated wallpapers (GIF) may impact performance on lower-end systems

## Default Wallpaper

Place your default wallpaper here and name it according to the `DEFAULT_WALLPAPER` setting in `config.sh` (default: `default.jpg`).