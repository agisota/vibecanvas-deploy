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
  opencode --version >> "$LOG" 2>&1 || echo "FAILED"
  echo "--- vibecanvas help ---"
  vibecanvas --help 2>&1 | head -5 || echo "FAILED"
  echo "=== Starting vibecanvas ==="
} > "$LOG" 2>&1

# Start vibecanvas in background, log output
vibecanvas serve --port "$INTERNAL_PORT" >> "$LOG" 2>&1 &
VC_PID=$!
echo "vibecanvas PID: $VC_PID" >> "$LOG"

# Give vibecanvas a moment, check if it survived
sleep 3
if kill -0 $VC_PID 2>/dev/null; then
  echo "vibecanvas is running" >> "$LOG"
else
  wait $VC_PID 2>/dev/null
  echo "vibecanvas CRASHED with exit code: $?" >> "$LOG"
fi

# Proxy is PID 1 — keeps container alive even if vibecanvas crashes
exec node /app/proxy.cjs
