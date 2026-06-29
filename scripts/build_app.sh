#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT/build"
DIST_DIR="$ROOT/dist"
APP_NAME="Prompt Favorite"
APP_DIR="$DIST_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
BUNDLE_ID="${PROMPT_FAVORITE_BUNDLE_ID:-local.promptfavorite.app}"
VERSION="${PROMPT_FAVORITE_VERSION:-0.1.0}"
BUILD_NUMBER="${PROMPT_FAVORITE_BUILD:-1}"
APP_CATEGORY="${PROMPT_FAVORITE_APP_CATEGORY:-public.app-category.productivity}"
ENTITLEMENTS="${PROMPT_FAVORITE_ENTITLEMENTS:-}"
PROVISIONING_PROFILE="${PROMPT_FAVORITE_PROVISIONING_PROFILE:-}"

if [ "${PROMPT_FAVORITE_APP_STORE:-0}" = "1" ] && [ -z "$ENTITLEMENTS" ]; then
  ENTITLEMENTS="$ROOT/Config/AppStore.entitlements"
fi

rm -rf "$BUILD_DIR" "$APP_DIR"
mkdir -p "$BUILD_DIR" "$MACOS_DIR" "$RESOURCES_DIR"

swiftc \
  -O \
  -framework Cocoa \
  -framework ApplicationServices \
  -framework ServiceManagement \
  "$ROOT/Sources/PromptFavoriteApp/main.swift" \
  -o "$MACOS_DIR/$APP_NAME"

if [ ! -f "$ROOT/assets/PromptFavorite.icns" ] || [ "$ROOT/scripts/generate_app_icon.swift" -nt "$ROOT/assets/PromptFavorite.icns" ]; then
  swift "$ROOT/scripts/generate_app_icon.swift" "$ROOT/assets" >/dev/null
  iconutil -c icns "$ROOT/assets/PromptFavorite.iconset" -o "$ROOT/assets/PromptFavorite.icns"
fi
cp "$ROOT/assets/PromptFavorite.icns" "$RESOURCES_DIR/PromptFavorite.icns"

if [ -n "$PROVISIONING_PROFILE" ]; then
  cp "$PROVISIONING_PROFILE" "$CONTENTS_DIR/embedded.provisionprofile"
fi

cat > "$CONTENTS_DIR/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>Prompt Favorite</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleIconFile</key>
  <string>PromptFavorite</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>Prompt Favorite</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>$VERSION</string>
  <key>CFBundleVersion</key>
  <string>$BUILD_NUMBER</string>
  <key>LSApplicationCategoryType</key>
  <string>$APP_CATEGORY</string>
  <key>LSMinimumSystemVersion</key>
  <string>13.0</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSDocumentsFolderUsageDescription</key>
  <string>Prompt Favorite saves Markdown prompt collections to the folder you choose.</string>
  <key>NSHumanReadableCopyright</key>
  <string>Copyright © 2026</string>
</dict>
</plist>
PLIST

if [ "${PROMPT_FAVORITE_SKIP_CODESIGN:-0}" != "1" ]; then
  SIGN_IDENTITY="${PROMPT_FAVORITE_CODESIGN_IDENTITY:-}"
  if [ -z "$SIGN_IDENTITY" ]; then
    DEFAULT_IDENTITY="Prompt Favorite Local Codesign"
    if security find-identity -v -p codesigning | awk -v name="$DEFAULT_IDENTITY" 'index($0, "\"" name "\"") { found = 1 } END { exit found ? 0 : 1 }'; then
      SIGN_IDENTITY="$DEFAULT_IDENTITY"
    else
      SIGN_IDENTITY="-"
      {
        echo "warning: using ad-hoc signing because no stable code-signing identity was found."
        echo "warning: run scripts/setup_local_codesign.sh to avoid stale macOS Accessibility permissions after rebuilds."
      } >&2
    fi
  fi
  CODESIGN_ARGS=(--force --deep --sign "$SIGN_IDENTITY")
  if [ -n "$ENTITLEMENTS" ]; then
    CODESIGN_ARGS+=(--entitlements "$ENTITLEMENTS")
  fi
  codesign "${CODESIGN_ARGS[@]}" "$APP_DIR" >/dev/null
fi

echo "$APP_DIR"
