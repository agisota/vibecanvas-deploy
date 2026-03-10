FROM oven/bun:1-debian

WORKDIR /app

# Install opencode CLI
ADD https://github.com/opencode-ai/opencode/releases/download/v0.0.55/opencode-linux-amd64.deb /tmp/opencode.deb
RUN dpkg -i /tmp/opencode.deb && rm /tmp/opencode.deb

# Install vibecanvas with baseline variant
RUN bun init -y && \
    bun add vibecanvas@0.1.8 vibecanvas-linux-x64-baseline@0.1.8 && \
    find node_modules -name vibecanvas -path '*/bin/*' -exec chmod +x {} \;

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV PORT=10000
EXPOSE 10000

CMD ["/app/start.sh"]
