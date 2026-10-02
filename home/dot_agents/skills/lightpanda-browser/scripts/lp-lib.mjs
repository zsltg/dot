// Shared library for the lightpanda-browser skill.
//
// Everything platform- and agent-specific lives here so lp-ensure.mjs and
// lp-stop.mjs stay tiny. Pure Node stdlib (plus global fetch on Node >=18) so
// the same code runs unchanged on Linux, macOS and Windows.

import net from 'node:net';
import http from 'node:http';
import os from 'node:os';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { spawn, spawnSync, execFileSync } from 'node:child_process';

// --- session key ------------------------------------------------------------
// Resolve one stable key per agent session, first match wins. This is what
// makes the per-session instance both agent-agnostic and platform-agnostic.
//
//   1. explicit override
//   2. a recognised agent's own session id (perfect 1:1, every OS)
//   3. (unix) POSIX session-leader + tty  -> one instance per terminal session
//   4. user + cwd hash                    -> one instance per project dir
const AGENT_SESSION_VARS = ['CLAUDE_CODE_SESSION_ID', 'TERM_SESSION_ID'];

export function sessionLeaderPid() {
  // The POSIX session leader is stable for the lifetime of the terminal
  // session, unlike this node process's own short-lived parent shell. Returns
  // null where it cannot be determined (e.g. Windows, no controlling tty).
  if (process.platform === 'win32') return null;
  try {
    const out = execFileSync('ps', ['-o', 'sess=', '-p', String(process.pid)], {
      encoding: 'utf8',
    }).trim();
    const pid = parseInt(out, 10);
    return Number.isInteger(pid) && pid > 0 ? pid : null;
  } catch {
    return null;
  }
}

function sanitize(s) {
  // Safe for filenames and docker container names.
  return s.replace(/[^A-Za-z0-9_.-]/g, '_').slice(0, 100) || 'default';
}

export function resolveKey() {
  if (process.env.LIGHTPANDA_SESSION_KEY) {
    return sanitize(process.env.LIGHTPANDA_SESSION_KEY);
  }
  for (const v of AGENT_SESSION_VARS) {
    if (process.env[v]) return sanitize(process.env[v]);
  }
  if (process.platform !== 'win32') {
    const sid = sessionLeaderPid();
    if (sid) {
      let tty = '';
      try {
        tty = execFileSync('ps', ['-o', 'tty=', '-p', String(process.pid)], {
          encoding: 'utf8',
        }).trim();
      } catch {
        /* ignore */
      }
      return sanitize(`posix-${sid}-${tty || 'notty'}`);
    }
  }
  const user = (os.userInfo().username || 'user').toString();
  const cwdHash = crypto.createHash('sha256').update(process.cwd()).digest('hex').slice(0, 8);
  return sanitize(`host-${user}-${cwdHash}`);
}

// --- state files ------------------------------------------------------------
export function runtimeDir() {
  const base = process.env.XDG_RUNTIME_DIR || os.tmpdir();
  const dir = path.join(base, 'lightpanda');
  fs.mkdirSync(dir, { recursive: true, mode: 0o700 });
  return dir;
}

export function statePath(key) {
  return path.join(runtimeDir(), `${key}.json`);
}

export function readState(key) {
  try {
    return JSON.parse(fs.readFileSync(statePath(key), 'utf8'));
  } catch {
    return null;
  }
}

export function writeState(key, obj) {
  const p = statePath(key);
  const tmp = `${p}.${process.pid}.tmp`;
  fs.writeFileSync(tmp, JSON.stringify(obj), { mode: 0o600 });
  fs.renameSync(tmp, p);
}

export function touchState(key) {
  try {
    const now = new Date();
    fs.utimesSync(statePath(key), now, now);
  } catch {
    /* ignore */
  }
}

export function removeState(key) {
  for (const p of [statePath(key), path.join(runtimeDir(), `${key}.log`)]) {
    try {
      fs.unlinkSync(p);
    } catch {
      /* ignore */
    }
  }
}

export function pidAlive(pid) {
  if (!pid) return false;
  try {
    process.kill(pid, 0);
    return true;
  } catch (e) {
    return e.code === 'EPERM'; // exists but not ours
  }
}

// --- networking helpers -----------------------------------------------------
export function freePort() {
  return new Promise((resolve, reject) => {
    const srv = net.createServer();
    srv.once('error', reject);
    srv.listen(0, '127.0.0.1', () => {
      const { port } = srv.address();
      srv.close(() => resolve(port));
    });
  });
}

export function health(port, timeoutMs = 1500) {
  return new Promise((resolve) => {
    const req = http.get(
      { host: '127.0.0.1', port, path: '/json/version', timeout: timeoutMs },
      (res) => {
        res.resume();
        resolve(res.statusCode === 200);
      },
    );
    req.on('error', () => resolve(false));
    req.on('timeout', () => {
      req.destroy();
      resolve(false);
    });
  });
}

export async function waitReady(port, totalMs = 10000) {
  const deadline = Date.now() + totalMs;
  while (Date.now() < deadline) {
    if (await health(port)) return true;
    await new Promise((r) => setTimeout(r, 250));
  }
  return false;
}

// --- backends ---------------------------------------------------------------
// Contract: ensureRuntime(), start(key, port) -> extra state, alive(state),
// stop(state), logTail(state). Platform specifics live entirely in here.

