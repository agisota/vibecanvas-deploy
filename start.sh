#!/bin/sh

export HOME=/app
mkdir -p /app/.vibecanvas

INTERNAL_PORT=$((${PORT:-10000} + 1))
export VIBECANVAS_PORT=$INTERNAL_PORT

# Start reverse proxy (0.0.0.0:PORT -> 127.0.0.1:INTERNAL_PORT)
node /app/proxy.cjs &

# Start vibecanvas on internal port
exec bunx vibecanvas serve --port "$INTERNAL_PORT"
