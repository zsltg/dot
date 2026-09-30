# AGENTS.md
Telegraph style, every line binds. Root rules and policies only.
## Project
Dotfiles and tool installs for Linux (Ubuntu) and macOS, managed with chezmoi. One command bootstraps a new machine: configs, CLI tools with man pages and zsh completions, runtimes, fonts, terminal.
## Tech Stack
- chezmoi: source state in `home/` (see `.chezmoiroot`). Templates `*.tmpl`, one-time prompts in `home/.chezmoi.toml.tmpl` (name, email, groups `dev`, `ai`, `docker`, detected `vm`).
- Homebrew on both OSes: CLI tools, latest versions, man pages, completions. Casks on macOS only.
- mise: node, ruby, go, and tools Homebrew lacks or ships badly (`cargo:`, `go:`, `npm:`, `ubi:`, `pipx:`). Shims on PATH, no `mise activate`.
- rustup: Rust toolchain. apt: system deps, docker-ce, Alacritty build deps (Linux).
- zsh: antidote loads selected Oh My Zsh libs and plugins, zsh-autosuggestions, zsh-syntax-highlighting (`home/dot_zsh_plugins.txt`). No OMZ framework. starship prompt, zoxide, native fzf.
- Theme: one palette everywhere (Alacritty, tmux, nvim, bat, delta, eza, zsh-autosuggestions, herdr, mc). Default Solarized dark. Option `selenized` (Selenized with Solarized dark background): set `theme` in `~/.config/chezmoi/chezmoi.toml` data. Font: SauceCodePro Nerd Font Mono.
## Layout
- `home/.chezmoidata/packages.yaml`: single source of truth for installed tools, per group and per OS. Brewfile and mise config render from it.
- `home/.chezmoidata/palette.yaml`: single source of truth for colors and tool theme names, per palette. Every template renders for each palette.
- `home/.chezmoiscripts/`: install scripts, run in number order. `run_onchange_` reruns when rendered content changes, hash inputs in a comment line.
- `home/.chezmoitemplates/`: shared template snippets (`brew-env`, `groups`).
- `home/private_dot_config/zsh/*.zsh`: interactive modules, sourced by `dot_zshrc`. `path.zsh` sourced by `.zshenv` and `.zprofile` only.
- `home/.lazy-lock.json`: nvim plugin lock. `~/.config/nvim/lazy-lock.json` symlinks to it, so `:Lazy update` shows as a repo diff.
## Commands
- Preview: `chezmoi diff`. Apply: `chezmoi apply`. Render one template: `chezmoi execute-template < <file>`.
- Render for the other OS: `chezmoi --override-data '{"chezmoi":{"os":"darwin","arch":"arm64"}}' execute-template < <file>`.
- Lint rendered scripts for both OSes: `shellcheck -S warning` on every rendered `.chezmoiscripts/*` output. Syntax: `bash -n` scripts, `zsh -n` zsh files.
- Secrets: `gitleaks dir .`. Pre-commit hook: `git config core.hooksPath .githooks` (runs `gitleaks git --staged`).
- End-to-end: clean `ubuntu:24.04` container, non-root user with passwordless sudo, preset `~/.config/chezmoi/chezmoi.toml` data, `chezmoi init --source <repo> --apply --no-tty`. Second `chezmoi apply` must be a no-op. Docker builds need `--network host` on this host.
- Startup budget: `zsh -i -c exit` near 100 ms. Profile with `zmodload zsh/zprof` before regressing it.
## Conventions
- Add or remove a tool: edit `packages.yaml` only. Prefer brew formula. Use mise when brew lacks it, lags upstream, or drags heavy deps (llvm, apache-arrow). Record the reason as a comment next to the entry.
- Latest versions by default. Install man pages and zsh completions for every tool, user completions to `~/.local/share/zsh/site-functions`.
- Every template renders on linux and darwin, amd64 and arm64. Guard OS-specific parts with `.chezmoi.os` and `.chezmoi.arch`, OS-specific files via `home/.chezmoiignore.tmpl`.
- Access optional data keys with `index`, not dot access (templates run with `missingkey=error`).
- Scripts: `#!/bin/bash`, `set -euo pipefail`, idempotent, safe to rerun. Network steps tolerate transient failure (retry or skip with a message).
- Shell init: guard each tool with `(( $+commands[x] ))`. No subshell or network call per prompt.
- Comments and docs in Simplified Technical English.
- Simplest mechanism that fits: no plugin managers beyond antidote, no extra frameworks.
## Boundaries
Never:
- Commit secrets, tokens, API keys, private keys, `~/.ssh`, `~/.gnupg`, `gh` hosts, app state or telemetry IDs. Secrets live in untracked `~/.zshenv.local` and `~/.zshrc.local`.
- Track machine-specific files (for example `scripts/cleanup-legacy-linux.sh`, excluded via `.git/info/exclude`).
- Run `chezmoi apply` against the real home without showing `chezmoi diff` first.
- Hardcode `/home/<user>` paths. Use `$HOME` or template data.

Only when asked:
- Commit or push. Add a new tool group or prompt. Remove a tool.
## Source Control & Commits
- Conventional Commits: `<type>(<scope>): <description>`, lowercase imperative. Types feat, fix, docs, style, refactor, perf, test, build, ci, chore. Scope is the area: `zsh`, `nvim`, `alacritty`, `tmux`, `git`, `packages`, `scripts`, `mise`.
- One atomic change per commit, no unrelated changes bundled.
- Agent-authored commits end with a `Co-Authored-By:` trailer.
- Before commit: templates render for both OSes, shellcheck clean, `gitleaks` clean.
