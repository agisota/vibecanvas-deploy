FROM oven/bun:1-debian

WORKDIR /app

RUN bun init -y && bun add vibecanvas@0.1.8 && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \;

EXPOSE 10000

CMD ["sh", "-c", "bunx vibecanvas serve --port ${PORT:-10000}"]
