#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install_home="${OPENCODE_PLAYWRIGHT_HOME:-${HOME}}"
config_root="${OPENCODE_PLAYWRIGHT_CONFIG_HOME:-${XDG_CONFIG_HOME:-${install_home}/.config}}"
config_dir="${config_root}/opencode"
bin_dir="${install_home}/.local/bin"
skill_dir="${install_home}/.agents/skills/playwright-cli"

mkdir -p "${config_dir}" "${bin_dir}" "${skill_dir}"

if [[ -f "${config_dir}/opencode.jsonc" ]]; then
  backup_file="${config_dir}/opencode.jsonc.bak-playwright-cli-$(date +%Y%m%d-%H%M%S)"
  cp -p "${config_dir}/opencode.jsonc" "${backup_file}"
  printf 'Backed up OpenCode config to %s\n' "${backup_file}"
fi

install -m 755 "${script_dir}/bin/playwright-cli" "${bin_dir}/playwright-cli"
install -m 644 \
  "${script_dir}/skills/playwright-cli/SKILL.md" \
  "${skill_dir}/SKILL.md"
install -m 600 "${script_dir}/opencode.jsonc" "${config_dir}/opencode.jsonc"

printf '%s\n' 'Installed OpenCode config, playwright-cli wrapper, and skill.'
printf '%s\n' 'Restart OpenCode and run the smoke test from opencode/README.md.'
