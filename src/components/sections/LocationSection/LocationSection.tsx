import { ArrowUpRight, Mail, MapPin } from 'lucide-react'
import { WhatsAppIcon } from '../../ui/WhatsAppIcon/WhatsAppIcon'
import { locationSection } from '../../../data/home'
import { site, social } from '../../../data/site'
import { MapEmbed } from '../../blocks/MapEmbed/MapEmbed'
import { Button } from '../../ui/Button/Button'
import { Container } from '../../ui/Container/Container'
import { InstagramIcon } from '../../ui/InstagramIcon/InstagramIcon'
import { Reveal } from '../../ui/Reveal/Reveal'
import styles from './LocationSection.module.css'

export function LocationSection() {
  const section = locationSection
  const instagram = social[0]

  return (
    <section className={styles.section} aria-labelledby="location-title">
      <Container className={styles.grid}>
        <Reveal className={styles.intro}>
          <p className="eyebrow">{section.eyebrow}</p>
          <h2 id="location-title" className={styles.title}>
            {section.title} <span>{section.accent}</span>
          </h2>
          <p className={styles.text}>{section.text}</p>
          <div className={styles.actions}>
            <Button href={site.mapsUrl} target="_blank" rel="noopener noreferrer" variant="dark">
              {section.directions}
              <ArrowUpRight aria-hidden="true" />
            </Button>
            <Button href={instagram.href} target="_blank" rel="noopener noreferrer" variant="secondary">
              <InstagramIcon size={18} />
              {instagram.handle}
            </Button>
          </div>
        </Reveal>

        <Reveal delay={0.1} className={styles.office}>
          <div className={styles.officeHead}>
            <span className={styles.pin} aria-hidden="true">
              <MapPin />
            </span>
            <div>
              <p className={styles.officeLabel}>{section.officeLabel}</p>
              <h3 className={styles.officeName}>{section.officeName}</h3>
            </div>
          </div>

          <address className={styles.details}>
            <p className={styles.row}>
              <MapPin aria-hidden="true" />
              <span>{site.address}</span>
            </p>
            <p className={styles.row}>
              <WhatsAppIcon />
              <span className={styles.links}>
                {site.phones.map((phone) => (
                  <a key={phone.tel} href={phone.wa} target="_blank" rel="noopener noreferrer">
                    {phone.label}
                  </a>
                ))}
              </span>
            </p>
            <p className={styles.row}>
              <Mail aria-hidden="true" />
              <span className={styles.links}>
                {site.emails.map((email) => (
                  <a key={email} href={`mailto:${email}`}>
                    {email}
                  </a>
                ))}
              </span>
            </p>
            <p className={styles.row}>
              <InstagramIcon size={18} />
              <span className={styles.links}>
                <a href={instagram.href} target="_blank" rel="noopener noreferrer">
                  {section.follow} {instagram.handle}
                </a>
              </span>
            </p>
          </address>

          <MapEmbed height={220} className={styles.map} />
        </Reveal>
      </Container>
    </section>
  )
}
