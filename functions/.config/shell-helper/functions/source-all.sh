#!/bin/sh
# Source every *.sh in a directory (lexicographic order).
# Usage: . /path/to/source-all.sh /path/to/dir

dir=$1
if [ -z "$dir" ]; then
  echo "source-all.sh: missing directory argument" >&2
  return 2
fi
if [ ! -d "$dir" ]; then
  echo "source-all.sh: not a directory: $dir" >&2
  return 2
fi

# Per-directory idempotent guard (so different dirs still work)
: "${__FUNC_SOURCE_ALL_DIRS:=}"
case ":$__FUNC_SOURCE_ALL_DIRS:" in
  *":$dir:"*) return 0 ;;
esac
__FUNC_SOURCE_ALL_DIRS="${__FUNC_SOURCE_ALL_DIRS:+$__FUNC_SOURCE_ALL_DIRS:}$dir"

# Expand file list safely even when no matches exist (unmatched glob stays literal)
set -- "$dir"/*.sh
if [ ! -e "$1" ]; then
  return 0
fi

for f do
  case "$f" in
    */source-all.sh) continue ;;
  esac
  [ -r "$f" ] || continue
  . "$f"
done

