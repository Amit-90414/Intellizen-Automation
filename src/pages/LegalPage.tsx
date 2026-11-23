import { Link } from 'react-router'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { Reveal } from '../components/ui/Reveal/Reveal'
import { Section } from '../components/ui/Section/Section'
import { Seo } from '../components/ui/Seo/Seo'
import { formatDate } from '../data/blog'
import { cookiePolicy, privacyPolicy, type LegalDoc } from '../data/legal'
import { breadcrumbs, graph, home } from '../data/schema'
import styles from './LegalPage.module.css'

const docs: Record<'privacy' | 'cookies', LegalDoc> = {
  privacy: privacyPolicy,
  cookies: cookiePolicy,
}

export default function LegalPage({ doc }: { doc: 'privacy' | 'cookies' }) {
  const page = docs[doc]
  const other = doc === 'privacy' ? cookiePolicy : privacyPolicy
  const updated = formatDate(page.updated)

  return (
    <>
      <Seo
        title={page.title}
        description={page.description}
        path={page.path}
        jsonLd={graph(breadcrumbs([home, { name: page.heading, path: page.path }]))}
      />

      <PageHero size="small" tags={['Legal', `Updated ${updated}`]} title={page.heading} subtitle={page.sub} />

      <Section>
        <div className={styles.layout}>
          <aside className={styles.aside} aria-label="On this page">
            <div className={styles.toc}>
              <p className={styles.tocTitle}>On this page</p>
              <ol>
                {page.sections.map((section) => (
                  <li key={section.id}>
                    <a href={`#${section.id}`}>{section.title}</a>
                  </li>
                ))}
              </ol>
              <Link to={other.path} className={styles.other}>
                {other.heading}
              </Link>
            </div>
          </aside>

          <article className={styles.article}>
            <p className={styles.updated}>
              Last updated: <time dateTime={page.updated}>{updated}</time>
            </p>
            {page.sections.map((section) => (
              <Reveal key={section.id}>
                <section id={section.id} className={styles.block} aria-labelledby={`${section.id}-title`}>
                  <h2 id={`${section.id}-title`}>{section.title}</h2>
                  {section.paragraphs?.map((paragraph) => <p key={paragraph}>{paragraph}</p>)}
                  {section.list && (
                    <ul>
                      {section.list.map((item) => (
                        <li key={item}>{item}</li>
                      ))}
                    </ul>
                  )}
                  {section.after?.map((paragraph) => <p key={paragraph}>{paragraph}</p>)}
                </section>
              </Reveal>
            ))}
          </article>
        </div>
      </Section>
    </>
  )
}
