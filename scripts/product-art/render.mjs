import { spawn } from 'node:child_process'
import { existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'

const args = process.argv.slice(2)
const flags = Object.fromEntries(
  args
    .filter((a) => a.startsWith('--'))
    .map((a) => {
      const [key, value = 'true'] = a.slice(2).split('=')
      return [key, value]
    }),
)
const only = args.filter((a) => !a.startsWith('--'))
const preview = 'preview' in flags
const shotFilter = flags.shot ? flags.shot.split(',').map(Number) : null
const workDir = process.env.RENDER_TMP ?? 'D:/personalProjecct/.render-tmp'
const outDir = flags.out ?? (preview ? join(workDir, 'preview') : fileURLToPath(new URL('../../public/assets/', import.meta.url)))
const browser = process.env.BROWSER_PATH ?? 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
const page = pathToFileURL(fileURLToPath(new URL('./scenes.html', import.meta.url))).href
const read = (file) => readFileSync(new URL(file, import.meta.url), 'utf8')
const source = (scene) => [read('./shader/prelude.glsl'), read('./shader/lib.glsl'), read(`./scenes/${scene}.glsl`), read('./shader/engine.glsl')].join('\n')
const sceneDir = new URL('./scenes/', import.meta.url)
const products = Object.fromEntries(
  readdirSync(sceneDir)
    .filter((f) => f.endsWith('.json') && f !== 'blog-covers.json')
    .map((f) => [f.replace(/.json$/, ''), JSON.parse(readFileSync(new URL(f, sceneDir), 'utf8'))]),
)
const blogCovers = existsSync(new URL('blog-covers.json', sceneDir)) ? JSON.parse(readFileSync(new URL('blog-covers.json', sceneDir), 'utf8')) : {}
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

const port = 9300 + Math.floor(Math.random() * 600)
mkdirSync(workDir, { recursive: true })
const profile = mkdtempSync(join(workDir, 'product-art-'))
const proc = spawn(
  browser,
  ['--headless=new', '--no-first-run', '--enable-gpu', '--ignore-gpu-blocklist', `--use-angle=${flags.angle ?? 'd3d11'}`, '--disable-gpu-watchdog', '--disable-renderer-backgrounding', '--disable-background-timer-throttling', '--disable-backgrounding-occluded-windows', `--remote-debugging-port=${port}`, `--user-data-dir=${profile}`, 'about:blank'],
  { stdio: 'ignore' },
)

let targets = []
for (let i = 0; i < 100 && targets.length === 0; i++) {
  try {
    targets = (await (await fetch(`http://127.0.0.1:${port}/json/list`)).json()).filter((t) => t.type === 'page')
  } catch {
    await sleep(200)
  }
}
if (targets.length === 0) throw new Error('Browser did not start')

for (const signal of ['SIGINT', 'SIGTERM']) process.on(signal, () => {
  proc.kill()
  process.exit(1)
})
process.on('exit', () => proc.kill())

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
const evaluate = async (expression) => {
  const response = await send('Runtime.evaluate', { expression, awaitPromise: true, returnByValue: true })
  if (response.result.exceptionDetails) throw new Error(response.result.exceptionDetails.exception?.description ?? JSON.stringify(response.result.exceptionDetails))
  return response.result.result.value
}

const write = (file, base64) => {
  const target = join(outDir, file)
  mkdirSync(dirname(target), { recursive: true })
  const bytes = Buffer.from(base64, 'base64')
  writeFileSync(target, bytes)
  return Math.round(bytes.length / 1024)
}

const sub = (a, b) => a.map((v, i) => v - b[i])
const len = (a) => Math.hypot(...a)

const settings = (shot, w, h, product, index) => {
  const focusPoint = shot.focusAt ?? shot.ta
  const ww = sub(shot.ta, shot.ro).map((v) => v / len(sub(shot.ta, shot.ro)))
  const focus = sub(focusPoint, shot.ro).reduce((s, v, i) => s + v * ww[i], 0)
  const azimuth = Math.atan2(shot.ro[0] - shot.ta[0], shot.ro[2] - shot.ta[2])
  const room = shot.room ?? product.room ?? [
    Math.min(shot.ro[0], shot.ta[0]) - 7000,
    Math.max(shot.ro[0], shot.ta[0]) + 7000,
    Math.min(shot.ro[2], shot.ta[2]) - 6000,
    Math.max(shot.ro[2], shot.ta[2]) + 5000,
  ]
  return {
    w,
    h,
    ro: shot.ro,
    ta: shot.ta,
    lens: shot.lens ?? 1.4,
    focus,
    aperture: shot.aperture ?? focus * 0.006,
    yaw: -(azimuth - 0.6155) + ((shot.light ?? 0) * Math.PI) / 180,
    roll: ((shot.roll ?? [0.5, -0.35, 0.25, -0.6][index % 4]) * Math.PI) / 180,
    room,
    ceil: product.ceil ?? 7500,
    lane: shot.lane ?? product.lane ?? [room[2] + 2300, 900],
    variant: shot.variant ?? 0,
    exposure: shot.exposure ?? product.exposure ?? 0.72,
    grain: shot.grain ?? 1,
    samples: Number(flags.samples ?? (preview ? 4 : shot.samples ?? 24)),
    tile: Number(flags.tile ?? 64),
    quality: 0.9,
  }
}

await send('Page.enable')
await send('Page.navigate', { url: page })
await sleep(700)
console.log('gpu:', await evaluate('window.gpu()'))

const jobs = []
for (const [slug, product] of Object.entries(products)) {
  if (only.length && !only.includes(slug)) continue
  product.shots.forEach((shot, index) => {
    if (shotFilter && !shotFilter.includes(index + 1)) return
    jobs.push({ scene: product.scene ?? slug, product, index, shot, file: preview ? `${slug}-${index + 1}.jpg` : `products/${slug}/render-${index + 1}.jpg`, small: !preview, w: 2400, h: 1650 })
  })
}
for (const [name, cover] of Object.entries(blogCovers)) {
  if (!only.includes(name) && !(only.length === 0 && !preview)) continue
  jobs.push({ scene: cover.scene, product: products[cover.scene] ?? {}, index: 0, shot: cover.shot, file: preview ? `${name}.jpg` : cover.file, small: false, w: 1600, h: 1100 })
}

let loaded = null
for (const job of jobs) {
  if (loaded !== job.scene) {
    const ms = await evaluate(`window.load(${JSON.stringify(source(job.scene))})`)
    loaded = job.scene
    console.log(`scene ${job.scene} compiled in ${ms} ms`)
  }
  const width = Number(flags.width ?? (preview ? 960 : Math.round(job.w * Number(flags.scale ?? 0.84))))
  const height = Math.round((width * job.h) / job.w)
  const o = settings(job.shot, width, height, job.product, job.index)
  const result = await evaluate(`window.shoot(${JSON.stringify({ ...o, outW: preview ? width : job.w, smallW: job.small ? job.w / 2 : 0 })})`)
  const kb = write(job.file, result.full)
  const smallKb = result.small ? write(job.file.replace(/\.jpg$/, '-sm.jpg'), result.small) : 0
  console.log(`${job.file.padEnd(58)} ${String(result.ms).padStart(7)} ms ${String(kb).padStart(5)} KB${smallKb ? ` / ${smallKb} KB` : ''}`)
}

ws.close()
proc.kill()
if (proc.exitCode === null) await new Promise((resolve) => proc.once('exit', resolve))
await sleep(500)
try {
  rmSync(profile, { recursive: true, force: true, maxRetries: 8, retryDelay: 400 })
} catch {
  console.log(`profile left at ${profile}`)
}
