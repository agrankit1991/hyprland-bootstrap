#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                   Set Wireless Regulatory Domain (regdom)                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Sets the wireless regulatory domain based on system timezone or config.
#

set -e

# Source required files
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"

set_wireless_regdom() {
    log_step "Setting wireless regulatory domain..."
    
    # Check for existing config
    if [ -f "/etc/conf.d/wireless-regdom" ]; then
        unset WIRELESS_REGDOM
        . /etc/conf.d/wireless-regdom
    fi

    # If already set, nothing to do
    if [ ! -n "${WIRELESS_REGDOM}" ]; then
        # Get current timezone
        if [ -e "/etc/localtime" ]; then
            TIMEZONE=$(readlink -f /etc/localtime)
            TIMEZONE=${TIMEZONE#/usr/share/zoneinfo/}

            COUNTRY="${TIMEZONE%%/*}"

            # If not a two-letter country code, get from zone.tab
            if [[ ! "$COUNTRY" =~ ^[A-Z]{2}$ ]] && [ -f "/usr/share/zoneinfo/zone.tab" ]; then
                COUNTRY=$(awk -v tz="$TIMEZONE" '$3 == tz {print $1; exit}' /usr/share/zoneinfo/zone.tab)
            fi

            # If valid country code, set it
            if [[ "$COUNTRY" =~ ^[A-Z]{2}$ ]]; then
                echo "WIRELESS_REGDOM=\"$COUNTRY\"" | sudo tee -a /etc/conf.d/wireless-regdom >/dev/null
                log_substep "Set WIRELESS_REGDOM to $COUNTRY in /etc/conf.d/wireless-regdom"

                if command -v iw &>/dev/null; then
                    sudo iw reg set ${COUNTRY}
                    log_substep "iw reg set ${COUNTRY}"
                fi
            fi
        fi
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set_wireless_regdom
fi
