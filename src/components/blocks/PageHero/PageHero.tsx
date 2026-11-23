import { useState, type ReactNode } from 'react'
import { motion, useReducedMotion } from 'motion/react'
import type { IconKey } from '../../../data/products'
import { cx } from '../../../utils/cx'
import { isFirstRender } from '../../../utils/firstRender'
import { srcSetFor } from '../../../utils/image'
import { IsoCluster } from '../../three-d/IsoCluster/IsoCluster'
import { MiniCube } from '../../three-d/MiniCube/MiniCube'
import { Container } from '../../ui/Container/Container'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import { Reveal } from '../../ui/Reveal/Reveal'
import styles from './PageHero.module.css'

type HeroStat = {
  value: string | number
  label: string
  icon: ReactNode
}

type PageHeroProps = {
  title: string
  tags?: string[]
  subtitle?: string
  actions?: ReactNode
  stats?: HeroStat[]
  image?: { src: string; alt: string; position?: string }
  art?: IconKey
  badge?: { value: string | number; label: string }
  note?: { title: string; text: string; icon: ReactNode }
  size?: 'default' | 'small'
  before?: ReactNode
}

const ease = [0.2, 0.7, 0.2, 1] as const

const cubes = [
  { size: 28, tone: 'yellow', delay: -1.4, className: 'c2' },
  { size: 64, tone: 'blue', delay: -2.6, className: 'c3' },
  { size: 22, tone: 'yellow', delay: -0.8, className: 'c4' },
] as const

function Backdrop() {
  return (
    <div className={styles.backdrop} aria-hidden="true">
      <span className={styles.grid} />
      <span className={cx(styles.glow, styles.glowBlue)} />
      <span className={cx(styles.glow, styles.glowYellow)} />
      <span className={styles.sweep} />
      <IsoCluster className={styles.cluster} />
      {cubes.map((cube) => (
        <MiniCube key={cube.className} size={cube.size} tone={cube.tone} delay={cube.delay} className={cx(styles.cube, styles[cube.className])} />
      ))}
    </div>
  )
}

export function PageHero({ title, tags, subtitle, actions, stats, image, art, badge, note, size = 'default', before }: PageHeroProps) {
  const reduce = useReducedMotion()
  const [first] = useState(isFirstRender)
  const hasMedia = size === 'default' && (image || art)

  const rise = (delay: number) => ({
    initial: first ? false : { opacity: 0, y: reduce ? 0 : 24 },
    animate: { opacity: 1, y: 0 },
    transition: { duration: 0.8, delay, ease },
  })

  return (
    <section className={cx(styles.hero, size === 'small' && styles.small)}>
      <Backdrop />

      <Container className={cx(styles.inner, hasMedia && styles.split)}>
        <div className={styles.text}>
          {before && <motion.div {...rise(0)}>{before}</motion.div>}

          {tags && tags.length > 0 && (
            <motion.p className={styles.tags} {...rise(0)}>
              <span className={styles.dot} aria-hidden="true" />
              {tags.map((tag) => (
                <span key={tag} className={styles.tag}>
                  {tag}
                </span>
              ))}
            </motion.p>
          )}

          <motion.h1 className={styles.title} {...rise(0.08)}>
            {title}
          </motion.h1>

          {subtitle && (
            <motion.p className={styles.subtitle} {...rise(0.16)}>
              {subtitle}
            </motion.p>
          )}

          {actions && (
            <motion.div className={styles.actions} {...rise(0.24)}>
              {actions}
            </motion.div>
          )}

          {stats && stats.length > 0 && (
            <motion.ul className={styles.stats} {...rise(0.32)}>
              {stats.map((stat) => (
                <li key={stat.label} className={styles.stat}>
                  <span className={styles.statIcon}>{stat.icon}</span>
                  <span className={styles.statValue}>{stat.value}</span>
                  <span className={styles.statLabel}>{stat.label}</span>
                </li>
              ))}
            </motion.ul>
          )}
        </div>

        {hasMedia && (
          <Reveal className={styles.media} effect="zoom" delay={0.15}>
            <div className={styles.frame}>
              {image ? (
                <img
                  src={image.src}
                  srcSet={srcSetFor(image.src)}
                  sizes="(min-width: 980px) 600px, (min-width: 660px) 620px, 94vw"
                  alt={image.alt}
                  className={styles.image}
                  style={{ objectPosition: image.position }}
                  width={1200}
                  height={1200}
                  fetchPriority="high"
                  decoding="async"
                />
              ) : (
                art && (
                  <span className={styles.art}>
                    <ProductIcon name={art} size={160} />
                  </span>
                )
              )}
            </div>

            {badge && (
              <p className={styles.badge}>
                <span className={styles.badgeValue}>{badge.value}</span>
                <span className={styles.badgeLabel}>{badge.label}</span>
              </p>
            )}

            {note && (
              <div className={styles.note}>
                <span className={styles.noteIcon}>{note.icon}</span>
                <span>
                  <span className={styles.noteTitle}>{note.title}</span>
                  <span className={styles.noteText}>{note.text}</span>
                </span>
              </div>
            )}
          </Reveal>
        )}
      </Container>
    </section>
  )
}
