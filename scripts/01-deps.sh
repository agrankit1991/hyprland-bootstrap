#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                       Base Dependencies & AUR Helper                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs base dependencies required for the installation process
# and the yay AUR helper.
#

set -e

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/utils.sh"

# ── Base Dependencies ────────────────────────────────────────────────────────

BASE_DEPS=(
    base-devel      # Essential build tools (gcc, make, etc.) - required for AUR
    git             # Version control - required to clone AUR packages
    curl            # URL data transfer - used by many install scripts
    wget            # File downloader - alternative to curl for downloads
)

# ── Installation Functions ───────────────────────────────────────────────────

install_base_deps() {
    log_step "Installing base dependencies..."
    
    local to_install=()
    
    for dep in "${BASE_DEPS[@]}"; do
        if is_installed "$dep"; then
            log_substep "$dep already installed"
        else
            to_install+=("$dep")
        fi
    done
    
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing: ${to_install[*]}"
        sudo pacman -S --noconfirm --needed "${to_install[@]}"
        log_success "Base dependencies installed"
    else
        log_success "All base dependencies already present"
    fi
}

install_yay() {
    log_step "Installing yay AUR helper..."
    
    if cmd_exists yay; then
        log_substep "yay already installed"
        return 0
    fi
    
    local tmp_dir
    tmp_dir=$(mktemp -d)
    
    log_substep "Cloning yay-bin from AUR..."
    git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay-bin"
    
    log_substep "Building and installing yay..."
    cd "$tmp_dir/yay-bin"
    makepkg -si --noconfirm
    cd - >/dev/null
    
    rm -rf "$tmp_dir"
    log_success "yay installed successfully"
}

# ── Main Installation ────────────────────────────────────────────────────────

install_deps() {
    print_header "Installing Dependencies"
    
    install_base_deps
    install_yay
    
    echo ""
    log_success "All dependencies installed!"
}

# ── Entry Point ──────────────────────────────────────────────────────────────

run_deps_install() {
    install_deps
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_deps_install
fi
