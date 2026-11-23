import { writeFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { posts } from '../src/data/blog.ts'
import { products } from '../src/data/products.ts'
import { siteUrl } from '../src/data/site.ts'

const today = new Date().toISOString().slice(0, 10)

const pages = [
  { path: '/', priority: '1.0', changefreq: 'monthly' },
  { path: '/products', priority: '0.9', changefreq: 'monthly' },
  ...products.map((product) => ({ path: `/products/${product.slug}`, priority: '0.8', changefreq: 'monthly' })),
  { path: '/technology', priority: '0.7', changefreq: 'monthly' },
  { path: '/blog', priority: '0.7', changefreq: 'weekly' },
  ...posts.map((post) => ({ path: `/blog/${post.slug}`, priority: '0.6', changefreq: 'monthly' })),
  { path: '/about', priority: '0.6', changefreq: 'yearly' },
  { path: '/contact', priority: '0.7', changefreq: 'yearly' },
  { path: '/privacy-policy', priority: '0.3', changefreq: 'yearly' },
  { path: '/cookie-policy', priority: '0.3', changefreq: 'yearly' },
]

const urls = pages
  .map(
    (page) => `  <url>
    <loc>${siteUrl}${page.path}</loc>
    <lastmod>${today}</lastmod>
    <changefreq>${page.changefreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>`,
  )
  .join('\n')

const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls}
</urlset>
`

const target = fileURLToPath(new URL('../public/sitemap.xml', import.meta.url))
writeFileSync(target, xml)
console.log(`sitemap.xml written with ${pages.length} URLs`)
