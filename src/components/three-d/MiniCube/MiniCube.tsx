import type { CSSProperties } from 'react'
import { cx } from '../../../utils/cx'
import styles from './MiniCube.module.css'

const tones = {
  yellow: { top: '#FFD24D', front: '#F6B400', side: '#D99A00' },
  blue: { top: '#1A4FB0', front: '#0A3A8F', side: '#002870' },
}

type MiniCubeProps = {
  size?: number
  tone?: keyof typeof tones
  delay?: number
  className?: string
}

export function MiniCube({ size = 34, tone = 'yellow', delay = 0, className }: MiniCubeProps) {
  const half = size / 2
  const t = tones[tone]
  const face = (transform: string, background: string): CSSProperties => ({ transform, background })

  return (
    <span className={cx(styles.wrap, className)} style={{ width: size, height: size }} aria-hidden="true">
      <span className={styles.cube} style={{ animationDelay: `${delay}s` }}>
        <span className={styles.face} style={face(`translateZ(${half}px)`, t.front)} />
        <span className={styles.face} style={face(`rotateY(180deg) translateZ(${half}px)`, t.front)} />
        <span className={styles.face} style={face(`rotateY(90deg) translateZ(${half}px)`, t.side)} />
        <span className={styles.face} style={face(`rotateY(-90deg) translateZ(${half}px)`, t.side)} />
        <span className={styles.face} style={face(`rotateX(90deg) translateZ(${half}px)`, t.top)} />
        <span className={styles.face} style={face(`rotateX(-90deg) translateZ(${half}px)`, t.side)} />
      </span>
    </span>
  )
}