const NIGHTLY = 'https://github.com/lightpanda-io/browser/releases/download/nightly';
const DOCKER_IMAGE = 'lightpanda/browser:nightly';

function assetName() {
  const arch = { x64: 'x86_64', arm64: 'aarch64' }[process.arch];
  const osName = { linux: 'linux', darwin: 'macos' }[process.platform];
  if (!arch || !osName) return null;
  return `lightpanda-${arch}-${osName}`;
}

function cacheBinPath() {
  const base =
    process.env.XDG_DATA_HOME || path.join(os.homedir(), '.local', 'share');
  return path.join(base, 'lightpanda', 'lightpanda');
}

const nativeBackend = {
  name: 'native',
  async ensureRuntime() {
    // Prefer a lightpanda already on PATH, else a previously cached download.
    const onPath = spawnSync(process.platform === 'win32' ? 'where' : 'which', [
      'lightpanda',
    ]);
    if (onPath.status === 0) {
      this._bin = onPath.stdout.toString().split(/\r?\n/)[0].trim();
      return;
    }
    const bin = cacheBinPath();
    if (fs.existsSync(bin)) {
      this._bin = bin;
      return;
    }
    const asset = assetName();
    if (!asset) {
      throw new Error(
        `no lightpanda binary published for ${process.platform}/${process.arch}; ` +
          `set LIGHTPANDA_BACKEND=docker`,
      );
    }
    const url = `${NIGHTLY}/${asset}`;
    process.stderr.write(`lightpanda: downloading ${url}\n`);
    const res = await fetch(url); // follows the GitHub -> S3 redirect
    if (!res.ok) throw new Error(`download failed: HTTP ${res.status}`);
    const buf = Buffer.from(await res.arrayBuffer());
    fs.mkdirSync(path.dirname(bin), { recursive: true });
    const tmp = `${bin}.download`;
    fs.writeFileSync(tmp, buf);
    fs.chmodSync(tmp, 0o755);
    fs.renameSync(tmp, bin);
    this._bin = bin;
  },
  start(key, port) {
    const logFile = path.join(runtimeDir(), `${key}.log`);
    const out = fs.openSync(logFile, 'a');
    const child = spawn(
      this._bin,
      ['serve', '--host', '127.0.0.1', '--port', String(port)],
      {
        detached: true, // own process group -> survives across tool calls
        stdio: ['ignore', out, out],
        windowsHide: true,
        env: { ...process.env, LIGHTPANDA_DISABLE_TELEMETRY: 'true' },
      },
    );
    child.unref();
    fs.closeSync(out);
    return { pid: child.pid, logFile };
  },
  alive(state) {
    return pidAlive(state.pid);
  },
  stop(state) {
    if (!state.pid) return;
    for (const target of [-state.pid, state.pid]) {
      // negative -> kill the whole detached group first
      try {
        process.kill(target, 'SIGTERM');
      } catch {
        /* already gone */
      }
    }
  },
  logTail(state) {
    try {
      return fs.readFileSync(state.logFile, 'utf8').split('\n').slice(-20).join('\n');
    } catch {
      return '';
    }
  },
};

function docker(args, opts = {}) {
  return spawnSync('docker', args, { encoding: 'utf8', ...opts });
}

const dockerBackend = {
  name: 'docker',
  async ensureRuntime() {
    if (docker(['version']).status !== 0) {
      throw new Error('docker is not available; install docker or set LIGHTPANDA_BACKEND=native');
    }
    if (docker(['image', 'inspect', DOCKER_IMAGE]).status !== 0) {
      process.stderr.write(`lightpanda: pulling ${DOCKER_IMAGE}\n`);
      const pull = docker(['pull', DOCKER_IMAGE], { stdio: 'inherit' });
      if (pull.status !== 0) throw new Error('docker pull failed');
    }
  },
  start(key, port) {
    const container = `lp-${key}`;
    docker(['rm', '-f', container]); // clear any stale container of this name
    const run = docker([
      'run', '-d', '--name', container,
      '-p', `127.0.0.1:${port}:9222`,
      '-e', 'LIGHTPANDA_DISABLE_TELEMETRY=true',
      DOCKER_IMAGE,
      'serve', '--host', '0.0.0.0', '--port', '9222', // 0.0.0.0 so the port map is reachable
    ]);
    if (run.status !== 0) throw new Error(`docker run failed: ${run.stderr}`);
    return { container };
  },
  alive(state) {
    const r = docker(['inspect', '-f', '{{.State.Running}}', state.container]);
    return r.status === 0 && r.stdout.trim() === 'true';
  },
  stop(state) {
    if (state.container) docker(['rm', '-f', state.container]);
  },
  logTail(state) {
    const r = docker(['logs', '--tail', '20', state.container]);
    return r.status === 0 ? r.stdout + r.stderr : '';
  },
};

export function getBackend(name) {
  if (name === 'native') return nativeBackend;
  if (name === 'docker') return dockerBackend;
  return null;
}

export function selectBackend() {
  const forced = process.env.LIGHTPANDA_BACKEND;
  if (forced) {
    const be = getBackend(forced);
    if (!be) throw new Error(`unknown LIGHTPANDA_BACKEND=${forced}`);
    return be;
  }
  // Default: native where lightpanda publishes a binary, docker elsewhere (Windows).
  return assetName() ? nativeBackend : dockerBackend;
}
