import { useState, type MouseEvent } from 'react'
import { motion, useReducedMotion } from 'motion/react'
import { ArrowRight } from 'lucide-react'
import { homeHero } from '../../../data/home'
import { copy } from '../../../data/site'
import { isFirstRender } from '../../../utils/firstRender'
import { HeroVideo } from '../../blocks/HeroVideo/HeroVideo'
import { Button } from '../../ui/Button/Button'
import { Container } from '../../ui/Container/Container'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import styles from './HomeHero.module.css'

const ease = [0.2, 0.7, 0.2, 1] as const

export function HomeHero() {
  const reduce = useReducedMotion()
  const [first] = useState(isFirstRender)
  const { home } = copy

  const rise = (delay: number) => ({
    initial: first ? false : { opacity: 0, y: reduce ? 0 : 26 },
    animate: { opacity: 1, y: 0 },
    transition: { duration: 0.9, delay, ease },
  })

  const scrollToProducts = (event: MouseEvent<HTMLAnchorElement>) => {
    const target = document.getElementById('products')
    if (!target) return
    event.preventDefault()
    target.scrollIntoView({ behavior: reduce ? 'auto' : 'smooth', block: 'start' })
  }

  return (
    <section className={styles.hero} aria-labelledby="home-title">
      <HeroVideo />

      <Container className={styles.text}>
        <motion.p className={styles.tags} {...rise(0)}>
          <span className={styles.dot} aria-hidden="true" />
          {homeHero.tags.map((tag) => (
            <span key={tag} className={styles.tag}>
              {tag}
            </span>
          ))}
        </motion.p>

        <motion.p className={styles.title} {...rise(0.08)}>
          {home.heading.before}
          <span className={styles.highlight}>
            {home.heading.highlight}
            <svg className={styles.swoosh} viewBox="0 0 200 18" preserveAspectRatio="none" aria-hidden="true">
              <path d="M3 13 C 50 3, 120 2, 197 9" fill="none" stroke="currentColor" strokeWidth="5" strokeLinecap="round" />
            </svg>
          </span>
          {home.heading.after}
        </motion.p>

        <motion.h1 id="home-title" className={styles.tagline} {...rise(0.16)}>
          {home.h1}
        </motion.h1>

        <motion.p className={styles.sub} {...rise(0.22)}>
          {home.sub}
        </motion.p>

        <motion.div className={styles.services} {...rise(0.3)}>
          <ul aria-label={homeHero.servicesLabel}>
            {homeHero.services.map((service) => (
              <li key={service.key}>
                <span className={styles.service}>
                  <span className={styles.serviceIcon}>
                    <ProductIcon name={service.icon} size={18} />
                  </span>
                  {service.label}
                </span>
              </li>
            ))}
          </ul>
        </motion.div>

        <motion.div className={styles.actions} {...rise(0.38)}>
          <Button to="/contact">
            {home.primary}
            <ArrowRight aria-hidden="true" />
          </Button>
          <Button href="#products" variant="secondary" onClick={scrollToProducts}>
            {home.secondary}
          </Button>
        </motion.div>

      </Container>
    </section>
  )
}
