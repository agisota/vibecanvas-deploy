#!/bin/sh

export HOME=/app
mkdir -p /app/.vibecanvas

INTERNAL_PORT=$((${PORT:-10000} + 1))
export VIBECANVAS_PORT=$INTERNAL_PORT

echo "=== DEBUG: PATH=$PATH"
echo "=== DEBUG: which vibecanvas = $(which vibecanvas 2>&1)"
echo "=== DEBUG: which opencode = $(which opencode 2>&1)"
echo "=== DEBUG: ls /app/node_modules/.bin/ ="
ls -la /app/node_modules/.bin/ 2>&1 | head -20
echo "=== DEBUG: vibecanvas binary test ="
vibecanvas --help 2>&1 | head -5 || echo "vibecanvas --help FAILED"
echo "=== DEBUG: opencode binary test ="
opencode --version 2>&1 || echo "opencode --version FAILED"
echo "=== DEBUG: PORT=$PORT INTERNAL_PORT=$INTERNAL_PORT"

# Start reverse proxy (0.0.0.0:PORT -> 127.0.0.1:INTERNAL_PORT)
node /app/proxy.cjs &

# Start vibecanvas on internal port
echo "=== Starting vibecanvas serve --port $INTERNAL_PORT"
exec bunx vibecanvas serve --port "$INTERNAL_PORT"
