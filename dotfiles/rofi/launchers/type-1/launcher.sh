#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           Rofi Application Launcher                        ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Simple application launcher using rofi
# This is a placeholder script - will be replaced during rofi theme installation
#

# Launch rofi in drun mode (desktop applications)
rofi -show drun \
    -modi drun \
    -display-drun "Applications" \
    -drun-display-format "{name}" \
    -no-drun-show-actions \
    -terminal kitty \
    -kb-cancel "Escape,Alt+F4" \
    -theme-str '
    * {
        font: "JetBrains Mono Nerd Font 12";
        background: rgba(30, 30, 46, 0.9);
        foreground: #cdd6f4;
        accent: #89b4fa;
    }
    window {
        width: 600px;
        border: 2px;
        border-color: @accent;
        border-radius: 10px;
        padding: 20px;
    }
    inputbar {
        border: 1px;
        border-color: @accent;
        border-radius: 5px;
        padding: 8px 16px;
        margin: 0px 0px 20px 0px;
    }
    listview {
        lines: 10;
        spacing: 5px;
    }
    element {
        border-radius: 5px;
        padding: 8px;
    }
    element selected {
        background-color: @accent;
        text-color: #1e1e2e;
    }
    '