#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        Theme Copy Script                                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Copies the themes directory and its subdirectories to ~/.config/omarchy/themes/
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

# Call all theme setup steps
setup_all_themes() {
	copy_themes
	set_initial_theme
	set_app_themes
	set_managed_policy_dirs
}

# Copy all themes to ~/.config/omarchy/themes
copy_themes() {
	log_step "Copying themes to ~/.config/omarchy/themes..."
	local SRC_DIR="$SCRIPT_DIR/themes"
	local DEST_DIR="$HOME/.config/omarchy/themes"
	mkdir -p "$DEST_DIR"
	cp -R "$SRC_DIR/." "$DEST_DIR/"
	log_success "Theme copy complete."
}

# Set the initial theme by creating symlinks
set_initial_theme() {
	log_step "Setting initial theme (tokyo-night)..."
	local THEMES_DIR="$HOME/.config/omarchy/themes"
	local CURRENT_DIR="$HOME/.config/omarchy/current"
	local THEME_NAME="tokyo-night"
	local THEME_PATH="$THEMES_DIR/$THEME_NAME"
	local BACKGROUND_PATH="$THEME_PATH/backgrounds/1-scenery-pink-lakeside-sunset-lake-landscape-scenic-panorama-7680x3215-144.png"
	mkdir -p "$CURRENT_DIR"
	ln -snf "$THEME_PATH" "$CURRENT_DIR/theme"
	ln -snf "$BACKGROUND_PATH" "$CURRENT_DIR/background"
	log_success "Initial theme set to $THEME_NAME."
}

# Set app-specific themes (e.g., btop)
set_app_themes() {
	log_step "Setting app-specific themes (btop)..."
	local BTOP_THEMES_DIR="$HOME/.config/btop/themes"
	local OMARCHY_THEME_BTOP="$HOME/.config/omarchy/current/theme/btop.theme"
	mkdir -p "$BTOP_THEMES_DIR"
	ln -snf "$OMARCHY_THEME_BTOP" "$BTOP_THEMES_DIR/current.theme"
	log_success "btop theme symlinked to current omarchy theme."
}

# Add managed policy directories for Chromium and Brave for theme changes
set_managed_policy_dirs() {
	log_step "Creating managed policy directories for Chromium and Brave..."

	sudo mkdir -p /etc/chromium/policies/managed
	sudo chmod a+rw /etc/chromium/policies/managed

	sudo mkdir -p /etc/brave/policies/managed
	sudo chmod a+rw /etc/brave/policies/managed
    
	log_success "Managed policy directories ready."
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	setup_all_themes
fi
