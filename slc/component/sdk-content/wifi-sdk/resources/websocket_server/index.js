import { createServer } from "http";
import { WebSocketServer } from "ws";

// Define variables
const HOSTNAME = "example.com";
const PATHNAME = "/myresource";
const PORT = 8080;

// Create an HTTP server
const server = createServer((req, res) => {
    res.writeHead(404);
    res.end();
});

// Create a WebSocket server
const wss = new WebSocketServer({ noServer: true, maxPayload: 100 * 1024 * 1024 });

// Handle WebSocket connections
wss.on("connection", function connection(ws, req) {
    // Print the IP address of the client
    let clientIp = req.socket.remoteAddress;
    if (clientIp.startsWith("::ffff:")) {
        clientIp = clientIp.replace("::ffff:", "");
    }
    console.log(`Client connected: ${clientIp}`);


    ws.on("ping", (data) => {
        console.log("Received ping from client with payload:", data.toString());
    });

    ws.on("pong", (data) => {
        console.log("Received pong from client with payload:", data.toString());
    });


    ws.on("message", function message(data) {
        try {
            console.log("received: %s", data);
        } catch (error) {
            console.error("Error processing message:", error);
            ws.close(1002, "Invalid message format");
        }
    });

    ws.on("error", function error(err) {
        console.error("WebSocket error:", err);
    });

    ws.on("close", function close(code, reason) {
        console.log(`WebSocket closed: ${code} - ${reason}`);
    });

    let messageCount = 0;
    const maxMessages = 5;

    const intervalId = setInterval(() => {
        try {
            if (ws.readyState === ws.OPEN) {
                if (messageCount < maxMessages) {
                    const message = "Hello, World!";
                    ws.send(message);
                    messageCount++;
                } else {
                    clearInterval(intervalId);
                }
            } else {
                clearInterval(intervalId);
            }
        } catch (error) {
            console.error("Error sending data:", error);
            clearInterval(intervalId);
        }
    }, 1000);

    // Send ping packet every 10 seconds
    const pingInterval = setInterval(() => {
        if (ws.readyState === ws.OPEN) {
            ws.ping();
        }
    }, 10000);

});

// Handle HTTP upgrade requests
server.on("upgrade", (req, socket, head) => {
    const { pathname, hostname } = new URL(req.url, `http://${req.headers.host}`);
    console.log(`Upgrade request for hostname: ${hostname}, pathname: ${pathname}`);

    if ((hostname === HOSTNAME && pathname === PATHNAME) || hostname === "localhost") {
        wss.handleUpgrade(req, socket, head, (ws) => {
            wss.emit("connection", ws, req);
        });
    } else {
        console.log("Invalid hostname or pathname, destroying socket");
        socket.destroy();
    }
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server is listening on port ${PORT}`);
});