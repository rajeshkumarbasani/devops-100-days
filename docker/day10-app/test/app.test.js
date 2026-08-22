'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');
const { createApp } = require('../src/app');

test('root responds', async () => {
  const response = await request(createApp()).get('/').expect(200);
  assert.equal(response.body.project, 'DevOps 100 Days');
});
test('live health responds', async () => {
  const response = await request(createApp()).get('/health/live').expect(200);
  assert.equal(response.body.status, 'alive');
});
test('ready health responds', async () => {
  const response = await request(createApp()).get('/health/ready').expect(200);
  assert.equal(response.body.status, 'ready');
});
