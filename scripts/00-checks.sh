#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           Pre-flight Checks                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# This script performs essential checks before installation:
# - Arch Linux detection
# - Internet connectivity
# - User permissions (not root, but has sudo)
# - Required dependencies
#

set -e

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/utils.sh"

# ── Main Checks ──────────────────────────────────────────────────────────────

run_checks() {
    print_header "Pre-flight Checks"
    
    local failed=0
    
    # Check 1: Arch Linux
    log_step "Checking operating system..."
    if is_arch; then
        log_success "Arch Linux detected"
    else
        log_error "This script is designed for Arch Linux only"
        ((failed++))
    fi
    
    # Check 2: Not running as root
    log_step "Checking user permissions..."
    if is_root; then
        log_error "Do not run this script as root"
        log_info "Run as a regular user with sudo privileges"
        ((failed++))
    else
        log_success "Running as regular user: $USER"
    fi
    
    # Check 3: Has sudo access
    log_step "Checking sudo access..."
    if sudo -n true 2>/dev/null || sudo -v; then
        log_success "Sudo access confirmed"
    else
        log_error "User does not have sudo privileges"
        log_info "Add user to wheel group: usermod -aG wheel $USER"
        ((failed++))
    fi
    
    # Check 4: Internet connectivity
    log_step "Checking internet connection..."
    if has_internet; then
        log_success "Internet connection available"
    else
        log_error "No internet connection"
        log_info "Please connect to the internet and try again"
        ((failed++))
    fi
    
    # Check 5: GPU detection
    log_step "Detecting GPU..."
    local gpu_vendor
    gpu_vendor=$(get_gpu_vendor)
    
    case "$gpu_vendor" in
        nvidia)
            log_success "Nvidia GPU detected"
            log_info "Nvidia drivers will be configured for Hyprland"
            export DETECTED_GPU="nvidia"
            ;;
        amd)
            log_success "AMD GPU detected"
            log_info "AMD drivers are included in the kernel"
            export DETECTED_GPU="amd"
            ;;
        intel)
            log_success "Intel GPU detected"
            export DETECTED_GPU="intel"
            ;;
        *)
            log_warning "Could not detect GPU vendor"
            export DETECTED_GPU="unknown"
            ;;
    esac
    
    # Check 6: Disk space
    log_step "Checking disk space..."
    local available_gb
    available_gb=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    
    if (( available_gb >= 5 )); then
        log_success "Sufficient disk space: ${available_gb}GB available"
    else
        log_warning "Low disk space: ${available_gb}GB available (5GB+ recommended)"
    fi
    
    # Summary
    echo ""
    if [[ $failed -eq 0 ]]; then
        log_success "All checks passed! Ready to install."
        return 0
    else
        log_error "$failed check(s) failed. Please fix the issues above."
        return 1
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_checks
fi
