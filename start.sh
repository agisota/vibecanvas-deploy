#!/bin/sh

export HOME=/app
LOG=/app/startup.log
mkdir -p /app/.vibecanvas

INTERNAL_PORT=$((${PORT:-10000} + 1))
export VIBECANVAS_PORT=$INTERNAL_PORT

# Diagnostics
{
  echo "=== $(date) ==="
  echo "PORT=$PORT INTERNAL_PORT=$INTERNAL_PORT"
  echo "PATH=$PATH"
  echo "--- CPU AVX flags ---"
  grep -o 'avx[^ ]*' /proc/cpuinfo 2>/dev/null | sort -u || echo "No AVX"
  echo "--- vibecanvas packages ---"
  ls -d /app/node_modules/vibecanvas-linux-* 2>/dev/null || echo "none"
  echo "--- opencode packages ---"
  ls -d /app/node_modules/opencode-linux-* 2>/dev/null || echo "none"
  echo "--- opencode version ---"
  opencode --version 2>&1 || echo "FAILED"
  echo "--- vibecanvas help ---"
  vibecanvas --help 2>&1 | head -5 || echo "FAILED"
  echo "=== Starting ==="
} > "$LOG" 2>&1

# Start reverse proxy (0.0.0.0:PORT -> 127.0.0.1:INTERNAL_PORT)
node /app/proxy.cjs &

# Start vibecanvas on internal port, log output
exec vibecanvas serve --port "$INTERNAL_PORT" >> "$LOG" 2>&1
