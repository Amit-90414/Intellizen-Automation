import { spawn } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, statSync, writeFileSync } from 'node:fs'
import { createServer } from 'node:http'
import { tmpdir } from 'node:os'
import { join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'

const assets = fileURLToPath(new URL('../public/assets/', import.meta.url))
const force = process.argv.includes('--force')
const quality = 0.8

const sources = [
  ...readdirSync(join(assets, 'products'), { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .flatMap((entry) => readdirSync(join(assets, 'products', entry.name)).filter((name) => /^render-\d+\.jpg$/.test(name)).map((name) => join(assets, 'products', entry.name, name))),
  ...readdirSync(join(assets, 'blog')).filter((name) => name.endsWith('.jpg')).map((name) => join(assets, 'blog', name)),
]

const sizes = [
  ['-xs', 480],
  ['-md', 800],
  ['-sm', 1200],
  ['', 0],
]

const outputs = (file) => sizes.map(([suffix, width]) => [file.replace(/\.jpg$/, `${suffix}.webp`), width])
const fresh = (file) => outputs(file).every(([out]) => existsSync(out) && (process.env.CI || statSync(out).mtimeMs >= statSync(file).mtimeMs))
const todo = force ? sources : sources.filter((file) => !fresh(file))

if (todo.length === 0) {
  console.log(`image variants up to date (${sources.length} sources)`)
  process.exit(0)
}

const browser = [
  process.env.BROWSER_PATH,
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  '/usr/bin/google-chrome',
  '/usr/bin/chromium',
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
].filter(Boolean).find((path) => existsSync(path))

if (!browser) {
  console.warn('image variants skipped: no Edge or Chrome found (set BROWSER_PATH)')
  process.exit(0)
}

const server = createServer((request, response) => {
  const file = join(assets, decodeURIComponent(new URL(request.url, 'http://localhost').pathname))
  if (!file.startsWith(assets) || !existsSync(file) || !statSync(file).isFile()) {
    response.writeHead(200, { 'content-type': 'text/html' })
    response.end('<!doctype html><title>variants</title>')
    return
  }
  response.writeHead(200, { 'content-type': 'image/jpeg' })
  response.end(readFileSync(file))
})
await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve))
const origin = `http://127.0.0.1:${server.address().port}`

const work = process.env.RENDER_TMP || (existsSync('D:/') ? 'D:/personalProjecct/.render-tmp' : tmpdir())
mkdirSync(work, { recursive: true })
const profile = mkdtempSync(join(work, 'variants-'))
const port = 9400 + Math.floor(Math.random() * 150)
const proc = spawn(browser, ['--headless=new', '--no-first-run', ...(process.env.CI ? ['--no-sandbox'] : []), `--remote-debugging-port=${port}`, `--user-data-dir=${profile}`, 'about:blank'], { stdio: 'ignore' })
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

await send('Page.navigate', { url: origin + '/' })
await sleep(500)

const encode = (url, widths) => `(async () => {
  const blob = await (await fetch(${JSON.stringify(url)})).blob()
  const source = await createImageBitmap(blob)
  const out = []
  for (const width of ${JSON.stringify(widths)}) {
    const w = width && width < source.width ? width : source.width
    const h = Math.round(source.height * (w / source.width))
    const bitmap = w === source.width ? source : await createImageBitmap(blob, { resizeWidth: w, resizeHeight: h, resizeQuality: 'high' })
    const canvas = new OffscreenCanvas(w, h)
    canvas.getContext('2d').drawImage(bitmap, 0, 0)
    const webp = await canvas.convertToBlob({ type: 'image/webp', quality: ${quality} })
    const bytes = new Uint8Array(await webp.arrayBuffer())
    let binary = ''
    for (let i = 0; i < bytes.length; i += 0x8000) binary += String.fromCharCode(...bytes.subarray(i, i + 0x8000))
    out.push(btoa(binary))
  }
  return out
})()`

let saved = 0
for (const file of todo) {
  const url = origin + '/' + relative(assets, file).split('\\').join('/')
  const targetsFor = outputs(file)
  const result = await send('Runtime.evaluate', { expression: encode(url, targetsFor.map(([, width]) => width)), awaitPromise: true, returnByValue: true })
  const encoded = result.result.result?.value
  if (!encoded) throw new Error(`Could not convert ${file}: ${JSON.stringify(result.result.exceptionDetails?.exception?.description ?? '')}`)
  targetsFor.forEach(([out], i) => {
    const data = Buffer.from(encoded[i], 'base64')
    writeFileSync(out, data)
    saved += data.length
  })
  console.log(`webp ${relative(assets, file)}`)
}

ws.close()
proc.kill()
server.close()
await sleep(1000)
try {
  rmSync(profile, { recursive: true, force: true, maxRetries: 10, retryDelay: 500 })
} catch {}
console.log(`wrote ${todo.length * sizes.length} webp files (${Math.round(saved / 1024)} KB)`)
