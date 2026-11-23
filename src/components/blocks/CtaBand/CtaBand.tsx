import { useId } from 'react'
import { ArrowRight } from 'lucide-react'
import { WhatsAppIcon } from '../../ui/WhatsAppIcon/WhatsAppIcon'
import { copy, site } from '../../../data/site'
import { Button } from '../../ui/Button/Button'
import { Container } from '../../ui/Container/Container'
import { Reveal } from '../../ui/Reveal/Reveal'
import styles from './CtaBand.module.css'

export function CtaBand() {
  const titleId = useId()

  return (
    <section className={styles.band} aria-labelledby={titleId}>
      <Container className={styles.inner}>
        <Reveal>
          <h2 id={titleId} className={styles.title}>
            {copy.cta.title}
          </h2>
        </Reveal>
        <Reveal delay={0.06} className={styles.actions}>
          <Button to="/contact">
            {copy.cta.primary}
            <ArrowRight aria-hidden="true" />
          </Button>
          <Button href={site.phones[0].wa} target="_blank" rel="noopener noreferrer" variant="secondary">
            <WhatsAppIcon />
            {copy.cta.call}
          </Button>
        </Reveal>
      </Container>
    </section>
  )
}
