import { site, siteUrl } from '../../../data/site'

type SeoProps = {
  title: string
  description: string
  path: string
  image?: string
  imageAlt?: string
  type?: 'website' | 'article'
  published?: string
  noindex?: boolean
  jsonLd?: object
}

export const defaultShareImage = '/assets/products/custom-automation-solutions/render-1.jpg'

export function Seo({
  title,
  description,
  path,
  image = defaultShareImage,
  imageAlt = site.name,
  type = 'website',
  published,
  noindex = false,
  jsonLd,
}: SeoProps) {
  const url = siteUrl + path
  const imageUrl = siteUrl + image

  return (
    <>
      <title>{title}</title>
      <meta name="description" content={description} />
      {noindex ? <meta name="robots" content="noindex, follow" /> : <link rel="canonical" href={url} />}
      <meta property="og:type" content={type} />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:url" content={url} />
      <meta property="og:image" content={imageUrl} />
      <meta property="og:image:alt" content={imageAlt} />
      <meta property="og:site_name" content={site.name} />
      {published && <meta property="article:published_time" content={published} />}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={imageUrl} />
      {jsonLd && <script type="application/ld+json">{JSON.stringify(jsonLd)}</script>}
    </>
  )
}
