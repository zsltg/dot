# fzf key bindings (Ctrl-T, Alt-C) and `**<Tab>` completion. fzf 0.48 and
# later make these with `fzf --zsh`.
(( $+commands[fzf] )) || return

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --inline-info
  --cycle
"
source <(fzf --zsh)

# Ctrl-R: history search without duplicates.
# Enter runs the command. Right arrow only puts it on the command line.
# Ctrl-X (Shift+Del) deletes the entry from the history file.
fzf-history-custom() {
  emulate -L zsh
  # Collect commands marked for deletion. Null-delimited so multi-line
  # entries survive. Exported so fzf's child shell (ctrl-x) can append to it.
  local -x _fzf_hist_del=$(mktemp)
  local HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
  local selected
  selected=$(fc -rl 1 \
    | awk '{ sub(/^[[:space:]]*[0-9]+\*?[[:space:]]+/, ""); if (!seen[$0]++) print }' \
    | fzf ${=FZF_CTRL_R_OPTS} +m \
        --expect=enter,right \
        --query="$LBUFFER" \
        --header 'Shift+Del (C-x): delete entry' \
        --bind 'ctrl-x:execute-silent(printf "%s\0" {} >> "$_fzf_hist_del")+exclude')
  # --- Persist deletions requested with Shift+Delete (Ctrl-X) ---
  if [[ -s $_fzf_hist_del ]]; then
    local -a to_delete pats
    local c
    while IFS= read -r -d '' c; do to_delete+=("$c"); done < $_fzf_hist_del
    if (( ${#to_delete} )); then
      # Escape each command so glob metacharacters match literally,
      # then build an alternation pattern matching the full line.
      for c in "${to_delete[@]}"; do pats+=("${(b)c}"); done
      local HISTORY_IGNORE="(${(j:|:)pats})"
      fc -W                       # rewrite $HISTFILE, dropping the ignored entries
      # Also purge them from THIS session's in-memory history.
      local _hs=$HISTSIZE
      HISTSIZE=0                  # clear the in-memory list
      HISTSIZE=$_hs
      fc -R "$HISTFILE"           # reload the freshly filtered file
    fi
  fi
  rm -f $_fzf_hist_del
  # Cancelled (Esc / Ctrl-C): just redraw.
  if [[ -z "$selected" ]]; then
    zle reset-prompt
    return
  fi
  local key cmd
  key=${$(print -r -- "$selected" | head -n 1):l}
  cmd=$(print -r -- "$selected" | tail -n +2)
  BUFFER="$cmd"
  CURSOR=$#BUFFER
  if [[ "$key" == "enter" ]]; then
    zle accept-line
  else
    zle reset-prompt
  fi
}

zle -N fzf-history-custom
bindkey '^R' fzf-history-custom
