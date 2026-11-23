import { spawn } from 'node:child_process'
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'

const browser = process.env.BROWSER_PATH ?? 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const scenesPage = pathToFileURL(fileURLToPath(new URL('./scenes.html', import.meta.url))).href
const outDir = fileURLToPath(new URL('../../public/assets/hero/', import.meta.url))
const scenes = ['circuit', 'blueprint', 'conveyor', 'scan', 'bokeh']
const only = process.argv.slice(2)
const port = 9400 + Math.floor(Math.random() * 400)
const profile = mkdtempSync(join(tmpdir(), 'hero-videos-'))

mkdirSync(outDir, { recursive: true })

const proc = spawn(browser, ['--headless=new', '--no-first-run', '--hide-scrollbars', `--remote-debugging-port=${port}`, `--user-data-dir=${profile}`, 'about:blank'], { stdio: 'ignore' })
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

await send('Page.enable')
await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false })
await send('Page.navigate', { url: scenesPage })
await sleep(800)

for (const [index, name] of scenes.entries()) {
  if (only.length > 0 && !only.includes(name)) continue
  const response = await send('Runtime.evaluate', { expression: `window.recordScene('${name}')`, awaitPromise: true, returnByValue: true })
  const result = response.result.result?.value
  if (!result) throw new Error(`Recording ${name} failed: ${JSON.stringify(response.result.exceptionDetails ?? response)}`)
  const file = `hero-${index + 1}`
  writeFileSync(join(outDir, `${file}.mp4`), Buffer.from(result.video, 'base64'))
  writeFileSync(join(outDir, `${file}.jpg`), Buffer.from(result.poster, 'base64'))
  console.log(`${file}.mp4  ${name.padEnd(10)} ${result.seconds}s  ${(result.bytes / 1024).toFixed(0)} KB`)
}

ws.close()
proc.kill()
await sleep(500)
rmSync(profile, { recursive: true, force: true })
