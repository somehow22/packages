#!/bin/sh
set -e

#!/bin/sh
set -e

if [ "$(id -u)" = "0" ]; then
  # Ensure expected dirs exist (only root needs to create them on fresh volumes)
  mkdir -p /data /config || true

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

  # Enforce strict permissions: dirs 0700, files 0600
  for p in /data /config; do
    chmod -R go-rwx "$p" 2>/dev/null || true
    find "$p" -type d -exec chmod 0700 {} + 2>/dev/null || true
    find "$p" -type f -exec chmod 0600 {} + 2>/dev/null || true
  done

  # Drop privileges and exec the requested command
  exec su-exec 10001:10001 "$@"
else
  # Already running as non-root (e.g., Kubernetes with runAsUser=10001); just exec
  exec "$@"
fi
