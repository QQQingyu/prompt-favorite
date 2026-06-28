# App Store Release Guide

This guide tracks the Mac App Store release path for Prompt Favorite.

## Current Release Risk

Prompt Favorite is a menu bar utility that captures selected text from other apps. The Mac App Store build uses App Sandbox and security-scoped bookmarks for user-selected folders. The main review risk is the global capture flow: it asks for Accessibility permission and temporarily sends `Cmd+C` to the frontmost app.

Keep the App Review notes plain:

```text
Prompt Favorite is a menu bar utility that saves user-selected text into local Markdown files. Global capture uses Accessibility permission to send a temporary Copy command to the frontmost app, then restores the previous clipboard contents. The app does not collect, upload, or share captured text.
```

## What The App Store Build Adds

- App Sandbox entitlements.
- User-selected folder read/write entitlement.
- App-scoped security-scoped bookmarks for persistent access to the selected target folder.
- Configurable bundle identifier, version, build number, and App Store category.
- App icon resources and a 1024px marketing icon.
- Optional embedded provisioning profile support.
- A command-line package script for App Store upload packages.

## What You Need

1. An active Apple Developer Program membership.
2. Full Xcode installed from the Mac App Store or Apple Developer Downloads.
3. A unique bundle id, for example:

```text
com.qqqingyu.promptfavorite
```

4. An App Store Connect app record using the same bundle id.
5. App distribution and installer signing identities installed in Keychain.
6. A Mac App Store provisioning profile for the bundle id, if signing manually.

## Local Preflight

```bash
./scripts/build_app.sh
"dist/Prompt Favorite.app/Contents/MacOS/Prompt Favorite" --self-test "$PWD/tmp-self-test"
codesign --verify --deep --strict --verbose=4 "dist/Prompt Favorite.app"
```

## Build A Sandbox Candidate

```bash
PROMPT_FAVORITE_APP_STORE=1 \
PROMPT_FAVORITE_BUNDLE_ID="com.qqqingyu.promptfavorite" \
./scripts/build_app.sh

codesign --display --entitlements :- "dist/Prompt Favorite.app"
```

The entitlements output should include:

```xml
<key>com.apple.security.app-sandbox</key>
<true/>
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
<key>com.apple.security.files.bookmarks.app-scope</key>
<true/>
```

## Build A Signed Upload Package

After Apple signing assets are installed:

```bash
PROMPT_FAVORITE_BUNDLE_ID="com.qqqingyu.promptfavorite" \
PROMPT_FAVORITE_VERSION="1.0.0" \
PROMPT_FAVORITE_BUILD="1" \
PROMPT_FAVORITE_APP_SIGN_IDENTITY="Apple Distribution: Your Name (TEAMID)" \
PROMPT_FAVORITE_INSTALLER_IDENTITY="Mac Installer Distribution: Your Name (TEAMID)" \
PROMPT_FAVORITE_PROVISIONING_PROFILE="/path/to/profile.provisionprofile" \
./scripts/build_app_store_pkg.sh
```

The script prints the `.pkg` path under `dist/`.

## Upload

Use Transporter or Xcode Organizer to upload the package to App Store Connect.

If Transporter is installed, upload the generated `.pkg`, then wait for App Store Connect processing to finish before filling metadata and submitting for review.

## App Store Connect Metadata

Suggested defaults:

- Name: `Prompt Favorite`
- Subtitle: `Save selected text to Markdown`
- Category: `Productivity`
- Privacy: no data collected, if the app remains fully local and does not add telemetry.
- Review notes: use the Accessibility explanation from the top of this guide.

Screenshots should show:

- Menu bar menu.
- Save Prompt review window.
- Save Format Settings window.
- Resulting Markdown file in Finder or Obsidian.
