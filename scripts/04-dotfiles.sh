#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           Dotfiles Deployment                              ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Deploys configuration files and dotfiles to their appropriate locations.
# Creates backups of existing configurations before overwriting.
#

set -e

# Get script directory and source utilities
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/config.sh"

# ── Global Variables ──────────────────────────────────────────────────────────

DOTFILES_DIR="$SCRIPT_DIR/../dotfiles"
BACKUP_DIR="$HOME/.config/hypr-backup"

# ── Configuration Mapping ────────────────────────────────────────────────────

# Array of source:destination mappings
declare -A DOTFILE_MAPPINGS=(
    # Hyprland configurations
    ["hypr/hyprland.conf"]="$HOME/.config/hypr/hyprland.conf"
    ["hypr/configs"]="$HOME/.config/hypr/configs"
    ["hypr/hyprlock.conf"]="$HOME/.config/hypr/hyprlock.conf"
    ["hypr/hypridle.conf"]="$HOME/.config/hypr/hypridle.conf"
    ["hypr/hyprsunset.conf"]="$HOME/.config/hypr/hyprsunset.conf"
    
    # Waybar configuration
    ["waybar"]="$HOME/.config/waybar"
    
    # Rofi configuration
    ["rofi"]="$HOME/.config/rofi"
    
    # SwayNC (notification center)
    ["swaync"]="$HOME/.config/swaync"
    
    # Kitty terminal
    ["kitty"]="$HOME/.config/kitty"
    
    # GTK configuration
    ["gtk-3.0"]="$HOME/.config/gtk-3.0"
    ["gtk-4.0"]="$HOME/.config/gtk-4.0"
    
    # Wallpapers
    ["wallpapers"]="$HOME/.config/hypr/wallpapers"
    
    # Scripts and utilities
    ["scripts"]="$HOME/.config/hypr/scripts"
)

# ── Deployment Functions ─────────────────────────────────────────────────────

backup_existing_configs() {
    log_step "Creating backup of existing configurations..."
    
    if [[ "$BACKUP_EXISTING" != "true" ]]; then
        log_substep "Backup disabled in config"
        return 0
    fi
    
    local backup_created=false
    
    for mapping in "${!DOTFILE_MAPPINGS[@]}"; do
        local target="${DOTFILE_MAPPINGS[$mapping]}"
        
        if [[ -e "$target" ]]; then
            if [[ "$backup_created" == "false" ]]; then
                mkdir -p "$BACKUP_DIR"
                log_substep "Backup directory: $BACKUP_DIR"
                backup_created=true
            fi
            
            backup_file "$target"
        fi
    done
    
    if [[ "$backup_created" == "false" ]]; then
        log_substep "No existing configurations to backup"
    fi
}

