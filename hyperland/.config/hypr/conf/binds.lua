-- -----------------------------------------------------
-- Key bindings
-- https://wiki.hypr.land/Configuring/Basics/Binds/
--
-- Descriptions are attached to each bind so that scripts/keybindings.sh can
-- render the cheatsheet straight from `hyprctl binds -j`, instead of
-- text-scraping this file.
--
-- Bind order is preserved from the old keybinding.conf, including the two
-- pre-existing duplicate bindings flagged inline below.
-- -----------------------------------------------------

local mainMod = "SUPER"
local move    = "SUPER + CTRL"
local hyper   = "SUPER + CTRL + SHIFT + ALT"

local home    = os.getenv("HOME")
local scripts = home .. "/.config/hypr/scripts"

-- Helper: the conditional_shortcut.sh binds all follow the same shape.
local function conditional(key, arg)
    hl.bind(mainMod .. " + " .. key,
        hl.dsp.exec_cmd(scripts .. '/conditional_shortcut.sh "' .. arg .. '"'),
        { description = "Conditional shortcut: " .. arg })
end

-- -----------------------------------------------------
-- Applications
-- -----------------------------------------------------

hl.bind(hyper .. " + T", hl.dsp.exec_cmd("kitty"),                       { description = "Terminal" })
hl.bind(hyper .. " + M", hl.dsp.exec_cmd("uwsm app -- spotify-launcher"), { description = "Spotify" })
hl.bind(hyper .. " + E", hl.dsp.exec_cmd("thunar"),                      { description = "File explorer" })
hl.bind(hyper .. " + Z", hl.dsp.exec_cmd("zen-browser"),                 { description = "Browser" })
hl.bind(hyper .. " + P", hl.dsp.exec_cmd("1password"),                   { description = "1Password" })

-- NOTE: duplicate of the HYPER+B bind further down (waybar launch.sh).
-- Preserved in original order so behaviour is unchanged; pick one to fix.
hl.bind(hyper .. " + B", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"),     { description = "Reload waybar" })

-- -----------------------------------------------------
-- Windows
-- -----------------------------------------------------

hl.bind(move .. " + Q", hl.dsp.window.close(),                            { description = "Kill active window" })
hl.bind(move .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }),  { description = "Toggle fullscreen" })

hl.bind(move .. " + H", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind(move .. " + L", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind(move .. " + K", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind(move .. " + J", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

hl.bind(move .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window right" })
hl.bind(move .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window left" })
hl.bind(move .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind(move .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

-- -----------------------------------------------------
-- Context-dependent shortcuts
-- -----------------------------------------------------

conditional("C", "SUPER,C,")
conditional("V", "SUPER,V,")
conditional("X", "SUPER,X,") -- NOTE: duplicate of the SUPER+X wlogout bind below.
conditional("K", "SUPER,K,")
conditional("Z", "SUPER,Z,")
conditional("A", "SUPER,A,")
conditional("F", "SUPER,F,")
conditional("R", "SUPER,R,")

for _, b in ipairs({
    { "ALT + left",          "ALT,Left," },
    { "ALT + right",         "ALT,Right," },
    { "ALT + SHIFT + left",  "ALT_SHIFT,Left," },
    { "ALT + SHIFT + right", "ALT_SHIFT,Right," },
    { "ALT + BackSpace",     "ALT,BackSpace," },
    { "ALT + Delete",        "ALT,Delete," },
}) do
    hl.bind(b[1], hl.dsp.exec_cmd(scripts .. '/conditional_shortcut.sh "' .. b[2] .. '"'),
        { repeating = true, description = "Conditional shortcut: " .. b[2] })
end

-- -----------------------------------------------------
-- Wallpapers
-- -----------------------------------------------------

for i, wallpaper in ipairs({ "background.jpg", "background2.jpg", "background3.png" }) do
    hl.bind(hyper .. " + " .. i,
        hl.dsp.exec_cmd(string.format('hyprctl hyprpaper wallpaper "DP-1,%s/Pictures/%s"', home, wallpaper)),
        { description = "Wallpaper " .. i })
end

-- -----------------------------------------------------
-- Actions
-- -----------------------------------------------------

hl.bind(move .. " + ALT + 4",  hl.dsp.exec_cmd(scripts .. "/screenshot.sh"),        { description = "Screenshot" })
hl.bind(mainMod .. " + X",     hl.dsp.exec_cmd("wlogout"),                          { description = "Logout menu" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("tofi-drun --drun-launch=true"),     { description = "App launcher" })
hl.bind(hyper .. " + R",       hl.dsp.exec_cmd('tofi-run | xargs -r sh -c'),        { description = "Run command" })
hl.bind(hyper .. " + K",       hl.dsp.exec_cmd(scripts .. "/keybindings.sh"),       { description = "Show keybindings" })
hl.bind(hyper .. " + B",       hl.dsp.exec_cmd(home .. "/.config/waybar/launch.sh"), { description = "Restart waybar" })
hl.bind(hyper .. " + C",       hl.dsp.exec_cmd(scripts .. "/loadconfig.sh"),        { description = "Reload Hyprland config" })

-- -----------------------------------------------------
-- Workspaces
-- -----------------------------------------------------

for i = 1, 9 do
    hl.bind(move .. " + " .. i,           hl.dsp.focus({ workspace = i }),       { description = "Workspace " .. i })
    hl.bind(move .. " + SHIFT + " .. i,   hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

-- Irregulars: P opens workspace 10, 0 opens workspace 11.
hl.bind(move .. " + P", hl.dsp.focus({ workspace = 10 }),        { description = "Workspace 10" })
hl.bind(move .. " + 0", hl.dsp.focus({ workspace = 11 }),        { description = "Workspace 11" })
hl.bind(move .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }), { description = "Move window to workspace 10" })

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(move .. " + down",          hl.dsp.focus({ workspace = "empty" }), { description = "Next empty workspace" })

-- -----------------------------------------------------
-- Media / function keys
-- -----------------------------------------------------

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -q s +5%"),                     { repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 5%-"),                     { repeating = true, description = "Brightness down" })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),   { repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),   { repeating = true, description = "Volume down" })

hl.bind(hyper .. " + V",     hl.dsp.exec_cmd("kitty --class=Wiremix -e wiremix -v output"),     { description = "Audio mixer" })
hl.bind("XF86AudioMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { description = "Toggle mute" })
hl.bind("XF86AudioPlay",     hl.dsp.exec_cmd("playerctl play-pause"),                           { description = "Play/pause" })
hl.bind("XF86AudioPause",    hl.dsp.exec_cmd("playerctl pause"),                                { description = "Pause" })
hl.bind("XF86AudioNext",     hl.dsp.exec_cmd("playerctl next"),                                 { description = "Next track" })
hl.bind("XF86AudioPrev",     hl.dsp.exec_cmd("playerctl previous"),                             { description = "Previous track" })
hl.bind("XF86AudioMicMute",  hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),  { description = "Toggle microphone" })
hl.bind("XF86Calculator",    hl.dsp.exec_cmd("qalculate-gtk"),                                  { description = "Calculator" })
-- NOTE: the old config bound "XF86Lock", which is not a real keysym -- hyprlang
-- accepted the string but the bind could never fire. XF86ScreenSaver is the
-- actual lock key. Remove this line if your keyboard has no such key.
hl.bind("XF86ScreenSaver",   hl.dsp.exec_cmd("hyprlock"),                                       { description = "Lock screen" })
hl.bind(hyper .. " + L",     hl.dsp.exec_cmd("hyprlock"),                                       { description = "Lock screen" })
