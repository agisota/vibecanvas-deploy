#!/bin/sh

export HOME=/app
mkdir -p /app/.vibecanvas

INTERNAL_PORT=$((${PORT:-10000} + 1))
export VIBECANVAS_PORT=$INTERNAL_PORT

# Start fake opencode server (satisfies vibecanvas startup check)
node /app/fake-opencode.cjs &

# Wait for fake opencode to be ready
sleep 1

# Start reverse proxy (0.0.0.0:PORT -> 127.0.0.1:INTERNAL_PORT)
node /app/proxy.cjs &

# Start vibecanvas on internal port
exec vibecanvas serve --port "$INTERNAL_PORT"
