import { ArrowRight, Boxes, Check, Download, Phone, Workflow } from 'lucide-react'
import { Link, useParams } from 'react-router'
import { CtaBand } from '../components/blocks/CtaBand/CtaBand'
import { BlogSection } from '../components/sections/BlogSection/BlogSection'
import { Gallery } from '../components/blocks/Gallery/Gallery'
import { FaqSection } from '../components/sections/FaqSection/FaqSection'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { ProductCard } from '../components/blocks/ProductCard/ProductCard'
import { Button } from '../components/ui/Button/Button'
import { ItemIcon } from '../components/ui/ItemIcon/ItemIcon'
import { ProductIcon } from '../components/ui/ProductIcon/ProductIcon'
import { ToneBadge } from '../components/ui/ToneBadge/ToneBadge'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { SectionHeading } from '../components/ui/SectionHeading/SectionHeading'
import { Seo } from '../components/ui/Seo/Seo'
import { Tabs } from '../components/ui/Tabs/Tabs'
import { categories } from '../data/categories'
import { postsForProduct } from '../data/blog'
import { productDetails } from '../data/productDetails'
import { breadcrumbs, faqPage, graph, home, organizationId } from '../data/schema'
import { getProduct, products, type Product } from '../data/products'
import { copy, site, siteUrl } from '../data/site'
import { isFilled } from '../utils/placeholder'
import NotFoundPage from './NotFoundPage'
import styles from './ProductDetailPage.module.css'

const isProduct = (value: Product | undefined): value is Product => value !== undefined

