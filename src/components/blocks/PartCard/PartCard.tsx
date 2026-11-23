import { ArrowRight } from 'lucide-react'
import { Link } from 'react-router'
import type { IconKey } from '../../../data/products'
import { ItemIcon } from '../../ui/ItemIcon/ItemIcon'
import { ToneBadge, type Tone } from '../../ui/ToneBadge/ToneBadge'
import styles from './PartCard.module.css'

type PartCardProps = {
  label: string
  slug: string
  icon: IconKey
  tone: Tone
  detail?: string
}

export function PartCard({ label, slug, icon, tone, detail }: PartCardProps) {
  return (
    <Link to={`/products/${slug}`} className={styles.card}>
      <ToneBadge tone={tone} className={styles.badge}>
        <ItemIcon name={label} fallback={icon} size={22} />
      </ToneBadge>
      <span className={styles.text}>
        <span className={styles.label}>{label}</span>
        {detail && <span className={styles.detail}>{detail}</span>}
      </span>
      <ArrowRight aria-hidden="true" className={styles.arrow} />
    </Link>
  )
}
