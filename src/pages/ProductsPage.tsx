import { AnimatePresence, motion } from 'motion/react'
import { ArrowRight, Cog, Package, Phone } from 'lucide-react'
import { useSearchParams } from 'react-router'
import { CtaBand } from '../components/blocks/CtaBand/CtaBand'
import { BlogSection } from '../components/sections/BlogSection/BlogSection'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { ProductCard } from '../components/blocks/ProductCard/ProductCard'
import { Button } from '../components/ui/Button/Button'
import { ProductIcon } from '../components/ui/ProductIcon/ProductIcon'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { Seo } from '../components/ui/Seo/Seo'
import { categories, categoryKeys, isCategory, type Category } from '../data/categories'
import { techSection } from '../data/home'
import { breadcrumbs, graph, home } from '../data/schema'
import { products } from '../data/products'
import { copy, site, siteUrl } from '../data/site'
import { cx } from '../utils/cx'
import styles from './ProductsPage.module.css'

export default function ProductsPage() {
  const [params, setParams] = useSearchParams()
  const raw = params.get('category')
  const selected: Category | 'all' = isCategory(raw) ? raw : 'all'
  const visible = selected === 'all' ? products : products.filter((product) => product.category === selected)
  const { products: page } = copy
  const overview = { src: '/assets/products/custom-automation-solutions/render-1.jpg', alt: page.imageAlt }

  const choose = (value: Category | 'all') => {
    const next = new URLSearchParams(params)
    if (value === 'all') next.delete('category')
    else next.set('category', value)
    setParams(next, { replace: true })
  }

  const chips: Array<{ value: Category | 'all'; label: string }> = [
    { value: 'all', label: page.all },
    ...categoryKeys.map((key) => ({ value: key, label: categories[key] })),
  ]

  return (
    <>
      <Seo
        title={page.title}
        description={page.description}
        path="/products"
        image={overview.src}
        imageAlt={overview.alt}
        jsonLd={graph(breadcrumbs([home, { name: 'Products', path: '/products' }]), {
          '@type': 'ItemList',
          itemListElement: products.map((product, i) => ({ '@type': 'ListItem', position: i + 1, name: product.name, url: `${siteUrl}/products/${product.slug}` })),
        })}
      />

      <PageHero
        tags={page.tags}
        title={page.heading}
        subtitle={page.sub}
        actions={
          <>
            <Button to="/contact">
              {copy.home.primary}
              <ArrowRight aria-hidden="true" />
            </Button>
            <Button href={`tel:${site.phones[0].tel}`} variant="ghost">
              <Phone aria-hidden="true" />
              {site.phones[0].label}
            </Button>
          </>
        }
        stats={[
          { value: products.length, label: 'Products', icon: <Package aria-hidden="true" /> },
          { value: techSection.items.length, label: 'Parts & technologies', icon: <Cog aria-hidden="true" /> },
        ]}
        image={{ src: overview.src, alt: overview.alt }}
        badge={{ value: categoryKeys.length, label: 'Product categories' }}
        note={{ title: page.noteTitle, text: page.noteText, icon: <ProductIcon name="custom" size={22} /> }}
      />

      <Section tone="sky" labelledBy="products-filter">
        <h2 id="products-filter" className="sr-only">
          Filter products by category
        </h2>
        <Reveal>
          <div className={styles.filters} role="group" aria-label="Product categories">
            {chips.map((chip) => (
              <button
                key={chip.value}
                type="button"
                className={cx(styles.chip, selected === chip.value && styles.chipActive)}
                aria-pressed={selected === chip.value}
                onClick={() => choose(chip.value)}
              >
                {chip.label}
              </button>
            ))}
          </div>
        </Reveal>

        <p className="sr-only" aria-live="polite">
          {`Showing ${visible.length} ${visible.length === 1 ? 'product' : 'products'}`}
        </p>

        <motion.ul layout className={styles.grid}>
          <AnimatePresence mode="popLayout" initial={false}>
            {visible.map((product) => (
              <motion.li
                key={product.slug}
                layout
                initial={{ opacity: 0, scale: 0.96 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.96 }}
                transition={{ duration: 0.3, ease: [0.2, 0.7, 0.2, 1] }}
                className={styles.item}
              >
                <Reveal effect="zoom" className={styles.cardReveal}>
                  <ProductCard product={product} variant="vertical" />
                </Reveal>
              </motion.li>
            ))}
          </AnimatePresence>
        </motion.ul>
      </Section>

      <CtaBand />

      <BlogSection />
    </>
  )
}
