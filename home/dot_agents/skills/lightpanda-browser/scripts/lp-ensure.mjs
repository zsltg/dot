#!/usr/bin/env node
// Ensure a per-session Lightpanda CDP server is running and print its ws:// endpoint.
//
// Idempotent: the first call in a session starts the instance; every later call
// returns the same one. stdout = exactly one line (the ws endpoint). All
// diagnostics go to stderr. Exit 0 = ready, non-zero = failure.

import fs from 'node:fs';
import {
  resolveKey, selectBackend, getBackend, readState, writeState, touchState,
  removeState, runtimeDir, statePath, freePort, waitReady, pidAlive, health,
  sessionLeaderPid,
} from './lp-lib.mjs';

const IDLE_TTL_MS = (Number(process.env.LIGHTPANDA_IDLE_TTL) || 1800) * 1000; // default 30m

function endpoint(port) {
  return `ws://127.0.0.1:${port}`;
}

// Reap other sessions' abandoned instances: owner process gone, or idle past TTL.
// Never touches the current key or a live+fresh instance.
function reapStale(currentKey) {
  let names;
  try {
    names = fs.readdirSync(runtimeDir()).filter((f) => f.endsWith('.json'));
  } catch {
    return;
  }
  const now = Date.now();
  for (const name of names) {
    const key = name.slice(0, -'.json'.length);
    if (key === currentKey) continue;
    const st = readState(key);
    if (!st) continue;
    let mtime = 0;
    try {
      mtime = fs.statSync(statePath(key)).mtimeMs;
    } catch {
      /* ignore */
    }
    const ownerDead = st.ownerPid != null && !pidAlive(st.ownerPid);
    const idle = now - mtime > IDLE_TTL_MS;
    if (ownerDead || idle) {
      // Reap with the backend that actually started it, not the current default.
      const be = getBackend(st.backend);
      try {
        if (be) be.stop(st);
      } catch {
        /* ignore */
      }
      removeState(key);
      process.stderr.write(`lightpanda: reaped stale instance ${key}\n`);
    }
  }
}

async function main() {
  const key = resolveKey();
  const backend = selectBackend();

  // 1. Reuse an existing healthy instance for this session.
  const existing = readState(key);
  if (existing && backend.alive(existing) && (await health(existing.port))) {
    touchState(key);
    process.stdout.write(endpoint(existing.port) + '\n');
    return;
  }
  if (existing) {
    // Stale/dead record for our own key: clean it before starting fresh.
    try {
      backend.stop(existing);
    } catch {
      /* ignore */
    }
    removeState(key);
  }

  // 2. Opportunistically reap other sessions' leftovers.
  reapStale(key);

  // 3. Ensure the runtime (download binary / pull image) and start detached.
  await backend.ensureRuntime();
  const port = await freePort();
  const started = backend.start(key, port);
  writeState(key, {
    backend: backend.name,
    port,
    ownerPid: sessionLeaderPid(), // null on Windows -> reaping falls back to idle TTL
    startedAt: new Date().toISOString(),
    ...started,
  });

  // 4. Wait for the CDP server to answer.
  if (!(await waitReady(port))) {
    const tail = backend.logTail(readState(key) || started);
    try {
      backend.stop(readState(key) || started);
    } catch {
      /* ignore */
    }
    removeState(key);
    process.stderr.write(
      `lightpanda: server did not become ready on port ${port}\n${tail}\n`,
    );
    process.exit(1);
  }

  process.stdout.write(endpoint(port) + '\n');
}

main().catch((err) => {
  process.stderr.write(`lightpanda: ${err.message || err}\n`);
  process.exit(1);
});
