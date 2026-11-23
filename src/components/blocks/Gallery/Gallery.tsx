import { useState } from 'react'
import { AnimatePresence, motion } from 'motion/react'
import { copy } from '../../../data/site'
import type { IconKey } from '../../../data/products'
import { cx } from '../../../utils/cx'
import { srcSetFor, thumbVersion } from '../../../utils/image'
import { ProductIcon } from '../../ui/ProductIcon/ProductIcon'
import styles from './Gallery.module.css'

type GalleryProps = {
  images: string[]
  alts?: string[]
  name: string
  icon: IconKey
  position?: string
}

const SLOTS = 4

export function Gallery({ images, alts, name, icon, position }: GalleryProps) {
  const [active, setActive] = useState(0)
  const current = images[active]

  return (
    <div className={styles.gallery}>
      <div className={styles.main}>
        <AnimatePresence initial={false}>
          {current ? (
            <motion.img
              key={current}
              src={current}
              srcSet={srcSetFor(current)}
              sizes="(min-width: 1180px) 640px, 94vw"
              alt={alts?.[active] ?? `${name}, image ${active + 1} of ${images.length}`}
              width={1200}
              height={760}
              className={styles.mainImage}
              style={{ objectPosition: active === 0 ? position : undefined }}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.25 }}
            />
          ) : (
            <div className={styles.placeholder}>
              <ProductIcon name={icon} size={72} />
              <span>{copy.product.photoSoon}</span>
            </div>
          )}
        </AnimatePresence>
      </div>

      {images.length > 1 && (
        <ul className={styles.thumbs}>
          {images.slice(0, SLOTS).map((src, i) => (
            <li key={src}>
              <button
                type="button"
                className={cx(styles.thumb, i === active && styles.thumbActive)}
                aria-label={`Show image ${i + 1} of ${name}`}
                aria-pressed={i === active}
                onClick={() => setActive(i)}
              >
                <img src={thumbVersion(src)} alt="" width={480} height={330} loading="lazy" decoding="async" style={{ objectPosition: i === 0 ? position : undefined }} />
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
