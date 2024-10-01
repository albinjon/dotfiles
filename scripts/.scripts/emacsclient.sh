#!/bin/bash

EMACS_CLIENT="/opt/homebrew/bin/emacsclient"
SOCKET_NAME="gui-emacs"

# Function to run Emacs client without blocking
run_emacs_client() {
    if [ $# -eq 0 ]; then
        nohup $EMACS_CLIENT --socket-name=$SOCKET_NAME $1 >/dev/null 2>&1 &
    else
        echo "Running emacs client with args: $@" >> /tmp/aerospace.log
        nohup $EMACS_CLIENT --socket-name=$SOCKET_NAME "$@" >/dev/null 2>&1 &
    fi
}

# Check if there's a visible frame
if $EMACS_CLIENT --socket-name=$SOCKET_NAME -e '(> (length (visible-frame-list)) 0)' 2>/dev/null | grep -q 't'; then
    # Visible frame exists, use --reuse-frame
    run_emacs_client "--reuse-frame" $@
else
    # No visible frame, create a new one
    run_emacs_client '--create-frame --alternate-editor=""' $@
fi

echo "Emacs client started" >> /tmp/aerospace.log
find_and_focus_emacs() {
    emacs_id=$(/opt/homebrew/bin/aerospace list-windows --workspace focused | grep Emacs | awk '{print $1}')
    echo "Emacs ID: $emacs_id" >> /tmp/aerospace.log
    if [ -n "$emacs_id" ]; then
        echo "Found Emacs window with ID: $emacs_id" >> /tmp/aerospace.log
        /opt/homebrew/bin/aerospace focus --window-id "$emacs_id"
        return 0
    fi
    return 1
}

end_count=50

while [ $end_count -gt 0 ]; do
    if find_and_focus_emacs; then
        echo "Found Emacs window" >> /tmp/aerospace.log
        exit 0
    fi
    end_count=$((end_count - 1))
    echo "Waiting for Emacs window to appear" >> /tmp/aerospace.log
    sleep 0.05
done

echo "Failed to find Emacs window" >> /tmp/aerospace.log
