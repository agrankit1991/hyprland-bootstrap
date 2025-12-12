e#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                     Complete Pacman Postflight Setup                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Runs all postflight configuration scripts for pacman.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/install/postflight/pacman.sh"

# ── Main Postflight Configuration ────────────────────────────────────────────

configure_postflight_all() {
    print_header "Complete Pacman Postflight Setup"
    
    # Configure pacman
    configure_pacman
    
    # Future: Additional postflight scripts can be added here
    
    echo ""
    log_success "All postflight configurations complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_postflight_all
fi
