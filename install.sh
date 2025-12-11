#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        Hyprland Bootstrap Installer                         ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Main installation script for Hyprland desktop environment on Arch Linux.
#
# Usage:
#   ./install.sh              # Interactive installation
#   ./install.sh --all        # Install everything
#   ./install.sh --minimal    # Minimal installation
#   ./install.sh --nvidia     # Nvidia drivers only
#   ./install.sh --packages   # Core packages only
#   ./install.sh --help       # Show help
#

set -e

# ── Script Setup ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR

# Source configuration and utilities
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/config.sh"

# ── Banner ───────────────────────────────────────────────────────────────────

show_banner() {
    echo -e "${BOLD_BLUE}"
    cat << 'EOF'
    ╦ ╦╦ ╦╔═╗╦═╗╦  ╔═╗╔╗╔╔╦╗
    ╠═╣╚╦╝╠═╝╠╦╝║  ╠═╣║║║ ║║
    ╩ ╩ ╩ ╩  ╩╚═╩═╝╩ ╩╝╚╝═╩╝
    ╔╗ ╔═╗╔═╗╔╦╗╔═╗╔╦╗╦═╗╔═╗╔═╗
    ╠╩╗║ ║║ ║ ║ ╚═╗ ║ ╠╦╝╠═╣╠═╝
    ╚═╝╚═╝╚═╝ ╩ ╚═╝ ╩ ╩╚═╩ ╩╩  
EOF
    echo -e "${NC}"
    echo -e "${DIM}  Hyprland Desktop Environment Setup for Arch Linux${NC}"
    echo ""
}

# ── Help ─────────────────────────────────────────────────────────────────────

show_help() {
    show_banner
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all           Install everything without prompts"
    echo "  --minimal       Install only core Hyprland components"
    echo "  --interactive   Ask before each component (default)"
    echo ""
    echo "  --nvidia        Install Nvidia drivers only"
    echo "  --skip-nvidia   Full install, skip Nvidia drivers"
    echo "  --packages      Install core packages only"
    echo "  --dotfiles      Deploy dotfiles only"
    echo "  --services      Enable system services only"
    echo "  --dev-tools     Install developer tools only"
    echo "  --security      Install security essentials only"
    echo ""
    echo "  --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./install.sh                    # Interactive installation"
    echo "  ./install.sh --all              # Full unattended installation"
    echo "  ./install.sh --minimal          # Core components only"
    echo "  ./install.sh --nvidia           # Just Nvidia drivers"
    echo ""
}

# ── Menu ─────────────────────────────────────────────────────────────────────

show_menu() {
    echo -e "${BOLD}Select installation type:${NC}"
    echo ""
    echo -e "  ${BOLD}1)${NC} Full Installation (Interactive)"
    echo -e "     ${DIM}Ask before installing each optional component${NC}"
    echo ""
    echo -e "  ${BOLD}2)${NC} Full Installation (All)"
    echo -e "     ${DIM}Install everything without prompts${NC}"
    echo ""
    echo -e "  ${BOLD}3)${NC} Minimal Installation"
    echo -e "     ${DIM}Core Hyprland + essential packages only${NC}"
    echo ""
    echo -e "  ${BOLD}4)${NC} Custom Installation"
    echo -e "     ${DIM}Select specific components to install${NC}"
    echo ""
    echo -e "  ${BOLD}q)${NC} Quit"
    echo ""
    
    while true; do
        echo -en "${COLOR_PROMPT}?${NC} Enter choice [1-4, q]: "
        read -r choice
        
        case "$choice" in
            1) INSTALL_MODE="interactive"; return 0 ;;
            2) INSTALL_MODE="all"; return 0 ;;
            3) INSTALL_MODE="minimal"; return 0 ;;
            4) show_custom_menu; return 0 ;;
            q|Q) echo ""; log_info "Installation cancelled."; exit 0 ;;
            *) echo "Invalid choice. Please enter 1-4 or q." ;;
        esac
    done
}

