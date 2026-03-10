FROM debian:bookworm-slim

# Install baseline Bun (no AVX requirement)
RUN apt-get update && apt-get install -y curl unzip && \
    BUN_INSTALL=/usr/local curl -fsSL https://bun.sh/install | bash && \
    rm -rf /var/lib/apt/lists/*

# Install opencode CLI
ADD https://github.com/opencode-ai/opencode/releases/download/v0.0.55/opencode-linux-amd64.deb /tmp/opencode.deb
RUN dpkg -i /tmp/opencode.deb && rm /tmp/opencode.deb

WORKDIR /app

# Install vibecanvas and force baseline binary
RUN bun init -y && \
    bun add vibecanvas@0.1.8 vibecanvas-linux-x64-baseline@0.1.8 && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \;

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV PORT=10000
EXPOSE 10000

CMD ["/app/start.sh"]
