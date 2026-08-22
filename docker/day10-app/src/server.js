'use strict';
const http = require('http');
const { createApp } = require('./app');

const port = Number.parseInt(process.env.PORT || '3000', 10);
const server = http.createServer(createApp());
server.keepAliveTimeout = 65000;
server.headersTimeout = 66000;
server.requestTimeout = 30000;

server.listen(port, '0.0.0.0', () => console.log(JSON.stringify({
  level: 'info', message: 'server_started', port, version: process.env.APP_VERSION || 'local'
})));

function shutdown(signal) {
  console.log(JSON.stringify({ level: 'info', message: 'shutdown', signal }));
  server.close(error => process.exit(error ? 1 : 0));
  setTimeout(() => process.exit(1), 10000).unref();
}
process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
