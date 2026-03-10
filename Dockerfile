FROM oven/bun:1-debian

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN bun init -y && \
    bun add vibecanvas@0.1.8 opencode-ai@latest && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \; && \
    find node_modules/.bin -name opencode -exec chmod +x {} \;

COPY proxy.js /app/proxy.js
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV HOME=/app
ENV PORT=10000

EXPOSE 10000

CMD ["/app/start.sh"]
