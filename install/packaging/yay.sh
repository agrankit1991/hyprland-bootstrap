# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        Yay Installer Script                              ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs yay AUR helper if not already installed.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

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

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	install_yay
fi
