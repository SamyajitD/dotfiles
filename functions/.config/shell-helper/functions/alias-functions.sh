#!/bin/sh
# aliasctl.sh — POSIX sh functions (SOURCE this file; do NOT execute it)
#
# Provides:
#   addalias  <key> <value...>   -> write/update alias in $ALIAS_FILE, apply immediately
#   rmalias   <key>              -> remove alias from $ALIAS_FILE, apply immediately
#   laddalias <key> <value...>   -> write/update alias in $ALIAS_LOCAL_FILE, apply immediately
#   lrmalias  <key>              -> remove alias from $ALIAS_LOCAL_FILE, apply immediately

# Default locations (override via env vars)
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${ALIAS_FILE:=$XDG_CONFIG_HOME/zsh/aliases.zsh}"
: "${ALIAS_LOCAL_FILE:=$XDG_CONFIG_HOME/zsh/aliases.local.zsh}"

_aliasctl__ensure_file() {
  f=$1
  d=${f%/*}
  [ -d "$d" ] || mkdir -p "$d" || return 1
  [ -f "$f" ] || : >"$f" || return 1
}

# Allow only safe alias names: [A-Za-z_][A-Za-z0-9_]*
_aliasctl__valid_key() {
  case $1 in
    ""|[!A-Za-z_]*|*[!A-Za-z0-9_]* ) return 1 ;;
    * ) return 0 ;;
  esac
}

# Escape single quotes so we can safely emit: alias k='value'
# foo'bar -> foo'\''bar
_aliasctl__escape_squotes() {
  printf '%s' "$1" | sed "s/'/'\\\\''/g"
}

_aliasctl__mktemp() {
  prefix=$1
  if command -v mktemp >/dev/null 2>&1; then
    mktemp "${prefix}.XXXXXX" 2>/dev/null && return 0
  fi
  echo "aliasctl: mktemp not found; refusing unsafe temp-file fallback" >&2
  return 1
}

_aliasctl__remove_key_from_file() {
  f=$1 key=$2
  _aliasctl__ensure_file "$f" || return 1

  tmp=$(_aliasctl__mktemp "$f.tmp") || return 1

  # Remove any line starting with: alias <key>=...
  # Keep everything else.
  grep -v -E "^[[:space:]]*alias[[:space:]]+${key}=" "$f" >"$tmp" 2>/dev/null || :
  mv -f "$tmp" "$f"
}

_aliasctl__add_or_replace_in_file() {
  f=$1 key=$2 value=$3
  _aliasctl__ensure_file "$f" || return 1

  tmp=$(_aliasctl__mktemp "$f.tmp") || return 1

  # Remove existing definitions for this key
  grep -v -E "^[[:space:]]*alias[[:space:]]+${key}=" "$f" >"$tmp" 2>/dev/null || :

  # Reject multi-line values (keeps aliases file sane)
  case $value in
    *'
'* )
      echo "aliasctl: value must be single-line" >&2
      rm -f "$tmp" 2>/dev/null || :
      return 2
      ;;
  esac

  esc=$(_aliasctl__escape_squotes "$value")
  printf "alias %s='%s'\n" "$key" "$esc" >>"$tmp"

  mv -f "$tmp" "$f"
}

_aliasctl__reload() {
  [ -r "$ALIAS_FILE" ] && . "$ALIAS_FILE"
  [ -r "$ALIAS_LOCAL_FILE" ] && . "$ALIAS_LOCAL_FILE"
}

addalias() {
  key=$1; shift 2>/dev/null || :
  value=$*
  [ -n "$key" ] && [ -n "$value" ] || { echo "usage: addalias <key> <value...>" >&2; return 2; }
  _aliasctl__valid_key "$key" || { echo "invalid alias name: $key" >&2; return 2; }

  _aliasctl__add_or_replace_in_file "$ALIAS_FILE" "$key" "$value" || return $?
  unalias "$key" 2>/dev/null || :
  _aliasctl__reload
}

rmalias() {
  key=$1
  [ -n "$key" ] || { echo "usage: rmalias <key>" >&2; return 2; }
  _aliasctl__valid_key "$key" || { echo "invalid alias name: $key" >&2; return 2; }

  _aliasctl__remove_key_from_file "$ALIAS_FILE" "$key" || return $?
  unalias "$key" 2>/dev/null || :
  _aliasctl__reload
}

laddalias() {
  key=$1; shift 2>/dev/null || :
  value=$*
  [ -n "$key" ] && [ -n "$value" ] || { echo "usage: laddalias <key> <value...>" >&2; return 2; }
  _aliasctl__valid_key "$key" || { echo "invalid alias name: $key" >&2; return 2; }

  _aliasctl__add_or_replace_in_file "$ALIAS_LOCAL_FILE" "$key" "$value" || return $?
  unalias "$key" 2>/dev/null || :
  _aliasctl__reload
}

lrmalias() {
  key=$1
  [ -n "$key" ] || { echo "usage: lrmalias <key>" >&2; return 2; }
  _aliasctl__valid_key "$key" || { echo "invalid alias name: $key" >&2; return 2; }

  _aliasctl__remove_key_from_file "$ALIAS_LOCAL_FILE" "$key" || return $?
  unalias "$key" 2>/dev/null || :
  _aliasctl__reload
}

