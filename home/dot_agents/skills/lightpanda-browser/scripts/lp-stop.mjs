#!/usr/bin/env node
// Stop this session's Lightpanda instance and remove its state.
// Use to force a clean restart, or for explicit teardown. Safe to run when
// nothing is running (no-op). Exit 1 when the instance does not stop.

import { resolveKey, getBackend, readState, removeState } from './lp-lib.mjs';

const key = resolveKey();
const st = readState(key);
if (!st) {
  process.stderr.write('lightpanda: no instance for this session\n');
  process.exit(0);
}
const be = getBackend(st.backend);
// Keep the state record when stop fails, so that a later stop can find the instance.
if (be && !be.stop(st)) {
  process.stderr.write(`lightpanda: could not stop instance ${key}\n`);
  process.exit(1);
}
removeState(key);
process.stderr.write(`lightpanda: stopped instance ${key}\n`);
