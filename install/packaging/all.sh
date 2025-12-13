#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                     Complete Package Installation                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs all packages (base + additional) for a complete Hyprland setup.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/install/packaging/base.sh"
source "$SCRIPT_DIR/install/packaging/yay.sh"
source "$SCRIPT_DIR/install/packaging/base-aur.sh"

# ── Main Installation ────────────────────────────────────────────────────────

install_all_packages() {
    print_header "Complete Package Installation"

    # Install all base packages
    install_base_packages

    # Install yay (AUR helper)
    install_yay

    # Install all AUR/community packages
    install_aur_packages

    echo ""
    log_success "All packages installed successfully!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_packages
fi
