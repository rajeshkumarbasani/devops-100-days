'use strict';
const express = require('express');
const helmet = require('helmet');

function createApp() {
  const app = express();
  app.disable('x-powered-by');
  app.set('trust proxy', 1);
  app.use(helmet());
  app.use(express.json({ limit: '16kb' }));

  app.get('/', (req, res) => res.status(200).json({
    project: 'DevOps 100 Days',
    day: Number(process.env.CHALLENGE_DAY || 0),
    theme: process.env.CHALLENGE_THEME || 'DevOps',
    environment: process.env.NODE_ENV || 'development',
    version: process.env.APP_VERSION || 'local',
    hostname: require('os').hostname()
  }));

  app.get('/health/live', (_, res) => res.status(200).json({ status: 'alive' }));
  app.get('/health/ready', (_, res) => res.status(200).json({
    status: 'ready',
    uptime_seconds: Math.floor(process.uptime()),
    version: process.env.APP_VERSION || 'local'
  }));

  app.get('/metrics', (_, res) => {
    res.type('text/plain').send([
      '# HELP app_up Whether the application is running.',
      '# TYPE app_up gauge',
      'app_up 1',
      '# HELP process_uptime_seconds Process uptime.',
      '# TYPE process_uptime_seconds counter',
      `process_uptime_seconds ${Math.floor(process.uptime())}`
    ].join('\n'));
  });

  app.use((req, res) => res.status(404).json({ error: 'Not Found', path: req.originalUrl }));
  return app;
}
module.exports = { createApp };
