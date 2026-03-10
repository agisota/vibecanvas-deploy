// Lightweight opencode server stub (~5MB RAM)
// Replaces real opencode serve which uses ~150MB
// Responds to health checks and WebSocket connections
const http = require("http");
const crypto = require("crypto");

const PORT = parseInt(process.env.FAKE_OPENCODE_PORT || "4096", 10);

const server = http.createServer((req, res) => {
  if (req.url === "/global/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "ok" }));
    return;
  }
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ status: "ok", version: "1.2.24" }));
});

server.on("upgrade", (req, socket) => {
  const key = req.headers["sec-websocket-key"];
  if (!key) { socket.destroy(); return; }

  const accept = crypto.createHash("sha1")
    .update(key + "258EAFA5-E914-47DA-95CA-5AB5ADF7BD34")
    .digest("base64");

  socket.write(
    "HTTP/1.1 101 Switching Protocols\r\n" +
    "Upgrade: websocket\r\n" +
    "Connection: Upgrade\r\n" +
    `Sec-WebSocket-Accept: ${accept}\r\n\r\n`
  );

  socket.on("data", () => {});
  socket.on("error", () => socket.destroy());
});

server.listen(PORT, "127.0.0.1", () => {
  console.log(`Fake opencode ready on 127.0.0.1:${PORT}`);
});
