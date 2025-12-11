#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                            Services Configuration                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Enables and configures essential systemd services for the Hyprland environment.
# This includes display manager, audio, networking, and other core services.
#

set -e

# Get script directory and source utilities
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/config.sh"

# ── Service Configuration Functions ──────────────────────────────────────────

enable_display_manager() {
    log_step "Configuring display manager..."
    
    if [[ "$INSTALL_SDDM_THEME" == "true" ]]; then
        # Enable SDDM
        if systemctl is-enabled sddm.service &>/dev/null; then
            log_substep "SDDM already enabled"
        else
            sudo systemctl enable sddm.service
            log_substep "Enabled SDDM display manager"
        fi
        
        # Disable other display managers
        local other_dms=("gdm" "lightdm" "lxdm" "xdm")
        for dm in "${other_dms[@]}"; do
            if systemctl is-enabled "${dm}.service" &>/dev/null 2>&1; then
                sudo systemctl disable "${dm}.service"
                log_substep "Disabled $dm display manager"
            fi
        done
    else
        log_substep "SDDM installation disabled in config"
    fi
}

enable_audio_services() {
    log_step "Configuring audio services..."
    
    # Enable user services for PipeWire
    local audio_services=(
        "pipewire.service"
        "pipewire-pulse.service" 
        "wireplumber.service"
    )
    
    for service in "${audio_services[@]}"; do
        if systemctl --user is-enabled "$service" &>/dev/null; then
            log_substep "$service already enabled"
        else
            systemctl --user enable "$service"
            log_substep "Enabled $service"
        fi
    done
    
    # Start services if not running
    for service in "${audio_services[@]}"; do
        if ! systemctl --user is-active "$service" &>/dev/null; then
            systemctl --user start "$service"
            log_substep "Started $service"
        fi
    done
}

enable_networking_services() {
    log_step "Configuring networking services..."
    
    # Enable NetworkManager
    if systemctl is-enabled NetworkManager.service &>/dev/null; then
        log_substep "NetworkManager already enabled"
    else
        sudo systemctl enable NetworkManager.service
        log_substep "Enabled NetworkManager"
    fi
    
    # Start NetworkManager if not running
    if ! systemctl is-active NetworkManager.service &>/dev/null; then
        sudo systemctl start NetworkManager.service
        log_substep "Started NetworkManager"
    fi
    
    # Enable Bluetooth if available
    if systemctl list-unit-files | grep -q bluetooth.service; then
        if systemctl is-enabled bluetooth.service &>/dev/null; then
            log_substep "Bluetooth already enabled"
        else
            sudo systemctl enable bluetooth.service
            log_substep "Enabled Bluetooth"
        fi
    else
        log_substep "Bluetooth service not available"
    fi
}



enable_docker_services() {
    log_step "Configuring container services..."
    
    if cmd_exists docker; then
        # Enable Docker service
        if systemctl is-enabled docker.service &>/dev/null; then
            log_substep "Docker service already enabled"
        else
            sudo systemctl enable docker.service
            log_substep "Enabled Docker service"
        fi
        
        # Add user to docker group
        if groups "$USER" | grep -q docker; then
            log_substep "User already in docker group"
        else
            sudo usermod -aG docker "$USER"
            log_substep "Added $USER to docker group"
            log_info "You'll need to log out and back in for docker group changes to take effect"
        fi
        
        # Enable Docker socket
        if systemctl is-enabled docker.socket &>/dev/null; then
            log_substep "Docker socket already enabled"
        else
            sudo systemctl enable docker.socket
            log_substep "Enabled Docker socket"
        fi
    else
        log_substep "Docker not installed, skipping container services"
    fi
}

