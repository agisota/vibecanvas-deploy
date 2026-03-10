FROM oven/bun:1-debian

WORKDIR /app

RUN bun init -y && bun add vibecanvas@0.1.8 && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \;

ENV PORT=7496

EXPOSE 7496

CMD ["bunx", "vibecanvas", "serve", "--port", "7496"]
