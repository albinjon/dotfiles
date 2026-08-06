#!/bin/bash
# Renders the keybinding cheatsheet from Hyprland's live bind list.
#
# This used to text-scrape conf/keybinding.conf; that file is gone since the
# move to Lua. Descriptions now come from the `description` flag set on each
# bind in conf/binds.lua.

set -euo pipefail

render() {
    python3 - <<'PY'
import html, json, subprocess, sys

MODS = [(64, "SUPER"), (4, "CTRL"), (1, "SHIFT"), (8, "ALT")]

binds = json.loads(subprocess.run(
    ["hyprctl", "binds", "-j"], capture_output=True, text=True, check=True).stdout)

rows = []
for b in binds:
    mods = "+".join(name for bit, name in MODS if b["modmask"] & bit)
    key = b["key"] or "code:{}".format(b["keycode"])
    combo = "{}+{}".format(mods, key) if mods else key

    # rofi runs with -markup, so anything unescaped would be parsed as Pango.
    label = b["description"] or "{} {}".format(b["dispatcher"], b["arg"]).strip()
    rows.append((combo, html.escape(label)))

width = max((len(c) for c, _ in rows), default=0)
for combo, label in rows:
    print("{}  -  {}".format(combo.ljust(width), label))
PY
}

sleep 0.2
render | rofi -theme ~/.config/rofi/launchers/type-1/style-11.rasi \
    -dmenu -i -markup -eh 2 -replace -p "Keybinds"
