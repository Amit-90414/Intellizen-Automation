import { useEffect, useRef, useState } from 'react'
import { createPortal } from 'react-dom'
import { AnimatePresence, motion } from 'motion/react'
import { ChevronDown, Mail, X } from 'lucide-react'
import { WhatsAppIcon } from '../../ui/WhatsAppIcon/WhatsAppIcon'
import { Link, NavLink, useLocation } from 'react-router'
import { productGroups } from '../../../data/menu'
import { copy, nav, site } from '../../../data/site'
import { cx } from '../../../utils/cx'
import { Button } from '../../ui/Button/Button'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import styles from './MobileNav.module.css'

type MobileNavProps = {
  open: boolean
  onClose: (restoreFocus: boolean) => void
}

const ease = [0.2, 0.7, 0.2, 1] as const
const FOCUSABLE = 'a[href], button:not([disabled])'

export function MobileNav({ open, onClose }: MobileNavProps) {
  const panelRef = useRef<HTMLDivElement>(null)
  const { pathname } = useLocation()
  const [productsOpen, setProductsOpen] = useState(() => pathname.startsWith('/products'))
  const lastPath = useRef(pathname)

  useEffect(() => {
    if (lastPath.current === pathname) return
    lastPath.current = pathname
    onClose(false)
  }, [pathname, onClose])

  useEffect(() => {
    if (!open) return
    const frame = window.requestAnimationFrame(() => {
      panelRef.current?.querySelector<HTMLElement>('[data-autofocus]')?.focus()
    })
    return () => window.cancelAnimationFrame(frame)
  }, [open])

  useEffect(() => {
    if (!open) return
    const { body } = document
    const previousOverflow = body.style.overflow
    body.style.overflow = 'hidden'

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.preventDefault()
        onClose(true)
        return
      }
      if (event.key !== 'Tab' || !panelRef.current) return
      const items = Array.from(panelRef.current.querySelectorAll<HTMLElement>(FOCUSABLE))
      if (items.length === 0) return
      const first = items[0]
      const last = items[items.length - 1]
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault()
        last.focus()
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault()
        first.focus()
      }
    }

    document.addEventListener('keydown', onKeyDown)
    return () => {
      body.style.overflow = previousOverflow
      document.removeEventListener('keydown', onKeyDown)
    }
  }, [open, onClose])

  return createPortal(
    <AnimatePresence>
      {open && (
        <div className={styles.root}>
          <motion.div
            className={styles.backdrop}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.28 }}
            onClick={() => onClose(true)}
          />
          <motion.div
            ref={panelRef}
            id="mobile-nav"
            role="dialog"
            aria-modal="true"
            aria-label="Menu"
            className={styles.panel}
            initial={{ x: '100%' }}
            animate={{ x: 0 }}
            exit={{ x: '100%' }}
            transition={{ duration: 0.28, ease }}
          >
            <div className={styles.top}>
              <Link to="/" className={styles.logo} onClick={() => onClose(false)}>
                <img src="/assets/brand/logo-color.png" alt="Intellizen Automation Solutions" width={427} height={127} />
              </Link>
              <button type="button" className={styles.close} aria-label="Close menu" data-autofocus onClick={() => onClose(true)}>
                <X aria-hidden="true" />
              </button>
            </div>

            <nav aria-label="Mobile" className={styles.nav}>
              <ul className={styles.list}>
                {nav.map((item) =>
                  item.to === '/products' ? (
                    <li key={item.to}>
                      <button
                        type="button"
                        className={cx(styles.link, styles.accordion, pathname.startsWith('/products') && styles.active)}
                        aria-expanded={productsOpen}
                        aria-controls="mobile-products"
                        onClick={() => setProductsOpen((value) => !value)}
                      >
                        {item.label}
                        <ChevronDown aria-hidden="true" className={cx(styles.chevron, productsOpen && styles.chevronOpen)} />
                      </button>
                      <AnimatePresence initial={false}>
                        {productsOpen && (
                          <motion.ul
                            id="mobile-products"
                            className={styles.sub}
                            initial={{ opacity: 0, y: -6 }}
                            animate={{ opacity: 1, y: 0 }}
                            exit={{ opacity: 0, y: -6 }}
                            transition={{ duration: 0.2, ease }}
                          >
                            {productGroups.map((group) => (
                              <li key={group.key} className={styles.group}>
                                <span className={styles.groupTitle}>{group.label}</span>
                                <ul className={styles.groupLinks}>
                                  {group.items.map((product) => (
                                    <li key={product.slug}>
                                      <NavLink
                                        to={`/products/${product.slug}`}
                                        className={({ isActive }) => cx(styles.subLink, isActive && styles.subActive)}
                                        onClick={() => onClose(false)}
                                      >
                                        <span className={styles.subIcon}>
                                          <ProductIcon name={product.icon} size={18} />
                                        </span>
                                        {product.name}
                                      </NavLink>
                                    </li>
                                  ))}
                                </ul>
                              </li>
                            ))}
                            <li>
                              <NavLink to="/products" end className={styles.viewAll} onClick={() => onClose(false)}>
                                {copy.header.megaAll}
                              </NavLink>
                            </li>
                          </motion.ul>
                        )}
                      </AnimatePresence>
                    </li>
                  ) : (
                    <li key={item.to}>
                      <NavLink
                        to={item.to}
                        end={item.to === '/'}
                        className={({ isActive }) => cx(styles.link, isActive && styles.active)}
                        onClick={() => onClose(false)}
                      >
                        {item.label}
                      </NavLink>
                    </li>
                  ),
                )}
              </ul>
            </nav>

            <div className={styles.bottom}>
              <Button to="/contact" variant="dark" block onClick={() => onClose(false)}>
                {copy.header.cta}
              </Button>
              <a href={site.phones[0].wa} target="_blank" rel="noopener noreferrer" className={styles.contact}>
                <WhatsAppIcon />
                {site.phones[0].label}
              </a>
              <a href={`mailto:${site.emails[1]}`} className={styles.contact}>
                <Mail aria-hidden="true" />
                {site.emails[1]}
              </a>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>,
    document.body,
  )
}
