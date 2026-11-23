import { spawn } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, statSync, writeFileSync } from 'node:fs'
import { createServer } from 'node:http'
import { tmpdir } from 'node:os'
import { extname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const dist = fileURLToPath(new URL('../dist/', import.meta.url))
const candidates = [
  process.env.BROWSER_PATH,
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  '/usr/bin/google-chrome',
  '/usr/bin/chromium',
  '/usr/bin/chromium-browser',
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
].filter(Boolean)
const browser = candidates.find((path) => existsSync(path))

if (!browser) {
  console.warn('prerender skipped: no Edge or Chrome found (set BROWSER_PATH to enable it)')
  writeFileSync(join(dist, '_redirects'), '/*    /index.html   200\n')
  process.exit(0)
}

const shell = readFileSync(join(dist, 'index.html'), 'utf8')
writeFileSync(join(dist, 'app.html'), shell)

const sitemap = readFileSync(join(dist, 'sitemap.xml'), 'utf8')
const routes = [...sitemap.matchAll(/<loc>https?:\/\/[^/]+(\/[^<]*)<\/loc>/g)].map((match) => match[1])

const types = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.mp4': 'video/mp4',
  '.xml': 'application/xml',
  '.txt': 'text/plain',
}

const server = createServer((request, response) => {
  const pathname = decodeURIComponent(new URL(request.url, 'http://localhost').pathname)
  const file = join(dist, pathname)
  if (pathname !== '/' && existsSync(file) && statSync(file).isFile()) {
    response.writeHead(200, { 'content-type': types[extname(file)] ?? 'application/octet-stream' })
    response.end(readFileSync(file))
    return
  }
  response.writeHead(200, { 'content-type': types['.html'] })
  response.end(shell)
})
await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve))
const origin = `http://127.0.0.1:${server.address().port}`

const port = 9600 + Math.floor(Math.random() * 150)
const profile = mkdtempSync(join(tmpdir(), 'prerender-'))
const proc = spawn(browser, ['--headless=new', '--no-first-run', '--hide-scrollbars', ...(process.env.CI ? ['--no-sandbox'] : []), `--remote-debugging-port=${port}`, `--user-data-dir=${profile}`, 'about:blank'], { stdio: 'ignore' })
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

let targets = []
for (let i = 0; i < 75 && targets.length === 0; i++) {
  try {
    targets = (await (await fetch(`http://127.0.0.1:${port}/json/list`)).json()).filter((t) => t.type === 'page')
  } catch {
    await sleep(200)
  }
}
if (targets.length === 0) throw new Error('Browser did not start')

const ws = new WebSocket(targets[0].webSocketDebuggerUrl)
await new Promise((resolve) => ws.addEventListener('open', resolve))
let id = 0
const pending = new Map()
ws.addEventListener('message', (event) => {
  const message = JSON.parse(event.data)
  if (message.id && pending.has(message.id)) {
    pending.get(message.id)(message)
    pending.delete(message.id)
  }
})
const send = (method, params = {}) =>
  new Promise((resolve) => {
    const next = ++id
    pending.set(next, resolve)
    ws.send(JSON.stringify({ id: next, method, params }))
  })
const evaluate = async (expression) => (await send('Runtime.evaluate', { expression, awaitPromise: true, returnByValue: true })).result.result?.value

const snapshot = `(() => {
  const head = document.head
  const managed = 'title, meta[name="description"], meta[name="robots"], link[rel="canonical"], meta[property^="og:"]:not([property="og:locale"]), meta[name^="twitter:"], meta[property^="article:"], script[type="application/ld+json"]'
  for (const node of head.querySelectorAll(managed)) node.setAttribute('data-prerender', '')
  for (const node of document.querySelectorAll('#root [style]')) {
    node.style.removeProperty('opacity')
    node.style.removeProperty('transform')
    node.style.removeProperty('visibility')
    if (!node.getAttribute('style')) node.removeAttribute('style')
  }
  for (const node of document.querySelectorAll('#root video')) node.remove()
  return '<!doctype html>\\n' + document.documentElement.outerHTML
})()`

await send('Page.enable')
await send('Emulation.setDeviceMetricsOverride', { width: 1440, height: 900, deviceScaleFactor: 1, mobile: false })

const pages = [...routes.map((route) => [route, route === '/' ? join(dist, 'index.html') : join(dist, route, 'index.html')]), ['/404', join(dist, '404.html')]]

for (const [route, target] of pages) {
  await send('Page.navigate', { url: origin + route })
  for (let i = 0; i < 60; i++) {
    if (await evaluate(`!!document.querySelector('main h1') && document.title.length > 0`)) break
    await sleep(150)
  }
  await sleep(1200)
  const html = (await evaluate(snapshot)).split(origin).join('')
  if (html.includes('127.0.0.1') || html.includes('localhost:')) throw new Error(`Local address left in ${route}`)
  mkdirSync(join(target, '..'), { recursive: true })
  writeFileSync(target, html)
  console.log(`prerendered ${route}`)
}

ws.close()
proc.kill()
server.close()
await sleep(1500)
rmSync(profile, { recursive: true, force: true, maxRetries: 10, retryDelay: 500 })
console.log(`prerendered ${pages.length} pages`)
