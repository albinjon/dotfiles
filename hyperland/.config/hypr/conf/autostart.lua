-- -----------------------------------------------------
-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- -----------------------------------------------------

local scripts = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.on("hyprland.start", function()
    -- Environment for xdg-desktop-portal-hyprland / screen sharing
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd(scripts .. "/xdg.sh")

    -- Polkit
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("lxqt-policykit-agent")

    -- Notifications, idle/lock, clipboard history
    hl.exec_cmd("dunst")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Appearance
    hl.exec_cmd(scripts .. "/gtk.sh")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/waybar/launch.sh")
    hl.exec_cmd("xrdb " .. os.getenv("HOME") .. "/.Xresources")
    -- Was duplicated in both cursor.conf and autostart.conf; runs once now.
    hl.exec_cmd("hyprctl setcursor Qogir-dark 24")

    -- Tray applets
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")

    -- Dump installed Arch packages into the dotfiles repo for version control
    hl.exec_cmd(scripts .. "/dump-installed.sh")
end)
