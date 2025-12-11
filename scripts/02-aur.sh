#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                      AUR Helper & AUR Package Installation                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs an AUR helper (yay or paru) and AUR packages.
#

set -e

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/utils.sh"
source "$SCRIPT_DIR/../config.sh" 2>/dev/null || true

# ── AUR Package Lists ────────────────────────────────────────────────────────

# Hypr ecosystem (AUR)
AUR_HYPR_ECOSYSTEM=(
    hyprshot
    hyprpicker
    hyprsunset
    hyprpolkitagent
)

# Theming (AUR)
AUR_THEMING=(
    catppuccin-gtk-theme-mocha
    bibata-cursor-theme
)

# Applications (AUR)
AUR_APPS=(
    brave-bin
    visual-studio-code-bin
)

# SDDM Theme (AUR)
AUR_SDDM=(
    sddm-theme-catppuccin
)

# ── AUR Helper Installation ──────────────────────────────────────────────────

install_yay() {
    if cmd_exists yay; then
        log_success "yay is already installed"
        return 0
    fi
    
    log_step "Installing yay AUR helper..."
    
    local tmp_dir
    tmp_dir=$(mktemp -d)
    
    git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay-bin"
    cd "$tmp_dir/yay-bin"
    makepkg -si --noconfirm
    cd - >/dev/null
    
    rm -rf "$tmp_dir"
    
    log_success "yay installed successfully"
}

install_paru() {
    if cmd_exists paru; then
        log_success "paru is already installed"
        return 0
    fi
    
    log_step "Installing paru AUR helper..."
    
    local tmp_dir
    tmp_dir=$(mktemp -d)
    
    git clone https://aur.archlinux.org/paru-bin.git "$tmp_dir/paru-bin"
    cd "$tmp_dir/paru-bin"
    makepkg -si --noconfirm
    cd - >/dev/null
    
    rm -rf "$tmp_dir"
    
    log_success "paru installed successfully"
}

install_aur_helper() {
    local helper="${AUR_HELPER:-yay}"
    
    print_section "AUR Helper"
    
    case "$helper" in
        yay)
            install_yay
            ;;
        paru)
            install_paru
            ;;
        *)
            log_warning "Unknown AUR helper: $helper, defaulting to yay"
            install_yay
            AUR_HELPER="yay"
            ;;
    esac
    
    export AUR_HELPER
}

# ── AUR Package Installation ─────────────────────────────────────────────────

install_hypr_ecosystem_aur() {
    log_step "Installing Hypr ecosystem tools from AUR..."
    install_aur "${AUR_HYPR_ECOSYSTEM[@]}"
}

install_theming_aur() {
    log_step "Installing themes from AUR..."
    install_aur "${AUR_THEMING[@]}"
}

install_apps_aur() {
    log_step "Installing applications from AUR..."
    install_aur "${AUR_APPS[@]}"
}

install_sddm_theme_aur() {
    log_step "Installing SDDM theme from AUR..."
    install_aur "${AUR_SDDM[@]}"
}

# ── Main Installation ────────────────────────────────────────────────────────

install_all_aur() {
    print_header "Installing AUR Packages"
    
    install_aur_helper
    
    install_hypr_ecosystem_aur
    install_theming_aur
    install_apps_aur
    
    if [[ "${INSTALL_SDDM_THEME:-true}" == "true" ]]; then
        install_sddm_theme_aur
    fi
    
    echo ""
    log_success "AUR package installation complete!"
}

install_aur_interactive() {
    print_header "Installing AUR Packages"
    
    install_aur_helper
    
    # Required packages
    install_hypr_ecosystem_aur
    
    # Optional categories
    if confirm "Install Catppuccin GTK theme and Bibata cursor?"; then
        install_theming_aur
    fi
    
    if confirm "Install Brave browser and VS Code?"; then
        install_apps_aur
    fi
    
    if confirm "Install SDDM Catppuccin theme?"; then
        install_sddm_theme_aur
    fi
    
    echo ""
    log_success "AUR package installation complete!"
}

# ── Entry Point ──────────────────────────────────────────────────────────────

run_aur_install() {
    local mode="${INSTALL_MODE:-interactive}"
    
    case "$mode" in
        all)
            install_all_aur
            ;;
        minimal)
            print_header "Installing AUR Packages (Minimal)"
            install_aur_helper
            install_hypr_ecosystem_aur
            log_success "Minimal AUR installation complete!"
            ;;
        interactive|*)
            install_aur_interactive
            ;;
    esac
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_aur_install
fi
