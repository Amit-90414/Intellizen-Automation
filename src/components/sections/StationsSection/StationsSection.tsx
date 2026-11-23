import type { CSSProperties } from 'react'
import { motion, useReducedMotion } from 'motion/react'
import { Link } from 'react-router'
import { stationsSection } from '../../../data/home'
import { IsometricLine } from '../../three-d/IsometricLine/IsometricLine'
import { Container } from '../../ui/Container/Container'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import { SectionHeading } from '../../ui/SectionHeading/SectionHeading'
import styles from './StationsSection.module.css'

const ease = [0.2, 0.7, 0.2, 1] as const

export function StationsSection() {
  const section = stationsSection
  const reduce = useReducedMotion()

  return (
    <section id="line" className={styles.section} aria-labelledby="stations-title">
      <Container>
        <SectionHeading id="stations-title" eyebrow={section.eyebrow} title={section.title} accent={section.accent} text={section.text} />
      </Container>

      <motion.div
        className={styles.showcase}
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ amount: 0.2 }}
        transition={{ duration: 0.8, ease }}
      >
        <IsometricLine />
        <ul className={styles.chips} aria-label={section.chipsLabel}>
          {section.chips.map((chip, i) => (
            <motion.li
              key={chip.slug}
              className={styles.chip}
              style={{ '--i': i } as CSSProperties}
              initial={{ opacity: 0, y: reduce ? 0 : 16 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ amount: 0.5 }}
              transition={{ duration: 0.6, delay: 0.3 + i * 0.12, ease }}
            >
              <Link to={`/products/${chip.slug}`} className={styles.chipLink}>
                <span className={styles.chipIcon}>
                  <ProductIcon name={chip.icon} size={20} />
                </span>
                <span>
                  <strong>{chip.label}</strong>
                  <small>{chip.text}</small>
                </span>
              </Link>
            </motion.li>
          ))}
        </ul>
      </motion.div>
    </section>
  )
}
