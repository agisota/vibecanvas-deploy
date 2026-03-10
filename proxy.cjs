const http = require("http");
const net = require("net");

const PORT = parseInt(process.env.PORT || "10000", 10);
const TARGET = parseInt(process.env.VIBECANVAS_PORT || "10001", 10);

const server = http.createServer((req, res) => {
  const opts = { hostname: "127.0.0.1", port: TARGET, path: req.url, method: req.method, headers: req.headers };
  const proxy = http.request(opts, (pRes) => {
    res.writeHead(pRes.statusCode, pRes.headers);
    pRes.pipe(res);
  });
  proxy.on("error", () => { res.writeHead(503); res.end("Starting..."); });
  req.pipe(proxy);
});

server.on("upgrade", (req, socket, head) => {
  const conn = net.connect(TARGET, "127.0.0.1", () => {
    const rawReq = `${req.method} ${req.url} HTTP/1.1\r\n${Object.entries(req.headers).map(([k,v])=>`${k}: ${v}`).join("\r\n")}\r\n\r\n`;
    conn.write(rawReq);
    conn.write(head);
    socket.pipe(conn);
    conn.pipe(socket);
  });
  conn.on("error", () => socket.destroy());
});

server.listen(PORT, "0.0.0.0", () => console.log(`Proxy 0.0.0.0:${PORT} -> 127.0.0.1:${TARGET}`));
