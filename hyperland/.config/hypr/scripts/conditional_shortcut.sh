#!/bin/bash

original_key="$1"

focused_class=$(hyprctl activewindow -j | jq -r '.class')

if [[ "$focused_class" != "org.wezfurlong.wezterm" ]]; then
    # Not in terminal - convert to CTRL equivalent
    case "$original_key" in
        "SUPER,C,") modified_key="CTRL,C," ;;
        "SUPER,V,") modified_key="CTRL,V," ;;
        "SUPER,X,") modified_key="CTRL,X," ;;
        "SUPER,Z,") modified_key="CTRL,Z," ;;
        "SUPER,A,") modified_key="CTRL,A," ;;
        "SUPER,F,") modified_key="CTRL,F," ;;
        "ALT_SHIFT,Left,") modified_key="CTRL_SHIFT,Left," ;;
        "ALT_SHIFT,Right,") modified_key="CTRL_SHIFT,Right," ;;
        "ALT,Left,") modified_key="CTRL,Left," ;;
        "ALT,Right,") modified_key="CTRL,Right," ;;
        "ALT,BackSpace,") modified_key="CTRL,BackSpace," ;;
        "ALT,Delete,") modified_key="CTRL,Delete," ;;
        *) modified_key="$original_key" ;;
    esac
    hyprctl dispatch sendshortcut $modified_key
else
    # In terminal - send original shortcut
    hyprctl dispatch sendshortcut $original_key
fi

