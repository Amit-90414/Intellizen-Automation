import type { ReactNode } from 'react'
import { ArrowRight, BadgeCheck, Boxes, Eye, Factory, Headset, MapPin, Package, Target } from 'lucide-react'
import { AdvantageCard } from '../components/blocks/AdvantageCard/AdvantageCard'
import { CtaBand } from '../components/blocks/CtaBand/CtaBand'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { ProductTile } from '../components/blocks/ProductTile/ProductTile'
import { FaqSection } from '../components/sections/FaqSection/FaqSection'
import { LocationSection } from '../components/sections/LocationSection/LocationSection'
import { ProcessSection } from '../components/sections/ProcessSection/ProcessSection'
import { Button } from '../components/ui/Button/Button'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { SectionHeading } from '../components/ui/SectionHeading/SectionHeading'
import { Seo } from '../components/ui/Seo/Seo'
import { aboutPage } from '../data/about'
import { products } from '../data/products'
import { breadcrumbs, faqPage, home, organizationId } from '../data/schema'
import { copy, site, siteUrl } from '../data/site'
import { cx } from '../utils/cx'
import { srcSetFor } from '../utils/image'
import styles from './AboutPage.module.css'

const factIcons: ReactNode[] = [
  <MapPin key="place" aria-hidden="true" />,
  <Factory key="work" aria-hidden="true" />,
  <Boxes key="range" aria-hidden="true" />,
  <Headset key="support" aria-hidden="true" />,
]

const purposeIcons: ReactNode[] = [<Eye key="vision" aria-hidden="true" />, <Target key="mission" aria-hidden="true" />]
const introImage = '/assets/products/test-benches/render-1.jpg'

export default function AboutPage() {
  const { about } = copy
  const { intro, facts, purpose, whatWeDo, advantages, faq } = aboutPage

  const jsonLd = {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'AboutPage',
        '@id': `${siteUrl}/about#page`,
        url: `${siteUrl}/about`,
        name: about.title,
        description: about.description,
        about: { '@id': organizationId },
      },
      breadcrumbs([home, { name: 'About', path: '/about' }]),
      faqPage(faq.items),
    ],
  }

  return (
    <>
      <Seo title={about.title} description={about.description} path="/about" image="/assets/products/custom-automation-solutions/render-4.jpg" imageAlt={about.heroImageAlt} jsonLd={jsonLd} />

      <PageHero
        tags={about.tags}
        title={about.heading}
        subtitle={about.sub}
        actions={
          <>
            <Button to="/products">
              {copy.home.secondary}
              <ArrowRight aria-hidden="true" />
            </Button>
            <Button to="/contact" variant="ghost">
              {copy.header.cta}
            </Button>
          </>
        }
        stats={[
          { value: products.length, label: 'Products', icon: <Package aria-hidden="true" /> },
          { value: site.advantages.length, label: 'Key advantages', icon: <BadgeCheck aria-hidden="true" /> },
        ]}
        image={{ src: '/assets/products/custom-automation-solutions/render-4.jpg', alt: about.heroImageAlt }}
        badge={{ value: 'Derabassi', label: 'Hansa Industrial Park' }}
        note={{ title: about.noteTitle, text: about.noteText, icon: <Factory aria-hidden="true" /> }}
      />

      <Section labelledBy="about-intro">
        <div className={styles.intro}>
          <div className={styles.story}>
            <SectionHeading id="about-intro" eyebrow={intro.eyebrow} title={intro.title} accent={intro.accent} />
            {intro.paragraphs.map((paragraph, i) => (
              <Reveal key={paragraph} delay={i * 0.05}>
                <p className={styles.paragraph}>{paragraph}</p>
              </Reveal>
            ))}
            <ul className={styles.facts}>
              {facts.map((fact, i) => (
                <Reveal as="li" key={fact.label} delay={i * 0.06} className={styles.fact}>
                  <span className={styles.factIcon}>{factIcons[i]}</span>
                  <span>
                    <span className={styles.factLabel}>{fact.label}</span>
                    <span className={styles.factValue}>{fact.value}</span>
                  </span>
                </Reveal>
              ))}
            </ul>
          </div>

          <Reveal delay={0.08} effect="zoom" className={styles.media}>
            <div className={styles.frame}>
              <img src={introImage} srcSet={srcSetFor(introImage)} sizes="(min-width: 1100px) 1320px, 100vw" alt={intro.imageAlt} width={1320} height={428} loading="lazy" decoding="async" />
            </div>
          </Reveal>
        </div>
      </Section>

      <Section tone="sky" labelledBy="about-purpose">
        <SectionHeading id="about-purpose" eyebrow={purpose.eyebrow} title={purpose.title} accent={purpose.accent} />
        <ul className={styles.purpose}>
          {purpose.cards.map((card, i) => (
            <Reveal as="li" key={card.label} delay={i * 0.08} className={cx(styles.purposeCard, i === 0 && styles.purposeDark)}>
              <span className={styles.purposeIcon}>{purposeIcons[i]}</span>
              <p className={styles.purposeLabel}>{card.label}</p>
              <h3 className={styles.purposeTitle}>{card.title}</h3>
              <p className={styles.purposeText}>{card.text}</p>
            </Reveal>
          ))}
        </ul>
      </Section>

      <Section labelledBy="what-we-do">
        <SectionHeading
          id="what-we-do"
          eyebrow={whatWeDo.eyebrow}
          title={whatWeDo.title}
          accent={whatWeDo.accent}
          link={{ to: '/products', label: copy.home.productsLink }}
        />
        <ul className={styles.tiles}>
          {products.map((product, i) => (
            <Reveal as="li" key={product.slug} delay={(i % 3) * 0.06}>
              <ProductTile product={product} />
            </Reveal>
          ))}
        </ul>
      </Section>

      <ProcessSection />

      <Section labelledBy="about-advantages">
        <SectionHeading id="about-advantages" eyebrow={advantages.eyebrow} title={advantages.title} />
        <ul className={styles.advantages}>
          {site.advantages.map((advantage, i) => (
            <Reveal as="li" key={advantage} delay={i * 0.06}>
              <AdvantageCard title={advantage} index={i} text={advantages.details[advantage]} />
            </Reveal>
          ))}
        </ul>
      </Section>

      <LocationSection />

      <CtaBand />

      <FaqSection section={faq} tone="white" />
    </>
  )
}
