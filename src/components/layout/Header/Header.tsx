import { useCallback, useEffect, useId, useRef, useState, type PointerEvent as ReactPointerEvent } from 'react'
import { AnimatePresence, motion } from 'motion/react'
import { ArrowUpRight, ChevronDown, Menu } from 'lucide-react'
import { WhatsAppIcon } from '../../ui/WhatsAppIcon/WhatsAppIcon'
import { Link, NavLink, useLocation } from 'react-router'
import { productGroups } from '../../../data/menu'
import { copy, nav, site } from '../../../data/site'
import { useScrolled } from '../../../hooks/useScrolled'
import { cx } from '../../../utils/cx'
import { thumbVersion } from '../../../utils/image'
import { Button } from '../../ui/Button/Button'
import { Container } from '../../ui/Container/Container'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import { MobileNav } from '../MobileNav/MobileNav'
import styles from './Header.module.css'

const linkClass = ({ isActive }: { isActive: boolean }) => cx(styles.link, isActive && styles.active)

function usePreloadMenuImages() {
  useEffect(() => {
    if (!window.matchMedia('(hover: hover) and (pointer: fine) and (min-width: 980px)').matches) return
    const timer = window.setTimeout(() => {
      for (const group of productGroups) {
        if (!group.image) continue
        const img = new Image()
        img.decoding = 'async'
        img.src = thumbVersion(group.image)
      }
    }, 2500)
    return () => window.clearTimeout(timer)
  }, [])
}

function ProductsMenu({ label }: { label: string }) {
  const { pathname } = useLocation()
  const [openOn, setOpenOn] = useState<string | null>(null)
  const open = openOn === pathname
  const wrapRef = useRef<HTMLDivElement>(null)
  const triggerRef = useRef<HTMLButtonElement>(null)
  const closeTimer = useRef<number | undefined>(undefined)
  const openedByHover = useRef(false)
  const panelId = useId()
  const active = pathname.startsWith('/products')

  usePreloadMenuImages()

  const setOpen = useCallback(
    (next: boolean | ((value: boolean) => boolean)) => {
      setOpenOn((current) => {
        const value = typeof next === 'function' ? next(current === pathname) : next
        return value ? pathname : null
      })
    },
    [pathname],
  )

  useEffect(() => {
    if (!open) return
    const onPointerDown = (event: PointerEvent) => {
      if (!wrapRef.current?.contains(event.target as Node)) setOpen(false)
    }
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return
      setOpen(false)
      triggerRef.current?.focus()
    }
    document.addEventListener('pointerdown', onPointerDown)
    document.addEventListener('keydown', onKeyDown)
    return () => {
      document.removeEventListener('pointerdown', onPointerDown)
      document.removeEventListener('keydown', onKeyDown)
    }
  }, [open, setOpen])

  useEffect(() => () => window.clearTimeout(closeTimer.current), [])

  const onPointerEnter = (event: ReactPointerEvent) => {
    if (event.pointerType !== 'mouse') return
    window.clearTimeout(closeTimer.current)
    if (!open) openedByHover.current = true
    setOpen(true)
  }

  const onPointerLeave = (event: ReactPointerEvent) => {
    if (event.pointerType !== 'mouse') return
    closeTimer.current = window.setTimeout(() => setOpen(false), 160)
  }

  const onTriggerClick = () => {
    if (openedByHover.current) {
      openedByHover.current = false
      setOpen(true)
      return
    }
    setOpen((value) => !value)
  }

  return (
    <div
      ref={wrapRef}
      className={cx(styles.mega, open && styles.megaOpen)}
      onPointerEnter={onPointerEnter}
      onPointerLeave={onPointerLeave}
      onBlur={(event) => {
        if (!event.currentTarget.contains(event.relatedTarget)) setOpen(false)
      }}
    >
      <button
        ref={triggerRef}
        type="button"
        className={cx(styles.link, styles.trigger, (active || open) && styles.active)}
        aria-expanded={open}
        aria-controls={panelId}
        onClick={onTriggerClick}
      >
        {label}
        <ChevronDown aria-hidden="true" className={cx(styles.chevron, open && styles.chevronOpen)} />
      </button>

      <AnimatePresence>
        {open && (
          <motion.div
            id={panelId}
            className={styles.panel}
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 8 }}
            transition={{ duration: 0.18, ease: [0.2, 0.7, 0.2, 1] }}
          >
            <div className={styles.megaGrid}>
              {productGroups.map((group) => {
                const href = `/products?category=${group.key}`
                return (
                  <section key={group.key} className={styles.megaCol} aria-labelledby={`${panelId}-${group.key}`}>
                    <Link id={`${panelId}-${group.key}`} to={href} className={styles.megaTitle}>
                      {group.label}
                    </Link>
                    <Link to={href} className={styles.megaMedia} tabIndex={-1} aria-hidden="true">
                      {group.image ? (
                        <img src={thumbVersion(group.image)} alt="" width={440} height={200} decoding="async" style={{ objectPosition: group.imagePosition }} />
                      ) : (
                        <span className={styles.megaArt}>
                          <ProductIcon name={group.icon} size={40} />
                        </span>
                      )}
                    </Link>
                    <ul className={styles.megaLinks}>
                      {group.items.map((product) => (
                        <li key={product.slug}>
                          <NavLink to={`/products/${product.slug}`} className={({ isActive }) => cx(styles.megaItem, isActive && styles.megaActive)}>
                            {product.name}
                          </NavLink>
                        </li>
                      ))}
                    </ul>
                  </section>
                )
              })}
            </div>
            <div className={styles.megaFoot}>
              <p>{copy.header.megaNote}</p>
              <Link to="/products" className={styles.megaAll}>
                {copy.header.megaAll}
                <ArrowUpRight aria-hidden="true" />
              </Link>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}

export function Header() {
  const scrolled = useScrolled(8)
  const [drawerOpen, setDrawerOpen] = useState(false)
  const burgerRef = useRef<HTMLButtonElement>(null)
  const phone = site.phones[0]

  const closeDrawer = useCallback((restoreFocus: boolean) => {
    setDrawerOpen(false)
    if (restoreFocus) burgerRef.current?.focus()
  }, [])

  return (
    <header className={cx(styles.header, scrolled && styles.scrolled)}>
      <Container className={styles.inner}>
        <Link to="/" className={styles.logo}>
          <img src="/assets/brand/logo-color.png" alt="Intellizen Automation Solutions" width={427} height={127} />
        </Link>

        <nav aria-label="Main" className={styles.nav}>
          <ul className={styles.menu}>
            {nav.map((item) => (
              <li key={item.to}>
                {item.to === '/products' ? (
                  <ProductsMenu label={item.label} />
                ) : (
                  <NavLink to={item.to} end={item.to === '/'} className={linkClass}>
                    {item.label}
                  </NavLink>
                )}
              </li>
            ))}
          </ul>
        </nav>

        <div className={styles.actions}>
          <a href={phone.wa} target="_blank" rel="noopener noreferrer" className={styles.phone}>
            <WhatsAppIcon />
            {phone.label}
          </a>
          <Button to="/contact" variant="dark" className={styles.cta}>
            {copy.header.cta}
            <ArrowUpRight aria-hidden="true" />
          </Button>
        </div>

        <button
          ref={burgerRef}
          type="button"
          className={styles.burger}
          aria-label="Open menu"
          aria-expanded={drawerOpen}
          aria-controls="mobile-nav"
          onClick={() => setDrawerOpen(true)}
        >
          <Menu aria-hidden="true" />
        </button>
      </Container>

      <MobileNav open={drawerOpen} onClose={closeDrawer} />
    </header>
  )
}
