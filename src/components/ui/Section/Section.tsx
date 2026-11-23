import type { ReactNode } from 'react'
import { cx } from '../../../utils/cx'
import { Container } from '../Container/Container'
import styles from './Section.module.css'

type SectionProps = {
  children: ReactNode
  tone?: 'white' | 'sky'
  id?: string
  labelledBy?: string
  className?: string
}

export function Section({ children, tone = 'white', id, labelledBy, className }: SectionProps) {
  return (
    <section id={id} aria-labelledby={labelledBy} className={cx(styles.section, styles[tone], className)}>
      <Container>{children}</Container>
    </section>
  )
}
