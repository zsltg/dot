#!/bin/bash
# Run the repo checks. CI runs this script too (.github/workflows/lint.yml).
#
# 1. Render the target state for each OS and arch, each palette, and with all
#    groups on and all groups off. A template error fails the check.
# 2. Lint the rendered install scripts (bash -n, shellcheck) and zsh files (zsh -n).
# 3. Lint the tracked shell scripts outside home/ (shellcheck).
# 4. Lint the GitHub workflows (actionlint, zizmor) and find secrets (gitleaks).
#
# Needs chezmoi, jq, zsh, shellcheck, actionlint, zizmor and gitleaks.
# zizmor also runs its online audits when GH_TOKEN is set.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
failed=()

# chezmoi reads the externals also for "dump --exclude=externals", and then
# downloads the font archive. Render from a copy of the source without the
# externals file, so that the check does not use the network. render_all
# renders the externals template separately.
mkdir "$tmp/src"
cp -R "$repo/.chezmoiroot" "$repo/home" "$tmp/src/"
rm "$tmp/src/home/.chezmoiexternal.toml.tmpl"

# Run chezmoi on the source copy with no user config, so that only the data
# given here is used. chezmoi warns that the config file differs from
# .chezmoi.toml.tmpl. Show its stderr only when the command fails.
chezmoi_src() {
  if ! chezmoi --source "$tmp/src" --config "$tmp/chezmoi.toml" "$@" 2>"$tmp/stderr"; then
    cat "$tmp/stderr" >&2
    return 1
  fi
}

# Record a failed step and continue with the next step.
step() {
  local name="$1"
  shift
  echo "==> $name"
  if ! "$@"; then
    failed+=("$name")
  fi
}

render_all() {
  local palettes os_arch os arch palette groups data kind target contents dir
  local -A seen=()
  palettes="$(chezmoi_src execute-template '{{ range $name, $_ := .palettes }}{{ $name }} {{ end }}')"
  mkdir -p "$tmp/scripts" "$tmp/zsh"
  for os_arch in linux/amd64 linux/arm64 darwin/amd64 darwin/arm64; do
    os="${os_arch%/*}"
    arch="${os_arch#*/}"
    for palette in $palettes; do
      for groups in true false; do
        data="{\"name\":\"CI\",\"email\":\"ci@example.com\",\"dev\":$groups,\"ai\":$groups,\"docker\":$groups,\"vm\":$groups,\"theme\":\"$palette\",\"chezmoi\":{\"os\":\"$os\",\"arch\":\"$arch\"}}"
        echo "    $os/$arch palette=$palette groups=$groups"
        chezmoi_src --override-data "$data" execute-template <"$repo/home/.chezmoiexternal.toml.tmpl" >/dev/null || return 1
        chezmoi_src --override-data "$data" dump --format json >"$tmp/dump.json" || return 1
        # Keep one copy of each rendered script and zsh file. The directory
        # name tells which render it comes from.
        while IFS=$'\t' read -r kind target contents; do
          [[ -z "${seen[$contents]:-}" ]] || continue
          seen[$contents]=1
          dir="$tmp/$kind/$os-$arch-$palette-$groups"
          mkdir -p "$dir"
          base64 -d <<<"$contents" >"$dir/${target//[.\/]/_}"
        done < <(jq -r 'to_entries[]
          | (if .value.type == "script" then "scripts"
             elif .value.type == "file" and (.key | test("(\\.zsh|^\\.zshrc|^\\.zshenv|^\\.zprofile)$")) then "zsh"
             else empty end) as $kind
          | "\($kind)\t\(.key)\t\(.value.contents | @base64)"' "$tmp/dump.json")
      done
    done
  done
}

lint_scripts() {
  local file rc=0
  for file in "$tmp"/scripts/*/*; do
    bash -n "$file" || rc=1
  done
  shellcheck -S warning "$tmp"/scripts/*/* || rc=1
  return "$rc"
}

lint_zsh() {
  local file rc=0
  for file in "$tmp"/zsh/*/*; do
    zsh -n "$file" || rc=1
  done
  return "$rc"
}

lint_repo_scripts() {
  local files=()
  mapfile -t files < <(git -C "$repo" ls-files scripts .githooks)
  (cd "$repo" && shellcheck -S warning "${files[@]}")
}

step "render templates" render_all
step "lint rendered scripts" lint_scripts
step "lint rendered zsh files" lint_zsh
step "lint repo scripts" lint_repo_scripts
step "actionlint" bash -c 'cd "$1" && actionlint' _ "$repo"
step "zizmor" zizmor --no-progress "$repo/.github"
step "gitleaks" gitleaks dir "$repo" --redact --no-banner

if ((${#failed[@]})); then
  printf 'FAILED: %s\n' "${failed[@]}" >&2
  exit 1
fi
echo "All checks passed."
