# OpenCode + Windows Playwright CLI

OpenCode runs in WSL. Browser automation runs through the globally installed
Windows `@playwright/cli` package and the Playwright Extension in a manually
opened Windows Chrome.

The WSL wrapper resolves the npm-generated Windows `playwright-cli.ps1` through
PowerShell on first use and caches only its path. It does not install Node,
Playwright, or browsers in WSL.

## Install

From the repository, run:

```bash
./opencode/install.sh
```

The installer creates a timestamped backup of an existing
`~/.config/opencode/opencode.jsonc`, then installs:

- the WSL wrapper as `~/.local/bin/playwright-cli`;
- the skill as `~/.agents/skills/playwright-cli/SKILL.md`;
- the candidate config as `~/.config/opencode/opencode.jsonc`.

`~/.local/bin` must be present in the `PATH` inherited by OpenCode.

## Manual smoke test

Open Windows Chrome manually and confirm that the Playwright Extension is
enabled. Then run from WSL:

```bash
command -v playwright-cli
playwright-cli --version
playwright-cli -s=windows-chrome attach --extension=chrome
playwright-cli -s=windows-chrome snapshot
playwright-cli -s=windows-chrome detach
```

On the first call, the wrapper expects this Windows command to resolve:

```powershell
(Get-Command playwright-cli.ps1 -ErrorAction Stop).Source
```

After upgrading or moving the global npm installation, refresh the cached path:

```bash
PLAYWRIGHT_CLI_REFRESH=1 playwright-cli --version
```

## OpenCode verification

Restart OpenCode and begin a fresh session. Ask it to inspect a known page in
the manually opened Chrome without naming the implementation. Verify that it:

1. loads the `playwright-cli` skill;
2. executes real `playwright-cli` Bash commands;
3. attaches through the extension instead of launching another browser;
4. snapshots the page and verifies the requested result;
5. detaches without closing Chrome.

The legacy `windows-chrome` MCP entry remains in `opencode.jsonc` with
`enabled: false` for rollback. Re-enable it only if the CLI smoke test fails.

Add `.playwright-cli/` to each project `.gitignore` if browser artifacts should
never be committed.
