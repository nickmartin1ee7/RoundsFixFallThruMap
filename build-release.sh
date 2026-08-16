#!/usr/bin/env bash
set -euo pipefail

# build-release.sh
# Build a Release DLL for RoundsFixFallThruMap and produce a zip for deployment.
# Usage:
#   ./build-release.sh --rounds /path/to/ROUNDS      # build against real install
#   ./build-release.sh --stubs                      # build using local stubs (dev only)
#   ./build-release.sh                              # tries to auto-detect common install paths

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
PROJECT_SLN="$REPO_ROOT/RoundsFixFallThruMap.slnx"
PROJECT_DLL_REL="RoundsFixFallThruMap/RoundsFixFallThruMap/bin/Release/netstandard2.1/RoundsFixFallThruMap.dll"
ARTIFACTS_DIR="$REPO_ROOT/artifacts"

# CLI args
ROUNDS_FOLDER=""
USE_STUBS=false

usage() {
  cat <<EOF
Usage: $0 [--rounds /path/to/ROUNDS] [--stubs]

Options:
  --rounds PATH   Path to ROUNDS install (overrides auto-detection)
  --stubs         Build with local API stubs (developer convenience; not for release)
  -h, --help      Show this help
EOF
  exit 1
}

# parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --rounds)
      ROUNDS_FOLDER="$2"; shift 2;;
    --stubs)
      USE_STUBS=true; shift;;
    -h|--help)
      usage;;
    *)
      echo "Unknown arg: $1"; usage;;
  esac
done

# auto-detect common locations if not provided
if [[ -z "$ROUNDS_FOLDER" && "$USE_STUBS" = false ]]; then
  for p in \
    "$HOME/.local/share/Steam/steamapps/common/ROUNDS" \
    "$HOME/.steam/steam/steamapps/common/ROUNDS" \
    "$HOME/.config/r2modmanPlus-local/ROUNDS/profiles/TOP" \
    "/mnt/c/Steam/steamapps/common/ROUNDS" \
    "C:/Steam/steamapps/common/ROUNDS" \
    "C:/Program Files (x86)/Steam/steamapps/common/ROUNDS" \
    "C:/Program Files/Steam/steamapps/common/ROUNDS"; do
    if [[ -d "$p" && -f "$p/Rounds.exe" ]]; then
      ROUNDS_FOLDER="$p"
      break
    fi
  done
fi

if [[ "$USE_STUBS" = true ]]; then
  echo "Building with local stubs (AllowLocalStubs=true). Not for release."
  DOTNET_ARGS=("-p:AllowLocalStubs=true")
else
  if [[ -z "$ROUNDS_FOLDER" ]]; then
    echo "ERROR: ROUNDS install not detected. Provide --rounds /path/to/ROUNDS or use --stubs for local builds." >&2
    exit 2
  fi
  echo "Detected ROUNDS folder: $ROUNDS_FOLDER"
  DOTNET_ARGS=("-p:RoundsFolder=$ROUNDS_FOLDER")
fi

# ensure artifacts dir
mkdir -p "$ARTIFACTS_DIR"

# clean and build
echo "Cleaning..."
dotnet clean "$PROJECT_SLN" -c Release >/dev/null

echo "Building Release..."
dotnet build "$PROJECT_SLN" -c Release "${DOTNET_ARGS[@]}"

# copy result
DLL_SRC="$REPO_ROOT/$PROJECT_DLL_REL"
if [[ ! -f "$DLL_SRC" ]]; then
  echo "ERROR: expected build output not found: $DLL_SRC" >&2
  exit 3
fi

TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)
OUT_NAME="RoundsFixFallThruMap-${TIMESTAMP}.zip"
TMP_DIR=$(mktemp -d)
cp "$DLL_SRC" "$TMP_DIR/"
cp "$REPO_ROOT/README.md" "$TMP_DIR/"

pushd "$TMP_DIR" >/dev/null
zip -r "$ARTIFACTS_DIR/$OUT_NAME" . >/dev/null
popd >/dev/null
rm -rf "$TMP_DIR"

echo "Created artifact: $ARTIFACTS_DIR/$OUT_NAME"

# list artifacts
ls -lh "$ARTIFACTS_DIR" | sed -n '1,200p'

exit 0
