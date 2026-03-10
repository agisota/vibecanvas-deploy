FROM oven/bun:1-debian

WORKDIR /app

RUN bun init -y && \
    bun add vibecanvas@0.1.8 opencode-ai@latest && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \; && \
    find node_modules/.bin -name opencode -exec chmod +x {} \;

ENV HOME=/app
ENV PORT=10000

EXPOSE 10000

CMD ["bunx", "vibecanvas", "serve", "--port", "10000"]
