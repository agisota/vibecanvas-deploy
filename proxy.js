const http = require("http");
const httpProxy = require("http-proxy");

const PORT = parseInt(process.env.PORT || "10000", 10);
const TARGET = parseInt(process.env.VIBECANVAS_PORT || "10001", 10);

const proxy = httpProxy.createProxyServer({ target: `http://127.0.0.1:${TARGET}`, ws: true });

proxy.on("error", (_err, _req, res) => {
  if (res.writeHead) res.writeHead(503);
  if (res.end) res.end("Starting...");
});

const server = http.createServer((req, res) => proxy.web(req, res));
server.on("upgrade", (req, socket, head) => proxy.ws(req, socket, head));

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Proxy listening on 0.0.0.0:${PORT} -> 127.0.0.1:${TARGET}`);
});
