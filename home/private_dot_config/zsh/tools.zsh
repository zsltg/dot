# Shell integration of installed tools. Each line is skipped when the tool is
# not installed.

# mise tools come from the shims directory on PATH (see path.zsh). "mise activate"
# is not used: its prompt hook adds about 100 ms to each prompt.
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#586e75'

# zsh-syntax-highlighting: no underline. These are the defaults that use
# underline, set here without it. The plugin sets a default only when the style is empty.
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green

# Ctrl-C at the prompt clears the line and draws the prompt again.
TRAPINT() {
  zle && zle reset-prompt
  return 127
}
