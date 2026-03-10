#!/bin/sh

export HOME=/app
mkdir -p /app/.vibecanvas

# Start socat to proxy 0.0.0.0:PORT → localhost:PORT+1 (vibecanvas binds localhost only)
INTERNAL_PORT=$((${PORT:-10000} + 1))

socat TCP-LISTEN:${PORT:-10000},fork,reuseaddr,bind=0.0.0.0 TCP:127.0.0.1:${INTERNAL_PORT} &

exec bunx vibecanvas serve --port "${INTERNAL_PORT}"
