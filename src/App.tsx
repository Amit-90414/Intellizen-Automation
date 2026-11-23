import { Suspense, useEffect } from 'react'
import { AnimatePresence, MotionConfig, motion } from 'motion/react'
import { Route, Routes, useLocation } from 'react-router'
import { Layout } from './components/layout/Layout/Layout'
import { ScrollToTop } from './components/layout/ScrollToTop/ScrollToTop'
import HomePage from './pages/HomePage'
import NotFoundPage from './pages/NotFoundPage'
import { AboutPage, BlogPage, BlogPostPage, ContactPage, LegalPage, ProductDetailPage, ProductsPage, TechnologyPage } from './routes'
import { endFirstRender } from './utils/firstRender'

const ease = [0.2, 0.7, 0.2, 1] as const

export default function App() {
  const location = useLocation()

  useEffect(endFirstRender, [])

  return (
    <MotionConfig reducedMotion="user">
      <Layout>
        <AnimatePresence mode="wait" initial={false}>
          <motion.div
            key={location.pathname}
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0, transition: { duration: 0.35, ease } }}
            exit={{ opacity: 0, transition: { duration: 0.2 } }}
          >
            <ScrollToTop />
            <Suspense fallback={<div style={{ minHeight: '70vh' }} />}>
              <Routes location={location}>
                <Route path="/" element={<HomePage />} />
                <Route path="/products" element={<ProductsPage />} />
                <Route path="/products/:slug" element={<ProductDetailPage />} />
                <Route path="/technology" element={<TechnologyPage />} />
                <Route path="/blog" element={<BlogPage />} />
                <Route path="/blog/:slug" element={<BlogPostPage />} />
                <Route path="/privacy-policy" element={<LegalPage doc="privacy" />} />
                <Route path="/cookie-policy" element={<LegalPage doc="cookies" />} />
                <Route path="/about" element={<AboutPage />} />
                <Route path="/contact" element={<ContactPage />} />
                <Route path="*" element={<NotFoundPage />} />
              </Routes>
            </Suspense>
          </motion.div>
        </AnimatePresence>
      </Layout>
    </MotionConfig>
  )
}
