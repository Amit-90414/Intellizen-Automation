import { marquee } from '../../../data/home'
import { Marquee } from '../../blocks/Marquee/Marquee'
import { Container } from '../../ui/Container/Container'
import { Reveal } from '../../ui/Reveal/Reveal'
import styles from './SystemsStrip.module.css'

export function SystemsStrip() {
  return (
    <section className={styles.strip} aria-labelledby="systems-strip">
      <Container>
        <Reveal>
          <h2 id="systems-strip" className={styles.label}>
            <span className={`eyebrow ${styles.pill}`}>{marquee.label}</span>
          </h2>
        </Reveal>
      </Container>
      <Reveal delay={0.08} className={styles.rows}>
        <Marquee items={marquee.items} seconds={Math.max(18, marquee.items.length * 1.2)} />
      </Reveal>
    </section>
  )
}
