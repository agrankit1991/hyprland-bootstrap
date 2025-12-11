#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         Terminal Colors & Formatting                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Reset
export NC='\033[0m'           # No Color / Reset

# Regular Colors
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'

# Bold Colors
export BOLD='\033[1m'
export BOLD_RED='\033[1;31m'
export BOLD_GREEN='\033[1;32m'
export BOLD_YELLOW='\033[1;33m'
export BOLD_BLUE='\033[1;34m'
export BOLD_PURPLE='\033[1;35m'
export BOLD_CYAN='\033[1;36m'
export BOLD_WHITE='\033[1;37m'

# Dim Colors
export DIM='\033[2m'

# Underline
export UNDERLINE='\033[4m'

# ── Semantic Colors ──────────────────────────────────────────────────────────
export COLOR_SUCCESS="${GREEN}"
export COLOR_ERROR="${RED}"
export COLOR_WARNING="${YELLOW}"
export COLOR_INFO="${CYAN}"
export COLOR_PROMPT="${PURPLE}"
export COLOR_HEADER="${BOLD_BLUE}"
export COLOR_DIM="${DIM}"

# ── Unicode Symbols ──────────────────────────────────────────────────────────
export CHECKMARK="✓"
export CROSSMARK="✗"
export ARROW="→"
export BULLET="•"
export STAR="★"
export WARNING_SIGN="⚠"
export INFO_SIGN="ℹ"
