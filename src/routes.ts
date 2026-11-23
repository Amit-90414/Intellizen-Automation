import { matchPath } from 'react-router'
import { lazyPage } from './utils/lazyPage'

export const ProductsPage = lazyPage(() => import('./pages/ProductsPage'))
export const ProductDetailPage = lazyPage(() => import('./pages/ProductDetailPage'))
export const AboutPage = lazyPage(() => import('./pages/AboutPage'))
export const ContactPage = lazyPage(() => import('./pages/ContactPage'))
export const TechnologyPage = lazyPage(() => import('./pages/TechnologyPage'))
export const BlogPage = lazyPage(() => import('./pages/BlogPage'))
export const BlogPostPage = lazyPage(() => import('./pages/BlogPostPage'))
export const LegalPage = lazyPage(() => import('./pages/LegalPage'))

const pages: [string, { preload: () => Promise<unknown> }][] = [
  ['/products', ProductsPage],
  ['/products/:slug', ProductDetailPage],
  ['/technology', TechnologyPage],
  ['/blog', BlogPage],
  ['/blog/:slug', BlogPostPage],
  ['/privacy-policy', LegalPage],
  ['/cookie-policy', LegalPage],
  ['/about', AboutPage],
  ['/contact', ContactPage],
]

export function preloadRoute(pathname: string) {
  const match = pages.find(([path]) => matchPath(path, pathname))
  return match ? match[1].preload() : Promise.resolve()
}
