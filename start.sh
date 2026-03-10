#!/bin/sh
set -e

echo "=== VibeCanvas Startup ==="
echo "PORT: ${PORT:-10000}"
echo "PWD: $(pwd)"
echo "USER: $(whoami)"

# Ensure writable home for SQLite
export HOME=/app
mkdir -p /app/.vibecanvas

# Find and chmod the binary
find /app/node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \;

echo "=== Starting vibecanvas ==="
exec bunx vibecanvas serve --port "${PORT:-10000}"
