#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                     Hyprland Bootstrap Configuration                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Edit this file before running install.sh to customize your installation.
# All settings can be overridden interactively during installation.
#

# ── Installation Options ─────────────────────────────────────────────────────

# Install Nvidia proprietary drivers and configure for Hyprland
INSTALL_NVIDIA=true

# Install and configure SDDM display manager with theme
INSTALL_SDDM_THEME=true

# Backup existing config files before overwriting
BACKUP_EXISTING=true

# ── Installation Mode ────────────────────────────────────────────────────────
# "all"         - Install everything without prompts
# "interactive" - Ask before installing each optional component
# "minimal"     - Core Hyprland setup only (no dev tools, security, etc.)
INSTALL_MODE="interactive"

# ── AUR Helper ───────────────────────────────────────────────────────────────
# Which AUR helper to use (will be installed if not present)
# Options: "yay" | "paru"
AUR_HELPER="yay"

# ── Default Applications ─────────────────────────────────────────────────────
# These will be set in Hyprland config variables

TERMINAL="kitty"
BROWSER="brave"
FILE_MANAGER="nautilus"
EDITOR="code"

# ── Theme Configuration ──────────────────────────────────────────────────────

# ── Wallpaper ────────────────────────────────────────────────────────────────

# Default wallpaper (relative to dotfiles/wallpapers or absolute path)
DEFAULT_WALLPAPER="default.png"

# ── Directories ──────────────────────────────────────────────────────────────

# Where to backup existing configs
BACKUP_DIR="$HOME/.config/hypr-backup"

# ── Advanced Options ─────────────────────────────────────────────────────────

# Skip confirmation prompts (use with caution)
SKIP_CONFIRM=false

# Enable verbose logging
VERBOSE=false

# Nvidia driver type: "dkms" | "open-dkms" (for Turing+ GPUs)
# Leave empty for auto-detection
NVIDIA_DRIVER_TYPE=""
