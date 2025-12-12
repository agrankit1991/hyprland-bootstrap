#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        Network Hardware Configuration                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Ensures iwd is enabled and disables systemd-networkd-wait-online to speed up boot.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

configure_network_hardware() {
    log_step "Configuring network hardware (iwd, systemd-networkd)..."
    
    # Enable iwd service
    sudo systemctl enable iwd.service
    log_substep "Enabled iwd.service"
    
    # Disable and mask systemd-networkd-wait-online
    sudo systemctl disable systemd-networkd-wait-online.service || true
    sudo systemctl mask systemd-networkd-wait-online.service || true
    log_substep "Disabled and masked systemd-networkd-wait-online.service"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_network_hardware
fi
