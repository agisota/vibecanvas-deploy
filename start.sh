#!/bin/sh

echo "=== VibeCanvas Startup ==="
echo "PORT: ${PORT:-10000}"
echo "Arch: $(uname -m)"
echo "opencode: $(which opencode 2>&1 || echo 'not found')"

# Ensure writable home for SQLite
export HOME=/app
mkdir -p /app/.vibecanvas

# Find and chmod the binary
find /app/node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \; 2>/dev/null

echo "=== Starting vibecanvas ==="
exec bunx vibecanvas serve --port "${PORT:-10000}" 2>&1
