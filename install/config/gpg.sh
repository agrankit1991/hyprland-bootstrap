#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         GPG Configuration                                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Configures GPG with multiple keyservers for better reliability.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

# ── Configuration Functions ──────────────────────────────────────────────────

configure_gpg_keyservers() {
    log_step "Configuring GPG keyservers..."
    
    # Create GPG directory if it doesn't exist
    sudo mkdir -p /etc/gnupg
    
    # Copy dirmngr configuration
    sudo cp "$SCRIPT_DIR/default/gpg/dirmngr.conf" /etc/gnupg/
    sudo chmod 644 /etc/gnupg/dirmngr.conf
    
    log_substep "Copied dirmngr.conf to /etc/gnupg/"
    
    # Restart dirmngr to apply changes
    sudo gpgconf --kill dirmngr 2>/dev/null || true
    sudo gpgconf --launch dirmngr 2>/dev/null || true
    
    log_substep "Restarted dirmngr service"
}

# ── Main Configuration ───────────────────────────────────────────────────────

configure_gpg() {
    print_header "GPG Configuration"
    
    configure_gpg_keyservers
    
    echo ""
    log_success "GPG configuration complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_gpg
fi
