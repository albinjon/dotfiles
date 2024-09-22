#!/bin/sh

get_icon() {
    case "$1" in
        1) echo "";;
        2) echo "";;
        3) echo "󰒱";;
        4) echo "";;
        5) echo "";;
        6) echo "";;
        7) echo "";;
        8) echo "󰶍";;
        9) echo "󰆼";;
        A) echo "";;
        B) echo "";;
        *) echo "";;
    esac
}

update_workspaces() {
    output=$(aerospace list-workspaces --all)
    IFS=$'\n' read -d '' -r -a ALL_SPACES <<< "$output"
    ACTIVE_SPACE=$(aerospace list-workspaces --focused)
    if [ -z "$ACTIVE_SPACE" ]; then
        return
    fi

    for space in "${ALL_SPACES[@]}"; do
        icon=$(get_icon "$space")
        if [ "$space" = "$ACTIVE_SPACE" ]; then
            sketchybar --set space.$space icon="$icon" background.drawing=on
        else
            sketchybar --set space.$space icon="$icon" background.drawing=off
        fi
    done
}

# TODO: Find out how to take the workspace info from the event, there is info:
# https://nikitabobko.github.io/AeroSpace/guide#exec-on-workspace-change-callback
case "$SENDER" in
    "aerospace_workspace_change") 
        update_workspaces
        ;;
    *)
        ;;
esac

