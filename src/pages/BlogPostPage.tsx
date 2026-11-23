import { useRef, useState } from 'react'
import { motion, useMotionValueEvent, useScroll } from 'motion/react'
import { ArrowRight, ArrowUpRight, CalendarDays, Check, Clock, Info, Link2, Mail, Tag } from 'lucide-react'
import { Link, useParams } from 'react-router'
import { BlogCard } from '../components/blocks/BlogCard/BlogCard'
import { CtaBand } from '../components/blocks/CtaBand/CtaBand'
import { FaqSection } from '../components/sections/FaqSection/FaqSection'
import { Button } from '../components/ui/Button/Button'
import { Container } from '../components/ui/Container/Container'
import { ProductIcon } from '../components/ui/ProductIcon/ProductIcon'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { RichText } from '../components/ui/RichText/RichText'
import { Section } from '../components/ui/Section/Section'
import { SectionHeading } from '../components/ui/SectionHeading/SectionHeading'
import { Seo } from '../components/ui/Seo/Seo'
import { blogAuthor, formatDate, getPost, posts, readMinutes, type BlogBlock } from '../data/blog'
import { getProduct, type Product } from '../data/products'
import { breadcrumbs, home, organizationId } from '../data/schema'
import { copy, siteUrl } from '../data/site'
import { isFirstRender } from '../utils/firstRender'
import { srcSetFor } from '../utils/image'
import NotFoundPage from './NotFoundPage'
import styles from './BlogPostPage.module.css'

const anchor = (text: string) =>
  text
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')

