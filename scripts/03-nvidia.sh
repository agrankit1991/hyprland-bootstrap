#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         Nvidia Driver Setup                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Installs and configures Nvidia proprietary drivers for Hyprland.
# Includes kernel module configuration and environment variables.
#

set -e

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/utils.sh"
source "$SCRIPT_DIR/../config.sh" 2>/dev/null || true

# ── Nvidia Packages ──────────────────────────────────────────────────────────

# Standard DKMS driver (works with all Nvidia GPUs)
NVIDIA_PACKAGES_DKMS=(
    nvidia-dkms
    nvidia-utils
    lib32-nvidia-utils
    nvidia-settings
    egl-wayland
    libva-nvidia-driver
)

# Open kernel modules (Turing, Ampere, Ada Lovelace, and newer)
NVIDIA_PACKAGES_OPEN=(
    nvidia-open-dkms
    nvidia-utils
    lib32-nvidia-utils
    nvidia-settings
    egl-wayland
    libva-nvidia-driver
)

# Required kernel headers
NVIDIA_KERNEL_HEADERS=(
    linux-headers
)

# ── Detection Functions ──────────────────────────────────────────────────────

# Check if Nvidia GPU is present
has_nvidia_gpu() {
    lspci | grep -qi "nvidia"
}

# Detect GPU generation for driver selection
# Returns: "turing_plus" for GTX 16xx/RTX or "legacy" for older
detect_nvidia_generation() {
    local gpu_info
    gpu_info=$(lspci | grep -i "nvidia" | head -1)
    
    # Check for Turing+ architectures (GTX 16xx, RTX 20xx, 30xx, 40xx, 50xx)
    if echo "$gpu_info" | grep -qiE "(RTX|GTX 16[0-9]{2}|RTX [2-5]0[0-9]{2}|RTX [2-5]0[0-9]{2})"; then
        echo "turing_plus"
    else
        echo "legacy"
    fi
}

# ── Installation Functions ───────────────────────────────────────────────────

install_kernel_headers() {
    log_step "Installing kernel headers..."
    
    # Detect running kernel
    local kernel_type
    if uname -r | grep -q "lts"; then
        kernel_type="linux-lts-headers"
    elif uname -r | grep -q "zen"; then
        kernel_type="linux-zen-headers"
    elif uname -r | grep -q "hardened"; then
        kernel_type="linux-hardened-headers"
    else
        kernel_type="linux-headers"
    fi
    
    install_pacman "$kernel_type"
}

install_nvidia_dkms() {
    log_step "Installing Nvidia DKMS drivers..."
    install_pacman "${NVIDIA_PACKAGES_DKMS[@]}"
}

install_nvidia_open() {
    log_step "Installing Nvidia Open DKMS drivers..."
    install_pacman "${NVIDIA_PACKAGES_OPEN[@]}"
}

# ── Configuration Functions ──────────────────────────────────────────────────

configure_mkinitcpio() {
    log_step "Configuring mkinitcpio for Nvidia..."
    
    local mkinitcpio_conf="/etc/mkinitcpio.conf"
    local nvidia_modules="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    
    # Backup original
    sudo cp "$mkinitcpio_conf" "${mkinitcpio_conf}.backup"
    
    # Check if nvidia modules are already present
    if grep -q "nvidia" "$mkinitcpio_conf"; then
        log_substep "Nvidia modules already in mkinitcpio.conf"
    else
        # Add nvidia modules to MODULES array
        sudo sed -i "s/^MODULES=(\(.*\))/MODULES=(\1 $nvidia_modules)/" "$mkinitcpio_conf"
        
        # Clean up any double spaces
        sudo sed -i 's/MODULES=( /MODULES=(/' "$mkinitcpio_conf"
        
        log_substep "Added Nvidia modules to mkinitcpio.conf"
    fi
    
    # Regenerate initramfs
    log_substep "Regenerating initramfs..."
    sudo mkinitcpio -P
    
    log_success "mkinitcpio configured"
}

configure_modprobe() {
    log_step "Configuring modprobe for DRM..."
    
    local modprobe_conf="/etc/modprobe.d/nvidia.conf"
    
    # Create nvidia modprobe config
    echo "options nvidia_drm modeset=1" | sudo tee "$modprobe_conf" > /dev/null
    echo "options nvidia_drm fbdev=1" | sudo tee -a "$modprobe_conf" > /dev/null
    
    log_success "Modprobe configured: $modprobe_conf"
}

