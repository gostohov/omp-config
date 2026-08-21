---
name: playwright-cli
description: Automate the manually opened authenticated Windows Chrome from OpenCode in WSL through the Windows @playwright/cli package and Playwright Extension. Use for browser navigation, UI checks, snapshots, screenshots, form interaction, console inspection, and network diagnostics.
license: Apache-2.0
compatibility: OpenCode in WSL with Windows Playwright CLI and Playwright Extension
metadata:
  upstream: https://github.com/microsoft/playwright-cli
  runtime: windows
---

# Windows Playwright CLI

## Environment contract

- `playwright-cli` is already a WSL wrapper around the globally installed
  Windows `@playwright/cli` package.
- Never install Playwright, Node.js, npm packages, browsers, or system
  dependencies from WSL.
- Never replace `playwright-cli` with `npx`, `npm exec`, or a Linux package.
- The user opens Windows Chrome manually and enables the Playwright Extension.
- Work through the named session `windows-chrome`.
- Use relative paths for screenshots, snapshots, uploads, storage state, config,
  and scripts. Do not pass absolute WSL paths to the Windows process.

## Start and finish

Attach before the first browser action:

```bash
playwright-cli -s=windows-chrome attach --extension=chrome
```

If Chrome or the extension is unavailable, report that prerequisite and stop.
Do not launch another browser or run `install-browser` as a fallback.

Reuse the same session for every subsequent call:

```bash
playwright-cli -s=windows-chrome snapshot
playwright-cli -s=windows-chrome goto https://example.com
```

When browser work is complete, detach without closing the user's browser:

```bash
playwright-cli -s=windows-chrome detach
```

Never use `close-all`, `kill-all`, or `delete-data` unless the user explicitly
requests that destructive session operation.

## Interaction workflow

1. Attach to `windows-chrome`.
2. Capture a snapshot and use element refs from that snapshot.
3. Perform the requested action in the same turn; do not merely describe it.
4. Capture another snapshot or inspect the relevant output to verify the result.
5. Detach when no further browser work remains.

Common commands:

```bash
playwright-cli -s=windows-chrome snapshot
playwright-cli -s=windows-chrome find "Sign in"
playwright-cli -s=windows-chrome click e15
playwright-cli -s=windows-chrome fill e7 "value"
playwright-cli -s=windows-chrome press Enter
playwright-cli -s=windows-chrome tab-list
playwright-cli -s=windows-chrome console error
playwright-cli -s=windows-chrome requests
playwright-cli -s=windows-chrome screenshot --filename=browser-result.png
```

Run `playwright-cli --help` or `playwright-cli <command> --help` when a command
is not covered here. Do not infer flags.

## Safety

- Treat authenticated browser contents, cookies, storage state, request headers,
  and screenshots as sensitive corporate data.
- Ask before `run-code`, uploads, drops, storage export, or data deletion.
- Do not expose extension tokens, authorization headers, cookies, or credentials
  in chat, logs, committed files, or command arguments.
- Prefer snapshots over screenshots for interaction. Save screenshots only when
  visual evidence is useful.
