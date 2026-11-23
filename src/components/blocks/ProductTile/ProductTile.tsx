import { ArrowRight } from 'lucide-react'
import { Link } from 'react-router'
import type { Product } from '../../../data/products'
import { cx } from '../../../utils/cx'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import styles from './ProductTile.module.css'

type ProductTileProps = {
  product: Product
  showSummary?: boolean
  className?: string
}

export function ProductTile({ product, showSummary = true, className }: ProductTileProps) {
  return (
    <Link to={`/products/${product.slug}`} className={cx(styles.tile, className)}>
      <span className={styles.chip}>
        <ProductIcon name={product.icon} size={24} />
      </span>
      <span className={styles.text}>
        <span className={styles.name}>{product.name}</span>
        {showSummary && <span className={styles.summary}>{product.summary}</span>}
      </span>
      <ArrowRight aria-hidden="true" className={styles.arrow} />
    </Link>
  )
}
