const isBlogCover = (src: string) => src.startsWith('/assets/blog/') && src.endsWith('.jpg')

const hasVariants = (src: string) => src.includes('/render-') || isBlogCover(src)

const webp = (src: string, suffix = '') => src.replace(/\.jpg$/, `${suffix}.webp`)

export const thumbVersion = (src: string) => (hasVariants(src) ? webp(src, '-xs') : src)

export const srcSetFor = (src: string) => {
  if (!hasVariants(src)) return undefined
  const full = isBlogCover(src) ? 1600 : 2400
  return `${webp(src, '-xs')} 480w, ${webp(src, '-md')} 800w, ${webp(src, '-sm')} 1200w, ${webp(src)} ${full}w`
}
