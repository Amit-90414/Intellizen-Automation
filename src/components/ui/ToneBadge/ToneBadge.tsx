import type { ReactNode } from 'react'
import { cx } from '../../../utils/cx'
import styles from './ToneBadge.module.css'

export type Tone = 'blue' | 'green' | 'yellow' | 'navy'

type ToneBadgeProps = {
  tone: Tone
  children: ReactNode
  className?: string
}

export function ToneBadge({ tone, children, className }: ToneBadgeProps) {
  return <span className={cx(styles.badge, styles[tone], className)}>{children}</span>
}

export function ToneDot({ tone }: { tone: Tone }) {
  return <span className={cx(styles.dot, styles[tone])} aria-hidden="true" />
}
