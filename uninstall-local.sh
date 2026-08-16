#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="RoundsFixFallThruMap.dll"

usage() {
  cat <<EOF
Usage: $0 --plugins /path/to/BepInEx/plugins

Removes this mod's DLL from a local BepInEx plugins directory.
EOF
  exit 1
}

if [[ $# -ne 2 || "$1" != "--plugins" ]]; then
  usage
fi

PLUGIN_PATH="$2/$PLUGIN_NAME"
if [[ ! -e "$PLUGIN_PATH" ]]; then
  echo "Not installed: $PLUGIN_PATH"
  exit 0
fi

rm "$PLUGIN_PATH"
echo "Removed: $PLUGIN_PATH"
