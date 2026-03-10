#!/bin/sh

export HOME=/app
mkdir -p /app/.vibecanvas /app/.local/share/opencode /app/.cache/opencode /app/.local/state/opencode

INTERNAL_PORT=$((${PORT:-10000} + 1))
export VIBECANVAS_PORT=$INTERNAL_PORT

# Pre-start opencode serve so vibecanvas finds it ready
opencode serve > /dev/null 2>&1 &

# Wait for opencode to be listening
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
  if curl -s http://127.0.0.1:4096 > /dev/null 2>&1; then
    break
  fi
  sleep 1
done

# Start reverse proxy (0.0.0.0:PORT -> 127.0.0.1:INTERNAL_PORT)
node /app/proxy.cjs &

# Start vibecanvas on internal port
exec vibecanvas serve --port "$INTERNAL_PORT"
