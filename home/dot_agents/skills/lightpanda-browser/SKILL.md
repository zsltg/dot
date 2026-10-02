---
name: lightpanda-browser
description: >-
  Drive a lightweight Lightpanda headless browser over CDP for browser automation, testing,
  e2e, and scraping — instead of launching Chrome/Chromium via Playwright. Reuses one
  Lightpanda instance per session (agent- and platform-agnostic: Linux, macOS, Windows). Use
  whenever a task needs to navigate pages, fill forms, click, extract DOM/content, or run
  browser tests headlessly. Fall back to real Chrome only when a test needs full rendering,
  CORS, or Chrome-specific APIs Lightpanda lacks.
allowed-tools: [Bash, Read, Write, Edit]
---

# lightpanda-browser

Use [Lightpanda](https://github.com/lightpanda-io/browser) — a fast, low-memory headless browser
that speaks the Chrome DevTools Protocol — as the browser engine for automation and tests,
instead of spinning up a full Chrome/Chromium. One instance is started per session and reused.

## 1. Get the shared endpoint

Always obtain the endpoint through the helper — never start `lightpanda serve` by hand:

```bash
LP_WS="$(node ~/.agents/skills/lightpanda-browser/scripts/lp-ensure.mjs)"
```

- First call in a session: starts the instance and downloads the runtime if needed.
- Every later call: returns the **same** `ws://127.0.0.1:<port>` instantly (reuse).
- Runtime backend is chosen automatically: the native nightly binary on Linux/macOS, the
  `lightpanda/browser:nightly` Docker image on Windows. Override with
  `LIGHTPANDA_BACKEND=native|docker`.

## 2. Connect and drive

Default to **puppeteer-core** (most reliable with Lightpanda); Playwright also works with
caveats. Use `-core` packages so no Chromium is downloaded. Copy-paste snippets and the
works/not-yet matrix are in [`references/connect.md`](references/connect.md).

Minimal check (needs `puppeteer-core` on the module path — `npm i puppeteer-core` in the project,
or run from a dir where `npx -y puppeteer-core` has resolved it):

```bash
LP_WS="$LP_WS" node -e 'const p=require("puppeteer-core");(async()=>{const b=await p.connect({browserWSEndpoint:process.env.LP_WS});const pg=await b.newPage();await pg.goto("https://example.com");console.log(await pg.title());await b.disconnect();})()'
```

Prefer `disconnect()` over `close()` so the shared server survives for the next step.

## 3. Limitations and fallback

Lightpanda does not yet do full visual rendering, CORS, or every Chrome-specific network/perf
API (see the matrix in `references/connect.md`). When a task genuinely needs one of those, say
so and fall back to real Chrome/Chromium via Playwright — do not silently return a wrong result.

## 4. Teardown

Normally leave the instance running; it is auto-reaped once its owning session ends or after an
idle timeout (`LIGHTPANDA_IDLE_TTL` seconds, default 1800). To force a clean restart:

```bash
node ~/.agents/skills/lightpanda-browser/scripts/lp-stop.mjs
```

## Notes

- **Per-session reuse** is keyed agent-agnostically: `LIGHTPANDA_SESSION_KEY` override →
  a known agent's session id (e.g. `CLAUDE_CODE_SESSION_ID`) → POSIX session+tty (unix) →
  user+cwd hash. Under a recognised agent it is exactly one instance per session on every OS.
- Cleanup is self-contained (lazy reaping in `lp-ensure.mjs`); no hooks or settings changes.
- The nightly runtime tracks upstream; pin a release tag in `scripts/lp-lib.mjs` (`NIGHTLY`,
  `DOCKER_IMAGE`) if you need reproducibility.
