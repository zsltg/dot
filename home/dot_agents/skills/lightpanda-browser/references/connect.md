# Connecting to the session's Lightpanda instance

`lp-ensure.mjs` prints one line: the CDP WebSocket endpoint, e.g. `ws://127.0.0.1:51544`.
Everything below assumes you captured it.

```bash
LP_WS="$(node ~/.agents/skills/lightpanda-browser/scripts/lp-ensure.mjs)"
LP_HTTP="${LP_WS/ws:/http:}"        # same host:port, http scheme
curl -s "$LP_HTTP/json/version"     # sanity check -> JSON
```

Use the `-core` driver packages so **no Chromium is downloaded** — Lightpanda is the browser.

## Puppeteer (recommended)

Most reliable path with Lightpanda today.

```js
// npx -y puppeteer-core   (or add puppeteer-core to your project)
import puppeteer from 'puppeteer-core';

const browser = await puppeteer.connect({ browserWSEndpoint: process.env.LP_WS });
const page = await browser.newPage();
await page.goto('https://example.com', { waitUntil: 'domcontentloaded' });
console.log(await page.title());
await browser.disconnect();          // leave the shared server running for reuse
```

Run it: `LP_WS="$LP_WS" node script.mjs`. Prefer `browser.disconnect()` over
`browser.close()` so the per-session server stays up for the next call.

## Playwright (works, with caveats)

Playwright probes for Chrome internals that Lightpanda doesn't fully implement, so basic
navigation/DOM works but some features may fail; a segfault on certain CDP connects is tracked
upstream (lightpanda-io/browser#384). Connect over the **http** endpoint:

```js
// npx -y playwright-core
import { chromium } from 'playwright-core';

const browser = await chromium.connectOverCDP(process.env.LP_HTTP);
const page = await (browser.contexts()[0] ?? await browser.newContext()).newPage();
await page.goto('https://example.com');
console.log(await page.title());
await browser.close();
```

If a Playwright script misbehaves against Lightpanda, switch that test to Puppeteer, or fall
back to real Chrome (see limitations).

## What works vs. not yet

| Works | Not yet / partial |
| --- | --- |
| Navigation, DOM tree & queries | Full visual rendering fidelity |
| Click, form fill, evaluate JS (V8) | CORS (upstream #2015) |
| XHR / Fetch, cookies, proxy, request interception | Some Chrome-only network controls |
| Basic screenshots | Some performance metrics |
| `robots.txt` compliance (`--obey-robots`) | Anything relying on Chrome-specific internals |

When a task needs full rendering, CORS, or Chrome-specific APIs, say so and fall back to real
Chrome/Chromium via Playwright rather than trusting a wrong result.
