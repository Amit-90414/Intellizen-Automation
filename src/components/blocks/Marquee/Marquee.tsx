import type { CSSProperties } from 'react'
import type { IconKey } from '../../../data/products'
import { cx } from '../../../utils/cx'
import { ItemIcon } from '../../ui/ItemIcon/ItemIcon'
import styles from './Marquee.module.css'

export type MarqueeItem = { key: string; label: string; icon: IconKey }

type MarqueeProps = {
  items: MarqueeItem[]
  reverse?: boolean
  seconds?: number
  tone?: 'solid' | 'soft'
  label?: string
}

function Item({ item }: { item: MarqueeItem }) {
  return (
    <li className={styles.item}>
      <span className={styles.chip}>
        <span className={styles.icon}>
          <ItemIcon name={item.label} fallback={item.icon} size={18} />
        </span>
        {item.label}
      </span>
    </li>
  )
}

export function Marquee({ items, reverse = false, seconds = 40, tone = 'solid', label }: MarqueeProps) {
  return (
    <div className={cx(styles.marquee, styles[tone])} style={{ '--duration': `${seconds}s` } as CSSProperties} aria-label={label} role={label ? 'region' : undefined}>
      <div className={cx(styles.track, reverse && styles.reverse)}>
        <ul className={styles.list}>
          {items.map((item) => (
            <Item key={item.key} item={item} />
          ))}
        </ul>
        <ul className={styles.list} aria-hidden="true">
          {items.map((item) => (
            <Item key={item.key} item={item} />
          ))}
        </ul>
      </div>
    </div>
  )
}
