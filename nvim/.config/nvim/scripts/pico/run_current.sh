#!/usr/bin/env bash

set -euo pipefail
: "${PORT:=auto}"  # e.g. /dev/ttyACM0 if you prefer explicit
FILE="${1:-}"; [ -z "$FILE" ] && { echo "Usage: pico_run_current.sh <file.py>"; exit 1; }
uvx mpremote connect "$PORT" run "$FILE"
