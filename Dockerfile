FROM oven/bun:1-debian

WORKDIR /app

# Install opencode CLI (required by vibecanvas)
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://opencode.ai/install | bash && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.opencode/bin:${PATH}"

RUN bun init -y && bun add vibecanvas@0.1.8 && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \;

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV PORT=10000
EXPOSE 10000

CMD ["/app/start.sh"]
