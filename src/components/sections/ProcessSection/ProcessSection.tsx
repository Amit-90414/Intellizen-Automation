import { motion } from 'motion/react'
import { processSection } from '../../../data/home'
import { Reveal } from '../../ui/Reveal/Reveal'
import { Section } from '../../ui/Section/Section'
import { SectionHeading } from '../../ui/SectionHeading/SectionHeading'
import styles from './ProcessSection.module.css'

export function ProcessSection() {
  const section = processSection

  return (
    <Section tone="sky" labelledBy="process-title">
      <SectionHeading id="process-title" eyebrow={section.eyebrow} title={section.title} accent={section.accent} />
      <ol className={styles.steps}>
        {section.steps.map((step, i) => (
          <Reveal as="li" key={step.title} delay={i * 0.08} className={styles.step}>
            <motion.span
              className={styles.bar}
              aria-hidden="true"
              initial={{ scaleX: 0 }}
              whileInView={{ scaleX: 1 }}
              viewport={{ amount: 0.6 }}
              transition={{ duration: 0.8, delay: 0.2 + i * 0.12, ease: [0.2, 0.7, 0.2, 1] }}
            />
            <span className={styles.num}>{String(i + 1).padStart(2, '0')}</span>
            <h3 className={styles.title}>{step.title}</h3>
            <p className={styles.text}>{step.text}</p>
          </Reveal>
        ))}
      </ol>
    </Section>
  )
}
