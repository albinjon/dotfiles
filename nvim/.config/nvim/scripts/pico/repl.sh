#!/usr/bin/env bash

set -euo pipefail
: "${PORT:=auto}"
uvx mpremote connect "$PORT" repl
