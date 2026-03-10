FROM oven/bun:1-debian

WORKDIR /app

# Install socat for 0.0.0.0 binding proxy
RUN apt-get update && apt-get install -y socat && rm -rf /var/lib/apt/lists/*

# Install vibecanvas + opencode-ai
RUN bun init -y && \
    bun add vibecanvas@0.1.8 opencode-ai@latest && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \; && \
    find node_modules/.bin -name opencode -exec chmod +x {} \;

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV HOME=/app
ENV PORT=10000

EXPOSE 10000

CMD ["/app/start.sh"]
