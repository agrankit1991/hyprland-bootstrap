#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                      Fast Systemd Shutdown Configuration                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Configures systemd to use a faster shutdown timeout.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

configure_fast_shutdown() {
    log_step "Configuring fast systemd shutdown..."
    
    sudo mkdir -p /etc/systemd/system.conf.d
    
    sudo tee /etc/systemd/system.conf.d/10-faster-shutdown.conf > /dev/null <<EOF
[Manager]
DefaultTimeoutStopSec=5s
EOF
    
    sudo systemctl daemon-reload
    log_success "Systemd shutdown timeout set to 5 seconds."
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_fast_shutdown
fi
