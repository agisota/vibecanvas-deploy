FROM oven/bun:1-alpine

WORKDIR /app

RUN bun init -y && bun add vibecanvas@0.1.8

ENV PORT=7496

EXPOSE 7496

CMD ["bunx", "vibecanvas", "serve", "--port", "7496"]
