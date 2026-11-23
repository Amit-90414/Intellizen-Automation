import { ArrowRight, Phone } from 'lucide-react'
import { Link } from 'react-router'
import { applicationsSection } from '../../../data/home'
import { copy, site } from '../../../data/site'
import { Button } from '../../ui/Button/Button'
import { Container } from '../../ui/Container/Container'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import { Reveal } from '../../ui/Reveal/Reveal'
import styles from './ApplicationsSection.module.css'

export function ApplicationsSection() {
  const section = applicationsSection

  return (
    <section className={styles.section} aria-labelledby="applications-title">
      <Container className={styles.grid}>
        <Reveal className={styles.intro}>
          <p className="eyebrow">{section.eyebrow}</p>
          <h2 id="applications-title" className={styles.title}>
            {section.title} <span>{section.accent}</span>
          </h2>
          <p className={styles.text}>{section.text}</p>
          <div className={styles.actions}>
            <Button to="/contact" variant="dark">
              {copy.home.primary}
              <ArrowRight aria-hidden="true" />
            </Button>
            <a href={`tel:${site.phones[0].tel}`} className={styles.call}>
              <Phone aria-hidden="true" />
              {site.phones[0].label}
            </a>
          </div>
        </Reveal>

        <ol className={styles.cards}>
          {section.items.map((item, i) => (
            <Reveal as="li" key={`${item.slug}-${item.title}`} delay={(i % 2) * 0.08 + Math.floor(i / 2) * 0.06}>
              <Link to={`/products/${item.slug}`} className={styles.card}>
                <span className={styles.num}>{String(i + 1).padStart(2, '0')}</span>
                <span className={styles.body}>
                  <span className={styles.cardTitle}>{item.title}</span>
                  <span className={styles.cardText}>{item.text}</span>
                  <span className={styles.product}>
                    <ProductIcon name={item.icon} size={16} />
                    {item.productName}
                  </span>
                </span>
              </Link>
            </Reveal>
          ))}
        </ol>
      </Container>
    </section>
  )
}
