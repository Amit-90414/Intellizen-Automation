import { useState } from 'react'
import { AnimatePresence, motion } from 'motion/react'
import { ArrowUpRight } from 'lucide-react'
import { techSection } from '../../../data/home'
import { PartCard } from '../../blocks/PartCard/PartCard'
import { Button } from '../../ui/Button/Button'
import { FilterChips } from '../../ui/FilterChips/FilterChips'
import { Reveal } from '../../ui/Reveal/Reveal'
import { Section } from '../../ui/Section/Section'
import { SectionHeading } from '../../ui/SectionHeading/SectionHeading'
import styles from './TechSection.module.css'

export function TechSection() {
  const section = techSection
  const [group, setGroup] = useState(section.groups[0].key)
  const visible = section.items.filter((item) => item.group === group)
  const options = section.groups.map(({ key, label, tone, items }) => ({ key, label, tone, count: items.length }))

  return (
    <Section labelledBy="tech-title">
      <SectionHeading id="tech-title" eyebrow={section.eyebrow} title={section.title} accent={section.accent} text={section.text} />

      <Reveal>
        <FilterChips options={options} value={group} onChange={setGroup} label="Filter by group" />
      </Reveal>

      <p className="sr-only" aria-live="polite">
        {`Showing ${visible.length} of ${section.items.length} items`}
      </p>

      <Reveal>
        <motion.ul layout className={styles.grid}>
          <AnimatePresence mode="popLayout" initial={false}>
            {visible.map((item) => (
              <motion.li
                key={`${item.group}-${item.label}`}
                layout
                initial={{ opacity: 0, scale: 0.94 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.94 }}
                transition={{ duration: 0.28, ease: [0.2, 0.7, 0.2, 1] }}
              >
                <PartCard label={item.label} slug={item.slug} icon={item.icon} tone={item.tone} />
              </motion.li>
            ))}
          </AnimatePresence>
        </motion.ul>
      </Reveal>

      <Reveal className={styles.band}>
        <div>
          <h3 className={styles.bandTitle}>{section.band.title}</h3>
          <p className={styles.bandText}>{section.band.text}</p>
        </div>
        <Button to={group === section.groups[0].key ? '/technology' : `/technology#group-${group}`}>
          {section.band.cta}
          <ArrowUpRight aria-hidden="true" />
        </Button>
      </Reveal>
    </Section>
  )
}
