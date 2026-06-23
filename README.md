# Prompt Favorite

English | [中文](./README.zh-CN.md)

Save selected text from any macOS app into a clean local Markdown prompt collection.

<p align="center">
  <img src="./assets/prompt-favorite-preview.svg" alt="Prompt Favorite preview" width="920">
</p>

<p align="center">
  <img alt="macOS" src="https://img.shields.io/badge/macOS-13%2B-111827?style=flat-square">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-AppKit-f97316?style=flat-square">
  <img alt="Markdown" src="https://img.shields.io/badge/storage-Markdown-2563eb?style=flat-square">
  <img alt="Obsidian friendly" src="https://img.shields.io/badge/Obsidian-friendly-7c3aed?style=flat-square">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-16a34a?style=flat-square">
</p>

Prompt Favorite is a tiny macOS menu bar app for collecting reusable prompts while you work. Select text in Chrome, Terminal, Codex, ChatGPT, Claude, Obsidian, or almost any other app, trigger Prompt Favorite, review the capture, and append it to a Markdown collection file.

The target folder is just a local folder. It can be a standalone prompt vault, an Obsidian vault folder, a synced directory, or any place you already manage Markdown notes.

## Highlights

- **Global capture**: capture selected text outside the app with Double Option or a standard shortcut.
- **Clipboard-safe**: temporarily copies the selection, then restores your previous clipboard content.
- **Review or quick save**: either confirm the title, folder, file, and body before saving, or append immediately.
- **Collection files**: append many prompt entries to one Markdown file instead of creating a new note every time.
- **Folder picker**: choose the target folder through macOS, no path typing required.
- **Bilingual UI**: English and Chinese, with Follow System as the default and manual language selection in the menu.
- **Obsidian-friendly**: every collection is a normal `.md` file with frontmatter and readable headings.

## Install

Clone and install the app locally:

```bash
git clone https://github.com/QQQingyu/prompt-favorite.git
cd prompt-favorite
./scripts/setup_local_codesign.sh
./scripts/install_app.sh
open "$HOME/Applications/Prompt Favorite.app"
```

The default install location is:

```text
~/Applications/Prompt Favorite.app
```

You can install somewhere else:

```bash
./scripts/install_app.sh /Applications
```

## First Run

Prompt Favorite needs macOS Accessibility permission because global capture works by sending a temporary `Cmd+C` to the frontmost app.

1. Start the app.
2. Click the menu bar icon.
3. Run **Check Capture Permission** to see the current app path and trust status.
4. Open **Accessibility Settings**.
5. Enable **Prompt Favorite**.
6. Quit and reopen Prompt Favorite.

If the permission is enabled but capture still fails, remove Prompt Favorite from **System Settings -> Privacy & Security -> Accessibility**, add the current installed app again, then reopen it:

```text
~/Applications/Prompt Favorite.app
```

For local development, run `./scripts/setup_local_codesign.sh` once before repeated rebuilds. Without a stable local signing identity, macOS may keep a stale Accessibility record after the app is rebuilt or replaced.

## Usage

1. Select text in any app.
2. Press the global trigger. The default is **Double Option**.
3. Review the title, target folder, collection file, and prompt body.
4. Save.

Prompt Favorite appends the entry to:

```text
<Target folder>/<Collection file>.md
```

The default target is:

```text
~/Documents/Prompt Favorite/Favorites.md
```

You can point the target folder to any Obsidian vault folder, for example:

```text
~/Documents/Obsidian Vault/Prompt Favorite
```

## Menu Options

- **Capture Selected Text**: manually run one capture.
- **Choose Target Folder...**: set the default save folder with a directory picker.
- **Save Format Settings...**: configure collection file, heading template, timestamp format, separator, and code fence language.
- **Global Trigger**: choose Double Option, Command + Option + P, Command + Shift + P, or Off.
- **Capture Behavior**: choose Review Before Save or Quick Save.
- **Language**: choose Follow System, Chinese, or English.
- **Launch at Startup**: start Prompt Favorite automatically when macOS starts.
- **Open Target Folder**: open the current prompt collection folder.
- **Check Capture Permission**: show whether the current installed app passes the macOS Accessibility trust check.
- **Open Accessibility Settings**: jump to macOS permission settings.

## Markdown Format

New collection files start with frontmatter:

````markdown
---
title: "Favorites"
tags:
  - prompt-collection
folder: "/Users/you/Documents/Prompt Favorite"
created: 2026-06-22T09:30:00Z
updated: 2026-06-22T09:35:00Z
---
````

Each saved prompt is appended as a structured entry:

````markdown
---

## 2026-06-22 17:35:00 - PRD Review

```prompt
Review this PRD and only point out blocking logic issues.
```
````

The entry heading template supports:

```text
{{time}}
{{title}}
```

## Development

Build the app:

```bash
./scripts/build_app.sh
```

Create a stable local code-signing identity for development builds:

```bash
./scripts/setup_local_codesign.sh
```

Run the Markdown write self-test:

```bash
"dist/Prompt Favorite.app/Contents/MacOS/Prompt Favorite" --self-test "$PWD/tmp-self-test"
```

Check the current app's Accessibility trust status:

```bash
"$HOME/Applications/Prompt Favorite.app/Contents/MacOS/Prompt Favorite" --check-accessibility
```

Install the current build:

```bash
./scripts/install_app.sh
```

The app is built with `swiftc`, Cocoa, and ApplicationServices. No package manager is required.

## Current Limits

- Global capture depends on macOS Accessibility permission.
- Capture is most reliable for normal selectable text that responds to `Cmd+C`.
- The collection file is a file name under the target folder; nested paths are intentionally stripped.

## License

MIT
