#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                     Complete Login Configuration Setup                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Runs all login-related configuration scripts.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/install/login/keyring.sh"

# ── Main Login Configuration ────────────────────────────────────────────────

configure_login_all() {
    print_header "Complete Login Configuration Setup"
    
    # Setup default keyring auto-unlock
    setup_default_keyring
    
    # Future: Additional login configuration scripts can be added here
    
    echo ""
    log_success "All login configurations complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_login_all
fi