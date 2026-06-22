#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_DIR="${1:-$HOME/Applications}"
APP_NAME="Prompt Favorite.app"

"$ROOT/scripts/build_app.sh" >/dev/null

mkdir -p "$INSTALL_DIR"
rm -rf "$INSTALL_DIR/$APP_NAME"
cp -R "$ROOT/dist/$APP_NAME" "$INSTALL_DIR/$APP_NAME"

echo "$INSTALL_DIR/$APP_NAME"
