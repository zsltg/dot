#!/bin/bash
# Install the dotfiles from this repo on a new machine, then examine the result.
# CI runs this script (.github/workflows/install.yml). Run it only on a machine
# that you can discard: it installs Homebrew, runtimes and tools, and it changes
# the login shell.
#
# Usage: scripts/install-test.sh full|minimal
#   full:    install the dev and ai groups. Install the docker group on Linux only.
#   minimal: install the core tools only.
#
# Run it as a non-root user with passwordless sudo. Set GITHUB_TOKEN, because
# the mise "github:" backend uses the GitHub API, and the rate limit without a
# token is low.
#
# The script fails when:
# - the first "chezmoi apply" fails,
# - a second "chezmoi apply" has changes to make, other than the run_after_
#   scripts that run on each apply,
# - a brew package or a mise tool of the enabled groups is not installed,
# - zsh or nvim writes to stderr on startup,
# - the zsh startup takes more than ZSH_STARTUP_LIMIT_MS (default 400).
set -euo pipefail

groups="${1:?usage: $0 full|minimal}"
case "$groups" in
full) dev=true ai=true docker=true ;;
minimal) dev=false ai=false docker=false ;;
*) echo "usage: $0 full|minimal" >&2; exit 2 ;;
esac
# colima cannot start on a CI runner, because the runner has no nested
# virtualization.
[ "$(uname -s)" = Darwin ] && docker=false

src="$(cd "$(dirname "$0")/.." && pwd)"
bin="$HOME/.local/bin"
export PATH="$bin:$PATH"
export TERM=xterm-256color

echo "==> install chezmoi"
mkdir -p "$bin"
sh -c "$(curl -fsLS --retry 3 get.chezmoi.io)" -- -b "$bin"

echo "==> preset the prompt answers"
mkdir -p "$HOME/.config/chezmoi"
cat >"$HOME/.config/chezmoi/chezmoi.toml" <<EOF
[data]
    name = "CI"
    email = "ci@example.com"
    dev = $dev
    ai = $ai
    docker = $docker
EOF

echo "==> first apply"
start=$SECONDS
chezmoi init --source "$src" --apply --no-tty
echo "first apply: $((SECONDS - start)) s"

echo "==> second apply is a no-op"
changes="$(chezmoi status | grep -vE ' \.chezmoiscripts/(15-dysk-docs|60-alacritty)\.sh$' || true)"
if [ -n "$changes" ]; then
  echo "chezmoi has changes to make after the first apply:" >&2
  echo "$changes" >&2
  chezmoi diff --exclude=scripts >&2
  exit 1
fi
start=$SECONDS
chezmoi apply --no-tty
echo "second apply: $((SECONDS - start)) s"

# Run the checks in a clean environment, so that the runner's tools and PATH
# do not hide a missing tool. PATH is the system default, as after a login.
clean=(env -i HOME="$HOME" USER="$USER" LOGNAME="$USER" TERM="$TERM" LANG=C.UTF-8
  PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin GITHUB_TOKEN="${GITHUB_TOKEN:-}")

echo "==> brew packages are installed"
chezmoi execute-template <"$src/home/.chezmoiscripts/run_onchange_after_10-brew.sh.tmpl" \
  | sed -n "/<<'BREWFILE'/,/^BREWFILE\$/{//!p;}" >"$HOME/Brewfile.test"
"${clean[@]}" zsh -lc 'brew bundle check --verbose --no-upgrade --file="$HOME/Brewfile.test"'
rm "$HOME/Brewfile.test"

echo "==> alacritty is installed"
"${clean[@]}" zsh -lc 'alacritty --version'

echo "==> mise tools are installed"
missing="$("${clean[@]}" zsh -lc 'mise ls --missing')"
if [ -n "$missing" ]; then
  echo "mise tools are missing:" >&2
  echo "$missing" >&2
  exit 1
fi

# Set the array ptycmd to a command that runs "$@" in a pseudo terminal, as
# in a terminal window. Without a terminal, zsh cannot enable its line editor
# and writes warnings. The script command of macOS and Linux differ.
pty_cmd() {
  if [ "$(uname -s)" = Darwin ]; then
    ptycmd=(script -q /dev/null "$@")
  else
    ptycmd=(script -qec "$(printf '%q ' "$@")" /dev/null)
  fi
}

pty() {
  pty_cmd "$@"
  if [ "$(uname -s)" = Darwin ]; then
    # macOS script writes "^D" when its stdin is at end of file. Remove it.
    "${ptycmd[@]}" </dev/null | sed '1s/^^D[[:cntrl:]]*//'
  else
    "${ptycmd[@]}" </dev/null
  fi
}

# Fail when a command writes output, and show the output.
no_output() {
  local out
  out="$("$@" 2>&1 | tr -d '\r')"
  if [ -n "$out" ]; then
    echo "$* wrote output:" >&2
    echo "$out" >&2
    return 1
  fi
}

echo "==> zsh starts without errors"
# The first start builds the completion cache and the antidote plugin file.
pty "${clean[@]}" zsh -lic exit
no_output pty "${clean[@]}" zsh -lic exit
limit="${ZSH_STARTUP_LIMIT_MS:-400}"
best=
pty_cmd zsh -ic exit
for _ in 1 2 3 4 5; do
  ms="$("${clean[@]}" zsh -fc 'zmodload zsh/datetime; s=$EPOCHREALTIME; "$@" >/dev/null </dev/null; printf "%.0f" $(( (EPOCHREALTIME - s) * 1000 ))' _ "${ptycmd[@]}")"
  if [ -z "$best" ] || [ "$ms" -lt "$best" ]; then
    best=$ms
  fi
done
echo "zsh startup: $best ms (best of 5, limit $limit ms)"
if [ "$best" -gt "$limit" ]; then
  echo "zsh startup is slower than $limit ms." >&2
  exit 1
fi

echo "==> nvim starts without errors"
# The first start installs the plugins from the lock file.
"${clean[@]}" zsh -lc 'nvim --headless "+Lazy! restore" +qa' || true
no_output "${clean[@]}" zsh -lc 'nvim --headless +qa'

echo "Install test passed ($groups)."
