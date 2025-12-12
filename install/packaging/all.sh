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

# ── Main Installation ────────────────────────────────────────────────────────

install_all_packages() {
    print_header "Complete Package Installation"
    
    # Install all base packages
    install_base_packages
    
    # Future: Additional optional packages can be added here
    # e.g., development tools, media applications, etc.
    
    echo ""
    log_success "All packages installed successfully!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_packages
fi
