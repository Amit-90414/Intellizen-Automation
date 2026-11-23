import { categories, categoryKeys } from './categories'
import { products } from './products'

export const productGroups = categoryKeys.map((key) => {
  const items = products.filter((product) => product.category === key)
  const cover = items.find((product) => product.images.length > 0)
  return {
    key,
    label: categories[key],
    items,
    icon: items[0].icon,
    image: cover?.images[0],
    imagePosition: cover?.imagePosition,
  }
})
