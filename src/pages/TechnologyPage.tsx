import { useEffect } from 'react'
import { ArrowRight, Boxes, Cog, Layers } from 'lucide-react'
import { useLocation } from 'react-router'
import { CtaBand } from '../components/blocks/CtaBand/CtaBand'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { PartCard } from '../components/blocks/PartCard/PartCard'
import { Button } from '../components/ui/Button/Button'
import { FilterChips } from '../components/ui/FilterChips/FilterChips'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { Seo } from '../components/ui/Seo/Seo'
import { ToneDot } from '../components/ui/ToneBadge/ToneBadge'
import { techSection } from '../data/home'
import { products } from '../data/products'
import { breadcrumbs, graph, home } from '../data/schema'
import { copy } from '../data/site'
import styles from './TechnologyPage.module.css'

export default function TechnologyPage() {
  const { hash } = useLocation()
  const page = copy.technology
  const { groups } = techSection

  useEffect(() => {
    if (!hash) return
    document.getElementById(decodeURIComponent(hash.slice(1)))?.scrollIntoView({ block: 'start' })
  }, [hash])

  const options = groups.map(({ key, label, tone, items }) => ({ key, label, tone, count: items.length, to: `#group-${key}` }))

  return (
    <>
      <Seo
        title={page.title}
        description={page.description}
        path="/technology"
        image="/assets/products/automation-components/render-1.jpg"
        jsonLd={graph(breadcrumbs([home, { name: page.heading, path: '/technology' }]))}
      />

      <PageHero
        tags={page.tags}
        title={page.heading}
        subtitle={page.sub}
        actions={
          <>
            <Button to="/products">
              {copy.home.secondary}
              <ArrowRight aria-hidden="true" />
            </Button>
            <Button to="/contact" variant="ghost">
              {copy.home.primary}
            </Button>
          </>
        }
        stats={[
          { value: techSection.items.length, label: 'Parts & technologies', icon: <Cog aria-hidden="true" /> },
          { value: products.length, label: 'Products', icon: <Boxes aria-hidden="true" /> },
        ]}
        image={{ src: '/assets/products/automation-components/render-1.jpg', alt: page.imageAlt }}
        badge={{ value: groups.length, label: 'Groups' }}
        note={{ title: page.noteTitle, text: page.noteText, icon: <Layers aria-hidden="true" /> }}
      />

      <Section tone="sky">
        <Reveal>
          <FilterChips options={options} label={page.jumpLabel} />
        </Reveal>

        <div className={styles.groups}>
          {groups.map((group) => (
            <section key={group.key} id={`group-${group.key}`} className={styles.group} aria-labelledby={`group-${group.key}-title`}>
              <Reveal className={styles.head}>
                <ToneDot tone={group.tone} />
                <h2 id={`group-${group.key}-title`} className={styles.title}>
                  {group.label}
                </h2>
                <span className={styles.count}>{group.items.length}</span>
              </Reveal>
              <ul className={styles.grid}>
                {group.items.map((item, i) => (
                  <Reveal as="li" key={item.label} delay={(i % 4) * 0.05}>
                    <PartCard label={item.label} slug={item.slug} icon={item.icon} tone={group.tone} detail={item.productName} />
                  </Reveal>
                ))}
              </ul>
            </section>
          ))}
        </div>
      </Section>

      <CtaBand />
    </>
  )
}
