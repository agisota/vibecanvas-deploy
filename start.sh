#!/bin/sh

echo "=== VibeCanvas Startup ==="
echo "PORT: ${PORT:-10000}"

export HOME=/app
mkdir -p /app/.vibecanvas

# Use baseline binary directly (no AVX required)
BASELINE="/app/node_modules/vibecanvas-linux-x64-baseline/bin/vibecanvas"
REGULAR="/app/node_modules/vibecanvas-linux-x64/bin/vibecanvas"

if [ -f "$BASELINE" ]; then
    echo "Using baseline binary"
    chmod +x "$BASELINE"
    exec "$BASELINE" serve --port "${PORT:-10000}" 2>&1
elif [ -f "$REGULAR" ]; then
    echo "Using regular binary"
    chmod +x "$REGULAR"
    exec "$REGULAR" serve --port "${PORT:-10000}" 2>&1
else
    echo "No binary found, using bunx"
    find /app/node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \; 2>/dev/null
    exec bunx vibecanvas serve --port "${PORT:-10000}" 2>&1
fi
