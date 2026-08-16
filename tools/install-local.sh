#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DLL="$SCRIPT_DIR/RoundsFixFallThruMap/bin/Release/netstandard2.1/RoundsFixFallThruMap.dll"
PLUGIN_NAME="RoundsFixFallThruMap.dll"

usage() {
  cat <<EOF
Usage: $0 --plugins /path/to/BepInEx/plugins

Copies the current Release DLL into a local BepInEx plugins directory.
EOF
  exit 1
}

if [[ $# -ne 2 || "$1" != "--plugins" ]]; then
  usage
fi

if [[ ! -f "$SOURCE_DLL" ]]; then
  echo "ERROR: Release DLL not found. Run ./build-release.sh first." >&2
  exit 2
fi

mkdir -p "$2"
cp "$SOURCE_DLL" "$2/$PLUGIN_NAME"
echo "Installed: $2/$PLUGIN_NAME"
