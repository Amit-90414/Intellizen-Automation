import { Link } from 'react-router'
import { cx } from '../../../utils/cx'
import { ToneDot, type Tone } from '../ToneBadge/ToneBadge'
import styles from './FilterChips.module.css'

type FilterOption = {
  key: string
  label: string
  count?: number
  tone?: Tone
  to?: string
}

type FilterChipsProps = {
  options: FilterOption[]
  label: string
  value?: string
  onChange?: (key: string) => void
}

export function FilterChips({ options, label, value, onChange }: FilterChipsProps) {
  const chips = options.map((option) => {
    const content = (
      <>
        {option.tone && <ToneDot tone={option.tone} />}
        {option.label}
        {option.count !== undefined && <span className={styles.count}>{option.count}</span>}
      </>
    )

    if (option.to) {
      return (
        <Link key={option.key} to={option.to} className={styles.filter}>
          {content}
        </Link>
      )
    }

    return (
      <button
        key={option.key}
        type="button"
        className={cx(styles.filter, value === option.key && styles.active)}
        aria-pressed={value === option.key}
        onClick={() => onChange?.(option.key)}
      >
        {content}
      </button>
    )
  })

  if (onChange) {
    return (
      <div className={styles.filters} role="group" aria-label={label}>
        {chips}
      </div>
    )
  }

  return (
    <nav className={styles.filters} aria-label={label}>
      {chips}
    </nav>
  )
}