function Block({ block }: { block: BlogBlock }) {
  switch (block.type) {
    case 'h2':
      return <h2 id={anchor(block.text)}>{block.text}</h2>
    case 'h3':
      return <h3>{block.text}</h3>
    case 'p':
      return (
        <p>
          <RichText text={block.text} />
        </p>
      )
    case 'list':
      return (
        <ul className={styles.list}>
          {block.items.map((item) => (
            <li key={item}>
              <RichText text={item} />
            </li>
          ))}
        </ul>
      )
    case 'table':
      return (
        <>
          <p className={styles.tableHint} aria-hidden="true">
            Swipe sideways to see the whole table
            <ArrowRight size={14} />
          </p>
          <div className={styles.tableWrap}>
            <table className={styles.table}>
              <thead>
                <tr>
                  {block.head.map((cell) => (
                    <th key={cell} scope="col">
                      {cell}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {block.rows.map((row) => (
                  <tr key={row[0]}>
                    {row.map((cell, i) =>
                      i === 0 ? (
                        <th key={cell} scope="row">
                          {cell}
                        </th>
                      ) : (
                        <td key={`${i}-${cell}`}>{cell}</td>
                      ),
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )
    case 'note':
      return (
        <p className={styles.note}>
          <Info aria-hidden="true" />
          <span>{block.text}</span>
        </p>
      )
  }
}

export default function BlogPostPage() {
  const { slug } = useParams()
  const post = getPost(slug)
  const mainRef = useRef<HTMLDivElement>(null)
  const [first] = useState(isFirstRender)
  const [progress, setProgress] = useState(0)
  const [copied, setCopied] = useState(false)
  const { scrollYProgress } = useScroll({ target: mainRef, offset: ['start 120px', 'end end'] })
  useMotionValueEvent(scrollYProgress, 'change', (value) => setProgress(Math.round(Math.min(1, Math.max(0, value)) * 100)))

  if (!post) return <NotFoundPage />

  const page = copy.blog
  const url = `${siteUrl}/blog/${post.slug}`
  const minutes = readMinutes(post)
  const linked = post.products.map((item) => getProduct(item)).filter((item): item is Product => Boolean(item))
  const related = [
    ...posts.filter((item) => item.slug !== post.slug && item.category === post.category),
    ...posts.filter((item) => item.slug !== post.slug && item.category !== post.category),
  ].slice(0, 3)

  const copyLink = async () => {
    try {
      await navigator.clipboard.writeText(url)
      setCopied(true)
      window.setTimeout(() => setCopied(false), 2000)
    } catch {
      window.prompt(page.copy, url)
    }
  }

  const jsonLd = {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'BlogPosting',
        headline: post.title,
        description: post.excerpt,
        image: siteUrl + post.image,
        datePublished: post.published,
        dateModified: post.published,
        author: { '@id': organizationId },
        publisher: { '@id': organizationId },
        mainEntityOfPage: url,
        keywords: post.tags.join(', '),
      },
      breadcrumbs([home, { name: 'Blog', path: '/blog' }, { name: post.title, path: `/blog/${post.slug}` }]),
      {
        '@type': 'FAQPage',
        mainEntity: post.faq.map((item) => ({ '@type': 'Question', name: item.q, acceptedAnswer: { '@type': 'Answer', text: item.a } })),
      },
    ],
  }

  return (
    <>
      <Seo
        title={post.seoTitle ?? `${post.title} | Intellizen`}
        description={post.excerpt}
        path={`/blog/${post.slug}`}
        image={post.image}
        imageAlt={post.imageAlt}
        type="article"
        published={post.published}
        jsonLd={jsonLd}
      />

      <article className={styles.page}>
        <Container className={styles.layout}>
          <div ref={mainRef} className={styles.main}>
            <header className={styles.header}>
              <motion.p className={styles.category} initial={first ? false : { opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}>
                {post.category}
              </motion.p>
              <motion.h1 className={styles.title} initial={first ? false : { opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.7, delay: 0.06 }}>
                {post.title}
              </motion.h1>
              <motion.p className={styles.metaRow} initial={first ? false : { opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.1 }}>
                <span>
                  <CalendarDays aria-hidden="true" />
                  <time dateTime={post.published}>{formatDate(post.published)}</time>
                </span>
                <span>
                  <Clock aria-hidden="true" />
                  {minutes} min read
                </span>
              </motion.p>
              <motion.p className={styles.intro} initial={first ? false : { opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.7, delay: 0.12 }}>
                {post.intro}
              </motion.p>
            </header>

            <Reveal effect="zoom" className={styles.cover}>
              <img src={post.image} srcSet={srcSetFor(post.image)} sizes="(min-width: 1100px) 880px, 94vw" alt={post.imageAlt} width={1600} height={1100} fetchPriority="high" decoding="async" />
            </Reveal>

            <div className={styles.body}>
              {post.body.map((block, i) => (
                <Reveal key={`${block.type}-${i}`}>
                  <Block block={block} />
                </Reveal>
              ))}
            </div>

            <Reveal className={styles.tags}>
              <span className={styles.tagsLabel}>
                <Tag aria-hidden="true" />
                {page.tagsLabel}
              </span>
              <ul>
                {post.tags.map((tag) => (
                  <li key={tag}>{tag}</li>
                ))}
              </ul>
            </Reveal>

            <Reveal className={styles.authorBox}>
              <img src="/assets/brand/logo-mark-color.png" alt="" width={56} height={56} />
              <div>
                <p className={styles.writtenBy}>{page.writtenBy}</p>
                <p className={styles.authorName}>{blogAuthor.name}</p>
                <p className={styles.authorRole}>{blogAuthor.role}</p>
              </div>
            </Reveal>
          </div>

          <aside className={styles.aside} aria-label="Article details">
            <div className={styles.group}>
              <Reveal className={`${styles.card} ${styles.wideOnly}`}>
                <div className={styles.byline}>
                  <img src="/assets/brand/logo-mark-color.png" alt="" width={44} height={44} />
                  <div>
                    <p className={styles.authorName}>{blogAuthor.name}</p>
                    <p className={styles.authorRole}>{blogAuthor.role}</p>
                  </div>
                </div>
                <dl className={styles.facts}>
                  <div>
                    <dt>
                      <CalendarDays aria-hidden="true" />
                      {page.published}
                    </dt>
                    <dd>
                      <time dateTime={post.published}>{formatDate(post.published)}</time>
                    </dd>
                  </div>
                  <div>
                    <dt>
                      <Clock aria-hidden="true" />
                      {page.readTime}
                    </dt>
                    <dd>{minutes} min</dd>
                  </div>
                  <div>
                    <dt>
                      <Tag aria-hidden="true" />
                      {page.category}
                    </dt>
                    <dd>
                      <span className={styles.pill}>{post.category}</span>
                    </dd>
                  </div>
                </dl>
              </Reveal>

              <Reveal delay={0.05} className={styles.card}>
                <p className={styles.cardTitle}>{page.products}</p>
                <ul className={styles.products}>
                  {linked.map((item) => (
                    <li key={item.slug}>
                      <Link to={`/products/${item.slug}`}>
                        <span className={styles.productIcon}>
                          <ProductIcon name={item.icon} size={18} />
                        </span>
                        {item.name}
                        <ArrowRight aria-hidden="true" className={styles.productArrow} />
                      </Link>
                    </li>
                  ))}
                </ul>
              </Reveal>
            </div>

            <div className={`${styles.group} ${styles.sticky}`}>
              <Reveal delay={0.05} className={`${styles.card} ${styles.wideOnly}`}>
                <div className={styles.progressHead}>
                  <span>{page.progress}</span>
                  <span>{progress}%</span>
                </div>
                <div className={styles.progressTrack} role="progressbar" aria-label={page.progress} aria-valuemin={0} aria-valuemax={100} aria-valuenow={progress}>
                  <motion.span className={styles.progressBar} style={{ scaleX: scrollYProgress }} />
                </div>
              </Reveal>

              <Reveal delay={0.1} className={styles.card}>
                <p className={styles.cardTitle}>{page.share}</p>
                <div className={styles.share}>
                  <button type="button" onClick={copyLink} className={styles.shareButton}>
                    {copied ? <Check aria-hidden="true" /> : <Link2 aria-hidden="true" />}
                    {copied ? page.copied : page.copy}
                  </button>
                  <a
                    href={`https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className={styles.shareButton}
                  >
                    <ArrowUpRight aria-hidden="true" />
                    LinkedIn
                  </a>
                  <a href={`mailto:?subject=${encodeURIComponent(post.title)}&body=${encodeURIComponent(url)}`} className={styles.shareButton}>
                    <Mail aria-hidden="true" />
                    Email
                  </a>
                </div>
              </Reveal>

              <Reveal delay={0.15} className={styles.cta}>
                <p className={styles.ctaTitle}>{page.ctaTitle}</p>
                <p className={styles.ctaText}>{page.ctaText}</p>
                <Button to="/contact" block>
                  {page.ctaButton}
                  <ArrowRight aria-hidden="true" />
                </Button>
              </Reveal>
            </div>
          </aside>
        </Container>
      </article>

      <Section tone="sky" labelledBy="related-title">
        <SectionHeading id="related-title" eyebrow={page.relatedEyebrow} title={page.related} link={{ to: '/blog', label: page.allPosts }} />
        <ul className={styles.related}>
          {related.map((item, i) => (
            <Reveal as="li" key={item.slug} delay={i * 0.06} effect="zoom">
              <BlogCard post={item} />
            </Reveal>
          ))}
        </ul>
      </Section>

      <CtaBand />

      <FaqSection section={{ eyebrow: page.faqEyebrow, title: page.faqTitle, items: post.faq }} tone="white" />
    </>
  )
}
