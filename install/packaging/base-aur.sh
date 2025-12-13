#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                   AUR/Community Package Installation                     ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs all AUR/community packages required for Hyprland setup.
# All packages in this script are considered recommended or optional.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/install/base-aur-packages.sh"

# ── Installation Functions ───────────────────────────────────────────────────

install_aur_packages() {
	print_header "Installing AUR/Community Packages"

	log_info "Updating AUR helper (yay) and installing packages..."
	yay -Syu --noconfirm --needed

	# Browsers
	log_step "Installing browsers..."
	install_aur "${PACKAGES_BROWSERS[@]}"

	# Development Apps
	log_step "Installing development apps..."
	install_aur "${PACKAGES_DEV_APPS[@]}"

	# Productivity/Knowledge Management
	log_step "Installing productivity/knowledge management apps..."
	install_aur "${PACKAGES_PRODUCTIVITY[@]}"

	# Media
	log_step "Installing media apps..."
	install_aur "${PACKAGES_MEDIA[@]}"

	echo ""
	log_success "AUR/community package installation complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	install_aur_packages
fi
