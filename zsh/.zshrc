# ---- Only run for interactive shells ----
[[ -o interactive ]] || return

# ---- XDG dirs (keep home clean + reproducible) ----
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh"

# ---- Editor defaults ----
export EDITOR="${EDITOR:-nvim}"
export SUDO_EDITOR="$EDITOR"

# ---- History (fast + useful across sessions) ----
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=20000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY   # writes as you go
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

# ---- Completion: configure styles BEFORE compinit ----
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

autoload -Uz compinit
# One dump file in cache makes subsequent startups faster
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# After compinit, before autosuggestions:
if [[ -r "$XDG_CONFIG_HOME/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$XDG_CONFIG_HOME/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
fi

# ---- zsh-autosuggestions ----
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fi

# ---- zsh-syntax-highlighting (MUST be last) ----
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ---- fzf integration (Arch packaged files) ----
# Gives Ctrl-R history search and other keybindings/completion hooks.
if [[ -r /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
fi
if [[ -r /usr/share/fzf/completion.zsh ]]; then
  source /usr/share/fzf/completion.zsh
fi

# ---- zoxide (fast directory jumping) ----
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ---- starship prompt ----
# Put config wherever YOU want; this is the “standard” XDG location.
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ---- Optional: keep Omarchy aliases (safe to remove later) ----
# Omarchy ships handy fzf aliases like `ff`, etc.
if [[ -r "$HOME/.local/share/omarchy/default/bash/aliases" ]]; then
  source "$HOME/.local/share/omarchy/default/bash/aliases"
fi

# ---- Functions from ~/.config/shell-helper/functions (stowed) ----  
FUNC_DIR="$XDG_CONFIG_HOME/shell-helper/functions"
[ -r "$FUNC_DIR/source-all.sh" ] && . "$FUNC_DIR/source-all.sh" "$FUNC_DIR"

# Load the aliases.zsh and aliases.local.zsh
ALIAS_DIR="$XDG_CONFIG_HOME/zsh"
ALIAS_FILE="$ALIAS_DIR/aliases.zsh"
ALIAS_LOCAL_FILE="$ALIAS_DIR/aliases.local.zsh"

# Create directory + files if missing (idempotent)
[ -d "$ALIAS_DIR" ] || mkdir -p "$ALIAS_DIR"
[ -f "$ALIAS_FILE" ] || : >"$ALIAS_FILE"
[ -f "$ALIAS_LOCAL_FILE" ] || : >"$ALIAS_LOCAL_FILE"

# Load them every shell start
. "$ALIAS_FILE"
. "$ALIAS_LOCAL_FILE"
