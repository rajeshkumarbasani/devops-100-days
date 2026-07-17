'use strict';

const http = require('http');
const { createApp } = require('./app');

const port = Number.parseInt(process.env.PORT || '3000', 10);
const host = process.env.HOST || '0.0.0.0';

if (!Number.isInteger(port) || port < 1 || port > 65535) {
  throw new Error(`Invalid PORT value: ${process.env.PORT}`);
}

const app = createApp();
const server = http.createServer(app);

server.keepAliveTimeout = 65000;
server.headersTimeout = 66000;
server.requestTimeout = 30000;

server.listen(port, host, () => {
  console.log(
    JSON.stringify({
      level: 'info',
      message: 'Server started',
      host,
      port,
      environment: process.env.NODE_ENV || 'development',
      version: process.env.APP_VERSION || 'local'
    })
  );
});

function gracefulShutdown(signal) {
  console.log(
    JSON.stringify({
      level: 'info',
      message: 'Graceful shutdown started',
      signal
    })
  );

  server.close((error) => {
    if (error) {
      console.error('Server shutdown failed:', error);
      process.exit(1);
    }

    console.log('HTTP server stopped successfully.');
    process.exit(0);
  });

  setTimeout(() => {
    console.error('Forced shutdown after timeout.');
    process.exit(1);
  }, 10000).unref();
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

process.on('uncaughtException', (error) => {
  console.error('Uncaught exception:', error);
  process.exit(1);
});

process.on('unhandledRejection', (reason) => {
  console.error('Unhandled rejection:', reason);
  process.exit(1);
});