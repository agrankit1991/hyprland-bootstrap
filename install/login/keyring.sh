#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                   Default Keyring Auto-Unlock Setup                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Ensures the default keyring is unlocked automatically on login.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

setup_default_keyring() {
    log_step "Setting up default keyring auto-unlock..."

    # 1. Safety Check: Ensure the package is actually installed
    install_pacman gnome-keyring

    # 2. Function to safely append if missing
    add_pam_line() {
        local file="$1"
        local line="$2"
        if [ -f "$file" ] && ! grep -qF "$line" "$file"; then
            echo "$line" | sudo tee -a "$file" > /dev/null
            log_substep "Added to $file: $line"
        fi
    }

    AUTH_LINE="auth       optional     pam_gnome_keyring.so"
    SESSION_LINE="session    optional     pam_gnome_keyring.so auto_start"

    add_pam_line "/etc/pam.d/login" "$AUTH_LINE"
    add_pam_line "/etc/pam.d/login" "$SESSION_LINE"
    add_pam_line "/etc/pam.d/sddm" "$AUTH_LINE"
    add_pam_line "/etc/pam.d/sddm" "$SESSION_LINE"

    log_success "Default keyring auto-unlock setup complete."
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_default_keyring
fi
