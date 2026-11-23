import type { IconKey } from '../../../data/products'
import { ProductIcon } from '../ProductIcon/ProductIcon'
import { icons, productPageIcons } from './icons'

type ItemIconProps = {
  name: string
  fallback: IconKey
  size?: number
  className?: string
}

export function ItemIcon({ name, fallback, size = 24, className }: ItemIconProps) {
  const Icon = icons[name] ?? productPageIcons[name]
  if (!Icon) return <ProductIcon name={fallback} size={size} className={className} />
  return <Icon size={size} strokeWidth={1.8} className={className} aria-hidden="true" focusable="false" />
}
