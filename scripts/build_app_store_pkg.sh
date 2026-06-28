#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${PROMPT_FAVORITE_VERSION:-0.1.0}"
BUILD_NUMBER="${PROMPT_FAVORITE_BUILD:-1}"
BUNDLE_ID="${PROMPT_FAVORITE_BUNDLE_ID:-}"
APP_SIGN_IDENTITY="${PROMPT_FAVORITE_APP_SIGN_IDENTITY:-${PROMPT_FAVORITE_CODESIGN_IDENTITY:-}}"
INSTALLER_SIGN_IDENTITY="${PROMPT_FAVORITE_INSTALLER_IDENTITY:-}"
PKG_PATH="$ROOT/dist/PromptFavorite-${VERSION}-${BUILD_NUMBER}.pkg"

if [ -z "$BUNDLE_ID" ]; then
  echo "error: set PROMPT_FAVORITE_BUNDLE_ID, for example com.example.promptfavorite" >&2
  exit 1
fi

if [ -z "$APP_SIGN_IDENTITY" ]; then
  echo "error: set PROMPT_FAVORITE_APP_SIGN_IDENTITY to your Apple app distribution signing identity." >&2
  echo "available signing identities:" >&2
  security find-identity -v -p codesigning >&2 || true
  exit 1
fi

if [ -z "$INSTALLER_SIGN_IDENTITY" ]; then
  echo "error: set PROMPT_FAVORITE_INSTALLER_IDENTITY to your Mac installer distribution signing identity." >&2
  echo "available signing identities:" >&2
  security find-identity -v -p codesigning >&2 || true
  exit 1
fi

PROMPT_FAVORITE_APP_STORE=1 \
PROMPT_FAVORITE_BUNDLE_ID="$BUNDLE_ID" \
PROMPT_FAVORITE_CODESIGN_IDENTITY="$APP_SIGN_IDENTITY" \
PROMPT_FAVORITE_VERSION="$VERSION" \
PROMPT_FAVORITE_BUILD="$BUILD_NUMBER" \
"$ROOT/scripts/build_app.sh" >/dev/null

productbuild \
  --component "$ROOT/dist/Prompt Favorite.app" /Applications \
  --sign "$INSTALLER_SIGN_IDENTITY" \
  "$PKG_PATH" >/dev/null

pkgutil --check-signature "$PKG_PATH" >/dev/null
echo "$PKG_PATH"
