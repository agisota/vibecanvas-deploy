FROM oven/bun:1-debian

RUN apt-get update && apt-get install -y nodejs curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN bun init -y && \
    bun add --trust vibecanvas@0.1.8 opencode-ai@latest && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \; && \
    find node_modules -name opencode -path '*/bin/*' -exec chmod +x {} \; && \
    echo "opencode version:" && /app/node_modules/.bin/opencode --version || true

# Create opencode config with free model
RUN mkdir -p /app/.config/opencode && \
    echo '{"provider":{},"model":"opencode/mimo-v2-flash-free"}' > /app/.config/opencode/config.json

# Pre-run opencode DB migration at build time
RUN mkdir -p /app/.local/share/opencode /app/.cache/opencode /app/.local/state/opencode && \
    timeout 15 opencode debug config > /dev/null 2>&1 || true

RUN mkdir -p /app/.vibecanvas

COPY proxy.cjs /app/proxy.cjs
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV HOME=/app
ENV PORT=10000
ENV PATH="/app/node_modules/.bin:${PATH}"

EXPOSE 10000

CMD ["/app/start.sh"]
