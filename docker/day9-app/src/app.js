'use strict';
const express = require('express');
const helmet = require('helmet');
function createApp() {
  const app = express();
  app.disable('x-powered-by');
  app.set('trust proxy', 1);
  app.use(helmet());
  app.use(express.json({ limit: '10kb' }));
  app.get('/', (req, res) => res.status(200).json({
    application: 'DevOps 100 Days', day: 9, platform: 'Amazon ECS Fargate',
    message: 'Day 9 production deployment is running',
    environment: process.env.NODE_ENV || 'development',
    version: process.env.APP_VERSION || 'local'
  }));
  app.get('/health/live', (req, res) => res.status(200).json({status:'alive', timestamp:new Date().toISOString()}));
  app.get('/health/ready', (req, res) => res.status(200).json({status:'ready', uptime_seconds:Math.floor(process.uptime()), version:process.env.APP_VERSION || 'local', timestamp:new Date().toISOString()}));
  app.use((req, res) => res.status(404).json({error:'Not Found', path:req.originalUrl}));
  app.use((err, req, res, next) => {
    console.error(JSON.stringify({level:'error', message:err.message}));
    if (res.headersSent) return next(err);
    return res.status(500).json({error:'Internal Server Error'});
  });
  return app;
}
module.exports = { createApp };
