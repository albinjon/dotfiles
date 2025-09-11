#!/usr/bin/env bash
set -euo pipefail
: "${PORT:=auto}"
ROOT="$(cd "$(dirname "$0")" && pwd)"

# Optional: compile modules to .mpy (keeps main.py readable in logs)
if command -v mpy-cross >/dev/null 2>&1; then
  find "$ROOT/src" -name '*.py' ! -name 'main.py' -print0 \
    | xargs -0 -I{} sh -c 'mpy-cross -O2 "{}" && mv "{}c" "$(dirname "{}")/$(basename "{}" .py).mpy"'
fi

uvx mpremote connect "$PORT" fs rmdir :/src || true
uvx mpremote connect "$PORT" fs mkdir :/src || true
uvx mpremote connect "$PORT" fs cp -r "$ROOT/src" :
uvx mpremote connect "$PORT" reset
