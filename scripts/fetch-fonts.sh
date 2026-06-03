#!/usr/bin/env bash
set -euo pipefail
DEST="theme/galaxy/login/resources/fonts"
BASE="https://cdn.jsdelivr.net/npm/@fontsource/atkinson-hyperlegible/files"
mkdir -p "$DEST"

fetch_if_missing() {
  local out="$1"
  local src="$2"
  if [[ ! -f "$DEST/$out" ]]; then
    echo "Fetching $out"
    curl -fsSL "$BASE/$src" -o "$DEST/$out"
  fi
}

fetch_if_missing "atkinson-hyperlegible-400.woff2" "atkinson-hyperlegible-latin-400-normal.woff2"
fetch_if_missing "atkinson-hyperlegible-700.woff2" "atkinson-hyperlegible-latin-700-normal.woff2"

echo "Fonts ready in $DEST"
