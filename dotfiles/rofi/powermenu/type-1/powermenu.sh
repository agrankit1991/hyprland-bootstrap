#!/usr/bin/env bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                              Rofi Power Menu                               ║
# ╚════════════════════════════════════════════════════════════════════════════╝
#
# Power menu with logout, reboot, shutdown options
# This is a placeholder script - will be replaced during rofi theme installation
#

# Menu options
logout="󰍃  Logout"
reboot="  Reboot"
shutdown="⏻  Shutdown"
lock="  Lock"
suspend="󰒲  Suspend"

# Show menu
chosen=$(echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown" | \
    rofi -dmenu \
        -i \
        -p "Power Menu" \
        -theme-str '
        * {
            font: "JetBrains Mono Nerd Font 12";
            background: rgba(30, 30, 46, 0.9);
            foreground: #cdd6f4;
            accent: #89b4fa;
        }
        window {
            width: 300px;
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
            lines: 5;
            spacing: 5px;
        }
        element {
            border-radius: 5px;
            padding: 10px;
        }
        element selected {
            background-color: @accent;
            text-color: #1e1e2e;
        }
        ')

# Execute chosen option
case $chosen in
    "$lock")
        hyprlock
        ;;
    "$logout")
        hyprctl dispatch exit
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac