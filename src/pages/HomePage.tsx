import { AdvantageCard } from '../components/blocks/AdvantageCard/AdvantageCard'
import { CtaBand } from '../components/blocks/CtaBand/CtaBand'
import { ProductCard } from '../components/blocks/ProductCard/ProductCard'
import { ProductTile } from '../components/blocks/ProductTile/ProductTile'
import { ApplicationsSection } from '../components/sections/ApplicationsSection/ApplicationsSection'
import { BlogSection } from '../components/sections/BlogSection/BlogSection'
import { FaqSection } from '../components/sections/FaqSection/FaqSection'
import { HomeHero } from '../components/sections/HomeHero/HomeHero'
import { LocationSection } from '../components/sections/LocationSection/LocationSection'
import { ProcessSection } from '../components/sections/ProcessSection/ProcessSection'
import { StationsSection } from '../components/sections/StationsSection/StationsSection'
import { SystemsStrip } from '../components/sections/SystemsStrip/SystemsStrip'
import { TechSection } from '../components/sections/TechSection/TechSection'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { SectionHeading } from '../components/ui/SectionHeading/SectionHeading'
import { Seo } from '../components/ui/Seo/Seo'
import { aboutPage } from '../data/about'
import { faqSection } from '../data/home'
import { products } from '../data/products'
import { graph, faqPage, localBusiness, organization, website } from '../data/schema'
import { copy, site } from '../data/site'
import { cx } from '../utils/cx'
import styles from './HomePage.module.css'

const jsonLd = graph(organization, localBusiness, website, faqPage(faqSection.items))

export default function HomePage() {
  const cards = products.filter((product) => product.featured !== 'tile')
  const tiles = products.filter((product) => product.featured === 'tile').slice(0, 8)
  const { home } = copy

  return (
    <>
      <Seo title={home.title} description={home.description} path="/" jsonLd={jsonLd} />

      <HomeHero />
      <SystemsStrip />
      <StationsSection />

      <Section id="products" labelledBy="products-title">
        <SectionHeading
          id="products-title"
          eyebrow={home.productsEyebrow}
          title={home.productsTitle}
          link={{ to: '/products', label: home.productsLink }}
        />

        <ul className={styles.cardGrid}>
          {cards.map((product, i) => (
            <Reveal
              as="li"
              key={product.slug}
              delay={i * 0.06}
              effect="zoom"
              className={cx(styles.cardItem, product.featured === 'large' ? styles.large : i === 1 ? styles.mediumTall : styles.medium)}
            >
              <ProductCard product={product} />
            </Reveal>
          ))}
        </ul>

        <ul className={styles.tileGrid}>
          {tiles.map((product, i) => (
            <Reveal as="li" key={product.slug} delay={i * 0.06}>
              <ProductTile product={product} />
            </Reveal>
          ))}
        </ul>
      </Section>

      <BlogSection />
      <ApplicationsSection />
      <ProcessSection />
      <TechSection />

      <Section labelledBy="advantages-title" className={styles.advantagesSection}>
        <SectionHeading id="advantages-title" eyebrow={aboutPage.advantages.eyebrow} title={home.advantagesTitle} />
        <ul className={styles.advantages}>
          {site.advantages.map((advantage, i) => (
            <Reveal as="li" key={advantage} delay={i * 0.06}>
              <AdvantageCard title={advantage} index={i} text={aboutPage.advantages.details[advantage]} />
            </Reveal>
          ))}
        </ul>
      </Section>

      {site.showClients && (
        <Section labelledBy="clients-title">
          <SectionHeading id="clients-title" title={home.clientsTitle} />
          <p className={styles.clients}>{home.clientsPlaceholder}</p>
        </Section>
      )}

      <LocationSection />
      <CtaBand />
      <FaqSection />
    </>
  )
}
