#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         Git Configuration                                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Configures Git with sensible defaults and optional user customization.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/install/defaults.sh"

# ── Configuration Functions ──────────────────────────────────────────────────

configure_git_identity() {
    log_step "Configuring Git identity..."
    
    local name="${GIT_NAME}"
    local email="${GIT_EMAIL}"
    
    # Always ask for name and email if not provided via environment variables
    if [[ -z "${name}" ]]; then
        name=$(ask "Git user name")
    fi
    
    if [[ -z "${email}" ]]; then
        email=$(ask "Git user email")
    fi
    
    git config --global user.name "$name"
    git config --global user.email "$email"
    
    log_substep "Name: $name"
    log_substep "Email: $email"
}

configure_git_defaults() {
    log_step "Configuring Git defaults..."
    
    # Default branch
    git config --global init.defaultBranch "$GIT_DEFAULT_BRANCH"
    log_substep "Default branch: $GIT_DEFAULT_BRANCH"
    
    # Editor
    git config --global core.editor "$EDITOR"
    log_substep "Editor: $EDITOR"
    
    # Line endings for Linux
    git config --global core.autocrlf input
    log_substep "Line endings: input (Linux)"
    
    # Colorized output
    git config --global color.ui true
    log_substep "Color UI: enabled"
    
    # Pull behavior - use rebase
    git config --global pull.rebase true
    log_substep "Pull behavior: rebase"
}

configure_git_aliases() {
    log_step "Configuring Git aliases..."
    
    # Common operations
    git config --global alias.st "status"
    git config --global alias.co "checkout"
    git config --global alias.br "branch"
    git config --global alias.ci "commit"
    git config --global alias.unstage "reset HEAD --"
    git config --global alias.last "log -1 HEAD"
    
    # Useful log formats
    git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
    git config --global alias.lp "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
    
    log_substep "Common aliases configured (st, co, br, ci, lg, lp)"
}

configure_global_gitignore() {
    log_step "Configuring global .gitignore..."
    
    mkdir -p ~/.config/git
    cp "$SCRIPT_DIR/config/.gitignore" ~/.config/git/ignore
    git config --global core.excludesfile ~/.config/git/ignore
    log_substep "Created ~/.config/git/ignore"
}

configure_commit_template() {
    log_step "Configuring commit message template..."
    
    mkdir -p ~/.config/git
    cp "$SCRIPT_DIR/config/.gitmessage" ~/.config/git/message
    git config --global commit.template ~/.config/git/message
    log_substep "Created ~/.config/git/message"
}

setup_ssh_key() {
    log_step "Setting up SSH key for GitHub..."
    
    local ssh_key="$HOME/.ssh/id_ed25519"
    
    # Check if key already exists
    if [[ -f "$ssh_key" ]]; then
        log_warning "SSH key already exists at $ssh_key"
        if ! confirm "Generate a new SSH key? (existing key will be backed up)"; then
            log_substep "Skipping SSH key generation"
            return
        fi
        # Backup existing key
        mv "$ssh_key" "${ssh_key}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "${ssh_key}.pub" "${ssh_key}.pub.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Generate SSH key
    local email="${GIT_EMAIL}"
    if [[ -z "${email}" ]]; then
        email=$(git config --global user.email)
    fi
    ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N ""
    
    # Start ssh-agent and add key
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add "$ssh_key" 2>/dev/null
    
    # Create SSH config
    mkdir -p ~/.ssh
    if ! grep -q "Host github.com" ~/.ssh/config 2>/dev/null; then
        cat >> ~/.ssh/config << EOL

Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOL
        log_substep "Updated ~/.ssh/config"
    fi
    
    # Display public key
    echo ""
    log_info "Your SSH public key:"
    echo -e "${COLOR_DIM}$(cat ${ssh_key}.pub)${NC}"
    echo ""
    log_info "Add this key to your GitHub account:"
    log_info "https://github.com/settings/ssh/new"
    echo ""
    
    if cmd_exists wl-copy; then
        wl-copy < "${ssh_key}.pub"
        log_success "Public key copied to clipboard!"
    fi
}

verify_git_config() {
    log_step "Verifying Git configuration..."
    
    log_substep "User: $(git config user.name) <$(git config user.email)>"
    log_substep "Default branch: $(git config init.defaultBranch)"
    log_substep "Editor: $(git config core.editor)"
}

# ── Main Configuration ───────────────────────────────────────────────────────

configure_git() {
    print_header "Git Configuration"
    
    configure_git_identity
    configure_git_defaults
    configure_git_aliases
    configure_global_gitignore
    configure_commit_template
    
    if [[ "${INSTALL_MODE}" == "interactive" ]]; then
        if confirm "Set up SSH key for GitHub?"; then
            setup_ssh_key
        fi
    fi
    
    verify_git_config
    
    echo ""
    log_success "Git configuration complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    configure_git
fi
