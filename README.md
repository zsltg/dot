# dot

Dotfiles and tool installs for Linux (Ubuntu) and macOS, managed with [chezmoi](https://www.chezmoi.io/).

## Install on a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply <github-user>/dot
```

chezmoi asks these questions once. It keeps the answers in `~/.config/chezmoi/chezmoi.toml`.

| Prompt | What it does |
|---|---|
| `name`, `email` | Git author in `~/.gitconfig`. |
| `dev` | Installs the dev tools: linters, cargo tools, pnpm, bun, deno, gh, lazygit, act, ruff, oha. |
| `ai` | Installs claude-code, codex, pi, herdr and crit. |
| `docker` | Installs docker-ce from the Docker apt repo on Linux, or colima and the docker CLI on macOS. |

To change an answer, edit `~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

On macOS, the first run can stop and ask you to install the Xcode Command Line Tools. Install them, then run `chezmoi apply` again.

## What installs what

- **Homebrew** installs the CLI tools on Linux and macOS. It installs their man pages and zsh completions too.
- **mise** installs node, ruby and go, and the tools that Homebrew does not have (`cargo:`, `go:`, `npm:`, `ubi:`, `pipx:` backends).
- **rustup** installs Rust.
- **antidote** loads the zsh plugins in `~/.zsh_plugins.txt`. These are some Oh My Zsh libraries and plugins, zsh-autosuggestions and zsh-syntax-highlighting.
- **Alacritty** comes from a Homebrew cask on macOS. On Linux, a script builds the latest release and installs its terminfo, desktop entry, man pages and completion.
- **SauceCodePro Nerd Font Mono** comes from a Homebrew cask on macOS. On Linux, chezmoi downloads it to `~/.local/share/fonts`.

The package list is in `home/.chezmoidata/packages.yaml`. Add or remove a tool there, then run `chezmoi apply`. The install script runs again when the list changes.

## Update

```sh
chezmoi update       # pull this repo and apply it
brew upgrade         # CLI tools
mise upgrade         # runtimes and mise tools
rustup update
antidote update      # zsh plugins
```

The Alacritty script runs on each `chezmoi apply` and builds only when a new release exists.

## Machine-specific settings and secrets

Do not put secrets in this repo. Put them in these files, which the repo does not contain:

- `~/.zshenv.local`: environment variables and API keys.
- `~/.zshrc.local`: interactive shell settings for one machine.

Enable the gitleaks pre-commit hook once per clone:

```sh
git config core.hooksPath .githooks
```

## Repo layout

- `home/`: the chezmoi source state (see `.chezmoiroot`).
- `home/.chezmoiscripts/`: install scripts, in the order of their numbers.
- `home/.lazy-lock.json`: the plugin versions for Neovim. `~/.config/nvim/lazy-lock.json` is a symlink to this file, so `:Lazy update` changes it in the repo. Commit the change.
