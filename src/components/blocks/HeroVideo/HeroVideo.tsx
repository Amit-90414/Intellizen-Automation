import { useEffect, useRef, useState } from 'react'
import { useReducedMotion } from 'motion/react'
import { heroVideos } from '../../../data/home'
import { useInView } from '../../../hooks/useInView'
import { cx } from '../../../utils/cx'
import styles from './HeroVideo.module.css'

const STORAGE_KEY = 'iz-hero-video'

function readLast() {
  try {
    return Number(window.localStorage.getItem(STORAGE_KEY) ?? -1)
  } catch {
    return -1
  }
}

function remember(index: number) {
  try {
    window.localStorage.setItem(STORAGE_KEY, String(index))
    return true
  } catch {
    return false
  }
}

function pickVideo() {
  const last = readLast()
  let next = Math.floor(Math.random() * heroVideos.length)
  if (next === last && heroVideos.length > 1) {
    next = (next + 1 + Math.floor(Math.random() * (heroVideos.length - 1))) % heroVideos.length
  }
  remember(next)
  return heroVideos[next]
}

const chosen = pickVideo()

type NavigatorWithConnection = Navigator & { connection?: { saveData?: boolean } }

export function HeroVideo({ className }: { className?: string }) {
  const reduce = useReducedMotion()
  const videoRef = useRef<HTMLVideoElement>(null)
  const [wrapRef, inView] = useInView<HTMLDivElement>({ rootMargin: '120px' })
  const [load, setLoad] = useState(false)
  const [ready, setReady] = useState(false)

  useEffect(() => {
    if (reduce || (navigator as NavigatorWithConnection).connection?.saveData) return
    const start = () => setLoad(true)
    if (document.readyState === 'complete') {
      const timer = window.setTimeout(start, 250)
      return () => window.clearTimeout(timer)
    }
    window.addEventListener('load', start, { once: true })
    return () => window.removeEventListener('load', start)
  }, [reduce])

  useEffect(() => {
    const video = videoRef.current
    if (!video) return
    video.muted = true
    if (inView) video.play().catch(() => undefined)
    else video.pause()
  }, [inView, load])

  return (
    <div ref={wrapRef} className={cx(styles.wrap, className)} aria-hidden="true">
      <img src={chosen.poster} alt="" className={styles.media} width={1280} height={720} decoding="async" fetchPriority="high" />
      {load && (
        <video
          ref={videoRef}
          className={cx(styles.media, styles.video, ready && styles.ready)}
          src={chosen.src}
          poster={chosen.poster}
          autoPlay
          muted
          loop
          playsInline
          preload="auto"
          disablePictureInPicture
          disableRemotePlayback
          onPlaying={() => setReady(true)}
        />
      )}
      <span className={styles.veil} />
    </div>
  )
}