show_custom_menu() {
    echo ""
    echo -e "${BOLD}Select components to install:${NC}"
    echo ""
    
    local run_checks=true
    local run_deps=false
    local run_packages=false
    local run_nvidia=false
    local run_dotfiles=false
    local run_services=false
    local run_sddm=false
    
    confirm "Install base dependencies & yay?" && run_deps=true
    confirm "Install core packages (pacman)?" && run_packages=true
    confirm "Install/configure Nvidia drivers?" && run_nvidia=true
    confirm "Deploy dotfiles?" && run_dotfiles=true
    confirm "Enable services?" && run_services=true
    confirm "Configure SDDM?" && run_sddm=true
    
    echo ""
    
    # Run selected components
    [[ "$run_checks" == true ]] && source "$SCRIPT_DIR/scripts/00-checks.sh" && run_checks
    [[ "$run_deps" == true ]] && source "$SCRIPT_DIR/scripts/01-deps.sh" && run_deps_install
    [[ "$run_packages" == true ]] && source "$SCRIPT_DIR/scripts/02-packages.sh" && install_all_packages
    [[ "$run_nvidia" == true ]] && source "$SCRIPT_DIR/scripts/03-nvidia.sh" && install_nvidia
    
    # Deploy dotfiles if selected
    [[ "$run_dotfiles" == true ]] && source "$SCRIPT_DIR/scripts/04-dotfiles.sh" && main
    
    # Enable services if selected  
    [[ "$run_services" == true ]] && source "$SCRIPT_DIR/scripts/05-services.sh" && run_services_install
    
    # TODO: Add remaining components when scripts are created
    # [[ "$run_sddm" == true ]] && source "$SCRIPT_DIR/scripts/06-sddm.sh" && configure_sddm
    # [[ "$run_sddm" == true ]] && source "$SCRIPT_DIR/scripts/06-sddm.sh" && configure_sddm
    
    exit 0
}

# ── Main Installation Flow ───────────────────────────────────────────────────

run_full_install() {
    # Pre-flight checks
    source "$SCRIPT_DIR/scripts/00-checks.sh"
    run_checks || exit 1
    
    # Base dependencies & yay
    source "$SCRIPT_DIR/scripts/01-deps.sh"
    run_deps_install
    
    # Core packages
    source "$SCRIPT_DIR/scripts/02-packages.sh"
    run_package_install
    
    # Nvidia drivers (if applicable)
    source "$SCRIPT_DIR/scripts/03-nvidia.sh"
    run_nvidia_install
    
    # Deploy dotfiles
    source "$SCRIPT_DIR/scripts/04-dotfiles.sh"
    main
    
    # Enable services
    source "$SCRIPT_DIR/scripts/05-services.sh"
    run_services_install
    
    # TODO: Add remaining installation steps
    # source "$SCRIPT_DIR/scripts/06-sddm.sh"
    # source "$SCRIPT_DIR/scripts/06-sddm.sh"
    # source "$SCRIPT_DIR/scripts/07-rofi.sh"
    # source "$SCRIPT_DIR/scripts/08-gtk-qt.sh"
    # source "$SCRIPT_DIR/scripts/09-post-install.sh"
    
    # Final message
    print_header "Installation Complete!"
    
    log_success "Hyprland has been installed and configured!"
    echo ""
    log_info "Next steps:"
    echo "  1. Reboot your system"
    echo "  2. Select Hyprland from the SDDM login screen"
    echo "  3. Press Super + D to open the application launcher"
    echo ""
    log_info "Configuration files are located at:"
    echo "  ~/.config/hypr/"
    echo "  ~/.config/waybar/"
    echo "  ~/.config/rofi/"
    echo ""
    
    if confirm "Reboot now?"; then
        sudo reboot
    fi
}

# ── Argument Parsing ─────────────────────────────────────────────────────────

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --all)
                INSTALL_MODE="all"
                ;;
            --minimal)
                INSTALL_MODE="minimal"
                ;;
            --interactive)
                INSTALL_MODE="interactive"
                ;;
            --nvidia)
                source "$SCRIPT_DIR/scripts/03-nvidia.sh"
                install_nvidia
                exit 0
                ;;
            --skip-nvidia)
                INSTALL_NVIDIA=false
                ;;
            --packages)
                source "$SCRIPT_DIR/scripts/00-checks.sh"
                run_checks || exit 1
                source "$SCRIPT_DIR/scripts/02-packages.sh"
                install_all_packages
                exit 0
                ;;
            --dotfiles)
                source "$SCRIPT_DIR/scripts/04-dotfiles.sh"
                main
                exit 0
                ;;
            --services)
                source "$SCRIPT_DIR/scripts/05-services.sh"
                run_services_install
                exit 0
                ;;
            --dev-tools)
                log_warning "Developer tools script not yet implemented"
                exit 1
                ;;
            --security)
                log_warning "Security script not yet implemented"
                exit 1
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
        shift
    done
}

# ── Entry Point ──────────────────────────────────────────────────────────────

main() {
    # Parse command line arguments
    parse_args "$@"
    
    # Show banner
    show_banner
    
    # If no mode set, show menu
    if [[ -z "${INSTALL_MODE:-}" || "$INSTALL_MODE" == "interactive" ]]; then
        show_menu
    fi
    
    # Run installation
    run_full_install
}

# Run main
main "$@"