create_config_directories() {
    log_step "Creating configuration directories..."
    
    local dirs=(
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/rofi"
        "$HOME/.config/swaync"
        "$HOME/.config/kitty"
        "$HOME/.config/gtk-3.0"
        "$HOME/.config/gtk-4.0"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            log_substep "Created: $dir"
        fi
    done
}

deploy_dotfiles() {
    log_step "Deploying configuration files..."
    
    local deployed_count=0
    
    for mapping in "${!DOTFILE_MAPPINGS[@]}"; do
        local source="$DOTFILES_DIR/$mapping"
        local target="${DOTFILE_MAPPINGS[$mapping]}"
        
        if [[ -e "$source" ]]; then
            # Create parent directory if it doesn't exist
            mkdir -p "$(dirname "$target")"
            
            # Remove existing file/directory if it exists
            if [[ -e "$target" ]]; then
                rm -rf "$target"
            fi
            
            # Copy the configuration
            cp -r "$source" "$target"
            log_substep "Deployed: $(basename "$target")"
            ((deployed_count++))
        else
            log_warning "Source not found: $source"
        fi
    done
    
    log_success "Deployed $deployed_count configuration files"
}

create_user_variables_config() {
    log_step "Creating user variables configuration..."
    
    local variables_file="$HOME/.config/hypr/configs/variables.conf"
    
    # Create the variables.conf file with user preferences from config.sh
    cat > "$variables_file" << EOF
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           User Variables                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# This file contains user-configurable variables used throughout the Hyprland
# configuration. Edit these values to customize your setup.
#

# ── Default Applications ──────────────────────────────────────────────────────

\$terminal     = $TERMINAL
\$browser      = $BROWSER
\$fileManager  = $FILE_MANAGER
\$editor       = $EDITOR
\$launcher     = ~/.config/rofi/launchers/type-1/launcher.sh
\$powermenu    = ~/.config/rofi/powermenu/type-1/powermenu.sh

# ── Theme Colors ───────────────────────────────────────────────────────────────
# Catppuccin Mocha color scheme

\$accent       = rgb(89b4fa)    # Blue
\$accentAlpha  = 89b4fa
\$background   = rgb(1e1e2e)    # Base
\$foreground   = rgb(cdd6f4)    # Text
\$surface      = rgb(313244)    # Surface0
\$overlay      = rgb(6c7086)    # Overlay0

# Additional theme colors
\$red          = rgb(f38ba8)
\$green        = rgb(a6e3a1)
\$yellow       = rgb(f9e2af)
\$blue         = rgb(89b4fa)
\$magenta      = rgb(cba6f7)
\$cyan         = rgb(94e2d5)

# ── Cursor Theme ─────────────────────────────────────────────────────────────────────

\$cursorTheme  = $CURSOR_THEME
\$cursorSize   = $CURSOR_SIZE

# ── Appearance ─────────────────────────────────────────────────────────────────────

\$borderSize   = 2
\$rounding     = 10
\$gapsIn       = 5
\$gapsOut      = 10
\$opacity      = 0.95

# ── Animation Settings ────────────────────────────────────────────────────────────

\$animationSpeed = 1.0

# ── Wallpaper ──────────────────────────────────────────────────────────────────────

\$wallpaper    = ~/.config/hypr/wallpapers/$DEFAULT_WALLPAPER

# ── Monitor Configuration ─────────────────────────────────────────────────────
# Edit the monitors.conf file for detailed monitor setup

\$primaryMonitor = DP-1
EOF

    log_substep "Created: $(basename "$variables_file")"
}

set_file_permissions() {
    log_step "Setting appropriate file permissions..."
    
    # Make scripts executable
    local script_dirs=(
        "$HOME/.config/hypr/scripts"
        "$HOME/.config/rofi/launchers"
        "$HOME/.config/rofi/powermenu"
    )
    
    for dir in "${script_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            find "$dir" -type f -name "*.sh" -exec chmod +x {} \;
            log_substep "Made scripts executable in: $(basename "$dir")"
        fi
    done
    
    # Set config file permissions (readable by user only)
    find "$HOME/.config/hypr" -type f -name "*.conf" -exec chmod 600 {} \;
    find "$HOME/.config/waybar" -type f \( -name "*.json" -o -name "*.jsonc" -o -name "*.css" \) -exec chmod 600 {} \;
    
    log_substep "Set secure permissions for configuration files"
}

setup_wallpaper() {
    log_step "Setting up wallpapers..."
    
    local wallpaper_dir="$HOME/.config/hypr/wallpapers"
    local default_wallpaper="$wallpaper_dir/$DEFAULT_WALLPAPER"
    
    if [[ -f "$default_wallpaper" ]]; then
        # Set wallpaper using swww if available
        if cmd_exists swww; then
            # Initialize swww daemon if not running
            if ! pgrep -x swww-daemon > /dev/null; then
                swww-daemon &
                sleep 1
            fi
            
            swww img "$default_wallpaper" --transition-type fade
            log_substep "Set wallpaper: $(basename "$default_wallpaper")"
        else
            log_substep "swww not installed, wallpaper will be set on first login"
        fi
    else
        log_warning "Default wallpaper not found: $default_wallpaper"
    fi
    
    # Copy user avatar image if available
    local face_image="$wallpaper_dir/face.png"
    if [[ -f "$face_image" ]]; then
        cp "$face_image" "$HOME/.face"
        log_substep "Set user avatar: ~/.face"
    else
        log_substep "User avatar not found, hyprlock will use fallback"
    fi
}

validate_deployment() {
    log_step "Validating deployment..."
    
    local errors=0
    local critical_files=(
        "$HOME/.config/hypr/hyprland.conf"
        "$HOME/.config/hypr/configs/variables.conf"
        "$HOME/.config/waybar/config.jsonc"
        "$HOME/.config/kitty/kitty.conf"
    )
    
    for file in "${critical_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "Missing critical file: $file"
            ((errors++))
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        log_success "All critical configuration files deployed successfully"
    else
        log_error "Deployment validation failed with $errors errors"
        return 1
    fi
}

print_post_deployment_info() {
    print_section "Dotfiles Deployment Complete"
    
    cat << EOF
${COLOR_SUCCESS}✓${NC} Configuration files have been deployed to ~/.config/

${COLOR_HEADER}Next Steps:${NC}
${BULLET} Logout and log back in to apply changes
${BULLET} Run 'hyprctl reload' to reload Hyprland configuration
${BULLET} Edit ~/.config/hypr/configs/variables.conf to customize settings
${BULLET} Edit ~/.config/hypr/configs/monitors.conf for monitor setup

${COLOR_HEADER}Key Configuration Files:${NC}
${BULLET} Hyprland: ~/.config/hypr/hyprland.conf
${BULLET} Variables: ~/.config/hypr/configs/variables.conf
${BULLET} Keybinds: ~/.config/hypr/configs/keybinds.conf
${BULLET} Waybar: ~/.config/waybar/config.jsonc
${BULLET} Terminal: ~/.config/kitty/kitty.conf

EOF

    if [[ "$BACKUP_EXISTING" == "true" && -d "$BACKUP_DIR" ]]; then
        echo -e "${COLOR_INFO}${INFO_SIGN}${NC} Backups saved to: $BACKUP_DIR"
    fi
}

# ── Main Execution ───────────────────────────────────────────────────────────

main() {
    print_header "Deploying Dotfiles"
    
    # Pre-deployment checks
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles directory not found: $DOTFILES_DIR"
        log_info "Please ensure the dotfiles directory exists and contains configuration files"
        exit 1
    fi
    
    # Execute deployment steps
    backup_existing_configs
    create_config_directories
    deploy_dotfiles
    create_user_variables_config
    set_file_permissions
    setup_wallpaper
    validate_deployment
    
    print_post_deployment_info
    
    log_success "Dotfiles deployment completed successfully!"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi