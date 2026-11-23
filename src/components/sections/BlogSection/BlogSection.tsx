import { posts, type BlogPost } from '../../../data/blog'
import { blogSection } from '../../../data/home'
import { BlogCard } from '../../blocks/BlogCard/BlogCard'
import { Reveal } from '../../ui/Reveal/Reveal'
import { Section } from '../../ui/Section/Section'
import { SectionHeading } from '../../ui/SectionHeading/SectionHeading'
import styles from './BlogSection.module.css'

type BlogSectionProps = {
  items?: BlogPost[]
  tone?: 'white' | 'sky'
}

export function BlogSection({ items, tone = 'white' }: BlogSectionProps) {
  const section = blogSection
  const latest = items ?? posts.slice(0, section.count)

  return (
    <Section tone={tone} labelledBy="blog-title" className={styles.section}>
      <SectionHeading
        id="blog-title"
        eyebrow={section.eyebrow}
        title={section.title}
        accent={section.accent}
        text={section.text}
        link={{ to: '/blog', label: section.link }}
      />
      <ul className={styles.grid}>
        {latest.map((post, i) => (
          <Reveal as="li" key={post.slug} delay={i * 0.08} effect="zoom">
            <BlogCard post={post} />
          </Reveal>
        ))}
      </ul>
    </Section>
  )
}
