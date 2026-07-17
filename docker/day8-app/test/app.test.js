'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');
const { createApp } = require('../src/app');

test('GET / returns application information', async () => {
  const app = createApp();

  const response = await request(app)
    .get('/')
    .expect('Content-Type', /json/)
    .expect(200);

  assert.equal(response.body.application, 'DevOps 100 Days');
  assert.equal(response.body.day, 8);
});

test('GET /health/live returns alive status', async () => {
  const app = createApp();

  const response = await request(app)
    .get('/health/live')
    .expect('Content-Type', /json/)
    .expect(200);

  assert.equal(response.body.status, 'alive');
});

test('GET /health/ready returns ready status', async () => {
  const app = createApp();

  const response = await request(app)
    .get('/health/ready')
    .expect('Content-Type', /json/)
    .expect(200);

  assert.equal(response.body.status, 'ready');
  assert.equal(typeof response.body.uptime_seconds, 'number');
});

test('Unknown route returns 404', async () => {
  const app = createApp();

  const response = await request(app)
    .get('/unknown')
    .expect('Content-Type', /json/)
    .expect(404);

  assert.equal(response.body.error, 'Not Found');
});