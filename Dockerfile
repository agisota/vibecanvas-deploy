FROM oven/bun:1-alpine

RUN bun install -g vibecanvas@0.1.8

EXPOSE 7496

CMD ["vibecanvas", "serve", "--port", "7496"]
