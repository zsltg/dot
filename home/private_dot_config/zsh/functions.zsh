# Find the source directory of a crate installed with `cargo install`.
cargo-whereis() {
  local crate="$1"
  if [[ -z "$crate" ]]; then
    echo "Usage: cargo-whereis <crate>"
    return 1
  fi
  local version=$(cargo install --list | awk -v c="$crate" '$1==c {print $2; exit}' | tr -d : | sed 's/^v//')
  if [[ -z "$version" ]]; then
    echo "Crate '$crate' not found in 'cargo install --list'"
    return 1
  fi
  local path=$(find ~/.cargo/registry/src -maxdepth 2 -type d -name "$crate-$version" -print -quit)
  if [[ -n "$path" ]]; then
    echo "$path"
  else
    echo "Not found in registry, checking git sources..."
    find ~/.cargo/git/checkouts -maxdepth 3 -type d -name "$crate*" -print
  fi
}
