#!/bin/bash
# Sends a shortcut to the focused window, remapping the SUPER/ALT-based binding
# to its CTRL equivalent whenever the focused window is not kitty.
#
# NOTE: `hyprctl dispatch` takes Lua now that the config is Lua -- the old
# `hyprctl dispatch sendshortcut MODS,KEY,` form no longer parses.

set -euo pipefail

original_key="$1"

focused_class=$(hyprctl activewindow -j | jq -r '.class')

if [[ "$focused_class" != "kitty" ]]; then
    # Not in terminal - convert to CTRL equivalent
    case "$original_key" in
        "SUPER,C,") target_key="CTRL,C," ;;
        "SUPER,V,") target_key="CTRL,V," ;;
        "SUPER,X,") target_key="CTRL,X," ;;
        "SUPER,K,") target_key="CTRL,K," ;;
        "SUPER,Z,") target_key="CTRL,Z," ;;
        "SUPER,A,") target_key="CTRL,A," ;;
        "SUPER,F,") target_key="CTRL,F," ;;
        "SUPER,R,") target_key="CTRL,R," ;;
        "ALT_SHIFT,Left,") target_key="CTRL_SHIFT,Left," ;;
        "ALT_SHIFT,Right,") target_key="CTRL_SHIFT,Right," ;;
        "ALT,Left,") target_key="CTRL,Left," ;;
        "ALT,Right,") target_key="CTRL,Right," ;;
        "ALT,BackSpace,") target_key="CTRL,BackSpace," ;;
        "ALT,Delete,") target_key="CTRL,Delete," ;;
        *) target_key="$original_key" ;;
    esac
else
    # In terminal - send original shortcut
    target_key="$original_key"
fi

# "CTRL_SHIFT,Left," -> mods="CTRL SHIFT", key="Left"
mods="${target_key%%,*}"
rest="${target_key#*,}"
key="${rest%%,*}"
mods="${mods//_/ }"

hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"${mods}\", key = \"${key}\" })"
