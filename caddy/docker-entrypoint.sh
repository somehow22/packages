#!/bin/sh
set -e

# Ensure expected dirs exist
mkdir -p /data /config

fix_perm() {
  dir="$1"
  # Try to write as uid:gid 10001; if it fails, chown the tree
  if su-exec 10001:10001 sh -lc "touch \"$dir\"/.permtest && rm -f \"$dir\"/.permtest" 2>/dev/null; then
    :
  else
    chown -R 10001:10001 "$dir" || true
  fi
}

fix_perm /data
fix_perm /config

# Drop privileges and exec the requested command
exec su-exec 10001:10001 "$@"

