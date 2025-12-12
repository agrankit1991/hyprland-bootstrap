#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                     Complete Configuration Setup                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Runs all configuration scripts.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/install/config/git.sh"
source "$SCRIPT_DIR/install/config/gpg.sh"

# ── Main Configuration ───────────────────────────────────────────────────────

configure_all() {
    print_header "Complete Configuration Setup"
    
    # Configure GPG
    configure_gpg
    
    # Configure Git
    configure_git
    
    # Future: Additional configuration scripts can be added here
    # e.g., shell configuration, terminal configuration, etc.
    
    echo ""
    log_success "All configurations complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_all
fi
