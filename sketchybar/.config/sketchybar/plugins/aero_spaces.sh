#!/bin/sh

debug_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> /tmp/sketchybar_workspace_debug.log
}

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
        *) echo "";; # Default icon for any other workspace
    esac
}

update_workspaces() {
debug_log "Updating workspaces. Sender: $SENDER"
    
    output=$(aerospace list-workspaces --all)
    debug_log "Raw output from 'aerospace list-workspaces --all': $output"
    
    IFS=$'\n' read -d '' -r -a ALL_SPACES <<< "$output"
    debug_log "Parsed ALL_SPACES: ${ALL_SPACES[*]}"
    
    ACTIVE_SPACE=$(aerospace list-workspaces --focused)
    debug_log "Raw output from 'aerospace list-workspaces --focused': $ACTIVE_SPACE"

    if [ -z "$ACTIVE_SPACE" ]; then
        debug_log "Failed to get active space"
        return
    fi

    for space in "${ALL_SPACES[@]}"; do
        icon=$(get_icon "$space")
        if [ "$space" = "$ACTIVE_SPACE" ]; then
            debug_log "Setting active space $space with icon $icon"
            sketchybar --set space.$space icon="$icon" background.drawing=on
        else
            debug_log "Setting inactive space $space with icon $icon"
            sketchybar --set space.$space icon="$icon" background.drawing=off
        fi
    done
    debug_log "Workspace update completed"
}

debug_log "Script started. SENDER: $SENDER, NAME: $NAME"

case "$SENDER" in
    "aerospace_workspace_change") 
        debug_log "Received aerospace_workspace_change event"
        update_workspaces
        ;;
    *)
        debug_log "Unknown SENDER: $SENDER"
        ;;
esac

debug_log "Script ended"