enable_essential_services() {
    log_step "Configuring essential system services..."
    
    # Enable essential services
    local essential_services=(
        "systemd-timesyncd.service"     # Time synchronization
        "systemd-resolved.service"      # DNS resolution
        "dbus.service"                  # D-Bus system message bus
    )
    
    for service in "${essential_services[@]}"; do
        if systemctl list-unit-files | grep -q "$service"; then
            if systemctl is-enabled "$service" &>/dev/null; then
                log_substep "$service already enabled"
            else
                sudo systemctl enable "$service"
                log_substep "Enabled $service"
            fi
        fi
    done
    
    # Enable user services
    local user_services=(
        "dbus.service"                  # User D-Bus session
    )
    
    for service in "${user_services[@]}"; do
        if systemctl --user list-unit-files | grep -q "$service"; then
            if systemctl --user is-enabled "$service" &>/dev/null; then
                log_substep "User $service already enabled"
            else
                systemctl --user enable "$service"
                log_substep "Enabled user $service"
            fi
        fi
    done
}

configure_systemd_user_session() {
    log_step "Configuring systemd user session..."
    
    # Enable lingering for the current user (allows user services to run without login)
    if loginctl show-user "$USER" | grep -q "Linger=yes"; then
        log_substep "User lingering already enabled"
    else
        sudo loginctl enable-linger "$USER"
        log_substep "Enabled user lingering for $USER"
    fi
    
    # Set XDG_RUNTIME_DIR for user services
    local env_file="$HOME/.config/systemd/user/environment.d/10-user-session.conf"
    mkdir -p "$(dirname "$env_file")"
    
    cat > "$env_file" << EOF
# User session environment variables
XDG_CURRENT_DESKTOP=Hyprland
XDG_SESSION_TYPE=wayland
XDG_SESSION_DESKTOP=Hyprland
EOF
    
    log_substep "Created user session environment file"
}

validate_services() {
    log_step "Validating service configuration..."
    
    local failed_services=()
    
    # Check critical services
    local critical_services=(
        "NetworkManager.service"
        "dbus.service"
    )
    
    if [[ "$INSTALL_SDDM_THEME" == "true" ]]; then
        critical_services+=("sddm.service")
    fi
    
    for service in "${critical_services[@]}"; do
        if ! systemctl is-enabled "$service" &>/dev/null; then
            failed_services+=("$service")
        fi
    done
    
    # Check user services
    local user_critical_services=(
        "pipewire.service"
        "pipewire-pulse.service"
        "wireplumber.service"
    )
    
    for service in "${user_critical_services[@]}"; do
        if ! systemctl --user is-enabled "$service" &>/dev/null; then
            failed_services+=("user:$service")
        fi
    done
    
    if [[ ${#failed_services[@]} -eq 0 ]]; then
        log_success "All critical services configured successfully"
    else
        log_warning "Some services failed to configure:"
        for service in "${failed_services[@]}"; do
            log_substep "Failed: $service"
        done
        return 1
    fi
}

print_post_services_info() {
    print_section "Services Configuration Complete"
    
    cat << EOF
${COLOR_SUCCESS}✓${NC} System services have been configured and enabled

${COLOR_HEADER}Enabled Services:${NC}
${BULLET} Display Manager: SDDM (if enabled)
${BULLET} Audio: PipeWire + WirePlumber
${BULLET} Networking: NetworkManager + Bluetooth
${BULLET} Time Sync: systemd-timesyncd
${BULLET} DNS: systemd-resolved

EOF

    if cmd_exists docker; then
        echo -e "${COLOR_HEADER}Container Services:${NC}"
        echo -e "${BULLET} Docker service enabled"
        echo -e "${BULLET} User added to docker group"
        echo ""
    fi
    
    cat << EOF
${COLOR_HEADER}Next Steps:${NC}
${BULLET} Reboot to ensure all services start properly
${BULLET} Check service status: systemctl --user status pipewire
${BULLET} Test audio: speaker-test -t sine -f 1000 -l 1

EOF
}

# ── Main Execution ───────────────────────────────────────────────────────────

run_services_install() {
    print_header "Configuring System Services"
    
    # Execute service configuration steps
    enable_essential_services
    configure_systemd_user_session
    enable_display_manager
    enable_audio_services
    enable_networking_services
    enable_docker_services
    validate_services
    
    print_post_services_info
    
    log_success "Services configuration completed successfully!"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_services_install "$@"
fi