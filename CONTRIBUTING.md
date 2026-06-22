# Contributing

Thanks for improving Prompt Favorite.

## Local Development

Build the app:

```bash
./scripts/build_app.sh
```

Install the local build:

```bash
./scripts/install_app.sh
open "$HOME/Applications/Prompt Favorite.app"
```

Run the Markdown write self-test:

```bash
"dist/Prompt Favorite.app/Contents/MacOS/Prompt Favorite" --self-test "$PWD/tmp-self-test"
```

## Pull Requests

Keep changes focused and include a short note about manual verification. For capture-related changes, test at least one external app and one Markdown write.
