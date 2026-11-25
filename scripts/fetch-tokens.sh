#!/usr/bin/env bash
set -euo pipefail
VERSION="0.1.0"
DEST="theme/galaxy/login/resources/css"
URL="https://cdn.jsdelivr.net/npm/@galaxyproject/brand-tokens@${VERSION}/dist/tokens.css"
mkdir -p "$DEST"
echo "Fetching brand tokens.css @ ${VERSION}"
curl -fsSL "$URL" -o "$DEST/tokens.css"
echo "tokens.css ready in $DEST"
