import { ArrowRight } from 'lucide-react'
import { Link } from 'react-router'
import { Reveal } from '../Reveal/Reveal'
import styles from './SectionHeading.module.css'

type SectionHeadingProps = {
  title: string
  id?: string
  eyebrow?: string
  accent?: string
  text?: string
  link?: { to: string; label: string }
}

export function SectionHeading({ title, id, eyebrow, accent, text, link }: SectionHeadingProps) {
  return (
    <div className={styles.heading}>
      <Reveal className={styles.text}>
        {eyebrow && <p className="eyebrow">{eyebrow}</p>}
        <h2 id={id}>
          {title}
          {accent && (
            <>
              {' '}
              <span className={styles.accent}>{accent}</span>
            </>
          )}
        </h2>
        {text && <p className={styles.lead}>{text}</p>}
      </Reveal>
      {link && (
        <Reveal delay={0.06}>
          <Link to={link.to} className={styles.link}>
            {link.label}
            <ArrowRight aria-hidden="true" />
          </Link>
        </Reveal>
      )}
    </div>
  )
}
