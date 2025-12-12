#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         Default Configuration Values                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# This file contains default configuration values used throughout the installation.
# These can be overridden by environment variables.
#

# ── Editor Configuration ─────────────────────────────────────────────────────

EDITOR="nvim"

# ── Git Configuration ────────────────────────────────────────────────────────

GIT_DEFAULT_BRANCH="master"

# ── Shell Configuration ──────────────────────────────────────────────────────

SHELL="bash"

# ── Directory Paths ──────────────────────────────────────────────────────────

# Backup directory for existing configs
BACKUP_DIR="${BACKUP_DIR:-$HOME/.config/hypr-backup}"

# ── AUR Helper ───────────────────────────────────────────────────────────────

AUR_HELPER="yay"
