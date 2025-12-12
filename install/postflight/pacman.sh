#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        Pacman Postflight Configuration                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Copies pacman.conf and updates the mirrorlist using reflector.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

configure_pacman() {
    log_step "Copying pacman.conf..."
    sudo cp "$SCRIPT_DIR/default/pacman/pacman.conf" /etc/pacman.conf
    log_success "pacman.conf copied to /etc/pacman.conf"

    log_step "Updating pacman mirrorlist with reflector..."
    if ! is_installed reflector; then
        install_pacman reflector
    fi

    # Use reflector to get the 10 latest HTTPS mirrors sorted by speed
    sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    log_success "Mirrorlist updated with reflector."

    # Sync the databases so the new [multilib] repo is recognized
    log_step "Syncing package databases..."
    sudo pacman -Syy
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_pacman
fi
