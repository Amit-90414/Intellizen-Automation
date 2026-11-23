import { ArrowRight, CalendarDays, Clock } from 'lucide-react'
import { Link } from 'react-router'
import { blogAuthor, formatDate, readMinutes, type BlogPost } from '../../../data/blog'
import { srcSetFor } from '../../../utils/image'
import styles from './BlogCard.module.css'

export function BlogCard({ post }: { post: BlogPost }) {
  return (
    <Link to={`/blog/${post.slug}`} className={styles.card}>
      <span className={styles.media}>
        <img src={post.image} srcSet={srcSetFor(post.image)} sizes="(min-width: 980px) 420px, (min-width: 640px) 50vw, 100vw" alt="" width={1600} height={1100} loading="lazy" decoding="async" />
        <span className={styles.tag}>{post.category}</span>
      </span>
      <span className={styles.body}>
        <span className={styles.meta}>
          <span>
            <CalendarDays aria-hidden="true" />
            {formatDate(post.published)}
          </span>
          <span className={styles.dot} aria-hidden="true" />
          <span>
            <Clock aria-hidden="true" />
            {readMinutes(post)} min read
          </span>
        </span>
        <h3 className={styles.title}>{post.title}</h3>
        <span className={styles.excerpt}>{post.excerpt}</span>
        <span className={styles.foot}>
          <span className={styles.author}>
            <img src="/assets/brand/logo-mark-color.png" alt="" width={28} height={28} />
            {blogAuthor.name}
          </span>
          <span className={styles.more}>
            Read more
            <ArrowRight aria-hidden="true" />
          </span>
        </span>
      </span>
    </Link>
  )
}
