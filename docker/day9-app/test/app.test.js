'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');
const { createApp } = require('../src/app');
test('GET / returns Day 9 metadata', async () => { const r = await request(createApp()).get('/').expect(200); assert.equal(r.body.day, 9); });
test('liveness works', async () => { const r = await request(createApp()).get('/health/live').expect(200); assert.equal(r.body.status, 'alive'); });
test('readiness works', async () => { const r = await request(createApp()).get('/health/ready').expect(200); assert.equal(r.body.status, 'ready'); });
test('unknown route returns 404', async () => { const r = await request(createApp()).get('/missing').expect(404); assert.equal(r.body.error, 'Not Found'); });
