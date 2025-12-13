
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        Hyprland Bootstrap Installer                      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# This script runs the full installation process in order:
#   1. Preflight checks
#   2. Package installation
#   3. System configuration
#   4. Login setup
#   5. Postflight configuration
#

set -e

# Set SCRIPT_DIR to the directory of this script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

# Export SCRIPT_DIR for all sub-scripts
export SCRIPT_DIR

# Helper for pretty output
print_section() {
	echo -e "\n\033[1;36m==> $1\033[0m\n"
}

# 1. Preflight Checks
print_section "[1/5] Running Preflight Checks"
"$SCRIPT_DIR/install/preflight/all.sh"

# 2. Package Installation
print_section "[2/5] Installing Packages"
"$SCRIPT_DIR/install/packaging/all.sh"

# 3. System Configuration
print_section "[3/5] Running System Configuration"
"$SCRIPT_DIR/install/config/all.sh"

# 4. Login Setup
print_section "[4/5] Running Login Setup"
"$SCRIPT_DIR/install/login/all.sh"

# 5. Postflight Configuration
print_section "[5/5] Running Postflight Configuration"
"$SCRIPT_DIR/install/postflight/all.sh"

echo -e "\n\033[1;32mHyprland Bootstrap Installation Complete!\033[0m\n"
