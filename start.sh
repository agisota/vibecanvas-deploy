#!/bin/sh

export HOME=/app
mkdir -p /app/.vibecanvas /app/.local/share/opencode /app/.cache/opencode /app/.local/state/opencode

INTERNAL_PORT=$((${PORT:-10000} + 1))
export VIBECANVAS_PORT=$INTERNAL_PORT

# Pre-start opencode serve so vibecanvas finds it ready on :4096
opencode serve > /dev/null 2>&1 &

# Wait for opencode to be fully ready
for i in $(seq 1 30); do
  if curl -sf http://127.0.0.1:4096/global/health > /dev/null 2>&1; then
    break
  fi
  sleep 1
done

# Start reverse proxy (0.0.0.0:PORT -> 127.0.0.1:INTERNAL_PORT)
node /app/proxy.cjs &

# Start vibecanvas on internal port
exec vibecanvas serve --port "$INTERNAL_PORT"
