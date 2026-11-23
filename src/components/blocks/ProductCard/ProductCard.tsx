import { ArrowRight } from 'lucide-react'
import { Link } from 'react-router'
import { copy } from '../../../data/site'
import type { Product } from '../../../data/products'
import { useInView } from '../../../hooks/useInView'
import { cx } from '../../../utils/cx'
import { srcSetFor } from '../../../utils/image'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import styles from './ProductCard.module.css'

type ProductCardProps = {
  product: Product
  variant?: 'overlay' | 'vertical'
  className?: string
}

export function ProductCard({ product, variant = 'overlay', className }: ProductCardProps) {
  const [ref, inView] = useInView<HTMLAnchorElement>({ once: true, threshold: 0.4 })
  const image = product.images[0]
  const href = `/products/${product.slug}`

  const media = image ? (
    <img
      src={image}
      srcSet={srcSetFor(image)}
      sizes={variant === 'overlay' ? '(min-width: 1024px) 60vw, (min-width: 640px) 50vw, 100vw' : '(min-width: 980px) 420px, (min-width: 640px) 50vw, 100vw'}
      alt=""
      loading="lazy"
      decoding="async"
      className={styles.image}
      style={{ objectPosition: product.imagePosition }}
    />
  ) : (
    <span className={styles.placeholder}>
      <ProductIcon name={product.icon} size={variant === 'overlay' ? 64 : 52} />
      <span>{copy.product.photoSoon}</span>
    </span>
  )

  if (variant === 'vertical') {
    return (
      <Link ref={ref} to={href} className={cx(styles.card, styles.vertical, className)} data-inview={inView || undefined}>
        <span className={styles.media}>{media}</span>
        <span className={styles.body}>
          <span className={styles.chip}>
            <ProductIcon name={product.icon} size={22} />
          </span>
          <span className={styles.name}>{product.name}</span>
          <span className={styles.summary}>{product.summary}</span>
          <span className={styles.more}>
            View details
            <ArrowRight aria-hidden="true" />
          </span>
        </span>
      </Link>
    )
  }

  return (
    <Link
      ref={ref}
      to={href}
      className={cx(styles.card, styles.overlay, !image && styles.noImage, className)}
      data-inview={inView || undefined}
    >
      <span className={styles.media}>{media}</span>
      <span className={styles.caption}>
        <span className={styles.name}>{product.name}</span>
        <span className={styles.summary}>{product.summary}</span>
      </span>
      <span className={styles.arrow} aria-hidden="true">
        <ArrowRight />
      </span>
    </Link>
  )
}
