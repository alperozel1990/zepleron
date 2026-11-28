// Oyun duman testi: headless Chromium + CDP, telefon emülasyonu. Adımlar komut satırından verilir.
//   node oyun-duman.mjs <url> <çıktı klasörü> <adım...>
//   adımlar: wait:<ms> | shot:<ad> | tap:<x>,<y> | reload | eval:<js> | size:<w>x<h>
// Konsol hataları, başarısız istekler ve her eval sonucu stdout'a yazılır. Profil koşu boyunca aynıdır (reload = kayıt testi).
import { spawn } from 'node:child_process';
import { mkdtempSync, rmSync, writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
const BIN = '/data/data/com.termux/files/usr/bin/chromium-browser';
const [url, outDir, ...steps] = process.argv.slice(2);
mkdirSync(outDir, { recursive: true });
const dir = mkdtempSync(join(process.env.TMPDIR, 'duman-'));
const proc = spawn(BIN, ['--headless=new', '--no-sandbox', '--remote-debugging-port=0', `--user-data-dir=${dir}`, '--window-size=412,915',
  '--mute-audio', '--no-first-run', '--enable-unsafe-swiftshader', '--ignore-gpu-blocklist', '--disable-background-timer-throttling',
  '--disable-renderer-backgrounding', ...(process.env.DUMAN_FLAGS ? process.env.DUMAN_FLAGS.split(' ') : []), 'about:blank'], { stdio: ['ignore', 'ignore', 'pipe'] });
const sleep = ms => new Promise(r => setTimeout(r, ms));
try {
  const wsUrl = await new Promise((ok, fail) => { let err = ''; const t = setTimeout(() => fail(new Error('chromium başlamadı')), 30000);
    proc.stderr.on('data', d => { err += d; const m = /DevTools listening on (ws:\/\/\S+)/.exec(err); if (m) { clearTimeout(t); ok(m[1]); } }); });
  const port = new URL(wsUrl).port;
  const page = (await (await fetch(`http://127.0.0.1:${port}/json/list`)).json()).find(t => t.type === 'page');
  const ws = new WebSocket(page.webSocketDebuggerUrl);
  await new Promise((ok, fail) => { ws.onopen = ok; ws.onerror = fail; });
  let id = 0; const pending = new Map();
  const send = (method, params = {}) => new Promise((ok, fail) => { const n = ++id; pending.set(n, { ok, fail }); ws.send(JSON.stringify({ id: n, method, params })); });
  ws.onmessage = m => { const msg = JSON.parse(m.data);
    if (msg.id && pending.has(msg.id)) { const { ok, fail } = pending.get(msg.id); pending.delete(msg.id); msg.error ? fail(new Error(msg.error.message)) : ok(msg.result); return; }
    const p = msg.params;
    if (msg.method === 'Runtime.exceptionThrown') console.log('JS HATA:', (p.exceptionDetails.exception?.description || p.exceptionDetails.text).slice(0, 300));
    if (msg.method === 'Runtime.consoleAPICalled' && (p.type === 'error' || p.type === 'warning')) console.log('konsol', p.type + ':', p.args.map(a => a.value ?? a.description ?? '').join(' ').slice(0, 300));
    if (msg.method === 'Network.loadingFailed' && !p.canceled) console.log('İSTEK BAŞARISIZ:', p.errorText, reqs.get(p.requestId) || '');
    if (msg.method === 'Network.requestWillBeSent') reqs.set(p.requestId, p.request.url.slice(0, 140));
    if (msg.method === 'Network.responseReceived' && p.response.status >= 400) console.log('HTTP', p.response.status, p.response.url.slice(0, 140)); };
  const reqs = new Map();
  await send('Runtime.enable'); await send('Network.enable'); await send('Page.enable');
  let W = 412, H = 915;
  const metrics = () => send('Emulation.setDeviceMetricsOverride', { width: W, height: H, deviceScaleFactor: 2, mobile: true, screenOrientation: { type: W > H ? 'landscapePrimary' : 'portraitPrimary', angle: W > H ? 90 : 0 } });
  await metrics(); await send('Emulation.setTouchEmulationEnabled', { enabled: true, maxTouchPoints: 5 });
  await send('Emulation.setUserAgentOverride', { userAgent: 'Mozilla/5.0 (Linux; Android 16; SM-S721B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36' });
  await send('Page.navigate', { url });
  for (const s of steps) {
    const [k, v = ''] = [s.slice(0, s.indexOf(':') < 0 ? s.length : s.indexOf(':')), s.indexOf(':') < 0 ? '' : s.slice(s.indexOf(':') + 1)];
    if (k === 'wait') await sleep(+v);
    else if (k === 'shot') { const r = await send('Page.captureScreenshot', { format: 'jpeg', quality: 70 }); writeFileSync(join(outDir, v + '.jpg'), Buffer.from(r.data, 'base64')); console.log('görüntü', v + '.jpg'); }
    else if (k === 'tap') { const [x, y] = v.split(',').map(Number);
      await send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [{ x, y }] }); await sleep(60);
      await send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] }); console.log('dokun', x, y); await sleep(250); }
    else if (k === 'reload') { await send('Page.reload'); console.log('yeniden yüklendi'); }
    else if (k === 'size') { [W, H] = v.split('x').map(Number); await metrics(); console.log('boyut', W, H); }
    else if (k === 'eval') { const r = await send('Runtime.evaluate', { expression: v, returnByValue: true, awaitPromise: true }); console.log('eval:', JSON.stringify(r.result.value ?? r.exceptionDetails?.text).slice(0, 1500)); }
  }
  ws.close();
} finally { proc.kill('SIGKILL'); try { rmSync(dir, { recursive: true, force: true }); } catch {} }
