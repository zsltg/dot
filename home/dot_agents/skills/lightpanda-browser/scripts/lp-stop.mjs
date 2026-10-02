#!/usr/bin/env node
// Stop this session's Lightpanda instance and remove its state.
// Use to force a clean restart, or for explicit teardown. Safe to run when
// nothing is running (no-op). Exit 0 always unless something unexpected throws.

import { resolveKey, getBackend, readState, removeState } from './lp-lib.mjs';

const key = resolveKey();
const st = readState(key);
if (!st) {
  process.stderr.write('lightpanda: no instance for this session\n');
  process.exit(0);
}
const be = getBackend(st.backend);
try {
  if (be) be.stop(st);
} finally {
  removeState(key);
}
process.stderr.write(`lightpanda: stopped instance ${key}\n`);
