'use strict';

const express = require('express');
const helmet = require('helmet');

function createApp() {
  const app = express();

  app.disable('x-powered-by');

  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"]
        }
      }
    })
  );

  app.use(express.json({ limit: '10kb' }));

  app.get('/', (request, response) => {
    response.status(200).json({
      application: 'DevOps 100 Days',
      day: 8,
      message: 'Production CI/CD deployment is running',
      environment: process.env.NODE_ENV || 'development',
      version: process.env.APP_VERSION || 'local'
    });
  });

  app.get('/health/live', (request, response) => {
    response.status(200).json({
      status: 'alive',
      timestamp: new Date().toISOString()
    });
  });

  app.get('/health/ready', (request, response) => {
    response.status(200).json({
      status: 'ready',
      uptime_seconds: Math.floor(process.uptime()),
      timestamp: new Date().toISOString()
    });
  });

  app.use((request, response) => {
    response.status(404).json({
      error: 'Not Found',
      path: request.originalUrl
    });
  });

  app.use((error, request, response, next) => {
    console.error('Unhandled application error:', error);

    if (response.headersSent) {
      return next(error);
    }

    return response.status(500).json({
      error: 'Internal Server Error'
    });
  });

  return app;
}

module.exports = {
  createApp
};