export default function ProductDetailPage() {
  const { slug } = useParams()
  const product = getProduct(slug)

  if (!product) return <NotFoundPage />

  const index = products.indexOf(product)
  const previous = products[(index - 1 + products.length) % products.length]
  const next = products[(index + 1) % products.length]
  const related = product.related.map((item) => getProduct(item)).filter(isProduct)
  const categoryLabel = categories[product.category]
  const path = `/products/${product.slug}`
  const detail = productDetails[product.slug]
  const text = copy.product
  const heroIndex = Math.min(product.heroImage ?? 1, product.images.length - 1)
  const heroImage = product.images[heroIndex]
  const longTitle = `${product.name} in Punjab | Intellizen Automation`
  const seoTitle = longTitle.length > 60 ? `${product.name} in Punjab | Intellizen` : longTitle

  const jsonLd = graph(
    breadcrumbs([
      home,
      { name: 'Products', path: '/products' },
      { name: categoryLabel, path: `/products?category=${product.category}` },
      { name: product.name, path },
    ]),
    {
      '@type': 'Service',
      name: product.name,
      description: product.lead,
      serviceType: categoryLabel,
      url: siteUrl + path,
      image: product.images.map((image) => siteUrl + image),
      provider: { '@id': organizationId },
    },
    ...(detail ? [faqPage(detail.faq)] : []),
  )


  const pending = product.specs.some((spec) => !isFilled(spec.value))
  const downloads = product.downloads.filter((file) => file.file)

  const tabs = [
    {
      id: 'specifications',
      label: 'Specifications',
      content: (
        <>
          <dl className={styles.specs}>
            {product.specs.map((spec) => (
              <div key={spec.label} className={styles.specRow}>
                <dt>{spec.label}</dt>
                {isFilled(spec.value) ? <dd>{spec.value}</dd> : <dd className={styles.specPending}>{text.specPending}</dd>}
              </div>
            ))}
          </dl>
          {pending && <p className={styles.specNote}>{text.specNote}</p>}
        </>
      ),
    },
    {
      id: 'applications',
      label: 'Applications',
      content: (
        <ul className={styles.applications}>
          {product.applications.map((application) => (
            <li key={application.title} className={styles.application}>
              <ToneBadge tone="blue" className={styles.applicationIcon}>
                <ItemIcon name={application.title} fallback={product.icon} size={22} />
              </ToneBadge>
              <h3>{application.title}</h3>
              <p>{application.text}</p>
            </li>
          ))}
        </ul>
      ),
    },
    {
      id: 'downloads',
      label: 'Downloads',
      content: (
        <ul className={styles.downloads}>
          {downloads.map((file) => (
            <li key={file.label} className={styles.download}>
              <span className={styles.downloadIcon}>
                <Download aria-hidden="true" />
              </span>
              <span className={styles.downloadLabel}>{file.label}</span>
              <a href={file.file} download className={styles.downloadLink}>
                Download
              </a>
            </li>
          ))}
        </ul>
      ),
    },
  ].filter((tab) => (tab.id !== 'downloads' || downloads.length > 0) && (tab.id !== 'applications' || product.applications.length > 0))

  return (
    <>
      <Seo
        title={seoTitle}
        description={product.seoDescription ?? product.lead}
        path={path}
        image={product.images[0]}
        imageAlt={product.imageAlts[0]}
        jsonLd={jsonLd}
      />

      <PageHero
        tags={['Products', categoryLabel]}
        title={product.name}
        subtitle={product.lead}
        actions={
          <>
            <Button to={`/contact?product=${product.slug}`}>
              {copy.product.quote}
              <ArrowRight aria-hidden="true" />
            </Button>
            <Button href={`tel:${site.phones[0].tel}`} variant="ghost">
              <Phone aria-hidden="true" />
              {site.phones[0].label}
            </Button>
          </>
        }
        stats={[
          ...(product.applications.length > 0 ? [{ value: product.applications.length, label: 'Applications', icon: <Workflow aria-hidden="true" /> }] : []),
          { value: product.related.length, label: 'Related products', icon: <Boxes aria-hidden="true" /> },
        ]}
        image={heroImage ? { src: heroImage, alt: product.imageAlts[heroIndex] ?? product.name } : undefined}
        art={product.icon}
        note={{ ...text.notes[product.category], icon: <ProductIcon name={product.icon} size={22} /> }}
      />

      <Section tone="sky" labelledBy="product-name">
        <Reveal className={styles.block}>
          <div className={styles.galleryCol}>
            <Gallery images={product.images} alts={product.imageAlts} name={product.name} icon={product.icon} position={product.imagePosition} />
          </div>

          <div className={styles.info}>
            <div className={styles.titleRow}>
              <span className={styles.iconChip}>
                <ProductIcon name={product.icon} size={26} />
              </span>
              <h2 id="product-name" className={styles.name}>
                {text.glance}
              </h2>
            </div>

            <Tabs items={tabs} label={`${product.name} details`} />
          </div>
        </Reveal>
      </Section>

      {detail && (
        <>
          <Section labelledBy="product-about">
            <div className={styles.about}>
              <div>
                <SectionHeading id="product-about" eyebrow={text.aboutEyebrow} title={product.summary} />
                {detail.intro.map((paragraph, i) => (
                  <Reveal key={paragraph} delay={i * 0.05}>
                    <p className={styles.paragraph}>{paragraph}</p>
                  </Reveal>
                ))}
              </div>
              <Reveal delay={0.1} className={styles.includes}>
                <h3 className={styles.includesTitle}>{text.includesTitle}</h3>
                <ul className={styles.includesList}>
                  {detail.includes.map((item) => (
                    <li key={item}>
                      <span className={styles.tick}>
                        <Check aria-hidden="true" />
                      </span>
                      {item}
                    </li>
                  ))}
                </ul>
                <Button to={`/contact?product=${product.slug}`} block>
                  {text.quote}
                  <ArrowRight aria-hidden="true" />
                </Button>
              </Reveal>
            </div>
          </Section>

          <Section tone="sky" labelledBy="product-features">
            <SectionHeading id="product-features" eyebrow={text.featuresEyebrow} title={text.featuresTitle} accent={text.featuresAccent} />
            <ul className={styles.features}>
              {detail.features.map((feature, i) => (
                <Reveal as="li" key={feature.title} delay={(i % 3) * 0.06} className={styles.feature}>
                  <span className={styles.featureNum}>{String(i + 1).padStart(2, '0')}</span>
                  <h3 className={styles.featureTitle}>{feature.title}</h3>
                  <p className={styles.featureText}>{feature.text}</p>
                </Reveal>
              ))}
            </ul>
          </Section>

          <Section labelledBy="product-process">
            <SectionHeading id="product-process" eyebrow={text.processEyebrow} title={text.processTitle} accent={text.processAccent} />
            <ol className={styles.steps}>
              {detail.process.map((step, i) => (
                <Reveal as="li" key={step.title} delay={i * 0.08} className={styles.step}>
                  <span className={styles.stepNum}>{String(i + 1).padStart(2, '0')}</span>
                  <h3 className={styles.stepTitle}>{step.title}</h3>
                  <p className={styles.stepText}>{step.text}</p>
                </Reveal>
              ))}
            </ol>
          </Section>
        </>
      )}

      <Section tone="sky" labelledBy="related-title">
        <SectionHeading id="related-title" title={copy.product.related} />
        <ul className={styles.related}>
          {related.map((item, i) => (
            <Reveal as="li" key={item.slug} delay={i * 0.06} effect="zoom" className={styles.relatedItem}>
              <ProductCard product={item} variant="vertical" />
            </Reveal>
          ))}
        </ul>

        <Reveal>
          <nav aria-label="More products" className={styles.pager}>
            <Link to={`/products/${previous.slug}`} className={styles.pagerLink} rel="prev">
              <ArrowRight aria-hidden="true" className={styles.back} />
              <span>
                <small>Previous</small>
                {previous.name}
              </span>
            </Link>
            <Link to={`/products/${next.slug}`} className={`${styles.pagerLink} ${styles.pagerNext}`} rel="next">
              <span>
                <small>Next</small>
                {next.name}
              </span>
              <ArrowRight aria-hidden="true" />
            </Link>
          </nav>
        </Reveal>
      </Section>

      <CtaBand />

      {detail && <FaqSection section={{ eyebrow: text.faqEyebrow, title: text.faqTitle, items: detail.faq }} tone="white" />}

      <BlogSection items={postsForProduct(product.slug)} tone="sky" />
    </>
  )
}