configure_pacman_hook() {
    log_step "Setting up Nvidia pacman hook..."
    
    local hook_dir="/etc/pacman.d/hooks"
    local hook_file="$hook_dir/nvidia.hook"
    
    sudo mkdir -p "$hook_dir"
    
    sudo tee "$hook_file" > /dev/null << 'EOF'
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=nvidia-dkms
Target=nvidia-open-dkms
Target=linux
Target=linux-lts
Target=linux-zen
Target=linux-hardened

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exec mkinitcpio -P;; esac; done'
EOF

    log_success "Pacman hook created: $hook_file"
}

enable_nvidia_services() {
    log_step "Enabling Nvidia power management services..."
    
    # Enable suspend/resume services for proper power management
    enable_service nvidia-suspend.service
    enable_service nvidia-hibernate.service
    enable_service nvidia-resume.service
    
    log_success "Nvidia services enabled"
}

create_hypr_nvidia_config() {
    log_step "Creating Hyprland Nvidia config..."
    
    local nvidia_conf_dir="$SCRIPT_DIR/../dotfiles/hypr/configs"
    mkdir -p "$nvidia_conf_dir"
    
    cat > "$nvidia_conf_dir/nvidia.conf" << 'EOF'
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                     Nvidia Environment Variables                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# Source this file in hyprland.conf: source = ~/.config/hypr/configs/nvidia.conf

# Hardware acceleration
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = NVD_BACKEND,direct

# Wayland specific
env = GBM_BACKEND,nvidia-drm
env = __GL_GSYNC_ALLOWED,1
env = __GL_VRR_ALLOWED,1

# Cursor fix (prevents invisible cursor on Nvidia)
env = WLR_NO_HARDWARE_CURSORS,1

# Electron/Chromium Wayland support
env = ELECTRON_OZONE_PLATFORM_HINT,auto

# Qt Wayland
env = QT_QPA_PLATFORM,wayland;xcb

# Firefox Wayland
env = MOZ_ENABLE_WAYLAND,1
EOF

    log_success "Nvidia config created: $nvidia_conf_dir/nvidia.conf"
}

# ── Main Installation ────────────────────────────────────────────────────────

install_nvidia() {
    print_header "Nvidia Driver Setup"
    
    # Check for Nvidia GPU
    if ! has_nvidia_gpu; then
        log_warning "No Nvidia GPU detected"
        if ! confirm "Continue with Nvidia driver installation anyway?" "n"; then
            log_info "Skipping Nvidia driver installation"
            return 0
        fi
    else
        log_success "Nvidia GPU detected"
    fi
    
    # Detect GPU generation
    local generation
    generation=$(detect_nvidia_generation)
    log_info "GPU generation: $generation"
    
    # Determine driver type
    local driver_type="${NVIDIA_DRIVER_TYPE:-}"
    
    if [[ -z "$driver_type" ]]; then
        if [[ "$generation" == "turing_plus" ]]; then
            log_info "Turing+ GPU detected - nvidia-open-dkms recommended"
            if confirm "Use nvidia-open-dkms (recommended for Turing+ GPUs)?" "y"; then
                driver_type="open-dkms"
            else
                driver_type="dkms"
            fi
        else
            log_info "Legacy GPU detected - using nvidia-dkms"
            driver_type="dkms"
        fi
    fi
    
    # Install kernel headers
    install_kernel_headers
    
    # Install drivers
    if [[ "$driver_type" == "open-dkms" ]]; then
        install_nvidia_open
    else
        install_nvidia_dkms
    fi
    
    # Configure system
    configure_mkinitcpio
    configure_modprobe
    configure_pacman_hook
    enable_nvidia_services
    create_hypr_nvidia_config
    
    echo ""
    log_success "Nvidia driver installation complete!"
    log_warning "A reboot is required to load the Nvidia drivers"
}

# Skip installation if not needed
skip_nvidia() {
    log_info "Skipping Nvidia driver installation"
}

# ── Entry Point ──────────────────────────────────────────────────────────────

run_nvidia_install() {
    local install="${INSTALL_NVIDIA:-true}"
    local mode="${INSTALL_MODE:-interactive}"
    
    if [[ "$install" != "true" ]]; then
        skip_nvidia
        return 0
    fi
    
    if [[ "$mode" == "interactive" ]]; then
        if confirm "Install and configure Nvidia drivers?"; then
            install_nvidia
        else
            skip_nvidia
        fi
    else
        install_nvidia
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_nvidia_install
fi
