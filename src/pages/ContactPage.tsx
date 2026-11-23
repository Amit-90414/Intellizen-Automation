import type { ReactNode } from 'react'
import { ArrowDown, Mail, MapPin, Phone } from 'lucide-react'
import { useSearchParams } from 'react-router'
import { ContactForm } from '../components/blocks/ContactForm/ContactForm'
import { MapEmbed } from '../components/blocks/MapEmbed/MapEmbed'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { Button } from '../components/ui/Button/Button'
import { InstagramIcon } from '../components/ui/InstagramIcon/InstagramIcon'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { Seo } from '../components/ui/Seo/Seo'
import { getProduct } from '../data/products'
import { breadcrumbs, businessId, graph, home, localBusiness } from '../data/schema'
import { copy, site, siteUrl, social } from '../data/site'
import styles from './ContactPage.module.css'

type InfoCardProps = {
  icon: ReactNode
  title: string
  children: ReactNode
}

function InfoCard({ icon, title, children }: InfoCardProps) {
  return (
    <div className={styles.card}>
      <span className={styles.icon}>{icon}</span>
      <div className={styles.cardBody}>
        <h2 className={styles.cardTitle}>{title}</h2>
        {children}
      </div>
    </div>
  )
}

export default function ContactPage() {
  const [params] = useSearchParams()
  const selected = getProduct(params.get('product') ?? undefined)?.slug ?? ''
  const { contact } = copy

  return (
    <>
      <Seo
        title={contact.title}
        description={contact.description}
        path="/contact"
        image="/assets/products/special-purpose-machines/render-1.jpg"
        imageAlt={contact.imageAlt}
        jsonLd={graph(
          breadcrumbs([home, { name: 'Contact', path: '/contact' }]),
          { '@type': 'ContactPage', url: `${siteUrl}/contact`, name: contact.title, about: { '@id': businessId } },
          localBusiness,
        )}
      />

      <PageHero
        tags={contact.tags}
        title={contact.heading}
        subtitle={contact.sub}
        actions={
          <>
            <Button to="#enquiry">
              {contact.form}
              <ArrowDown aria-hidden="true" />
            </Button>
            <Button href={`tel:${site.phones[0].tel}`} variant="ghost">
              <Phone aria-hidden="true" />
              {site.phones[0].label}
            </Button>
          </>
        }
        size="small"
      />

      <Section tone="sky">
        <div className={styles.layout}>
          <div className={styles.details}>
            <Reveal className={styles.cards}>
              <InfoCard icon={<MapPin aria-hidden="true" />} title="Visit">
                <address className={styles.text}>{site.address}</address>
                <p className={styles.gstin}>GSTIN: {site.gstin}</p>
              </InfoCard>
              <InfoCard icon={<Mail aria-hidden="true" />} title="Email">
                <p className={styles.links}>
                  {site.emails.map((email) => (
                    <a key={email} href={`mailto:${email}`}>
                      {email}
                    </a>
                  ))}
                </p>
              </InfoCard>
              <InfoCard icon={<Phone aria-hidden="true" />} title="Call">
                <p className={styles.links}>
                  {site.phones.map((phone) => (
                    <a key={phone.tel} href={`tel:${phone.tel}`}>
                      {phone.label}
                    </a>
                  ))}
                </p>
              </InfoCard>
              <InfoCard icon={<InstagramIcon size={22} />} title="Follow">
                <p className={styles.links}>
                  {social.map((profile) => (
                    <a key={profile.href} href={profile.href} target="_blank" rel="noopener noreferrer">
                      {profile.handle}
                    </a>
                  ))}
                </p>
              </InfoCard>
            </Reveal>
            <Reveal delay={0.06}>
              <MapEmbed height={260} />
            </Reveal>
          </div>

          <Reveal delay={0.1} className={styles.formCard}>
            <h2 id="enquiry" className={styles.formTitle}>
              {contact.form}
            </h2>
            <ContactForm defaultProduct={selected} />
          </Reveal>
        </div>
      </Section>
    </>
  )
}
