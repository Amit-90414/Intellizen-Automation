import { useState } from 'react'
import { AnimatePresence, motion } from 'motion/react'
import { ArrowDown, Search, X } from 'lucide-react'
import { BlogCard } from '../components/blocks/BlogCard/BlogCard'
import { CtaBand } from '../components/blocks/CtaBand/CtaBand'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { Button } from '../components/ui/Button/Button'
import { FilterChips } from '../components/ui/FilterChips/FilterChips'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { Seo } from '../components/ui/Seo/Seo'
import { blogCategories, posts } from '../data/blog'
import { breadcrumbs, graph, home, organizationId } from '../data/schema'
import { copy, siteUrl } from '../data/site'
import styles from './BlogPage.module.css'

const ALL = 'all'
const ease = [0.2, 0.7, 0.2, 1] as const

export default function BlogPage() {
  const page = copy.blog
  const [category, setCategory] = useState(ALL)
  const [query, setQuery] = useState('')
  const needle = query.trim().toLowerCase()

  const visible = posts.filter((post) => {
    if (category !== ALL && post.category !== category) return false
    if (!needle) return true
    return [post.title, post.excerpt, post.category, ...post.tags].join(' ').toLowerCase().includes(needle)
  })

  const options = [
    { key: ALL, label: page.all, count: posts.length },
    ...blogCategories.map((name) => ({ key: name, label: name, count: posts.filter((post) => post.category === name).length })),
  ]

  const reset = () => {
    setCategory(ALL)
    setQuery('')
  }

  return (
    <>
      <Seo
        title={page.title}
        description={page.description}
        path="/blog"
        image={posts[0].image}
        imageAlt={posts[0].imageAlt}
        jsonLd={graph(breadcrumbs([home, { name: 'Blog', path: '/blog' }]), {
          '@type': 'Blog',
          '@id': `${siteUrl}/blog#blog`,
          url: `${siteUrl}/blog`,
          name: page.heading,
          publisher: { '@id': organizationId },
          blogPost: posts.map((post) => ({
            '@type': 'BlogPosting',
            headline: post.title,
            url: `${siteUrl}/blog/${post.slug}`,
            datePublished: post.published,
            image: siteUrl + post.image,
          })),
        })}
      />

      <PageHero
        tags={page.tags}
        title={page.heading}
        subtitle={page.sub}
        actions={
          <>
            <Button to="#articles">
              {page.read}
              <ArrowDown aria-hidden="true" />
            </Button>
            <Button to="/contact" variant="ghost">
              {copy.home.primary}
            </Button>
          </>
        }
        size="small"
      />

      <Section tone="sky" id="articles" labelledBy="articles-title">
        <h2 id="articles-title" className="sr-only">
          {page.listTitle}
        </h2>

        <Reveal className={styles.toolbar}>
          <FilterChips options={options} value={category} onChange={setCategory} label={page.filterLabel} />
          <label className={styles.search}>
            <Search aria-hidden="true" className={styles.searchIcon} />
            <span className="sr-only">{page.searchLabel}</span>
            <input
              type="search"
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder={page.searchPlaceholder}
              enterKeyHint="search"
              autoComplete="off"
            />
            {query && (
              <button type="button" className={styles.clear} onClick={() => setQuery('')} aria-label="Clear search">
                <X aria-hidden="true" />
              </button>
            )}
          </label>
        </Reveal>

        <p className="sr-only" aria-live="polite">
          {`Showing ${visible.length} ${visible.length === 1 ? 'article' : 'articles'}`}
        </p>

        {visible.length > 0 ? (
          <motion.ul layout className={styles.grid}>
            <AnimatePresence mode="popLayout" initial={false}>
              {visible.map((post, i) => (
                <motion.li
                  key={post.slug}
                  layout
                  initial={{ opacity: 0, scale: 0.96 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.96 }}
                  transition={{ duration: 0.3, ease }}
                >
                  <Reveal effect="zoom" delay={(i % 3) * 0.06} className={styles.cardReveal}>
                    <BlogCard post={post} />
                  </Reveal>
                </motion.li>
              ))}
            </AnimatePresence>
          </motion.ul>
        ) : (
          <div className={styles.empty}>
            <p>{page.empty}</p>
            <Button variant="secondary" onClick={reset}>
              {page.clear}
            </Button>
          </div>
        )}
      </Section>

      <CtaBand />
    </>
  )
}
