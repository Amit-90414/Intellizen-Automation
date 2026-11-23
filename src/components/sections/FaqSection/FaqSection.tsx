import { useId, useState } from 'react'
import { AnimatePresence, motion } from 'motion/react'
import { ArrowRight, ChevronDown } from 'lucide-react'
import { Link } from 'react-router'
import { faqSection } from '../../../data/home'
import { cx } from '../../../utils/cx'
import { Reveal } from '../../ui/Reveal/Reveal'
import { Section } from '../../ui/Section/Section'
import { SectionHeading } from '../../ui/SectionHeading/SectionHeading'
import styles from './FaqSection.module.css'

type FaqContent = {
  eyebrow: string
  title: string
  items: { q: string; a: string }[]
  more?: string
}

export function FaqSection({ section = faqSection, tone = 'sky' }: { section?: FaqContent; tone?: 'white' | 'sky' }) {
  const baseId = useId()
  const [open, setOpen] = useState<number | null>(0)

  return (
    <Section tone={tone} labelledBy="faq-title">
      <SectionHeading id="faq-title" eyebrow={section.eyebrow} title={section.title} />
      <div className={styles.list}>
        {section.items.map((item, i) => {
          const expanded = open === i
          const panelId = `${baseId}-panel-${i}`
          const buttonId = `${baseId}-button-${i}`
          return (
            <Reveal key={item.q} delay={i * 0.05} className={cx(styles.item, expanded && styles.open)}>
              <h3 className={styles.question}>
                <button
                  id={buttonId}
                  type="button"
                  className={styles.toggle}
                  aria-expanded={expanded}
                  aria-controls={panelId}
                  onClick={() => setOpen(expanded ? null : i)}
                >
                  <span className={styles.num}>{String(i + 1).padStart(2, '0')}</span>
                  <span className={styles.q}>{item.q}</span>
                  <ChevronDown aria-hidden="true" className={styles.chevron} />
                </button>
              </h3>
              <AnimatePresence initial={false}>
                {expanded && (
                  <motion.div
                    id={panelId}
                    role="region"
                    aria-labelledby={buttonId}
                    className={styles.answer}
                    initial={{ opacity: 0, y: -6 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -6 }}
                    transition={{ duration: 0.22, ease: [0.2, 0.7, 0.2, 1] }}
                  >
                    <p>{item.a}</p>
                  </motion.div>
                )}
              </AnimatePresence>
            </Reveal>
          )
        })}
      </div>
      {section.more && (
        <Reveal className={styles.more}>
          <Link to="/contact" className={styles.moreLink}>
            {section.more}
            <ArrowRight aria-hidden="true" />
          </Link>
        </Reveal>
      )}
    </Section>
  )
}
