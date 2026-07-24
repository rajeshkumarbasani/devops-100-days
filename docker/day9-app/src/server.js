'use strict';
const http = require('http');
const { createApp } = require('./app');
const port = Number.parseInt(process.env.PORT || '3000', 10);
const host = process.env.HOST || '0.0.0.0';
if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error(`Invalid PORT: ${process.env.PORT}`);
const server = http.createServer(createApp());
server.keepAliveTimeout = 65000;
server.headersTimeout = 66000;
server.requestTimeout = 30000;
server.listen(port, host, () => console.log(JSON.stringify({level:'info', message:'Server started', host, port, version:process.env.APP_VERSION || 'local'})));
function shutdown(signal) {
  console.log(JSON.stringify({level:'info', message:'Graceful shutdown started', signal}));
  server.close((error) => process.exit(error ? 1 : 0));
  setTimeout(() => process.exit(1), 10000).unref();
}
process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
process.on('uncaughtException', (error) => { console.error(error); process.exit(1); });
process.on('unhandledRejection', (reason) => { console.error(reason); process.exit(1); });
