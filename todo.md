# 1. The Auth Agent (The Bouncer) - To ask for Root/Sudo password
exec-once = /usr/lib/hyprpolkitagent

# 2. The Secret Service (The Safe) - To store App passwords
exec-once = gnome-keyring-daemon --start --components=secrets