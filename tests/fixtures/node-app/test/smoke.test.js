'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { add, greet } = require('../src/index.js');

test('add sums two integers', () => {
  assert.equal(add(2, 3), 5);
});

test('greet formats the greeting', () => {
  assert.equal(greet('world'), 'hello, world');
});
