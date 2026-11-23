import { ArrowRight, ArrowUp } from 'lucide-react'
import { Link } from 'react-router'
import { formatDate, posts, readMinutes } from '../../../data/blog'
import { products } from '../../../data/products'
import { copy, site, social } from '../../../data/site'
import { Container } from '../../ui/Container/Container'
import { InstagramIcon } from '../../ui/InstagramIcon/InstagramIcon'
import { Reveal } from '../../ui/Reveal/Reveal'
import styles from './Footer.module.css'

const year = new Date().getFullYear()
const text = copy.footer
const latest = posts.slice(-3).reverse()

const backToTop = () => {
  const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  window.scrollTo({ top: 0, behavior: reduce ? 'auto' : 'smooth' })
}

export function Footer() {
  return (
    <footer className={styles.footer}>
      <Container className={styles.grid}>
        <Reveal>
          <div className={styles.brand}>
            <Link to="/" className={styles.logo}>
              <img src="/assets/brand/logo-white.png" alt="Intellizen Automation Solutions" width={427} height={127} />
            </Link>
            <p className={styles.about}>{text.about}</p>
            {/* <address className={styles.contact}>
              {site.phones.map((phone) => (
                <a key={phone.tel} href={`tel:${phone.tel}`}>
                  <Phone size={18} aria-hidden="true" />
                  {phone.label}
                </a>
              ))}
              {site.emails.map((email) => (
                <a key={email} href={`mailto:${email}`}>
                  <Mail size={18} aria-hidden="true" />
                  {email}
                </a>
              ))}
              <a href={site.mapsUrl} target="_blank" rel="noopener noreferrer">
                <MapPin size={18} aria-hidden="true" />
                {site.address}
              </a>
            </address> */}
            <ul className={styles.social}>
              {social.map((profile) => (
                <li key={profile.href}>
                  <a href={profile.href} target="_blank" rel="noopener noreferrer" aria-label={`${site.name} on ${profile.label}`}>
                    <InstagramIcon size={20} />
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </Reveal>

        <Reveal delay={0.08}>
          <nav aria-labelledby="footer-company">
            <h2 id="footer-company" className={styles.heading}>{text.company}</h2>
            <ul className={styles.list}>
              {text.links.map((item) => (
                <li key={item.to}>
                  <Link to={item.to}>{item.label}</Link>
                </li>
              ))}
            </ul>
          </nav>
        </Reveal>

        <Reveal delay={0.16}>
          <nav aria-labelledby="footer-products">
            <h2 id="footer-products" className={styles.heading}>{text.products}</h2>
            <ul className={`${styles.list} ${styles.wide}`}>
              {products.map((product) => (
                <li key={product.slug}>
                  <Link to={`/products/${product.slug}`}>{product.name}</Link>
                </li>
              ))}
            </ul>
          </nav>
        </Reveal>

        <Reveal delay={0.24}>
          <nav aria-labelledby="footer-blog">
            <h2 id="footer-blog" className={styles.heading}>{text.blog}</h2>
            <ul className={styles.posts}>
              {latest.map((post) => (
                <li key={post.slug}>
                  <Link to={`/blog/${post.slug}`}>{post.title}</Link>
                  <span>
                    <time dateTime={post.published}>{formatDate(post.published)}</time> · {readMinutes(post)} min read
                  </span>
                </li>
              ))}
            </ul>
            <Link to="/blog" className={styles.more}>
              {text.allPosts}
              <ArrowRight size={16} aria-hidden="true" />
            </Link>
          </nav>
        </Reveal>
      </Container>

      <div className={styles.bottom}>
        <Container className={styles.bottomRow}>
          <p className={styles.legal}>
            <span>
              © {year} {site.name} · Derabassi, Punjab
            </span>
            <span>GSTIN: {site.gstin}</span>
          </p>
          <button type="button" className={styles.top} onClick={backToTop}>
            Back to top
            <ArrowUp size={16} aria-hidden="true" />
          </button>
        </Container>
      </div>
    </footer>
  )
}
