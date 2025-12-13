# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        User Config Copy Script                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Copies the config directory and its subdirectories to ~/.config
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

copy_user_configs() {
	log_step "Copying configs to ~/.config..."
	local SRC_DIR="$SCRIPT_DIR/config"
	local DEST_DIR="$HOME/.config"
	mkdir -p "$DEST_DIR"
	cp -R "$SRC_DIR/*" "$DEST_DIR/"
	log_success "Config copy complete."
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	copy_user_configs
fi


