#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                            Utility Functions                                ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Source colors if not already loaded
[[ -z "$NC" ]] && source "$SCRIPT_DIR/colors.sh"

# ── Logging Functions ────────────────────────────────────────────────────────

log_info() {
    echo -e "${COLOR_INFO}${INFO_SIGN}${NC} $1"
}

log_success() {
    echo -e "${COLOR_SUCCESS}${CHECKMARK}${NC} $1"
}

log_warning() {
    echo -e "${COLOR_WARNING}${WARNING_SIGN}${NC} $1"
}

log_error() {
    echo -e "${COLOR_ERROR}${CROSSMARK}${NC} $1" >&2
}

log_step() {
    echo -e "\n${COLOR_HEADER}${ARROW}${NC} ${BOLD}$1${NC}"
}

log_substep() {
    echo -e "  ${COLOR_DIM}${BULLET}${NC} $1"
}

# ── Header & Section Functions ───────────────────────────────────────────────

print_header() {
    local title="$1"
    local width=60
    local padding=$(( (width - ${#title}) / 2 ))
    
    echo ""
    echo -e "${COLOR_HEADER}╔$(printf '═%.0s' $(seq 1 $width))╗${NC}"
    echo -e "${COLOR_HEADER}║$(printf ' %.0s' $(seq 1 $padding))${BOLD}${title}$(printf ' %.0s' $(seq 1 $((width - padding - ${#title}))))║${NC}"
    echo -e "${COLOR_HEADER}╚$(printf '═%.0s' $(seq 1 $width))╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${COLOR_HEADER}── $1 ──${NC}"
}

# ── User Prompts ─────────────────────────────────────────────────────────────

# Ask yes/no question with default
# Usage: confirm "Question?" [y|n]
confirm() {
    local prompt="$1"
    local default="${2:-y}"
    local yn_hint

    if [[ "$default" == "y" ]]; then
        yn_hint="[Y/n]"
    else
        yn_hint="[y/N]"
    fi

    while true; do
        echo -en "${COLOR_PROMPT}?${NC} ${prompt} ${yn_hint} "
        read -r response
        response="${response:-$default}"
        
        case "${response,,}" in
            y|yes) return 0 ;;
            n|no)  return 1 ;;
            *)     echo "Please answer yes or no." ;;
        esac
    done
}

# Ask for text input with optional default
# Usage: ask "Prompt" [default_value]
ask() {
    local prompt="$1"
    local default="$2"
    local hint=""

    [[ -n "$default" ]] && hint=" (${default})"

    local response
    read -rp "${COLOR_PROMPT}?${NC} ${prompt}${hint}: " response
    echo "${response:-$default}"
}

# Select from options
# Usage: select_option "Prompt" "option1" "option2" "option3"
select_option() {
    local prompt="$1"
    shift
    local options=("$@")
    local selected=0
    
    echo -e "${COLOR_PROMPT}?${NC} ${prompt}"
    
    for i in "${!options[@]}"; do
        echo -e "  ${BOLD}$((i+1)))${NC} ${options[$i]}"
    done
    
    while true; do
        echo -en "  Enter choice [1-${#options[@]}]: "
        read -r choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
            echo "${options[$((choice-1))]}"
            return 0
        fi
        echo "  Invalid choice. Please enter a number between 1 and ${#options[@]}."
    done
}

# ── Package Management ───────────────────────────────────────────────────────

# Check if a package is installed
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# Check if command exists
cmd_exists() {
    command -v "$1" &>/dev/null
}

# Install packages with pacman (handles arrays)
install_pacman() {
    local packages=("$@")
    local to_install=()
    
    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log_substep "${pkg} already installed"
        fi
    done
    
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing: ${to_install[*]}"
        sudo pacman -S --noconfirm --needed "${to_install[@]}"
    fi
}

# Install packages with AUR helper
install_aur() {
    local aur_helper="${AUR_HELPER:-yay}"
    local packages=("$@")
    local to_install=()
    
    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log_substep "${pkg} already installed"
        fi
    done
    
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing from AUR: ${to_install[*]}"
        "$aur_helper" -S --noconfirm --needed "${to_install[@]}"
    fi
}

# ── File Operations ──────────────────────────────────────────────────────────

# Backup a file or directory
backup_file() {
    local source="$1"
    local backup_dir="${BACKUP_DIR:-$HOME/.config/hypr-backup}"
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    
    if [[ -e "$source" ]]; then
        mkdir -p "$backup_dir"
        local basename
        basename=$(basename "$source")
        cp -r "$source" "$backup_dir/${basename}.${timestamp}.bak"
        log_substep "Backed up: $source"
    fi
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Backup existing file if it's not a symlink to source
    if [[ -e "$target" && ! -L "$target" ]]; then
        backup_file "$target"
        rm -rf "$target"
    elif [[ -L "$target" ]]; then
        rm "$target"
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    ln -sf "$source" "$target"
    log_substep "Linked: $target → $source"
}

# ── System Checks ────────────────────────────────────────────────────────────

# Check if running as root
is_root() {
    [[ $EUID -eq 0 ]]
}

# Check internet connectivity
has_internet() {
    ping -c 1 archlinux.org &>/dev/null
}

# Check if running on Arch Linux
is_arch() {
    [[ -f /etc/arch-release ]]
}

# Get GPU vendor
get_gpu_vendor() {
    if lspci | grep -i "nvidia" &>/dev/null; then
        echo "nvidia"
    elif lspci | grep -i "amd" &>/dev/null; then
        echo "amd"
    elif lspci | grep -i "intel" &>/dev/null; then
        echo "intel"
    else
        echo "unknown"
    fi
}

# ── Service Management ───────────────────────────────────────────────────────

enable_service() {
    local service="$1"
    if systemctl list-unit-files | grep -q "^${service}"; then
        sudo systemctl enable "$service"
        log_substep "Enabled: $service"
    else
        log_warning "Service not found: $service"
    fi
}

start_service() {
    local service="$1"
    sudo systemctl start "$service"
}

# ── Spinner/Progress ─────────────────────────────────────────────────────────

spinner() {
    local pid=$1
    local message="${2:-Processing...}"
    local spinchars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    
    while kill -0 "$pid" 2>/dev/null; do
        for (( i=0; i<${#spinchars}; i++ )); do
            echo -en "\r${COLOR_INFO}${spinchars:$i:1}${NC} $message"
            sleep 0.1
        done
    done
    echo -en "\r"
}

# Run command with spinner
run_with_spinner() {
    local message="$1"
    shift
    
    "$@" &>/dev/null &
    local pid=$!
    spinner $pid "$message"
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        log_success "$message"
    else
        log_error "$message failed"
    fi
    
    return $exit_code
}
